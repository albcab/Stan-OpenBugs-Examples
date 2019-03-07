//lsat.stan

data {
  int<lower=0> N;
  int<lower=0> R;
  int<lower=0> T;
  int<lower=0> culm[R];
  int<lower=0, upper=1> response[R,T];
}

transformed data {
  int<lower=0, upper=1> obs[N,T];
  for (i in 1:R) {
    if (i==1)
      for (j in 1:culm[i])
        obs[j,] = response[i,];
    else
      for (j in (culm[i-1]+1):culm[i])
        obs[j,] = response[i,];
  }
}

parameters {
  real<lower=0> beta;
  vector[N] theta;
  vector[T] alpha;
}

transformed parameters {
  real logit_p[N,T];
  real<lower=0, upper=1> p[N,T];
  // gamma reparametrization:
  real gamma = log(beta);
  for (i in 1:N)
    for (j in 1:T)
      logit_p[i,j] = beta*theta[i]-alpha[j];
  p = inv_logit(logit_p);
}

model {
  for (i in 1:T)
    target += bernoulli_lpmf(obs[,i] | p[,i]);
  target += normal_lpdf(theta | 0, 1);
  // target += -log(beta);
  //try a reparametrization with gamma and a non inf improper prior
}

generated quantities {
  vector[T] a = alpha-mean(alpha);
}
