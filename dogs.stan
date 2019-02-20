//dogs.stan

data {
  int<lower=0> Dogs;
  int<lower=0> Trials;
  int<lower=0, upper=1> Y[Dogs, Trials];
}

transformed data {
  int<lower=0> x_a[Dogs, Trials];
  int<lower=0> x_b[Dogs, Trials];
  x_a[,1] = rep_array(0, Dogs);
  x_b[,1] = x_a[,1];
  for (j in 2:Trials) {
    for (i in 1:Dogs) {
      x_a[i,j] = sum(Y[i,1:(j-1)]);
      x_b[i,j] = j-1 - x_a[i,j];
    }
  }
}

parameters {
  real alpha;
  real beta;
}

transformed parameters {
  real log_pi[Dogs, Trials];
  real<lower=0> Pi[Dogs, Trials];
  for (j in 1:Trials) {
    for (i in 1:Dogs) {
      log_pi[i,j] = alpha*x_a[i,j] + beta*x_b[i,j];
    }
  }
  Pi = exp(log_pi);
}

model {
  for (j in 1:Trials) {
    for (i in 1:Dogs) {
      target += bernoulli_lpmf(1-Y[i,j] | Pi[i,j]);
    }
  }
}

generated quantities {
  real<lower=0> A;
  real<lower=0> B;
  A = exp(alpha);
  B = exp(beta);
}
