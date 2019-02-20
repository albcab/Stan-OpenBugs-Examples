## PUMPS OPEN BUGS EXAMPLE

library(ggplot2)
library(rstan)

data_raw <- list(t = c(94.3, 15.7, 62.9, 126, 5.24, 31.4, 1.05, 1.05, 2.1, 10.5),
                  x = c( 5, 1, 5, 14, 3, 19, 1, 1, 4, 22), 
                  N = 10)

data_pumps <- tibble::tibble(time = data_raw$t,
                             failures = data_raw$x)

ggplot(data_pumps, aes(x = time, y = failures)) +
  geom_point()

modelo <- stan("pumps.stan",
               data = data_raw)

                 