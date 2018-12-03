#' predict
#' @description uses the results of a model to predict new data
#'
#' @param betas the betas returned by a model
#' @param new_data new data
#' @return a vector of new predictions
#' @export
predict <- function(betas, new_data){
  return(new_data%*%betas)
}
