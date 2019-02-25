### STACKS EXAMPLE OPEN BUGS

library(rstan)

data_raw <- list(p = 3, N = 21, 
                 Y = c(42, 37, 37, 28, 18, 18, 19, 20, 15, 14, 14, 13, 11, 12, 8, 7, 8, 8, 9, 15, 15),
                 x = t(structure(.Data = c(80, 27, 89,
                                          80, 27, 88,
                                          75, 25, 90,
                                          62, 24, 87,
                                          62, 22, 87,
                                          62, 23, 87,
                                          62, 24, 93,
                                          62, 24, 93,
                                          58, 23, 87,
                                          58, 18, 80,
                                          58, 18, 89,
                                          58, 17, 88,
                                          58, 18, 82,
                                          58, 19, 93,
                                          50, 18, 89,
                                          50, 18, 86,
                                          50, 19, 72,
                                          50, 19, 79,
                                          50, 20, 80,
                                          56, 20, 82,
                                          70, 20, 91), .Dim = c(3, 21))))

# A single file is used to do all 6 regressions, the file must be
# edited in order to do each of them!

model_normal <- stan_model("stacks.stan")
(sample_normal <- sampling(model_normal,
                          data = data_raw))

model_ddexp <- stan_model("stacks.stan")
(sample_ddexp <- sampling(model_ddexp,
                         data = data_raw))

model_t <- stan_model("stacks.stan")
(sample_t <- sampling(model_t,
                      data = data_raw))

model_normal_ridge <- stan_model("stacks.stan")
(sample_normal_ridge <- sampling(model_normal_ridge,
                                 data = data_raw))

model_ddexp_ridge <- stan_model("stacks.stan")
(sample_ddexp <- sampling(model_ddexp_ridge,
                          data = data_raw))

model_t_ridge <- stan_model("stacks.stan")
(sample_t <- sampling(model_t_ridge,
                      data = data_raw))
