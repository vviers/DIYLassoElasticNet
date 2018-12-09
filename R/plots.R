library(ggplot2)
library(magrittr)


## Lasso
# betas.lasso <- t(mapply(lasso_solve, lambda = seq(0, 2, .05), MoreArgs = list(y = y, X = X)))
# betas.lasso <- data.frame(betas.lasso)
# betas.lasso$lambda <- seq(0, 2, .05)
#
# betas.lasso <- betas.lasso %>%
#   tidyr::gather(key = "Betas", value = "value", 1:10)
#
# # Plot
# betas.lasso %>%
#   ggplot(aes(x = lambda)) +
#   geom_line(aes(y = value, color = Betas)) +
#   ggtitle("Coefficient Profiles - Lasso", subtitle = "Simulated data.")
#
#
# ## Elastic Net
#
# df <- data.frame()
#
# for (a in seq(0, 1, .2)){
#
#   betas.en <- t(mapply(elasticNet_solve, lambda = seq(0, 2, .05), MoreArgs = list(y = y, X = X, alpha = a)))
#   betas.en <- data.frame(betas.en)
#   betas.en$lambda <- seq(0, 2, .05)
#   betas.en$alpha <- a
#
#   betas.en <- betas.en %>%
#     tidyr::gather(key = "Betas", value = "value", 1:10)
#
#   df <- rbind(df, betas.en)
# }
#
# # Plot
# df %>%
#   ggplot(aes(x = lambda)) +
#   geom_line(aes(y = value, color = Betas)) +
#   facet_grid(. ~ alpha) +
#   ggtitle("Coefficient Profiles - ElasticNet - for different alpha", subtitle = "Simulated data. The title of each plot is the alpha value.")



