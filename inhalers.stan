//inhales.stan

data {
  int<lower=0> N;
  int<lower=0> T;
  int<lower=0> G;
  int<lower=0> Ncut;
  int<lower=0, upper=4> Nind[N,G+1];
  matrix<lower=-1, upper=1>[G,T] treat;
  matrix<lower=-1, upper=1>[G,T] period;
  matrix<lower=-1, upper=1>[G,T] carry;
}

parameters {
  
  ordered[Ncut] a;
  
  real beta; //treatment effect
  real pI; //period effect
  real kappa; //carryover effect

  real b[N]; //random effect
  real<lower=0> tao;
  
}

transformed parameters {
  
  matrix[G,T] mu;
  
  real<lower=0, upper=1> Q[N,T,Ncut];
  simplex[Ncut+1] p[N,T];
  
  real log_tao = log(tao);
  
  mu = (beta/2)*treat+(pI/2)*period+kappa*carry;
  
  for (i in 1:N)
    for (t in 1:T)
      for (j in 1:Ncut)
        Q[i,t,j] = inv_logit(-(a[j]+mu[Nind[i,3],t]+b[i]));
  
  for (i in 1:N)
    for (t in 1:T)
      p[i,t,] = [1-Q[i,t,1], Q[i,t,1]-Q[i,t,2], Q[i,t,2]-Q[i,t,3], Q[i,t,3]]';
      
}

model {
  for (i in 1:N)
    for (t in 1:T)
      target += categorical_lpmf(Nind[i,t] | p[i,t,]);
  target += normal_lpdf(b | 0, sqrt(tao));
}

generated quantities {
  real log_sigma;
  real<lower=0> sigma = sqrt(tao);
  log_sigma = log(sigma);
}
