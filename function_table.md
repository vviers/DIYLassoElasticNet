## A list of the useful functions in the package.

| function | parameters | usage | source code |
|------:|:------|:------:|:----:|
| `lasso_solve` |`y`, `X`, `lambda`, `epsilon = .1` | a Solver for the Lasso problem using the coordinate descent algorithm. Returns a vector of betas. | [see code](https://github.com/vviers/DIYLassoElasticNet/blob/master/R/coordinate_descent_lasso.R) |
| `elasticNet_solve` | `y`, `X`, `lambda`, `epsilon = .1`| a Solver for the ElasticNet problem using the coordinate descent algorithm. Returns a vector of betas. | [see code](https://github.com/vviers/DIYLassoElasticNet/blob/master/R/coordinate_descent_EN.R) |
| `tune_lasso` |`lambda_max` , `step_lambda`, `ytrain`, `Xtrain`, `yvalid`, `Xvalid`|Returns the optimal lambda for Lasso, given a training and a validation set | [see code](https://github.com/vviers/DIYLassoElasticNet/blob/master/R/lasso_tune.R) |
| `tune_EN` |`lambda_max` , `step_lambda`, `ytrain`, `Xtrain`, `yvalid`, `Xvalid`| Returns the optimal lambda and alpha for ElasticNet, given a training and a validation set | [see code](https://github.com/vviers/DIYLassoElasticNet/blob/master/R/EN_tune.R) |
| `cv_lasso` | `lambda_max`, `step_lambda`, `n_folds = 10`, `y`, `X`, `one_stderr_rule = TRUE`| Finds the best lambda for Lasso using cross validation. | [see code](https://github.com/vviers/DIYLassoElasticNet/blob/master/R/crossval_lasso.R) |
| `cv_EN` | `lambda_max`, `step_lambda`, `n_folds = 10`, `y`, `X`, `one_stderr_rule = TRUE`| Finds the best lambda and alpha for Elastic Net using cross validation. | [see code](https://github.com/vviers/DIYLassoElasticNet/blob/master/R/crossval_EN.R) |
| `plot_cv_lasso` | `cv_results` | Takes the output of `cv_lasso` and plots the MSE associated with each lambda. | [see code](https://github.com/vviers/DIYLassoElasticNet/blob/master/R/crossval_lasso.R) |
| `plot_cv_EN`| `cv_results` | Plot the result of `cv_EN` |  [see code](https://github.com/vviers/DIYLassoElasticNet/blob/master/R/crossval_EN.R) |
| `predict` | `betas`, `new_data`| Given a vector of betas for a model, returns the model's predictions for a new set of observations. | [see code](https://github.com/vviers/DIYLassoElasticNet/blob/master/R/predict.R) |
| `createData` | `betas`, `n`, `sigma_error`, `example_number` | Creates simulated data for a given simulation setting (see more below) | [see code](https://github.com/vviers/DIYLassoElasticNet/blob/master/R/generate_data.R) |
