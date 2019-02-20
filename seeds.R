## SEEDS EXAMPLE OPENBUGS

library(ggplot2)
library(rstan)

data_raw <- list(r = c(10, 23, 23, 26, 17, 5, 53, 55, 32, 46, 10, 8, 10, 8, 23, 0, 3, 22, 15, 32, 3),
                 n = c(39, 62, 81, 51, 39, 6, 74, 72, 51, 79, 13, 16, 30, 28, 45, 4, 12, 41, 30, 51, 7),
                 x1 = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
                 x2 = c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1),
                 N = 21)

attach(data_raw)
data_seeds <- tibble::tibble(germ = r,
                             total = n,
                             seed = x1,
                             root = x2)
detach(data_raw)

ggplot(data_seeds, aes(total, germ)) +
  geom_point() +
  facet_grid(rows = vars(seed), cols = vars(root))

model <- stan("seeds.stan",
              data = data_raw)

pairs(model, 
      pars = c("alpha0", "alpha1", "alpha2", "alpha12"))

sample_params <- get_sampler_params(model)
colnames(sample_params[[1]])
