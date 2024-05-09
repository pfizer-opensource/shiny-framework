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

## ----filterData--------------------------------------------

#' Filter wrangled dataframe
#'
#' @param tableData dataframe
#' @param flag population flag variable name to filter summary table
#' @param safety_pop population flag value to filter summary table (e.g., Y/N)
#'
#' @return tibble object
#' @import dplyr
#' @export
#'
#' @examples

filterData <- function(tableData, flag, safety_pop){
  filteredData <- tableData %>% 
    dplyr::filter(!!sym(flag) == safety_pop) # filter data on specified safety population
  
  return(filteredData)
}
