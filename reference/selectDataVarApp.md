# Data and variable shiny app

This module function comes from the [Modules inside of
modules](https://mastering-shiny.org/scaling-modules.html#modules-inside-of-modules)
section of Mastering Shiny.

## Usage

``` r
selectDataVarApp(filter = is.numeric)
```

## Arguments

- filter:

  variable filter (i.e., `is.numeric` or `is.character`)

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
