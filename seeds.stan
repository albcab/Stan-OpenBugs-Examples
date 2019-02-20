//seeds.stan

data {
  int<lower=0> N;
  int<lower=0> r[N];
  int<lower=0> n[N];
  int<lower=0, upper=1> x1[N];
  int<lower=0, upper=1> x2[N];
}

transformed data {
  int<lower=0, upper=1> x12[N];
  for (i in 1:N)
    x12[i] = x1[i]*x2[i];
}

parameters {
  real alpha0;
  real alpha1;
  real alpha2;
  real alpha12;
  real b[N];
  real<lower=0> tao;
}

transformed parameters {
  real logit_p[N];
  real sigma = sqrt(tao);
  for (i in 1:N)
    logit_p[i] = alpha0 + alpha1*x1[i] + alpha2*x2[i] + alpha12*x12[i] + b[i];
}

model {
  //target += binomial_lpmf(r | n, p);
  target += binomial_logit_lpmf(r | n, logit_p);
  target += normal_lpdf(b | 0, sigma);
  target += inv_gamma_lpdf(tao | 0.001, 0.001);
}

generated quantities {
  real<lower=0, upper=1> p[N] = inv_logit(logit_p);
}