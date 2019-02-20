// rats.stan
// Gelfand et al 1990 model (w/o cov between model estimates)

data {
  int<lower=0> N; //groups(rats), each with its own regressor
  int<lower=0> T; //obs(weeks) for each group, same regressor
  vector[T] x; //age in days of the rats (when measured)
  real xbar; //mean of the weeks (normalizing to reduce dependence)
  real Y[N,T]; //observations (weights for each rat at each week)
}

transformed data {
  vector[T] x_norm = x - xbar; //reduce dependence of mean parameters
}

parameters {
  //means of obs
  vector[N] alpha;
  vector[N] beta;
  //mean of means
  real alpha_c;
  real beta_c;
  //precision of obs
  real<lower=0> tao_c;
  //precision of means
  real<lower=0> tao_a;
  real<lower=0> tao_b;
}

transformed parameters {
  real<lower=0> sigma_c = sqrt(1/tao_c);
  real<lower=0> sigma_a = sqrt(1/tao_a);
  real<lower=0> sigma_b = sqrt(1/tao_b);
}

model {
  //Likelihood observations
  for (i in 1:T)
    target += normal_lpdf(Y[,i] | alpha+beta*x_norm[i], sigma_c);
  //Likelihood parameters (hirearchical)
  target += normal_lpdf(alpha | alpha_c, sigma_a);
  target += normal_lpdf(beta | beta_c, sigma_b);
  //Priors (all noninformative)
  //means are ifnored (constants)
  //precisions (variances) are improper gammas (inv-gammas) (same, creo)
  target += gamma_lpdf(tao_c | 0.001, 0.001);
  target += gamma_lpdf(tao_a | 0.001, 0.001);
  target += gamma_lpdf(tao_b | 0.001, 0.001);
}

generated quantities {
  real alpha_0 = alpha_c - beta_c*xbar;
}
