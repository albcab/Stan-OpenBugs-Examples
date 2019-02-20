//pumps.stan

data {
  int<lower=0> N;
  int<lower=0> x[N];
  vector<lower=0>[N] t;
}

parameters {
  vector<lower=0>[N] theta;
  real<lower=0> alpha;
  real<lower=0> beta;
}

model {
  target += poisson_lpmf(x | theta .* t);
  target += gamma_lpdf(theta | alpha, beta);
  target += exponential_lpdf(alpha | 1);
  target += gamma_lpdf(beta | 0.1, 1);
}
