//dugongs.stan

data {
  int<lower=0> N;
  real<lower=0> Y[N];
  real<lower=0> x[N];
}

parameters {
  real alpha;
  real<lower=0> beta;
  real<lower=0,upper=1> gamma;
  real<lower=0> tao;
}

transformed parameters {
  real mu[N];
  real log_beta;
  real log_tao = log(tao);
  log_beta = log(beta);
  
  for (i in 1:N)
    mu[i] = alpha-beta*gamma^x[i];

}

model {
  target += normal_lpdf(Y | mu, sqrt(tao));
  target += uniform_lpdf(gamma | 0, 1);
}
