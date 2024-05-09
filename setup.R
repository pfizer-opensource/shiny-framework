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

# This project uses {renv} package that used repository and packages specified below. 
# You may choose to follow renv commands below to restore renv installation from the renv.lock file (Option 1)
# or install package dependencies on your own from the specified repo (Option 2).

# Option 1:
# We recommend using the {renv} package to isolate packages
install.packages("renv")
renv::activate()
renv::restore()

# Option 2:
PPM_repos <- "https://packagemanager.posit.co/cran/2024-03-01"
# For CentOS Linux: "https://packagemanager.posit.co/cran/__linux__/centos7/2024-03-01"
# Please visit https://packagemanager.posit.co/ to install the correct package
#   set for your OS.
# This Shiny app has been tested and works with packages at 2024-03-01.

pkg_deps <- c("dplyr", "gt", "gtsummary", "haven", "rlang", "shiny", "shinyalert",
              "shinyFiles", "yaml", "knitr", "tidyselect", "purrr", "diffdf",
              "sessioninfo", "waldo", "shinytest2", "testthat", "markdown")

install.packages( pkg_deps )