# DIYLassoElasticNet
Using this repo to collabore on ST443 (Machine Learning) final project:

Implementing Coordinate Descent algorithm for solving Penalised Least Squares (Lasso, Elastic Net)

A list of all functions can be found [here](https://github.com/vviers/DIYLassoElasticNet/blob/master/function_table.md)

----
## Installing
To download and use the package on your machine:

```
library(devtools)
install_github("vviers/DIYLassoElasticNet")
library(DIYLassoElasticNet)
```
----
## Usage

Here is an example use-case of the package where we simulate data and run it.

```r
library(DIYLassoElasticNet)
```

Create data
```r
betas <- rep(c(2, 0, .5, 0.01), 5)
dta_train <- createData(betas = betas, n = 100, sigma_error = 3)
dta_validate <- createData(betas = betas, n = 100, sigma_error = 3)
```

Tune a lasso model (i.e. pick lambda)
```r
 tune_lasso(lambda_max = 2, step_lambda = .1,
           ytrain = dta_train$y, Xtrain = dta_train$X,
           yvalid = dta_validate$y, Xvalid = dta_validate$X)

# Best lambda is 0.4 
# $errors
#     lambda estimated_error is_best
# 1     0.0        13.17927   FALSE
# 2     0.1        12.26027   FALSE
# 3     0.2        11.68068   FALSE
# 4     0.3        11.30466   FALSE
# 5     0.4        11.24156    TRUE
# 6     0.5        11.33416   FALSE
# 7     0.6        11.52249   FALSE
# 8     0.7        11.81333   FALSE
# 9     0.8        12.19440   FALSE
# 10    0.9        12.66137   FALSE
# 11    1.0        13.23329   FALSE
# 12    1.1        13.89013   FALSE
# 13    1.2        14.55949   FALSE
# 14    1.3        15.31925   FALSE
# 15    1.4        16.93944   FALSE
# 16    1.5        17.88436   FALSE
# 17    1.6        18.91824   FALSE
# 18    1.7        20.02061   FALSE
# 19    1.8        21.12140   FALSE
# 20    1.9        19.50444   FALSE
# 21    2.0        20.80506   FALSE
# 
# $best_lambda
# [1] 0.4
```

Figure out what betas the model used
```r
lasso_solve(dta_train$y, dta_train$X, lambda = .4)
# [1] 1.5311064 0.2613068 0.2486529 0.2051319 1.5575664 0.3225001 0.6675448
# [8] 0.5046712 1.1550332 0.0000000 0.0000000 0.6174950 1.3441147 0.1167632
# [15] 0.3703017 0.3928038 1.4282755 0.5485805 0.1793708 0.0000000
```

Do the same for elasticNet
```r
tune_EN(lambda_max = 2, step_lambda = .1,
           ytrain = dta_train$y, Xtrain = dta_train$X,
           yvalid = dta_validate$y, Xvalid = dta_validate$X)
# Best lambda is 0.4 
# with Best Alpha 1 
# $errors
#     lambda alpha estimated_error is_best
# 1     0.0   0.0        13.17927   FALSE
# 2     0.1   1.0        12.26027   FALSE
# 3     0.2   1.0        11.68068   FALSE
# 4     0.3   1.0        11.30466   FALSE
# 5     0.4   1.0        11.24156    TRUE
# 6     0.5   1.0        11.33416   FALSE
# 7     0.6   1.0        11.52249   FALSE
# 8     0.7   1.0        11.81333   FALSE
# 9     0.8   1.0        12.19440   FALSE
# 10    0.9   1.0        12.66137   FALSE
# 11    1.0   0.1        13.20559   FALSE
# 12    1.1   0.0        13.37778   FALSE
# 13    1.2   0.0        13.54466   FALSE
# 14    1.3   0.0        13.71500   FALSE
# 15    1.4   0.0        13.88801   FALSE
# 16    1.5   0.0        14.06303   FALSE
# 17    1.6   0.0        14.23950   FALSE
# 18    1.7   0.0        14.41692   FALSE
# 19    1.8   0.0        14.59486   FALSE
# 20    1.9   0.0        14.77294   FALSE
# 21    2.0   0.0        14.95082   FALSE
# 
# $best_lambda
# [1] 0.4
# 
# $best_alpha
# [1] 1
```
