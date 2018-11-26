# In a function: simple version that works
# Assumes that X and y have already been properly standardized.
lasso.solve <- function(y, X, lambda = .01, epsilon = .01){

  #print(lambda)

  RSS <- function(betas){
    return((1/(2*length(y))) * sum((y - X %*% betas)^2) + lambda * sum(abs(betas)))
  }

  # Standardize X
  X <- scale(X)
  # De-mean y
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
      betas[j] <- sign(beta_star) * max(c((abs(beta_star) - lambda), 0))

    }

    #print(RSS(betas = betas))

    # check convergence (no beta moved more than epsilon)
    # NB: sum(c(FALSE, FALSE, FALSE)) => 0
    # if (RSS(betas = betas) < RSS_before){
    #   hasConverged <- abs(RSS(betas = betas) - RSS_before) < epsilon
    # } else {
    #   hasConverged <- TRUE
    #   return(betas_before)
    # }

    hasConverged <- abs(RSS(betas = betas) - RSS_before) < epsilon
    #run <- run+1

  }

  return(betas)

}
