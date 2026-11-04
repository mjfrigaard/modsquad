# Data and variable input server module

This module function comes from the [Modules inside of
modules](https://mastering-shiny.org/scaling-modules.html#modules-inside-of-modules)
section of Mastering Shiny.

## Usage

``` r
selectDataVarServer(id, filter = is.numeric)
```

## Arguments

- id:

  module id

- filter:

  limit the options of built-in datasets (i.e., `is.data.frame` or
  `is.matrix`)

## Value

shiny server function
