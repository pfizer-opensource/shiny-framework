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

library(shiny)
library(haven)
library(dplyr)
library(gt)
library(gtsummary)
library(shinyFiles)
library(shinyalert)
library(yaml)


# source functions --------------------------------------------------------
## functions are stored in R/ and should be sourced automatically if in folder
## important - set working directory to app location


# load wrangled data ------------------------------------------------------
wrangled_df <- pullData()

# get data column names ---------------------------------------------------

getColNames <- function(df = wrangled_df) {
  colNames <- colnames(df)
  colNames <- setNames(colNames, colNames)
  colNames
}

# build ui ---------------------------------------------------------------

ui <- fluidPage(
  tagList(github_corner("github_link", gh_url = "https://github.com/pfizer-opensource")),
  align = "center",
    tabsetPanel(
    tabPanel(
      "mainPanel",
      # MAIN APP CODE GOES HERE
      h1("{gtsummary} app"),
      h2("Illustration of the reproducible shiny framework initiative"),
      sidebarLayout(
        sidebarPanel(
          h3("Table options:"),
          tabsetPanel(
            # MAIN TABLE DATA OPTIONS GO HERE 
            tabPanel(
              "Select data",
              selectInput(
                "flag_select",
                "Select Population Flag",
                choices = c("EFFFL", "COMP24FL")
              ),
              radioButtons(
                "safety_pop_select",
                "Choose Population Indicator",
                choices = c("Y", "N"),
                inline = T
              ),
              selectInput(
                "table_vars",
                "Select variables of interest",
                getColNames(),
                multiple = TRUE
              ),
              selectInput(
                "group_vars",
                "Select group of interest",
                getColNames(),
                multiple = TRUE
              )
            ),
            # MAIN TABLE METADATA OPTIONS GO HERE 
            tabPanel(
              "Select Metadata",
              textInput("table_number", "Table number", "1"),
              textInput("title", "Title"),
              textInput("subtitle", "Subtitle"),
              textAreaInput("footnote", "Footnote")
            )
          )
        ),
        # TABLE OUTPUT GOES HERE
        mainPanel(
            h3("Table output:"),
            gt::gt_output(outputId = "table"))
      )
    ),
    tabPanel(
      "capturePanel",
      # CAPTURE REACTIVES CODE GOES HERE
      h3("Capture options/output:"),
      useShinyalert(force = TRUE), #force load shinyAlert
      textInput(
        "inputsName", 
        "Enter object name for list of inputs", 
        "inputs"
      ),
      textInput(
        "exportsName",
        "Enter object name for list of reactives",
        "exports"
      ),
      actionButton("capture", "Click here to capture")
    ),
    tabPanel(
      "loadPanel",
      # LOAD REACTIVES CODE GOES HERE
      h3("Load previous inputs:"),
      shinyFilesButton(
        'files',
        label = 'File select',
        title = 'Please select a file',
        multiple = FALSE
      ),
      actionButton("load", "Load previous objects"),
      verbatimTextOutput('filepaths'),
      uiOutput ("contents"),
      verbatimTextOutput('rawInputValue')
    ),
    # PANEL WITH GENERAL APP INFO GOES HERE
    tabPanel("infoPanel",
             includeMarkdown("README.md"),
             align = "left")
  ))

# define server logic -----------------------------------------------------

server <- function(input, output, session) {

### mainPanel server code--------------------------------------------------
    
  # Generate gtsummary Object
  table_gtsummary <- reactive({
    
    # specified inputs required for creating the table
    req(input$flag_select)
    req(input$safety_pop_select)
    req(input$table_vars)
    req(input$group_vars)

    
    #Filter data on selected population flag
    filtered_df <- wrangled_df %>% 
      filterData(., input$flag_select, input$safety_pop_select)
    
    # create table using filtered data
    if(nrow(filtered_df) > 0){
    table_gt <-
      makeTable(
        data = filtered_df,
        tableVars = input$table_vars,
        groupVars = input$group_vars
      )
    # display warning if there is not enough data to create a summary table 
    }else{
      shinyalert(title = "No data to display",
                 text = "No data matching the Population Flag and Indicator values. Change filters",
                 type = "warning")
    }
  })
  
  # Generate Gt Object From Gtsummary Object
  table_gt  <- reactive({
    table_gtsummary() %>%
      gtsummary::as_gt()
  })
  
  # Add Metadata Onto Gt Object
  table_gt_fmtd <- reactive({
    table_gt() %>%
      tab_header(
        title = md(
          paste(
            "Table",
            paste0(input$table_number, ":"),
            input$title
          )
        ),
        subtitle = md(input$subtitle)
      ) %>%
      tab_source_note(
        source_note = md(input$footnote)
      )
  })
  
  # Render Gt Object
  output$table <- gt::render_gt({
    expr = table_gt_fmtd()
  })
  
  # Export Test Values For Shinytest2
  shiny::exportTestValues(
    table_gtsummary = {
      table_gtsummary()
    },
    table_gt = {
      table_gt()
    },
    table_gt_fmtd = {
      table_gt_fmtd()
    }
  )
  
### capturePanel server code--------------------------------------------------
  
  # Capture app reactives in a generalized way
  observeEvent(input$capture, {
    # generate warning notification to user when one of the selectInputs is missing
    if (is.null(input$table_vars) || is.null(input$group_vars)) {
      shinyalert(
        title = "One or more inputs are missing",
        text = "Return to the mainPanel tab and specify variables and group of interest",
        type = "warning"
      )
    }
    req(input$table_vars)
    req(input$group_vars)
    
    # OPTION - specify reactives of interest to save
    # export <- list(
    #   table_gtsummary = {
    #     table_gtsummary()
    #     },
    #   table_gt = {
    #     table_gt()
    #     }
    #   )
    
    # alternatively, automatically generate list of reactives for export
    # use function to auto gen reactive list
    getReactives4Export <- function(n = 3) {
      # note that function is expected to run within a reactive context
      # get parent environment
      curr_env1 <- rlang::env_parent(n = n)
      reactive_objs <-
        unlist(lapply(curr_env1, shiny::is.reactive))
      export <- names(reactive_objs[reactive_objs == T])
      
      # omit the get_inputs reactive which is used for loading purposes
      # can also omit other reactives as needed here
      export <- export[export != "get_inputs"]
      # wrangle export vector into list with reactive formatting
      export_names <- export
      export <- as.list(export)
      # print TRUE or FALSE to the developers console depending on if 
      # reactives were captured
      if (length(export) > 0) {
        print("TRUE")
        export <- paste0(export, "()")
      } else{
        print("FALSE")
        export
      }
      names(export) <- export_names
      # parse list reactives to get objects
      eval_parse_reactive <-
        function(reactive_str) {
          eval(parse(text = reactive_str))
        }
      export_vals <- lapply(export, eval_parse_reactive)
      # TODO - consider also saving reactive expressions
      # this export_expr line of code gets those expressions into a list
      export_expr <- lapply(names(export), eval_parse_reactive)
      return(export_vals)
    }
    export <- getReactives4Export()
    # save inputs based on user selections
    # save YAML files
    write_yaml(
      reactiveValuesToList(input),
      paste0("inputs/", input$inputsName, ".YAML")
    )
    # save gtsummary export generated based on user selections
    saveRDS(export, file = paste0("exports/", input$exportsName, ".RDS"))
    # REVIEW - consider saving outs
    # leaving this out for time being
    # outs <- outputOptions(output)
    # lapply(names(outs), function(name) {
    #   outputOptions(output, name, suspendWhenHidden = FALSE)
    # })
    # print(outs)
  })
  
### capturePanel server code--------------------------------------------------
  
    # Create inputs folder variable
    roots <- c(root = 'inputs/')
    
    # Choose saved input file YAML file of interest 
    observeEvent(input$files, {
      if (!is.null(input$files)) {
        shinyFileChoose(input,
                        'files',
                        root = roots,
                        filetypes = c('', 'YAML'))
      }
    })
    
    # Print the name of the selected YAML file to user
    output$filepaths <- renderPrint({
      req(input$files)
      if (!is.null(input$files)) {
        cat("File selected:",
            parseFilePaths(roots, input$files)$name)
      }
    })
  
  # Read in the contents of the chosen YAML input file when selected
  get_inputs <- reactive({
    req(input$files)
    inFile <- input$files
    if (length(parseFilePaths(roots, input$files)$name) != 0) {
      read_yaml(paste0("inputs/", parseFilePaths(roots, inFile)$name))
    }
  })
  
  
  # Output the chosen inputs for the user to view
  output$contents <- renderUI({
    
    if (!is.null(get_inputs())) {
    
    # Access user inputs excluding the ones we don't want to get printed out
    input_names <- setdiff(
      names(get_inputs()), 
      # excluding framework action buttons and export/input names
      c("capture", "load", "files", "inputsName", "exportsName")
    )

      #Access input names
      input_desc <- get_inputs()[input_names]

      # Print out input names and values from selected YAML file
      HTML(paste0(input_names,": ", input_desc, br()))
    }
  })
  
  # Load selected inputs from the file chosen by the user to recreate a table
  observeEvent(input$load, {
    req(get_inputs())
    
    input_to_update <- get_inputs()
    
    # Give user a pop-up window informing that new inputs are being loaded when
    # the load input$load burtton is clicked
    if (is.null(input_to_update)) {
      input_to_update <- character(0)
    } else{
      shinyalert(title = "Return to the mainPanel tab and view the updated table",
                 text = "Note, it might need some time to load",
                 type = "success")
    }
    
    # Update inputs with the loaded inputs from YAML 
    multiUpdateSelectInput <- function(input_name, session, input_to_update){
      updateSelectInput(
        session,
        input_name,
        selected = input_to_update[[input_name]]
      )
    }
    # This vector will try to pull out your user inputs 
    input_order <- setdiff(
      names(input_to_update), 
      # excluding framework action buttons
      c("capture", "load", "files")
    )
    # Alternatively, you can specify the input vector with your own order
    # input_order <- c(
    #   "table_vars", "group_vars",
    #   "flag_select", "safety_pop_select"
    # )
    map(
      input_order,
      multiUpdateSelectInput,
      session = session, input_to_update = input_to_update
    )
  })
  
}

# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
# runApp(shinyApp(ui = ui, server = server),
# host = "0.0.0.0",
# port = 80)