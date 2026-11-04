# Dataset app

This standalone app function is from the [Getting started: UI input +
server
output](https://mastering-shiny.org/scaling-modules.html#getting-started-ui-input-server-output)
section of Mastering Shiny.

## Usage

``` r
datasetApp(filter = NULL)
```

## Value

shiny application

## filter

This application includes an argument for filtering objects "*limit the
options to built-in datasets that are either data frames (filter =
is.data.frame) or matrices (filter = is.matrix)*" displayed in the
[`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html).

## reactive values

The [`renderPrint()`](https://rdrr.io/pkg/shiny/man/renderPrint.html)
output contains the output from
[`shiny::reactiveValuesToList()`](https://rdrr.io/pkg/shiny/man/reactiveValuesToList.html)
and contains the`inputId`s for the modules in the application.
