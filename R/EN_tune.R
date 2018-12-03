#' tune_EN
#' @description finds optimal lambda / alpha, given train and validation sets
#'
#' @param ytrain a nx1 label vector used for training
#' @param Xtrain the design matrix used for training
#' @param yvalid a nx1 label vector used for validating
#' @param Xvalid the design matrix used for validating
#' @param lambda_max maximum lambda to try
#' @param step_lambda step size between 0 and \code{lambda_max}
#' @param n_folds the number of folds to use in cross-validation
#' @param one_stderr_rule whether to use the one-standard-error rule when choosing lambda
#'
#' @return a list object containing a data.frame summarizing the error for each pair of lambda/alpha, and the best lambda/alpha
#' @export
tune_EN <- function(lambda_max = 10,
                  step_lambda = .1,
                  ytrain,
                  Xtrain,
                  yvalid,
                  Xvalid){


  # get MSE wrt lambda
  cv.one_passEN <- function(lambda, alpha){

    # Target errors vector
    error <- 0

    beta.EN <- elasticNet_solve(ytrain, Xtrain, lambda = lambda, alpha = alpha)
    ypred <- predict(beta.EN, Xvalid)

    error <- mean((yvalid - ypred)^2)

    return(error)
  }

  # Init grid of lambdas and alphas
  lambdas <- seq(0, lambda_max, step_lambda)
  alphas<-seq(0, 1, 0.1)

  df <- data.frame(lambda = lambdas,
                   alpha = numeric(length(lambdas)),
                   estimated_error = numeric(length(lambdas)))

  for (i in 1:length(df$lambda)){
    # for each lambda, choose the best alpha which gives min error
    # store the data in alpha_best, error, std, always store the min one
    # initiate with alpha = 0
    alpha_best <- 0
    error <- cv.one_passEN(lambda = df$lambda[i], alpha = alpha_best)

    for ( j in 2:length(alphas)){
      current_pass <- cv.one_passEN(lambda = df$lambda[i], alpha = alphas[j])

      if(error > current_pass){

        error <- current_pass
        alpha_best = alphas[j]

      }
    }
    #then put it in the df table, with the selected alpha and corresponding error and std
    df$estimated_error[i] <- error
    df$alpha[i] <- alpha_best
  }



  best_lambda <- df$lambda[which.min(df$estimated_error)]
  best_alpha <- df$alpha[which.min(df$estimated_error)]

  df$is_best <- df$lambda == best_lambda

  cat("Best lambda is", best_lambda, "\nwith Best Alpha", best_alpha, "\n")

  return(list(errors = df, best_lambda = best_lambda, best_alpha = best_alpha))

}
