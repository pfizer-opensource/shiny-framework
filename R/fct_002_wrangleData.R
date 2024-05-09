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

## ----wrangleData--------------------------------------------

#' Wrangle imported ADSL dataframe
#'
#' @param myADSL imported dataframe
#'
#' @return tibble object
#' @import dplyr
#' @export
#'
#' @examples
wrangleData <- function(myADSL){
  
  # Create new ARMfac, AGEfac, RACEfac, DURDISfac columns
  tableData <- myADSL %>%
    dplyr::mutate(ARMfac = factor(TRT01AN, 
                           labels = c("Placebo","Xanomelin Low Dose", "Xanomelin High Dose"),
                           levels = c(0,54,81))) %>%
    dplyr::mutate(AGEfac = factor(AGEGR1N,
                           levels = c(1,2,3),
                           labels = c("<65","65-80",">80"))) %>%
    dplyr::mutate(RACEfac = factor(RACEN,
                            levels = c(1,2,6),
                            labels = c("WHITE","BLACK OR AFRICAN AMERICAN","AMERICAN INDIAN OR ALASKA NATIVE"))) %>%
    dplyr::mutate(BMIfac = factor(BMIBLGR1,
                           levels = c("<25","25-<30",">=30"))) %>%
    dplyr::mutate(DURDISfac = factor(DURDSGR1,
                              levels = c("<12", ">=12"))) %>%
    #select columns needed for the  shiny app 
    dplyr::select(ARMfac, AGEfac, AGE, RACEfac, SEX, ETHNIC, BMIBL, BMIfac, HEIGHTBL, WEIGHTBL, DURDIS, DURDISfac, DCDECOD, EFFFL, COMP24FL)
  return(tableData)
}
