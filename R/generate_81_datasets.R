source("R/simulation_data_generator.R")


for (p in c(10, 50, 500)){
  for (sparsity in c(.1, .5, .8)){
    for (nt in c(20, 100, 500)){
      for (sigerror in c(1, 3, 10)){
        createDataSet(p = p, beta_sparsity = sparsity,
                      n_train = nt, n_validation = nt, n_test = 200,
                      num_datasets = 50, sigma_error = sigerror)
      }
    }
  }
}
