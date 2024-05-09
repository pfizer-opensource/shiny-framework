# Illustrating good practice for production Shiny app development

## License information

The contents of this repository are provided under the Apache v2.0
license as laid out in the LICENSE.md file.

## Background

Many people who write Shiny apps are not professional developers. But
taking an app from a Proof of Concept (PoC) state to Production quality
often involves a significant effort and refactoring code to make it more
robust, testable, and verifiably correct.

The Shiny application we are sharing here reads ADaM format data and
creates a simple summary table using the {gtsummary} package. The user
can nominate dataset variables to summarise and select a grouping
variable and {gtsummary} creates a simple table.

## Why are Pfizer sharing this?

The functionality within this app is simple, but we are illustrating the
WAGOLL principle - What A Good One Looks Like - where the example is
simple, so it does not distract from the main point - defining a
framework for developing a Shiny app which will make it "Production
quality". We wanted to be able to provide some quick guidance and an
example app for our colleagues at Pfizer that would illustrate these
concepts:

-   Using functions as the workhorse code of the app
-   Testing these functions outside the app to verify correctness using
    {testthat} or similar
-   Capturing the state of the app by externalising reactives and
    user-choices to YAML
-   Reconstituting the state of the app by ingesting YAML
-   Testing the app as a whole using {shinytest2} and similar tools.
-   A template .R script which can be used to recreate the summary table
    created within the application ***outside*** of the Shiny app using
    the YAML file and the R functions used within the app. By running
    the template .R script in a validated R environment we can
    effectively recreate what the user defined within the Shiny app but
    in a qualified, validated, production environment

![Describing the flow of a production Shiny application using workflow
described in this repository.](images/process-diagram.png)

We have used the concepts within this work - tested R functions, YAML
and .R template script for production runs - in many different
situations at Pfizer, not just within Shiny applications, for example
passing parameters into an {Rmarkdown} template which uses tested
functions.

## What is the benefit of this work?

As we have discussed above, typically Shiny apps are developed within
business lines (not by professional developers) to get a quick "Proof of
Concept" and something useful for their team. The framework of starting
by writing, testing and documenting the R function "building blocks"
described here should be easy enough for most R coders to adopt for any
Shiny development, whether intended for production or not. It extends
beyond Shiny to other "dynamic deliverables" such as {shinylive} Quarto
documents, parameterised Quarto documents, dashboards, etc. Having
started with this framework, it would be easy to "convert" these Proof
of Concept deliverables to more rigorous, production quality or extend
their functionality.

QC of apps and deliverables developed using this framework can be
simplified in a number of ways:

-   R functions used in the app and by the template can be verified by
    code review, {testthat} test coverage, third party verification.
-   .R template script can similarly be verified by code review, third
    party verification.
-   YAML output from the Shiny app (user settings and Shiny reactives)
    can be verified by a third party.
-   Shiny app code and behaviour can be tested via {shinytest2}
    coverage.
-   Verification that the summary table produced via the .R template
    script in a "production task" run in a production environment
    matches what is generated within the Shiny app can be verified by
    third party verification.

The key thing is that QC steps described above can be performed up front
rather than on delivery of the final table. We also allow flexibility in
table definition as the functions used within the Shiny app allow a
range of possible table definitions via user inputs within the app. By
capturing and externalising these in the YAML file and passing them as
parameters into the .R template script we can then have a single process
that generates a wide range of possible outputs.

The existing process of table definition -\> programming -\> table
delivery -\> QC verification puts a lot of the QC at the end of the
process once the table has been delivered and is typically done for each
individual table - even if those tables have similar characteristics.

In the process of developing this framework we consulted with internal
QA colleagues to get their feedback on this process which has been
incorporated into the code shared here.

## What is in this repository?

The Shiny application is contained within the main directory.

To run the app, either open run-app.R and submit the code, or open app.R
and run within the RStudio IDE.

R functions used by the Shiny application are in /R

Test cases for the R functions and Shiny application are in
tests/testthat

Template .R script for production run of the summary table is in
/template

An example YAML file for testing importing into the Shiny app is in
/inputs

Example of user inputs externalised from the Shiny app are stored in
/exports

### How to use the Shiny app

In the Shiny app, there are several key tab panels:

-   mainPanel with the core table creation inputs

-   capturePanel with the interace to save the mainPanel's UI input
    selections and app reactives

-   loadPanel to load in previously a saved UI input selections file

-   an infoPanel with general application info.

Additionally, this framework uses a custom server-level function called
`getReactives4Export()` in `app.R` (for the capturePanel) to
automatically generate list of reactives for export (`exports.RDS` by
default). The selected inputs are exported using
`shiny::reactiveValuesToList()` (`inputs.YAML` by default). Previously
saved input files (`inputs.YAML`) can be loaded into the app using the
`multiUpdateSelectInput()` custom internal function (for the loadPanel).
Note that the user may sometimes have to specify the update order
sequence instead of using `multiUpdateSelectInput()` for more complex
applications when loading their previously stored input file.

### Use of RDS files for data and saved output

We are aware of the security finding around use of RDS files and their
[potential security risk as outlined in this
post](https://hiddenlayer.com/research/r-bitrary-code-execution/). [It
is suggested that RDS (and other binary file types) are treated as a
potential security risk if their provenance is not known or
trusted](https://rud.is/b/2024/05/03/cve-2024-27322-should-never-have-been-assigned-and-r-data-files-are-still-super-risky-even-in-r-4-4-0/).

In this repository, RDS files are used in two places:

-   To pass data into the Shiny app. We have prepared a dataset that can
    be read directly into the app, instead of performing data processing
    within the app. The rationale for this is that we imagined that data
    processing is best handled outside of a Shiny app, where QC can
    review processing steps through a straightforward R script, rather
    than via the internal steps of Shiny code.

    -   You can recreate this input file "/data/wrangledData.RDS" by running
        code in the "/R/generate_wrangledData.R". Run this code if you
        wish to replace the file "/data/wrangledData.RDS".

-   We also externalise the {gt} table object from the Shiny app into an
    RDS file (/exports/exports.RDS), so that it can be compared against the 
    table created via the "/template/template.R" script (production run of the table
    creation). Since the latter ({gt} table export) is a by-product of
    running the app, we feel this is low security risk. RDS file use is
    preferred here since it captures the data, variable types and object
    structure to facilitate comparison with the version created via the
    "/template/template.R" production script. {waldo} `compare` function
    will highlight even small differences in this object for example if
    package versions used in Shiny differ from those in the production
    environment.

In the context of this illustrative example, it is easier to "see" what
the code is doing if we use RDS files in this case. Other users may wish
to consider more appropriate file formats if sharing content more widely
due to the security concern above.

## Pre-requisites, package installation and {renv}

We recommend the use of the {renv} package to manage packages associated
with this application. This allows you to isolate packages and package
versions used with this application from other applications, and
projects.

First, create a new RStudio project (if you haven't already created an
RStudio project based on the Github repository). Open the file
"setup.R". Using this file, you have two options to install packages
used in this Shiny application. If you haven't already, you can install
{renv}, activate it, and restore the package dependencies from the
renv.lock environment within the project by running the lines under
Option 1 (Recommended). We have tested the Shiny application using the R
packages as at 2024-03-01 and R version 4.2.1. If you choose to install
packages on your own (Option 2), please select the appropriate PPM (We
recommend installing packages from Posit Package Manager to get them at
2024-03-01) repository for your Operating System (OS).

## How should I submit questions, queries and enhancements?

You should fork this repository and submit a pull-request.

## Developers

-   Natalia Andriychuk

-   Samir Parmar

-   James Kim

-   Mike K Smith
