#' cv_lasso
#' @description use cross-validation to find the best value of lambda
#'
#' @param y a nx1 label vector
#' @param X the design matrix
#' @param lambda_max maximum lambda to try
#' @param step_lambda step size between 0 and \code{lambda_max}
#' @param n_folds the number of folds to use in cross-validation
#' @param one_stderr_rule whether to use the one-standard-error rule when choosing lambda
#'
#' @return a list object containing a data.frame summarizing the error for each lambda, and the best lambda
#' @export
cv_lasso <- function(lambda_max = 5,
                     step_lambda = .1,
                     n_folds = 10,
                     y,
                     X,
                     one_stderr_rule = TRUE){

  if (nrow(X) %% n_folds != 0){
    warning("Data not perfectly divisible into n balanced folds. Rounding...")
  }

  folds <- sample(rep(1:n_folds, ceiling(nrow(X) / n_folds)), size = length(y))

  cv.one_pass <- function(lambda){
    errors <- numeric(n_folds)
    for (i in 1:n_folds){

      Xtest = X[folds == i, ]
      ytest = y[folds == i]
      Xtrain = X[folds != i, ]
      ytrain = y[folds != i]

      beta.lasso <- lasso_solve(ytrain, Xtrain, lambda = lambda)
      ypred <- predict(beta.lasso, Xtest)

      errors[i] <- mean((ytest - ypred)^2)
    }
    return(list(error = mean(errors), std = sd(errors)))
  }

  lambdas <- seq(0, lambda_max, step_lambda)

  df <- data.frame(lambda = lambdas,
                   estimated_error = numeric(length(lambdas)),
                   std = numeric(length(lambdas)))

  for (l in 1:length(df$lambda)){
    one_pass <- cv.one_pass(lambda = df$lambda[l])
    df$estimated_error[l] <- one_pass$error
    df$std[l] <- one_pass$std
  }

  df$ci_up <- df$estimated_error + df$std
  df$ci_down <- df$estimated_error - df$std


  if (!one_stderr_rule){

    best_lambda <- df$lambda[which.min(df$estimated_error)]

  } else {

    thresh <- df$ci_up[which.min(df$estimated_error)]

    best_lambda <- max(df$lambda[df$estimated_error <= thresh])

  }

  df$is_best <- df$lambda == best_lambda

  cat("Best lambda is", best_lambda)

  return(list(errors = df, best_lambda = best_lambda))

}

#' plot_cv.lasso
#' @description plots the result of \code{cv_lasso}
#'
#' @param cv_results the list returned by \code{cv_lasso}
#' @return a plot
#' @export
plot_cv_lasso <- function(cv_results){

  dta <- cv_results$errors

  dta %>%
    ggplot2::ggplot(aes(x = lambda)) +
    ggplot2::geom_point(aes(y = estimated_error, color = is_best), size = 1, pch = 3) +
    ggplot2::geom_point(aes(y = ci_up), color = "red", size = 1, pch = 3) +
    ggplot2::geom_point(aes(y = ci_down), color = "red", size = 1, pch = 3) +
    ggplot2::geom_hline(yintercept = dta[which.min(dta$estimated_error), "ci_up"],
               color = "grey", size = .2) +
    ggplot2::scale_color_manual(name = "Best Lambda",
                       values = c("TRUE" = "green", "FALSE" = "black")) +
    ggplot2::geom_segment(aes(x=cv_results$best_lambda, xend=cv_results$best_lambda,
                     y=0, yend = dta[dta$is_best, "estimated_error"]),
                 lty = "dashed", size = .25, color = "green") +
    ggplot2::ylab("10-fold average cross-validation error")

}
