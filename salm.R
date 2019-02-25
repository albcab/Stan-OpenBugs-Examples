## SALM OPEN BUGS EXAMPLE

library(rstan)

data_raw <- list(doses = 6, 
                 plates = 3,
                 y = t(structure(.Data = c(15,21,29,16,18,21,16,26,33,27,41,60,33,38,41,20,27,42),
                                 .Dim = c(3, 6))),
                 x = c(0, 10, 33, 100, 333, 1000))

model <- stan_model("salm.stan")
sampl <- sampling(model,
                  data = data_raw)
                  # control = list(max_treedepth = 15,
                  #                adapt_delta = 0.75))

params <- get_sampler_params(sampl)
for (i in 1:4) {
  hist(params[[i]][,3])
  readline("Click")
}