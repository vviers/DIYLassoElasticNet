#' createData
#' @description creates simulated data to test our solvers on
#' @param n number of observations
#' @param sigma_error noisiness of the Data Generating Process
#' @param example the numeric id of the simulation setting to be used (see report)
#'
#' @return a list containing \code{X}, \code{y} and \code{betas}
#'
#' @export
createData <- function(n, sigma_error, example = c(1, 2, 3, 4, 5)){

  # betas
  if (example == 1){
    betas <-c(3, 1.5, 0, 0, 2, 0, 0, 0)

  } else if (example == 2){
    betas <-rep(c(2, 0, .5, 0.01), 5)

  } else if (example == 3){
    betas <-rep(c(2, 0, .5, 0.01), 8)

  } else if (example == 4){
    betas <- c(2, 0, 0.5, 0.01, 2, -0.5, 1.5, -0.9, 0, 0)

  } else if (example == 5){
    betas <- rep(c(0, 3), each = 15)
  }

  p <- length(betas)

  # Get X
  if (example %in% c(1, 2, 3)){
    Var_X <- diag(1, nrow = p, ncol = p)
    for (i in 1:p){
      for (j in 1:p){
        Var_X[i, j] <- .5^(abs(i - j))
      }
    }
    X <- mvtnorm::rmvnorm(n, sigma = Var_X)

  } else if (example == 5){
    Var_X <- diag(1, nrow = p, ncol = p)
    X <- mvtnorm::rmvnorm(n, sigma = Var_X)

  } else if (example == 4){
    X = matrix(0, n, p)
    X[,1] = rnorm(n, sd = 1)
    X[,2] = rnorm(n, sd = 1)
    X[,3] = rnorm(n, sd = 1)
    for(i in 4:p){
      r = 0.6+0.3*runif(1)
      r = matrix(c(r, sqrt(1-r*r)), 2, 1)
      a = sample(i-1, 2, replace = FALSE)
      X[,i] = X[,a] %*% r
    }
  }

  # y
  y <- X %*% betas + rnorm(n, 0, sigma_error)

  return(list(X = X, y = y, betas = betas))

}
