//mice.stan

data {
  int<lower=0> M;
  int<lower=0> N;
  matrix<lower=0>[M,N] t;
}

parameters {
  vector[M] beta;
  real<lower=0> r;
}

transformed parameters {
  vector<lower=0>[M] mu = exp(beta);
}

model {
  for (i in 1:M)
    target += weibull_lpdf(t[i,] | r, (1/mu[i])^(1/r));
  target += exponential_lpdf(r | 0.001);
}

generated quantities {
  vector<lower=0>[M] median;
  real veh_control;
  real test_sub;
  real pos_control = beta[4]-beta[1];
  test_sub = beta[3]-beta[1];
  veh_control = beta[2]-beta[1];
  for (i in 1:M)
    median[i] = (log(2)*exp(-beta[i]))^(1/r);
}
