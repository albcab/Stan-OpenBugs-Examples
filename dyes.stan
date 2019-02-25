//dyes.stan

data {
  int<lower=0> batches;
  int<lower=0> samples;
  real<lower=0> y[batches, samples];
}

parameters {
  real mu[batches];
  real theta;
  real<lower=0> sigma2_w;
  real<lower=0> sigma2_b;
}

transformed parameters {
  real<lower=0> sigma_w;
  real<lower=0> sigma_b;
  sigma_w = sqrt(sigma2_w);
  sigma_b = sqrt(sigma2_b);
}

model {
  for (i in 1:samples)
    target += normal_lpdf(y[,i] | mu, sigma_w);
  target += normal_lpdf(mu | theta, sigma_b);
  target += -log(sigma2_w)-log(sigma2_b);
}

generated quantities {
  real<lower=0> tao_w;
  real<lower=0> tao_b;
  real<lower=0> sigma2_t;
  real<lower=0, upper=1> f_w;
  real<lower=0, upper=1> f_b;
  tao_w = 1/sigma2_w;
  tao_b = 1/sigma2_b;
  sigma2_t = sigma2_w+sigma2_b;
  f_w = sigma2_w/sigma2_t;
  f_b = sigma2_b/sigma2_t;
}
