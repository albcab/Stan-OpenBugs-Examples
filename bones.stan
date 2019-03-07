//bones.stan

data {
  
  int<lower=0> nC;
  int<lower=0> nI;
  
  int<lower=0> ngamma[4];
  vector[ngamma[1]] gamma1;
  matrix[ngamma[2],2] gamma2;
  vector[3] gamma3;
  matrix[ngamma[4],4] gamma4;
  
  vector[nI] delta;
  
  int<lower=0> n_obs;
  int<lower=0> n_mis;
  int<lower=0> ii_obs[n_obs];
  int<lower=0> ii_mis[n_mis];
  
  row_vector<lower=1, upper=5>[n_obs] grade_obs;
  
}

transformed data {
  int<lower=0> n = n_obs+n_mis;
}

parameters {
  //introduce the missing values as parameters to estimate:
  row_vector<lower=1, upper=5>[n_mis] grade_mis;
  real theta[nC];
}

transformed parameters {
  
  //put together the missing and know data:
  row_vector<lower=0, upper=5>[n] grade;
  matrix<lower=0, upper=5>[nC,nI] Grade;
  
  matrix[nC,ngamma[1]] logit_Q1;
  matrix[nC,ngamma[2]] logit_Q2[2];
  matrix[nC,ngamma[3]] logit_Q3[3];
  matrix[nC,ngamma[4]] logit_Q4[4];
  
  matrix<lower=0, upper=1>[nC,ngamma[1]] Q1;
  matrix<lower=0, upper=1>[nC,ngamma[2]] Q2[2];
  matrix<lower=0, upper=1>[nC,ngamma[3]] Q3[3];
  matrix<lower=0, upper=1>[nC,ngamma[4]] Q4[4];
  
  simplex[2] P1[nC,ngamma[1]];
  simplex[3] P2[nC,ngamma[2]];
  simplex[4] P3[nC,ngamma[3]];
  simplex[5] P4[nC,ngamma[4]];
  
  //join missing and known data and re-build the original matrix:
  grade[ii_obs] = grade_obs;
  grade[ii_mis] = grade_mis;
  for (i in 1:nC)
    Grade[i,] = grade[1+nI*(i-1):nI*i];
  
  for (i in 1:nC) {
    for (j in 1:ngamma[1])
      logit_Q1[i,j] = delta[j]*(theta[i]-gamma1[j]);
    for (j in 1:ngamma[2])
      for (k in 1:2)
        logit_Q2[k,i,j] = delta[j]*(theta[i]-gamma2[j,k]);
    for (j in 1:ngamma[3])
      for (k in 1:3)
        logit_Q3[k,i,j] = delta[j]*(theta[i]-gamma3[k]);
    for (j in 1:ngamma[4])
      for (k in 1:4)
        logit_Q4[k,i,j] = delta[j]*(theta[i]-gamma4[j,k]);    
  }
  
  Q1 = inv_logit(logit_Q1);
  Q2 = inv_logit(logit_Q2);
  Q3 = inv_logit(logit_Q3);
  Q4 = inv_logit(logit_Q4);
  
  for (i in 1:nC) {
    for (j in 1:ngamma[1])
      P1[i,j,] = [1-Q1[i,j], Q1[i,j]]';
    for (j in 1:ngamma[2])
      P2[i,j,] = [1-Q2[1,i,j], Q2[1,i,j]-Q2[2,i,j], Q2[2,i,j]]';
    for (j in 1:ngamma[3])
      P3[i,j,] = [1-Q3[1,i,j], Q3[1,i,j]-Q3[2,i,j], Q3[2,i,j]-Q3[3,i,j], Q3[3,i,j]]';
    for (j in 1:ngamma[4])
      P4[i,j,] = [1-Q4[1,i,j], Q4[1,i,j]-Q4[2,i,j], Q4[2,i,j]-Q4[3,i,j], Q4[3,i,j]-Q4[4,i,j], Q4[4,i,j]]';
  }
  
}

model {
  
  for (i in 1:nC) {
    for (j in 1:ngamma[1])
      target += categorical_lpmf(Grade[i,j]<=1.5?1:2 | P1[i,j,]);
    for (j in 1:ngamma[2])
      target += categorical_lpmf(Grade[i,ngamma[1]+j]<=1.5?1:(Grade[i,ngamma[1]+j]<=2.5?2:3) | P2[i,j,]);
    for (j in 1:ngamma[3])
      target += categorical_lpmf(Grade[i,sum(ngamma[1:2])+j]<=1.5?1:(Grade[i,sum(ngamma[1:2])+j]<=2.5?2:(Grade[i,sum(ngamma[1:2])+j]<=3.5?3:4)) | P3[i,j,]);
    for (j in 1:ngamma[3])
      target += categorical_lpmf(Grade[i,sum(ngamma[1:3])+j]<=1.5?1:(Grade[i,sum(ngamma[1:3])+j]<=2.5?2:(Grade[i,sum(ngamma[1:3])+j]<=3.5?3:(Grade[i,sum(ngamma[1:3])+j]<=4.5?4:5))) | P4[i,j,]);
  }
  
}
