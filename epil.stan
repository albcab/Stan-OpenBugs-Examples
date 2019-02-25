//epil.stan

data {
  int<lower=0> N;
  int<lower=0> T;
  int<lower=0> y[N,T];
  vector<lower=0, upper=1>[N] Trt;
  vector<lower=0>[N] Base;
  vector<lower=0>[N] Age;
  real<lower=0, upper=1> V4[T];
}

transformed data {
  vector[N] log_Base;
  vector[N] log_Age;
  matrix[N,6] regressors[T];
  log_Base = log(Base ./ 4);
  log_Age = log(Age);
  for (i in 1:T) 
    regressors[i] = append_col(append_col(append_col(append_col(append_col(rep_vector(1, N), log_Base-mean(log_Base)), Trt-mean(Trt)), log_Base .* Trt-mean(log_Base .* Trt)), log_Age-mean(log_Age)), rep_vector(V4[i]-mean(V4), N));
}

parameters {
  vector[6] alpha;
  vector[N] b_hat;
  matrix[N,T] b_bar;
  real<lower=0> tao_hat;
  real<lower=0> tao_bar;
}

transformed parameters {
  matrix<lower=0>[N,T] mu;
  matrix[N,T] log_mu;
  real<lower=0> sigma_hat;
  real<lower=0> sigma_bar;
  for (i in 1:T)
    log_mu[,i] = regressors[i]*alpha+b_hat+b_bar[,i];
  mu = exp(log_mu);
  sigma_hat = sqrt(tao_hat);
  sigma_bar = sqrt(tao_bar);
}

model {
  for(i in 1:T) {
    target += poisson_lpmf(y[,i] | mu[,i]);
    target += normal_lpdf(b_bar[,i] | 0, sigma_bar);
  }
  target += normal_lpdf(b_hat | 0, sigma_hat);
  target += -log(tao_hat)-log(tao_bar);
}

generated quantities {
  real alpha0 = alpha[1]-alpha[2]*mean(log_Base)-alpha[3]*mean(Trt)-alpha[4]*mean(log_Base .* Trt)-alpha[5]*mean(log_Age)-alpha[6]*mean(V4);
}
