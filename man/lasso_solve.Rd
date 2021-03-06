% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coordinate_descent_lasso.R
\name{lasso_solve}
\alias{lasso_solve}
\title{lasso_solve}
\usage{
lasso_solve(y, X, lambda = 0.01, epsilon = 1)
}
\arguments{
\item{y}{a nx1 label vector}

\item{X}{the design matrix}

\item{lambda}{the weight of the penalty term in the Lasso problem}

\item{epsilon}{the smallest change in penalised RSS that defines convergence}
}
\value{
a px1 vector of betas
}
\description{
a Solver for the Lasso problem
}
