# Some plots

library(ggplot2)
library(magrittr)
library(latex2exp)
#
#
# Lasso
dta <- createData(n = 100, sigma_error = 3, example = 1)
betas.lasso <- t(mapply(lasso_solve, lambda = seq(0, 3, .05), MoreArgs = list(y = dta$y, X = dta$X)))
betas.lasso <- data.frame(betas.lasso)
betas.lasso$lambda <- seq(0, 3, .05)

betas.lasso <- betas.lasso %>%
  tidyr::gather(key = "Betas", value = "value", 1:8)

# Plot
betas.lasso %>%
  ggplot(aes(x = lambda)) +
  geom_line(aes(y = value, color = Betas)) +
  ylab("Beta values") +
  ggtitle("Coefficient Profiles - Lasso", subtitle = "Simulated data, Example 1. n = 100") +
  ggsave(filename = "plots/Example1", device = "png")



# ex 2
# Lasso
dta <- createData(n = 100, sigma_error = 3, example = 2)
betas.lasso <- t(mapply(lasso_solve, lambda = seq(0, 3, .05), MoreArgs = list(y = dta$y, X = dta$X)))
betas.lasso <- data.frame(betas.lasso)
betas.lasso$lambda <- seq(0, 3, .05)

betas.lasso <- betas.lasso %>%
  tidyr::gather(key = "Betas", value = "value", 1:20)

betas.lasso %>%
  ggplot(aes(x = lambda)) +
  geom_line(aes(y = value, color = Betas)) +
  ylab("Beta values") +
  ggtitle("Coefficient Profiles - Lasso", subtitle = "Simulated data, Example 2. n = 100") +
  ggsave(filename = "plots/Example2", device = "png")



# ex 4
# Lasso
dta <- createData(n = 100, sigma_error = 3, example = 4)
betas.lasso <- t(mapply(lasso_solve, lambda = seq(0, 3, .05), MoreArgs = list(y = dta$y, X = dta$X)))
betas.lasso <- data.frame(betas.lasso)
betas.lasso$lambda <- seq(0, 3, .05)

betas.lasso <- betas.lasso %>%
  tidyr::gather(key = "Betas", value = "value", 1:10)

betas.lasso %>%
  ggplot(aes(x = lambda)) +
  geom_line(aes(y = value, color = Betas)) +
  ylab("Beta values") +
  ggtitle("Coefficient Profiles - Lasso", subtitle = "Simulated data, Example 4. n = 100") +
  ggsave(filename = "plots/Example4", device = "png")





# ex 5
# Lasso
dta <- createData(n = 10000, sigma_error = 1, example = 5)
betas.lasso <- t(mapply(lasso_solve, lambda = seq(0, 3, .05), MoreArgs = list(y = dta$y, X = dta$X)))
betas.lasso <- data.frame(betas.lasso)
betas.lasso$lambda <- seq(0, 3, .05)

betas.lasso <- betas.lasso %>%
  tidyr::gather(key = "Betas", value = "value", 1:30)

betas.lasso$non_zero[1:915]    <- FALSE
betas.lasso$non_zero[916:1830] <- TRUE

betas.lasso %>%
  ggplot(aes(x = lambda)) +
  geom_line(aes(y = value, group = Betas, color = non_zero)) +
  ylab("Beta values") +
  ggtitle("Coefficient Profiles - Lasso", subtitle = "Simulated data (n=100), Example 5.") #+
  ggsave(filename = "plots/Example5", device = "png")






## Elastic Net

dta <- createData(n = 1000, sigma_error = 3, example = 5)
df <- data.frame()

for (a in seq(0, 1, .2)){

  betas.en <- t(mapply(elasticNet_solve, lambda = seq(0, 3, .05), MoreArgs = list(y = dta$y, X = dta$X, alpha = a)))
  betas.en <- data.frame(betas.en)
  betas.en$lambda <- seq(0, 3, .05)
  betas.en$alpha <- a

  betas.en <- betas.en %>%
    tidyr::gather(key = "Betas", value = "value", 1:30)

  betas.en$non_zero[1:915]    <- FALSE
  betas.en$non_zero[916:1830] <- TRUE

  df <- rbind(df, betas.en)
}


# # Plot
df %>%
  ggplot(aes(x = lambda)) +
  geom_line(aes(y = value, group = Betas, color = non_zero)) +
  facet_wrap(. ~ alpha, ncol = 3) +
  ggtitle("Coefficient Profiles - ElasticNet - for different alpha",
          subtitle = "Simulated data. n = 1000. The title of each plot is the alpha value.") #+
  ggsave(filename = "plots/Example1_EN", device = "png")




load("full.RData")

fullMSE <- data.frame(fullMSE[-1, ])
fullMSE <- fullMSE[seq(1, 20, 2), ]
fullMSE$model <- c("lasso", "en")
fullMSE

fullMSE %>%
  tidyr::gather(key = "Example", value = "value", 1:5) %>%
  ggplot(aes(x = noise)) +
  geom_line(aes(y = value, color = model)) +
  facet_wrap(. ~ Example, scales = "free_y") +
  ylab("Estimated Test MSE") +
  xlab(TeX("$\\sigma_{\\epsilon}$")) +
  ggtitle("Estimated MSE for the EN and the Lasso",
          subtitle = "For different levels of irreducible noise in the Data Generating Process.\nn_train = n_validation = 20, n_test = 200\n50 datasets") +
  ggsave(filename = "plots/noiseMSE.png", device = "png")

fullNonZero <- data.frame(fullNonZero[-1, ])
fullNonZero <- fullNonZero[seq(1, 20, 2), ]
fullNonZero$model <- c("lasso", "en")
fullNonZero

fullNonZero %>%
  tidyr::gather(key = "Example", value = "value", 1:5) %>%
  ggplot(aes(x = noise)) +
  geom_line(aes(y = value, color = model)) +
  facet_wrap(. ~ Example, scales = "free_y") +
  ylab("Non-zero Betas") +
  xlab(TeX("$\\sigma_{\\epsilon}$")) +
  ggtitle("Estimated Median Number of NonZero coefficients for the EN and the Lasso",
          subtitle = "For different levels of irreducible noise in the Data Generating Process.\nn_train = n_validation = 20, n_test = 200\n50 datasets") #+
  ggsave(filename = "plots/noiseNonZ.png", device = "png")





