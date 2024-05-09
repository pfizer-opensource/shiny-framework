# Copyright 2024 Pfizer Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

## ----setup, include=FALSE-----------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(haven)
library(dplyr)
library(gtsummary)
library(gt)


## ----makeTable----------------------------------------------

#' Create gtsummary table with table and group variables selected
#'
#' @param data wrangled dataframe
#' @param tableVars summary table variables
#' @param groupVars summary table grouping variables
#'
#' @return tibble object
#' @import dplyr gtsummary tidyselect
#' @export
#'
#' @examples
#' makeTable(data = tableData, tableVars = c("AGE", "AGEfac"), groupVars = "ARMfac")

makeTable <- function(data, tableVars, groupVars){
  
  data %>%
    # Select all specified groupVars and tableVars
    dplyr::select(tidyselect::all_of(c({{groupVars}},{{tableVars}}))) %>%
    gtsummary::tbl_summary(by = {{groupVars}},
                missing = "no") %>% # don't list missing data separately
    gtsummary::add_n() %>% # add column with total number of non-missing observations
    gtsummary::modify_header(label = "**Variable**") %>% # update the column header
    gtsummary::bold_labels()
}


## ----eval = FALSE-------------------------------------------
# makeTable(data = tableData, tableVars = c("AGE", "AGEfac"), groupVars = "ARMfac")

