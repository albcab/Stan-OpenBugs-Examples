//kidney.stan

data {
  int<lower=0> N;
  int<lower=0> M;
  matrix<lower=0>[N,M] t;
  matrix<lower=0>[N,M] age;
  vector<lower=0, upper=1>[N] sex;
  vector<lower=1, upper=4>[N] disease;
}

transformed data {
  matrix<lower=0, upper=1>[N,3] dd = rep_matrix(0, N, 3);
  for (i in 1:N) {
    if (disease[i]==2)
      dd[i,1] = 1;
    if (disease[i]==3)
      dd[i,2] = 1;
    if (disease[i]==4)
      dd[i,3] = 1;    
  }
}

parameters {
  vector[6] beta;
  vector[N] b;
  real<lower=0> tao;
  real<lower=0> r;
}

transformed parameters {
  
  matrix[N,6] regressors[M];
  matrix<lower=0>[N,M] mu;
  real log_tao = log(tao);
  
  for (i in 1:M) {
    regressors[i] = append_col(append_col(append_col(rep_vector(1, N), age[,i]), sex), dd);
    mu[,i] = exp(regressors[i]*beta + b);
  }
    
}

model {
  for (i in 1:M)
    for (j in 1:N)
      target += weibull_lpdf(t[j,i] | r, (1/mu[j,i])^(1/r));
  target += normal_lpdf(b | 0, sqrt(tao));
  target += gamma_lpdf(r | 1, 0.001);
}

generated quantities {
  real<lower=0> sigma = sqrt(tao);
}
