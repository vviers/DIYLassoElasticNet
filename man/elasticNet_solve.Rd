% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coordinate_descent_EN.R
\name{elasticNet_solve}
\alias{elasticNet_solve}
\title{elasticNet_solve}
\usage{
elasticNet_solve(y, X, lambda = 0.01, alpha = 0.5, epsilon = 1)
}
\arguments{
\item{y}{a nx1 label vector}

\item{X}{the design matrix}

\item{lambda}{the weight of the overall penalty term}

\item{alpha}{the relative weigth given to the L1 (Lasso) penalty}

\item{epsilon}{the smallest change in penalised RSS that defines convergence}
}
\value{
a px1 vector of betas
}
\description{
a Solver for the ElasticNet problem
}
