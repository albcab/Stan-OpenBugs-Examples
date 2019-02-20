// 8schools.stan
data {
  int<lower=0> J;
  real y[J];
  real<lower=0> sigma[J];
}

parameters {
  real mu;
  real<lower=0> tao;
  vector[J] eta;
}

transformed parameters {
  vector[J] theta = mu + tao*eta;
}

model {
  target += normal_lpdf(eta | 0, 1); // prior
  target += normal_lpdf(y | theta, sigma); // likelihood
}
