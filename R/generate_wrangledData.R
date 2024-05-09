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

# source functions
source_files <- list.files("R", "^fct_") 
purrr::map(paste0("R/", source_files), source) 

# call functions to generate data 
df <- getData()
wrangled_df <- wrangleData(df)

# save dataset
saveRDS(wrangled_df, 'data/wrangledData.RDS')
