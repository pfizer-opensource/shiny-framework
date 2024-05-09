# load libraries
library(diffdf)
library(purrr)
library(waldo)
library(yaml)
library(gt)
library(sessioninfo)

# source functions, inputs and outputs
source_files <- list.files("R", "^fct_") 
purrr::map(paste0("R/", source_files), source) 

# load inputs.YAML
inputs <- read_yaml('inputs/inputs.YAML')
# load exports.RDS
exports <- readRDS('exports/exports.RDS')

# utilize loaded functions to get, wrangle, and filter data
dat <- getData() %>% 
  wrangleData()  %>%
  # filter data using shiny recorded reactives
  filterData(., flag = inputs[["flag_select"]], safety_pop = inputs[["safety_pop_select"]])

#run makeTable function using shiny recorded reactives
gt_dat <- makeTable(data = dat, tableVars = inputs[["table_vars"]], groupVars = inputs[["group_vars"]]) 
gt::gtsave(gtsummary::as_gt(gt_dat), "gtsummary_table.html")

#compare shiny and function outputs with waldo
result <- waldo::compare(as_tibble(gt_dat$table_body), as_tibble(exports$table_gtsummary$table_body))
result

sessioninfo::session_info()
