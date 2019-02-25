//equiv.stan

data {
  int<lower=0> N;
  int<lower=0> P;
  int<lower=-1, upper=1> group[N];
  real Y[N,P];
}

parameters {
  real mu;
  real phi;
  real pI;
  real delta[N];
  real<lower=0> tao1;
  real<lower=0> tao2;
}

transformed parameters {
  real m[N,P];
  real<lower=0> sigma1;
  real<lower=0> sigma2;
  for (i in 1:N) 
    for (j in 1:P) 
      m[i,j] = mu+(j==1?group[i]:group[i]*(-1))*phi/2+(j==1?1:-1)*pI/2+delta[i];
  sigma1 = sqrt(tao1);
  sigma2 = sqrt(tao2);
}

model {
  for (i in 1:P)
    target += normal_lpdf(Y[,i] | m[,i], sigma1);
  target += normal_lpdf(delta | 0, sigma2);
  target += -log(tao1)-log(tao2); //Jeffrey's priors for both variances
}
