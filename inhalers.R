## INHALERS EXAMPLE OPEN BUGS

library(rstan)

data_raw <- list(N = 286, 
                 T = 2, 
                 G = 2, 
                 Npattern = 16, 
                 Ncut = 3,
                 pattern = t(structure(.Data = 
                                       c(1, 1, 
                                         1, 2, 
                                         1, 3, 
                                         1, 4,
                                         2, 1,
                                         2, 2,
                                         2, 3,
                                         2, 4,
                                         3, 1,
                                         3, 2,
                                         3, 3,
                                         3, 4,
                                         4, 1,
                                         4, 2,
                                         4, 3,
                                         4, 4), .Dim = c(2, 16))),
                 Ncum = t(structure(.Data = 
                                    c( 59, 122,
                                       157, 170,
                                       173, 173,
                                       175, 175,
                                       186, 226,
                                       253, 268,
                                       270, 270,
                                       271, 271,
                                       271, 278,
                                       278, 280,
                                       280, 281,
                                       281, 281,
                                       282, 284, 
                                       285, 285,
                                       285, 286,
                                       286, 286), .Dim = c(2, 16))),
                 treat = t(structure(.Data = 
                                     c( 1, -1, 
                                        -1, 1), .Dim = c(2, 2))),
                 period = t(structure(.Data = 
                                      c( 1, -1, 
                                         1, -1), .Dim = c(2, 2))),
                 carry = t(structure(.Data = 
                                     c( 0, -1, 
                                        0, 1), .Dim = c(2, 2))))

attach(data_raw)
Nind <- matrix(ncol = 3, nrow = N)
place <- 0
for (i in 1:Npattern)
  for (j in 1:G)
    if (place != Ncum[i,j]) {
      for(k in (place+1):Ncum[i,j])
        Nind[k,] <- c(pattern[i,], j)
      place <- Ncum[i,j] 
    }
detach(data_raw)

names(data_raw)[7] <- "Nind"
data_raw$Nind <- Nind

model <- stan_model("inhalers.stan")
(sample <- sampling(model,
                    data = data_raw))
