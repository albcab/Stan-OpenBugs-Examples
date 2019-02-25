## DYES OPEN BUGS EXAMPLE

library(rstan)

data_raw <- list(batches = 6, samples = 5,
                 y = t(structure(
                   .Data = c(1545, 1440, 1440, 1520, 1580,
                             1540, 1555, 1490, 1560, 1495,
                             1595, 1550, 1605, 1510, 1560,
                             1445, 1440, 1595, 1465, 1545,
                             1595, 1630, 1515, 1635, 1625,
                             1520, 1455, 1450, 1480, 1445), .Dim = c(5, 6))))

model <- stan_model("dyes.stan")
sample <- sampling(model,
                   data = data_raw)

pairs(sample, pars = c("lp__", "tao_w", "tao_b"))

sample2 <- sampling(model,
                   data = data_raw,
                   control = list(adapt_delta = 0.95,
                                  max_treedepth = 15))
