#' elasticNet_solve
#' @description a Solver for the ElasticNet problem
#' @param y a nx1 label vector
#' @param X the design matrix
#' @param lambda the weight of the overall penalty term
#' @param alpha the relative weigth given to the L1 (Lasso) penalty
#' @param epsilon the smallest change in penalised RSS that defines convergence
#'
#' @return a px1 vector of betas
#'
#'@export
elasticNet_solve <- function(y, X, lambda = .01, alpha = .5, epsilon = .01){

  print(paste0("lambda ", lambda, ", alpha ", alpha))

  RSS <- function(betas){
    return((1/(2*length(y))) * sum((y - X %*% betas)^2) + lambda * (alpha * sum(abs(betas)) + (1-alpha) * sum(betas^2))) # penalty
  }

  # rescale data
  X <- scale(X)
  y <- y - mean(y)

  # get p
  p <- ncol(X)

  # Init all betas = 0
  betas <- numeric(p)

  # Set hasConverged to False for now
  hasConverged <- FALSE

  #Keep track of the runs (useful for debugging)
  #run <- 1

  while(!hasConverged){

    #print(run)

    betas_before <- betas
    RSS_before <- RSS(betas = betas_before) # to keep track of convergence
    #print(RSS_before)

    # update all betas until they converge

    for (j in 1:p){

      # force Bj = 0
      betas[j] = 0

      # get vector of partial residuals
      r_j <- (y - X %*% betas)

      # get OLS estimate of beta_j*
      # we can use cov because y and X are all standardized
      beta_star = cov(X[, j], r_j)

      # Update beta_j with soft_thresholding
      betas[j] <- sign(beta_star) * (max(c((abs(beta_star) - lambda*alpha), 0))) / (1 + lambda*(1-alpha))

    }

    # check convergence (no beta moved more than epsilon)
    # NB: sum(c(FALSE, FALSE, FALSE)) => 0
    #hasConverged <- (sum(abs(betas_before - betas) > epsilon) == 0)

    hasConverged <- abs(RSS(betas = betas) - RSS_before) < epsilon

    #run <- run+1

  }
  return(betas)
}
