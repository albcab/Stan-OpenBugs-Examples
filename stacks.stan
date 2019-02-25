//stacks.stan

data {
  int<lower=0> p;
  int<lower=0> N;
  real Y[N];
  real<lower=0> x[N,p];
}

transformed data {
  matrix[N,p+1] z;
  vector<lower=0>[p] sd_x;
  vector[p] mean_x;
  z[,1] = rep_vector(1, N);
  for (i in 1:p) {
    mean_x[i] = mean(x[,i]);
    sd_x[i] = sd(x[,i]);
    for (j in 1:N)
      z[j,i+1] = (x[j,i]-mean_x[i])/sd_x[i];
  }
}

parameters {
  vector[p+1] beta;
  real<lower=0> tao;
  // exclusivley for ridge:
  real<lower=0> phi;
}

transformed parameters {
  vector[N] mu;
  real<lower=0> sigma;
  vector[p] b;
  real b0;
  // d is exclusivley for student-t:
  real<lower=0> d = 4;
  mu = z*beta;
  sigma = sqrt(tao);
  for (i in 2:p+1)
    b[i-1] = beta[i]/sd_x[i-1];
  b0 = beta[1]-mean_x'*b;
}

model {
  // 3 Likelihood options:
  // target += normal_lpdf(Y | mu, sigma);
  // target += double_exponential_lpdf(Y | mu, sigma);
  target += student_t_lpdf(Y | d, mu, sigma);
  // priors (non informative):
  target += -log(tao);
  // in the case of the ridge:
  target += normal_lpdf(beta[2:p+1] | 0, sqrt(phi));
  // and its prior:
  target += -log(phi);
}

generated quantities {
  int<lower=0, upper=1> outlier[N];
  for(i in 1:N)
    outlier[i] = fabs((Y[i]-mu[i])/sigma)>=2.5;
}
