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

# load libraries ----------------------------------------------------------
library(purrr)
library(tidyselect)
library(dplyr)

# Create list of R files that start with fct_
source_files <- list.files("R", "^fct_")

# Load all R functions
purrr::map(paste0("R/", source_files), source) 

# Save ADSL data object for testing
myADSL <- getData()

# Capture expected column names for ADSL
myADSL_expected_names <-
  c(
    "TRT01AN",
    "AGEGR1N",
    "AGE",
    "RACEN",
    "SEX",
    "ETHNIC",
    "BMIBL",
    "BMIBLGR1",
    "HEIGHTBL",
    "WEIGHTBL",
    "DURDIS",
    "DURDSGR1",
    "DCDECOD",
    "EFFFL",
    "COMP24FL"
  )

# Capture wrangleData function test data output
wrangleData_output <- wrangleData(myADSL)

# Capture expected column names for ADSL after it has been wrangled
wrangleData_out_expected_names <-
  c(
    "ARMfac",
    "AGEfac",
    "AGE",
    "RACEfac",
    "SEX",
    "ETHNIC",
    "BMIBL",
    "BMIfac",
    "HEIGHTBL",
    "WEIGHTBL",
    "DURDIS",
    "DURDISfac",
    "DCDECOD",
    "EFFFL",
    "COMP24FL"
  )

# Capture expected variables to create factors for the wrangeData function
expected_fac_vars <- c("TRT01AN", "AGEGR1N",
                       "RACEN", "BMIBLGR1",
                       "DURDSGR1")


#Check if any of the columns in the test dataset have empty columns
check_for_empty_cols <- function(data) {
  data %>%
    dplyr::select(everything()) %>%
    purrr::map( ~ all(is.na(.x))) %>%
    purrr::reduce(all)
}

# Capture expectedTable output to test makeTable function
expectedTable <-
  makeTable(
    data = wrangleData_output,
    tableVars = c("AGE", "AGEfac"),
    groupVars = "ARMfac"
  )

#Capture data to filter
data_to_filter <- wrangleData_output %>% 
  head(n=10) 

#Capture filtered data for testing
exp_filtered_dat_fl1 <- filterData(data_to_filter, "EFFFL", "N")
exp_filtered_dat_fl2 <- filterData(data_to_filter, "COMP24FL", "Y")
