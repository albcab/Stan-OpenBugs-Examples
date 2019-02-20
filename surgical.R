## SURGICAL EXAMPLE OPEN BUGS

setwd("C:/Users/dell_x/Desktop/Bocconi/Stan")

library(ggplot2)
library(rstan)

data_raw <- list(n = c(47, 148, 119, 810,   211, 196, 148, 215, 207, 97, 256, 360),
                 r = c(0, 18, 8, 46, 8, 13, 9,   31, 14, 8, 29, 24),
                 N = 12)

data_surg <- tibble::tibble(proc = data_raw$n,
                            death = data_raw$r)

ggplot(data_surg, aes(y = death, x = proc)) +
  geom_point()

ggplot(data_surg, aes(death)) +
  geom_histogram()

model <- stan_model("surgical.stan")
model1 <- sampling(model,
                   data = data_raw)

piccolo <- summary(model1)$summary
samples <- extract(model1)

par(mfrow = c(1,2))
for (i in 1:data_raw$N) {
  hist(samples$p[,i])
  hist(samples$logit_p[,i])
  readline("Click")
}

par(mfrow = c(1,1))
hist(samples$lp__)
