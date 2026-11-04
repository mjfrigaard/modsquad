# Unit tests

``` r

library(modsquad)
library(testthat)
```

## Unit tests

The unit tests for the utility functions are in
`tests/testthat/test-find_vars.R`. Each test is also shown in this
vignette with its output.

## find_vars()

Test function (`is.double`)

``` r

testthat::test_that("find_vars", {
    testthat::expect_equal(
    object = find_vars(datasets::airquality,
                            filter = is.double),
    expected = names(airquality)[vapply(airquality, is.double, logical(1))])
    test_cmt("find_vars", "is.double()")
})
#> 
#>     find_vars: is.double() 
#> Test passed with 1 success 🥇.
```

Test function (`is.character`)

``` r

testthat::test_that("find_vars", {
  testthat::expect_equal(
    object = find_vars(datasets::mtcars,
                            filter = is.character),
    expected = datasets::mtcars |>
      dplyr::select(where(is.character)) |>
      names())
  test_cmt("find_vars", "is.character()")
})
#> 
#>     find_vars: is.character() 
#> Test passed with 1 success 🎊.
```

Test error: `state.abb` is a vector–pass `is.character` function to
`filter`

``` r

find_vars(data = datasets::state.abb, is.character)
#> Error in `find_vars()`:
#> ! is.data.frame(data) is not TRUE
```

``` r

testthat::test_that("find_vars", {
  testthat::expect_error(object =
      find_vars(datasets::state.abb, filter = is.character))
  test_cmt("find_vars", "error: data")
})
#> 
#>     find_vars: error: data 
#> Test passed with 1 success 🌈.
```

Test error: pass `is.miracle` function to `filter`

``` r

find_vars(data = datasets::mtcars, is.miracle)
#> Error:
#> ! object 'is.miracle' not found
```

``` r

testthat::test_that("find_vars", {
  testthat::expect_error(object =
      find_vars(datasets::mtcars, filter = is.miracle))
  test_cmt("find_vars", "error: filter")

})
#> 
#>     find_vars: error: filter 
#> Test passed with 1 success 🎊.
```
