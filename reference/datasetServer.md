# Data server module

*we just use [`get()`](https://rdrr.io/r/base/get.html) to retrieve the
dataset with its name...Here we take advantage of the usual rule that
last expression processed in the function becomes the return value. This
value should always be a reactive*

This module function comes from the [Getting started: UI input + server
output](https://mastering-shiny.org/scaling-modules.html#getting-started-ui-input-server-output)
section of Mastering Shiny.

## Usage

``` r
datasetServer(id)
```

## Arguments

- id:

  module id

## Value

reactive data object from datasets package
