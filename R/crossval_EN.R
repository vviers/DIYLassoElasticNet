#' cv_EN
#' @description use cross-validation to find the best values of lambda and alpha
#'
#' @param y a nx1 label vector
#' @param X the design matrix
#' @param lambda_max maximum lambda to try
#' @param step_lambda step size between 0 and \code{lambda_max}
#' @param n_folds the number of folds to use in cross-validation
#' @param one_stderr_rule whether to use the one-standard-error rule when choosing lambda
#'
#' @return a list object containing a data.frame summarizing the error for each pair of lambda/alpha, and the best lambda/alpha
#' @export
cv_EN <- function(lambda_max = 10,
                     step_lambda = .1,
                     n_folds = 10,
                     y,
                     X,
                     one_stderr_rule = TRUE){

  # set K-folds
  if (nrow(X) %% n_folds != 0){
    warning("Data not perfectly divisible into n balanced folds. Rounding...")
  }

  folds <- sample(rep(1:n_folds, ceiling(nrow(X) / n_folds)), size = length(y))

  # get MSE wrt lambda
  cv.one_passEN <- function(lambda, alpha){

    # Target errors vector
    errors <- numeric(n_folds)

    for (i in 1:n_folds){

      Xtest = X[folds == i, ]
      ytest = y[folds == i]
      Xtrain = X[folds != i, ]
      ytrain = y[folds != i]

      beta.EN <- elasticNet_solve(ytrain, Xtrain, lambda = lambda, alpha = alpha)
      ypred <- predict(beta.EN, Xtest)

      errors[i] <- mean((ytest - ypred)^2)
    }
    return(list(error = mean(errors), std = sd(errors)))
  }

  # Init grid of lambdas and alphas
  lambdas <- seq(0, lambda_max, step_lambda)
  alphas<-seq(0, 1, 0.1)

  df <- data.frame(lambda = lambdas,
                   alpha = numeric(length(lambdas)),
                   estimated_error = numeric(length(lambdas)),
                   std = numeric(length(lambdas)))

  for (i in 1:length(df$lambda)){
    # for each lambda, choose the best alpha which gives min error
    # store the data in alpha_best, error, std, always store the min one
    # initiate with alpha = 0
    alpha_best <- 0
    current_pass <- cv.one_passEN(lambda = df$lambda[i], alpha = alpha_best) #
    error <- current_pass$error
    std <- current_pass$std

    for ( j in 2:length(alphas)){
      current_pass <- cv.one_passEN(lambda = df$lambda[i], alpha = alphas[j])

      if(error > current_pass$error){

        error <- current_pass$error
        std <- current_pass$std
        alpha_best = alphas[j]

      }
    }
    #then put it in the df table, with the selected alpha and corresponding error and std

    df$estimated_error[i] <- error
    df$std[i] <- std
    df$alpha[i] <- alpha_best
  }

  #the confidence internval of MSE
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

#' plot_cv_EN
#' @description plots the result of \code{cv_EN}
#'
#' @param cv_results the list returned by \code{cv_EN}
#' @return a plot
#' @export
plot_cv_EN <- function(cv_results){

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
