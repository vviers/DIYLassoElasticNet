#' createData
#' @description creates simulated data to test our solvers on
#' @param betas a vector of beta values
#' @param n number of observations
#' @param sigma_error noisiness of the Data Generating Process
#'
#' @return a list containing \code{X}, \code{y} and \code{betas}
#'
#' @export
createData <- function(betas, n, sigma_error){

  ## Betas
  betas <- betas
  p <- length(betas)

  ## Variance-Covariance of X
  Var_X <- diag(1, nrow = p, ncol = p)
  for (i in 1:p){
    for (j in 1:p){
      Var_X[i, j] <- .5^(abs(i - j)) # we could change this too!
    }
  }

  # X
  X <- mvtnorm::rmvnorm(n, sigma = Var_X)

  # y
  y <- X %*% betas + rnorm(n, 0, sigma_error)

  return(list(X = X, y = y, betas = betas))

}
