library(rstan)

schools_dat <- list(J = 8, 
                    y = c(28,  8, -3,  7, -1,  1, 18, 12),
                    sigma = c(15, 10, 16, 11,  9, 11, 10, 18))

eight <- stan("8schools.stan",
              data = schools_dat)

print(eight) #customizable
plot(eight)
plot(eight, pars = c("theta[1]", "theta[2]", "theta[3]", "theta[4]",
                     "theta[5]", "theta[6]", "theta[7]", "theta[8]",
                     "lp__"))
samples <- extract(eight)
names(samples)
dim(samples$theta)

apply(samples$theta, 2, mean)

summa <- summary(eight)
names(summa)
summa$summary

params <- get_sampler_params(eight)
length(params)
