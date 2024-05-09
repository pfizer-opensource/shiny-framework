library(testthat)


test_that('output has correct class and dimentions', {
  expect_s3_class(expectedTable, c("tbl_summary", "gtsummary"))
  expect_equal(dim(expectedTable$inputs$data), c(254, 3))
})

test_that('output table has correct names and data types', {
  expect_named(expectedTable$inputs$data, c("ARMfac", "AGE", "AGEfac"))
  expect_s3_class(c(expectedTable$inputs$data$AGEfac, expectedTable$inputs$data$ARMfac), "factor")
  
})
