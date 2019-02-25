//surgical.stan 

data {
  int<lower=0> N;
  int<lower=0> r[N];
  int<lower=0> n[N];
}

parameters {
  real mu;
  real<lower=0> tao;
  vector[N] b;
}

transformed parameters {
  vector[N] logit_p;
  real sigma;
  logit_p = mu + b;
  sigma = sqrt(tao);
}

model {
  target += binomial_logit_lpmf(r | n, logit_p);
  target += normal_lpdf(b | 0, sigma);
  target += inv_gamma_lpdf(tao | 0.001, 0.001);
}

generated quantities {
  real<lower=0, upper=1> p[N];
  for (i in 1:N)
    p[i] = inv_logit(logit_p[i]);
}
