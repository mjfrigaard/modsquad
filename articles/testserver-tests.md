# testServer tests

``` r

library(modsquad)
library(testthat)
```

The [`testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html)
tests for the modules and standalone app functions are in
`tests/testthat/`. Each test is also shown in this vignette with its
output.

## datasetServer()

Verify `NULL`

``` r

shiny::testServer(datasetServer, expr = {

  testthat::expect_equal(input$dataset, NULL)
  test_cmt("datasetServer", "dataset$input is NULL")
})
#> 
#>     datasetServer: dataset$input is NULL
```

Verify input

``` r

shiny::testServer(datasetServer, expr = {
  session$setInputs(dataset = "faithful")
  testthat::expect_equal(
    object = input$dataset,
    expected = "faithful")
  test_cmt("datasetServer", "dataset$input")
})
#> 
#>     datasetServer: dataset$input
```

Verify [`class()`](https://rdrr.io/r/base/class.html) of `returned()`

``` r

class(datasets::airquality)
#> [1] "data.frame"
```

``` r

shiny::testServer(datasetServer, expr = {
  session$setInputs(dataset = "airquality")
  testthat::expect_equal(
    object = class(session$returned()),
    expected = "data.frame")
  test_cmt("datasetServer", "class(session$returned())")
})
#> 
#>     datasetServer: class(session$returned())
```

Verify [`class()`](https://rdrr.io/r/base/class.html) of `returned()`

``` r

is.matrix(datasets::WorldPhones)
#> [1] TRUE
```

``` r

shiny::testServer(datasetServer, expr = {
  session$setInputs(dataset = "WorldPhones")
  testthat::expect_true(
    object = is.matrix(session$returned()))
  test_cmt("datasetServer", "is.matrix(session$returned())")
})
#> 
#>     datasetServer: is.matrix(session$returned())
```

Verify [`typeof()`](https://rdrr.io/r/base/typeof.html) of `returned()`

``` r

typeof(datasets::mtcars)
#> [1] "list"
```

``` r

shiny::testServer(datasetServer, expr = {
  session$setInputs(dataset = "mtcars")
  expect_equal(
    object = typeof(session$returned()),
    expected = typeof(datasets::mtcars))
  test_cmt("datasetServer", "typeof(session$returned())")
})
#> 
#>     datasetServer: typeof(session$returned())
```

## datasetApp()

Check `dataset` input

``` r

ds_app <- datasetApp()
shiny::testServer(app = ds_app, expr = {
  session$setInputs(`dataset-dataset` = "chickwts")
  testthat::expect_equal(
    object = input$`dataset-dataset`,
    expected = "chickwts")
  test_cmt("datasetApp", "input$`dataset-dataset`")
})
#> 
#>     datasetApp: input$`dataset-dataset`
```

Check `class` of reactive [`data()`](https://rdrr.io/r/utils/data.html)

``` r

ds_app <- datasetApp()
shiny::testServer(app = ds_app, expr = {
  session$setInputs(`dataset-dataset` = "chickwts")
  testthat::expect_true(
    object = is.data.frame(data()))
  test_cmt("datasetApp", "is.data.frame(data())")
})
#> 
#>     datasetApp: is.data.frame(data())
```

``` r

ds_app <- datasetApp()
shiny::testServer(app = ds_app, expr = {
  session$setInputs(`dataset-dataset` = "chickwts")
  testthat::expect_equal(
    object = names(data()),
    expected = names(datasets::chickwts))
  test_cmt("datasetApp", "names(data())")
})
#> 
#>     datasetApp: names(data())
```

``` r

ds_app <- datasetApp()
shiny::testServer(app = ds_app, expr = {
  session$setInputs(`dataset-dataset` = "chickwts")
  testthat::expect_equal(
    object = class(output$data),
    expected = "character")
  test_cmt("datasetApp", "class(output$data)")

})
#> 
#>     datasetApp: class(output$data)
```

## selectVarServer()

The
[`selectVarServer()`](https://mjfrigaard.github.io/modsquad/reference/selectVarServer.md)
function has additional arguments, so the `args` list is used (with
[`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)):

``` r

shiny::testServer(selectVarServer,

  args = list(data = reactive(datasets::mtcars),
              filter = is.numeric), expr = {

  testthat::expect_true(
    object = is.reactive(data))
  test_cmt("selectVarServer", "is.reactive(data())")
})
#> 
#>     selectVarServer: is.reactive(data())
```

Test passing different arguments to
[`find_vars()`](https://mjfrigaard.github.io/modsquad/reference/find_vars.md)

``` r

shiny::testServer(selectVarServer,
  args = list(data = reactive(datasets::chickwts),
              filter = is.numeric), expr = {
  testthat::expect_equal(
    object = find_vars(data(), is.factor),
    expected = "feed")
  test_cmt("selectVarServer", "find_vars()")
})
#> 
#>     selectVarServer: find_vars()
```

Test passing `filter` and setting `input$var`:

``` r

shiny::testServer(selectVarServer,
  args = list(data = reactive(datasets::chickwts),
              filter = is.numeric), expr = {

  session$setInputs(var = "weight")
  testthat::expect_equal(object = input$var,
      expected = "weight")
  test_cmt("selectVarServer", "input$var")
})
#> 
#>     selectVarServer: input$var
```

Test passing `filter`, setting `input$var`, and `session$returned()`:

``` r

shiny::testServer(selectVarServer,
  args = list(data = reactive(datasets::chickwts),
              filter = is.numeric), expr = {
  session$setInputs(var = "feed")
  testthat::expect_equal(object = session$returned(),
      expected = datasets::chickwts["feed"])
  test_cmt("selectVarServer", "session$returned()")

})
#> 
#>     selectVarServer: session$returned()
```

## selectVarApp()

Test `is.reactive(var)`

``` r

sv_app <- selectVarApp()
shiny::testServer(app = sv_app, expr = {
  session$setInputs(`var-var` = "Ozone",
                    `data-dataset` = "airquality")
  
  testthat::expect_true(object = is.reactive(var))
  test_cmt("selectVarApp", "is.reactive(var)")
})
#> 
#>     selectVarApp: is.reactive(var)
```

Test the inputs with module namespaces

``` r

sv_app <- selectVarApp()
shiny::testServer(app = sv_app, expr = {
  session$setInputs(`var-var` = "Ozone",
                    `data-dataset` = "airquality")

  testthat::expect_equal(
    object = input$`var-var`,
    expected = "Ozone")
  test_cmt("selectVarApp", "input$`var-var`")

})
#> 
#>     selectVarApp: input$`var-var`
```

Test [`data()`](https://rdrr.io/r/utils/data.html) is reactive

``` r

sv_app <- selectVarApp()
shiny::testServer(app = sv_app, expr = {
  session$setInputs(`var-var` = "Ozone",
                    `data-dataset` = "airquality")

  testthat::expect_true(object = is.reactive(data))
  test_cmt("selectVarApp", "is.reactive(data)")

})
#> 
#>     selectVarApp: is.reactive(data)
```

Test [`class()`](https://rdrr.io/r/base/class.html) of
[`data()`](https://rdrr.io/r/utils/data.html)

``` r

sv_app <- selectVarApp()
shiny::testServer(app = sv_app, expr = {
  session$setInputs(`var-var` = "Ozone",
                    `data-dataset` = "airquality")
  
  testthat::expect_true(
    object = is.data.frame(data()))
  test_cmt("selectVarApp", "is.data.frame(data())")

})
#> 
#>     selectVarApp: is.data.frame(data())
```

Test specific variables from
[`data()`](https://rdrr.io/r/utils/data.html)

``` r

sv_app <- selectVarApp()
shiny::testServer(app = sv_app, expr = {
  session$setInputs(`var-var` = "Ozone",
                    `data-dataset` = "airquality")

  testthat::expect_equal(
    object = data()[[input$`var-var`]],
    expected = airquality[["Ozone"]])
  test_cmt("selectVarApp", "data()[[input$`var-var`]]")

})
#> 
#>     selectVarApp: data()[[input$`var-var`]]
```

## selectDataVarServer()

Test [`is.reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) on
`data`

``` r

shiny::testServer(selectDataVarServer, 
  args = list(filter = is.numeric), expr = {
    
  testthat::expect_true(
    object = is.reactive(data))
  test_cmt("selectDataVarServer", "is.reactive(data)")

})
#> 
#>     selectDataVarServer: is.reactive(data)
```

Test [`is.reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) on
`var`

``` r

shiny::testServer(selectDataVarServer, 
  args = list(filter = is.numeric), expr = {

  testthat::expect_true(
    object = is.reactive(var))
  test_cmt("selectDataVarServer", "is.reactive(var)")

})
#> 
#>     selectDataVarServer: is.reactive(var)
```

## selectDataVarApp()

Test inputs for `var-var-var`

``` r

dv_app <- selectDataVarApp()
shiny::testServer(app = dv_app, expr = {
  session$setInputs(`var-var-var` = "Ozone",
                    `var-data-dataset` = "airquality")

  testthat::expect_equal(
    object = input$`var-var-var`,
    expected = "Ozone")
  test_cmt("selectDataVarApp", "input$`var-var-var`")

})
#> 
#>     selectDataVarApp: input$`var-var-var`
```

Test inputs for `var-data-dataset`

``` r

dv_app <- selectDataVarApp()
shiny::testServer(app = dv_app, expr = {
  session$setInputs(`var-var-var` = "Ozone",
                    `var-data-dataset` = "airquality")

  testthat::expect_equal(
    object = input$`var-data-dataset`,
    expected = "airquality")
  test_cmt("selectDataVarApp", "input$`var-data-dataset`")

})
#> 
#>     selectDataVarApp: input$`var-data-dataset`
```

Test [`is.reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) for
`var`

``` r

dv_app <- selectDataVarApp()
shiny::testServer(app = dv_app, expr = {
  session$setInputs(`var-var-var` = "Ozone",
                    `var-data-dataset` = "airquality")

  testthat::expect_true(object = is.reactive(var))
  test_cmt("selectDataVarApp", "is.reactive(var)")

})
#> 
#>     selectDataVarApp: is.reactive(var)
```
