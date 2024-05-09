library(testthat)

test_that("wrangleData output is a data frame with expected column names with no missing column names", {
  
  expect_success(expect_type(wrangleData_output, 'list'))
  expect_success(expect_equal(dim(wrangleData_output), c(254, 15)))
  expect_true(sum(is.na(names(wrangleData_output))) == 0)
  expect_success(expect_equal(names(wrangleData_output),wrangleData_out_expected_names))
  
})

test_that("expected columns are factors",{
  expect_s3_class(wrangleData_output$RACEfac, "factor")
  expect_s3_class(wrangleData_output$BMIfac, "factor")
})

test_that("output does not contain empty columns",{
expect_false(check_for_empty_cols(wrangleData_output))
  })
