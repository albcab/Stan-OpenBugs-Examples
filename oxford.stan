//oxford.stan

data {
  int<lower=0> K;
  int<lower=0> r1[K];
  int<lower=0> n1[K];
  int<lower=0> r0[K];
  int<lower=0> n0[K];
  vector[K] year;
}

transformed data {
  matrix[K,3] regressors = append_col(append_col(rep_vector(1, K), year), year .* year-22);
}

parameters {
  vector[K] mu;
  vector[3] alpha;
  vector[K] b;
  real<lower=0> tao;
}

transformed parameters {
  vector[K] log_phi;
  vector<lower=0, upper=1>[K] p1;
  vector<lower=0, upper=1>[K] p0;
  vector[K] logit_p1;
  vector[K] logit_p0;
  real<lower=0> sigma = sqrt(tao);
  log_phi = regressors*alpha+b;
  logit_p1 = mu+log_phi;
  logit_p0 = mu;
  p1 = inv_logit(logit_p1);
  p0 = inv_logit(logit_p0);
}

model {
  target += binomial_lpmf(r1 | n1, p1);
  target += binomial_lpmf(r0 | n0, p0);
  target += normal_lpdf(b | 0, sigma);
  target += -log(tao);
}
