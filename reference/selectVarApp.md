# Select Variable App

This module function comes from the [Case study: selecting a numeric
variable](https://mastering-shiny.org/scaling-modules.html#case-study-selecting-a-numeric-variable)
section of Mastering Shiny.

## Usage

``` r
selectVarApp(filter = is.numeric)
```

## Arguments

- filter:

  variables to list. *This will be set by the caller of the module, so
  doesn’t need to be reactive*

## Value

shiny app

## Reactive values

The only changes to this application include a call to
[`verbatimTextOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html)
in the UI, which renders the contents of
[`reactiveValuesToList()`](https://rdrr.io/pkg/shiny/man/reactiveValuesToList.html)
in the server. The
[`renderPrint()`](https://rdrr.io/pkg/shiny/man/renderPrint.html) output
contains the `inputId`s for the modules in the application.
