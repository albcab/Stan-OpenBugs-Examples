# Rats BUGS example model in Stan

library(ggplot2)
library(dplyr)
library(rstan)

# Loading up data
data_rats <- list(x = c(8.0, 15.0, 22.0, 29.0, 36.0), 
                  xbar = 22, 
                  N = 30, 
                  T = 5,   
                  Y = t(structure(
                    .Data = c(151, 199, 246, 283, 320,
                              145, 199, 249, 293, 354,
                              147, 214, 263, 312, 328,
                              155, 200, 237, 272, 297,
                              135, 188, 230, 280, 323,
                              159, 210, 252, 298, 331,
                              141, 189, 231, 275, 305,
                              159, 201, 248, 297, 338,
                              177, 236, 285, 350, 376,
                              134, 182, 220, 260, 296,
                              160, 208, 261, 313, 352,
                              143, 188, 220, 273, 314,
                              154, 200, 244, 289, 325,
                              171, 221, 270, 326, 358,
                              163, 216, 242, 281, 312,
                              160, 207, 248, 288, 324,
                              142, 187, 234, 280, 316,
                              156, 203, 243, 283, 317,
                              157, 212, 259, 307, 336,
                              152, 203, 246, 286, 321,
                              154, 205, 253, 298, 334,
                              139, 190, 225, 267, 302,
                              146, 191, 229, 272, 302,
                              157, 211, 250, 285, 323,
                              132, 185, 237, 286, 331,
                              160, 207, 257, 303, 345,
                              169, 216, 261, 295, 333,
                              157, 205, 248, 289, 316,
                              137, 180, 219, 258, 291,
                              153, 200, 244, 286, 324),
                    .Dim = c(5,30))))

#Making a tibble for future processing
raw <- cbind(1:data_rats$N, data_rats$Y)
colnames(raw) <- c("rat", data_rats$x)
data_rats1 <- tibble::as_tibble(raw)

# tidying up the data
data_rats2 <- tidyr::gather(data_rats1, 
                            "8":"36", 
                            key = "week",
                            value = "weight",
                            convert = T)

# Some visualizations
ggplot(data_rats2, aes(weight, color = as.factor(week))) +
  geom_histogram(binwidth = 5)

ggplot(data_rats2, 
       aes(x = week, y = weight, color = as.factor(rat))) +
  geom_line()

data_rats2 %>% 
  group_by(week) %>%
  summarise(avg = mean(weight)) %>%
  ggplot(aes(x = week, y = avg)) +
  geom_line() #increasing function with decreasing slope

# Use the Gelfand et al 1990 model (w/o covariance 
# between parameters in the model) using STAN

model <- stan("rats.stan",
              data = data_rats)

# Do some train-test
attach(data_rats)
data_rats_train <- list(x = x[-T], 
                        xbar = mean(x[-T]), 
                        N = N,
                        T = T-1,
                        Y = Y[,-T])
data_rats_test <- list(x = x[T],
                       xbar = xbar,
                       N = N,
                       T = 1,
                       Y = Y[,T])
detach(data_rats)

model_train <- stan("rats.stan",
                    data = data_rats_train)

draws <- extract(model_train)
names(draws)

attach(data_rats_test)
params <- tibble::tibble(alpha = apply(draws$alpha, 2, mean),
                         beta = apply(draws$beta, 2, mean),
                         x_xbar = rep(x-xbar, N),
                         estimate = alpha+beta*x_xbar,
                         test = Y)
detach(data_rats_test)
