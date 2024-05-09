library(shinytest2)

test_that("{shinytest2} Assess armfac grouped gtsummary object", {
  app <- AppDriver$new(name = "group-armfac", height = 746, width = 998)
  app$set_inputs(table_vars = c("AGE", "AGEfac"))
  app$set_inputs(group_vars = "ARMfac")
  
  gtsummary_obj <- app$get_value(export = "table_gtsummary")
  
  expect_s3_class( gtsummary_obj , c("tbl_summary", "gtsummary" ))
  expect_equal( dim(gtsummary_obj$inputs$data), c(234, 3) )
  expect_equal( colnames(gtsummary_obj$inputs$data), c("ARMfac", "AGE", "AGEfac") )
  
  app$stop()
})

test_that("{shinytest2} Assess armfac grouped gt object", {
  app <- AppDriver$new(name = "group-armfac", height = 746, width = 998)
  app$set_inputs(table_vars = c("AGE", "AGEfac"))
  app$set_inputs(group_vars = "ARMfac")
  
  gt_obj <- app$get_value(export = "table_gt")
  
  expect_s3_class( gt_obj , c("gt_tbl", "list"))
  expect_equal( dim(gt_obj$`_data`), c(5, 9) )
  
  app$stop()
})
