#' tune_lasso
#' @description finds optimal lambda, given train and validation sets
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
tune_lasso <- function(lambda_max = 10,
                    step_lambda = .1,
                    ytrain,
                    Xtrain,
                    yvalid,
                    Xvalid){


  cv.one_pass <- function(lambda){
    error <- 0

    beta.lasso <- lasso_solve(ytrain, Xtrain, lambda = lambda)
    ypred <- predict(beta.lasso, Xvalid)

    error <- mean((yvalid - ypred)^2)

    return(error)
  }

  lambdas <- seq(0, lambda_max, step_lambda)

  df <- data.frame(lambda = lambdas,
                   estimated_error = numeric(length(lambdas)))

  for (l in 1:length(df$lambda)){
    df$estimated_error[l] <- cv.one_pass(lambda = df$lambda[l])
  }

  best_lambda <- df$lambda[which.min(df$estimated_error)]

  df$is_best <- df$lambda == best_lambda

  cat("Best lambda is", best_lambda, "\n")

  return(list(errors = df, best_lambda = best_lambda))

}
