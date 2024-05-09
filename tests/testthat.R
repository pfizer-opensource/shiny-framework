# run testthat tests (including shinytest2) -------------------------------
library(testthat)
library(shinytest2)

# source all R scripts in R folder
lapply(list.files("R", full.names = TRUE, recursive = TRUE), source)
# specify test_folder 
test_folder <- "tests/testthat"
# call tests
testthat::test_file( file.path(test_folder, "test-shinytest2.R") )
testthat::test_file( file.path(test_folder, "test-getData.R") )
testthat::test_file( file.path(test_folder, "test-makeData.R") )
testthat::test_file( file.path(test_folder, "test-wrangleData.R") )
testthat::test_file( file.path(test_folder, "test-filterData.R") )
