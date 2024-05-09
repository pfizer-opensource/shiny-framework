test_that('filtered data has correct dimentions', {
  expect_equal(dim(exp_filtered_dat_fl1), c(0, 15))
  expect_equal(dim(exp_filtered_dat_fl2), c(5, 15))
})

test_that("output does or does not contain empty columns when expected", {
  expect_true(check_for_empty_cols(exp_filtered_dat_fl1))
  expect_false(check_for_empty_cols(exp_filtered_dat_fl2))
})

test_that("expected columns are all present in the data", {
  expect_success(expect_equal(sum(wrangleData_out_expected_names %in% names(exp_filtered_dat_fl1)), 15))
  expect_success(expect_equal(sum(wrangleData_out_expected_names %in% names(exp_filtered_dat_fl2)), 15))
})
