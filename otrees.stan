//otrees.stan

data {
  int<lower=0> n;
  int<lower=0> K;
  vector<lower=0>[n] x;
  matrix<lower=0>[K,n] Y;
}

parameters {
  vector[3] mu;
  vector<lower=0>[3] tao;
  matrix[K,3] theta;
  real<lower=0> tao_c;
}

transformed parameters {
  matrix[K,3] phi;
  matrix[K,n] eta;
  vector[3] log_tao;
  real log_tao_c = log(tao_c);
  log_tao = log(tao);
  
  phi[,1] = exp(theta[,1]);
  phi[,2] = exp(theta[,2])-1;
  phi[,3] = -exp(theta[,3]);
  
  for (j in 1:n)
    for (i in 1:K)
      eta[i,j] = phi[i,1]/(1+phi[i,2]*exp(phi[i,3]*x[j]));
}

model {
  for (i in 1:K) {
    target += normal_lpdf(Y[i,] | eta[i,], sqrt(tao_c));
    target += normal_lpdf(theta[i,] | mu, sqrt(tao));
  }
}

generated quantities {
  real<lower=0> sigma_c;
  vector<lower=0>[3] sigma = sqrt(tao);
  sigma_c = sqrt(tao_c);
}
