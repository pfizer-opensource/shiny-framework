library(testthat)

test_that("adsl data is a dataframe with expected dimentions", {
  expect_success(expect_type(myADSL, 'list'))
  expect_success(expect_equal(dim(myADSL), c(254,48)))

})

test_that("expected columns are all present in the data", {
  expect_success(expect_equal(sum(expected_fac_vars %in% names(myADSL)), 5))
  expect_success(expect_equal(sum(myADSL_expected_names %in% names(myADSL)), 15))
})

test_that("output does not contain any empty columns", {
  expect_false(check_for_empty_cols(myADSL))
})

