#' createDataSet
#' @description creates simulated data to test our solvers on
#' @param p the number of dimensions in the simulated data
#' @param beta_sparsity the proportion of true non-zero betas
#' @param n_train number of training observations
#' @param n_validation number of validation (tuning) observations
#' @param n_test number of testing observations
#' @param num_datasets number of different datasets to generate
#' @param sigma_error noisiness of the Data Generating Process
#'
#' @return a list containing all 50 generated datasets
#'
#' @export
createDataSet <- function(p, beta_sparsity, n_train = 20, n_validation =20, n_test = 200, num_datasets = 50, sigma_error){

  n_total_per_dataset <- (n_train + n_validation + n_test)
  n_total <- n_total_per_dataset * num_datasets

  ## Betas
  # Init all betas = 0
  betas <- numeric(p)
  # List potential values for beta:
  potential_betas <- seq(-10, 10, by = .5)[-c(20, 21, 22)] # remove small values zero !

  # Pick nonzero betas (with prob = beta_sparsity)
  non_zero_betas <- sample(c(TRUE, FALSE), size = p, replace = TRUE, prob = c(beta_sparsity, 1- beta_sparsity))

  # Assign random value to non-zero betas
  betas[non_zero_betas] <- sample(potential_betas, size = sum(non_zero_betas), replace = TRUE)



  ## Variance-Covariance of X
  Var_X <- diag(1, nrow = p, ncol = p)
  for (i in 1:p){
    for (j in 1:p){
      Var_X[i, j] <- .5^(abs(i - j)) # we could change this too!
    }
  }

  # X
  X <- mvtnorm::rmvnorm(n_total, sigma = Var_X)

  # y
  y <- X %*% betas + rnorm(n_total, 0, sigma_error)



  dataset_name <- sprintf("data/data-p_%i_sparsity_%.2f_sigm_%f_ntrain_%i.RData",
                          p, beta_sparsity, sigma_error, n_train)

  # Save and export data:
  # Do the splitting
  #train <- 1:n_train
  #validate <- (n_train+1):(n_train+n_validation)
  #test <- !which(1:n_train+n_validation)
  #Xtrain <- X[, ]
  #Xvalidate <- X[n_train+1:n_train+n_validation, ]
  #X

  # colnames(df) <- c("y", paste0("X", 1:p))
  #
  # df$dataset_number <- rep(1:num_datasets, each = n_total_per_dataset)
  #
  # df$type_data <- rep(rep(c("training", "validation", "test"), times = c(n_train, n_validation, n_test)),
  #                     times = num_datasets)

  # Give it a meaningful name

  dataset_name <- sprintf("data/data-p_%i_sparsity_%.2f_sigm_%f_ntrain_%i.RData",
                           p, beta_sparsity, sigma_error, n_train)


  save("betas", "y", "X", file = dataset_name)
}
