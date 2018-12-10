## Basic Simulation

devtools::install_github("vviers/DIYLassoElasticNet")
library(DIYLassoElasticNet)

# Seed for reproducibility
set.seed(42)

# Create a table to store results about...
## MSE
MSEtable = matrix(0, 4, 5)
MSEtable = data.matrix(MSEtable)
colnames(MSEtable) = c(paste('example', 1:5))
rownames(MSEtable) = c('lasso.mean','lasso.std','EN.mean','EN.std')

## Sparsity
Nonzero = MSEtable
colnames(Nonzero) = c(paste('example',1:5))
rownames(Nonzero) = c('lasso.median','lasso.std','EN.median','EN.std')


for (e in c(1, 2, 3, 4, 5)){
  cat("example", e, "...\n\n")
  # test with 50 datasets
  MSE = matrix(0, 50, 2)
  Betas = MSE

  for (i in 1:50){

    cat('dataset', i, '\n')

    #create data
    dta_train <- createData(n = 20, sigma_error = 3, example = e)
    dta_validate <- createData(n = 20, sigma_error = 3, example = e)
    dta_test <- createData(n = 200, sigma_error = 3, example = e)

    #tune a lasso model (i.e. pick lambda)
    tune.lasso = tune_lasso(lambda_max = 3, step_lambda = .1,
                            ytrain = dta_train$y, Xtrain = dta_train$X,
                            yvalid = dta_validate$y, Xvalid = dta_validate$X)

    lambda.lasso = tune.lasso$best_lambda

    #figure out what betas the model used
    betas.lasso = lasso_solve(dta_train$y, dta_train$X, lambda = lambda.lasso)

    #get the number of non-zero betas
    num.betas.lasso = sum(betas.lasso != 0)
    Betas[i,1] = num.betas.lasso

    # Do the same for ElasticNet
    # Tune a EN model(pick lambda and alpha)
    tune.EN = tune_EN(lambda_max = 3, step_lambda = .1,
                      ytrain = dta_train$y, Xtrain = dta_train$X,
                      yvalid = dta_validate$y, Xvalid = dta_validate$X)

    # get the betas with the best couple of lambda and alpha
    lambda.EN = tune.EN$best_lambda
    alpha.EN = tune.EN$best_alpha
    betas.EN = elasticNet_solve(dta_train$y, dta_train$X, lambda = lambda.EN,
                                alpha = alpha.EN)
    #get the number of non-zero betas
    num.betas.EN = sum(betas.EN != 0)
    Betas[i,2] = num.betas.EN

    #comparing them with different examples
    #mseLasso
    ypred <- predict(betas.lasso, dta_test$X)
    MSE[i,1] <- mean((dta_test$y - ypred)^2)
    #mseEN
    ypred <- predict(betas.EN, dta_test$X)
    MSE[i,2] <- mean((dta_test$y - ypred)^2)
  }

  # cat('MSE.lasso =',mean(MSE[,1]),'MSE.EN =', mean(MSE[,2]))
  MSEtable[1, e] = mean(MSE[,1])
  MSEtable[2, e] = sd(MSE[,1])
  MSEtable[3, e] = mean(MSE[,2])
  MSEtable[4, e] = sd(MSE[,2])
  MSEtable <- round(MSEtable, 2)

  Nonzero[1, e] = median(Betas[,1])
  Nonzero[2, e] = sd(Betas[,1])
  Nonzero[3, e] = median(Betas[,2])
  Nonzero[4, e] = sd(Betas[,2])
  Nonzero <- round(Nonzero, 2)
}

# Export results for latex
knitr::kable(rbind(MSEtable, Nonzero), format = "latex")
