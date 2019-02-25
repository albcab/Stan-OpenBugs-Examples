//salm.stan

data {
  int<lower=0> doses;
  int<lower=0> plates;
  int<lower=0> y[doses, plates];
  int<lower=0> x[doses];
}

transformed data {
  real<lower=0> x_log_10[doses];
  for (i in 1:doses)
    x_log_10[i] = log(x[i]+10);
}

parameters {
  real alpha;
  real beta;
  real gamma;
  real<lower=0> tao;
  real lambda[doses, plates];
}

transformed parameters {
  real<lower=0> mu[doses, plates];
  real log_mu[doses, plates];
  for (i in 1:doses) {
    for (j in 1:plates)
      log_mu[i,j] = alpha+beta*x_log_10[i]+gamma*x[i]+lambda[i,j];
  }
  mu = exp(log_mu);
}

model {
  for (j in 1:plates) {
    target += poisson_lpmf(y[,j] | mu[,j]);
    target += normal_lpdf(lambda[,j] | 0, sqrt(tao));
  }
  target += -log(tao); //non-informative Jeffrey's prior
}
