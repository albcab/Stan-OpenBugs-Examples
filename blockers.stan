//blockers.stan

data {
  int<lower=0> Num;
  int<lower=0> rt[Num];
  int<lower=0> nt[Num];
  int<lower=0> rc[Num];
  int<lower=0> nc[Num];
}

parameters {
  vector[Num] mu;
  vector[Num] delta;
  real d;
  real<lower=0> tao;
  real delta_new;
}

transformed parameters {
  vector<lower=0, upper=1>[Num] pt;
  vector<lower=0, upper=1>[Num] pc;
  vector[Num] logit_pt;
  vector[Num] logit_pc;
  real<lower=0> sigma;
  logit_pc = mu;
  logit_pt = mu+delta;
  pt = inv_logit(logit_pt);
  pc = inv_logit(logit_pc);
  sigma = sqrt(tao);
}

model {
  target += binomial_lpmf(rt | nt, pt);
  target += binomial_lpmf(rc | nc, pc);
  target += normal_lpdf(delta | d, sigma);
  target += -log(tao);
  target += student_t_lpdf(delta_new | 4, d, sigma);
}
