# Variable input server module

This module function comes from the [Server
inputs](https://mastering-shiny.org/scaling-modules.html#server-inputs)
section of Mastering Shiny.

## Usage

``` r
selectVarServer(id, data, filter = is.numeric)
```

## Arguments

- id:

  module id

- data:

  reactive data object to retrieve variables from

- filter:

  passed to
  [`find_vars()`](https://mjfrigaard.github.io/modsquad/reference/find_vars.md),
  i.e., the type of variables to list (*this will be set by the caller
  of the module, so doesn’t need to be reactive*

## Value

shiny server function

## stopifnot()

*check that each input to your module is either reactive or constant. If
you don’t, and the user supplies the wrong type, they’ll get a cryptic
error message. You can make the life of module user much easier with a
quick and dirty call to
[`stopifnot()`](https://rdrr.io/r/base/stopifnot.html)*

## returned variable validation

The returned value from `selectVarServer()` has been
