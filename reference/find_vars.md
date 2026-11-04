# Find variables

This function is covered in the [Case study: selecting a numeric
variable](https://mastering-shiny.org/scaling-modules.html#case-study-selecting-a-numeric-variable)
section of Mastering Shiny, then updated in the [Server
inputs](https://mastering-shiny.org/scaling-modules.html#server-inputs)
section to include the
[`stopifnot()`](https://rdrr.io/r/base/stopifnot.html) checks.

## Usage

``` r
find_vars(data, filter = is.vector)
```

## Arguments

- data:

  reactive data object to retrieve variables from

- filter:

  which variables to list. *This will be set by the caller of the
  module, so doesn’t need to be reactive*

## Value

variable names

## stopifnot()

From the [Server
inputs](https://mastering-shiny.org/scaling-modules.html#server-inputs)
section, *"check that each input to your module is either reactive or
constant. If you don’t, and the user supplies the wrong type, they’ll
get a cryptic error message. You can make the life of module user much
easier with a quick and dirty call to
[`stopifnot()`](https://rdrr.io/r/base/stopifnot.html)."* Read more at
[mastering-shiny.org](https://mastering-shiny.org/).
