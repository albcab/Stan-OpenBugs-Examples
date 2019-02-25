## EQUIV EXAMPLE BUGS

library(rstan)
library(ggplot2)

data_raw <- list(N = 10, P = 2,
                 group = c(1, 1, -1, -1, -1, 1, 1, 1, -1, -1),
                 Y = t(structure(.Data = c(1.40, 1.65,
                                         1.64, 1.57,
                                         1.44, 1.58,
                                         1.36, 1.68,
                                         1.65, 1.69,
                                         1.08, 1.31,
                                         1.09, 1.43,
                                         1.25, 1.44,
                                         1.25, 1.39,
                                         1.30, 1.52), .Dim = c(2, 10))))

model <- stan_model("equiv.stan")
sample <- sampling(model,
                   data = data_raw,
                   control = list(adapt_delta = 0.9,
                                  max_treedepth = 15))

params <- get_sampler_params(sample)

for (i in 1:4) {
  ggplot(tibble::as_tibble(params[[i]])) +
    geom_histogram(aes(treedepth__)) +
    facet_grid(cols = vars(divergent__))
  readline("Click")
}