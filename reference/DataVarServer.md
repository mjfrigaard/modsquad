# Data and variable shiny server (version 2)

This module function comes from the [Modules inside of
modules](https://mastering-shiny.org/scaling-modules.html#modules-inside-of-modules)
section of Mastering Shiny.

## Usage

``` r
DataVarServer(input, output, session, filter = is.numeric)
```

## Arguments

- input:

  shiny server argument

- output:

  shiny server argument

- session:

  shiny server argument

- filter:

  variable filter (i.e., `is.numeric` or `is.character`)

## Value

shiny app
