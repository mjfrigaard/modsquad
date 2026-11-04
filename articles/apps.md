# Mastering Shiny: Shiny modules (apps)

``` r

library(modsquad)
library(lobstr)
library(fs)
```

## Mastering Shiny Apps

This vignette walks through the structure of each application using the
abstract syntax tree
([`ast()`](https://lobstr.r-lib.org/reference/ast.html)) function from
the [`lobstr` package](https://lobstr.r-lib.org/). Three of the
applications in the `modsquad` package come from the [Modules section of
Mastering Shiny](https://mastering-shiny.org/scaling-modules.html), with
a few adjustments:

- Each standalone app function has a
  [`verbatimTextOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html)
  in the `ui`:

  ``` r

  shiny::verbatimTextOutput("vals")
  ```

- And an accompanying
  [`renderPrint()`](https://rdrr.io/pkg/shiny/man/renderPrint.html) in
  the `server`:

  ``` r

  output$vals <- shiny::renderPrint({
    x <- shiny::reactiveValuesToList(input,
                            all.names = TRUE)
    print(x)
  })
  ```

Printing the output from
[`shiny::reactiveValuesToList()`](https://rdrr.io/pkg/shiny/man/reactiveValuesToList.html)
in the top-level of the standalone function shows the namespaces and
modules throughout the application.

### `datasetApp()`

``` default
█─datasetApp 
├─filter = NULL 
└─█─shinyApp 
  ├─ui = █─fluidPage 
  │      ├─█─datasetInput 
  │      │ ├─id = "dataset" 
  │      │ ├─filter = is.data.frame 
  │      │ └─█─selectInput 
  │      │   └─inputId = "dataset" 
  │      └─█─tableOutput 
  │        └─"data"
  └─server = █─function(input, output, session)
             └─█─data <- datasetServer(id = "dataset") 
               └─output$data <- renderTable(head(data()))
```

**[`datasetApp()`](https://mjfrigaard.github.io/modsquad/reference/datasetApp.md)
contains the
[`datasetInput()`](https://mjfrigaard.github.io/modsquad/reference/datasetInput.md)
and
[`datasetServer()`](https://mjfrigaard.github.io/modsquad/reference/datasetServer.md)
module functions**

- [`datasetInput()`](https://mjfrigaard.github.io/modsquad/reference/datasetInput.md)
  displays the objects from the `datasets` package (`"dataset"`)
  matching the `filter` argument (i.e., `is.data.frame`, `is.matrix`)
  and the table output (`"data"`) in the UI

- The `inputId` in the UI passes a `datasets` object (as
  `input$dataset`, a character string) to
  [`datasetServer()`](https://mjfrigaard.github.io/modsquad/reference/datasetServer.md),
  which fetches and returns the object as a reactive via
  [`get()`](https://rdrr.io/r/base/get.html)

#### `datasetApp()` Reactive values

The output from
[`reactiveValuesToList()`](https://rdrr.io/pkg/shiny/man/reactiveValuesToList.html)
are displayed in the UI:

    $`dataset-dataset`
    [1] "ability.cov"

The first `dataset` is from the module `id`, and the second is from the
`inputId` (in the
[`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html)).

### `selectVarApp()`

**[`selectVarApp()`](https://mjfrigaard.github.io/modsquad/reference/selectVarApp.md)
contains the
[`datasetInput()`](https://mjfrigaard.github.io/modsquad/reference/datasetInput.md)/`Server()`
and
[`selectVarInput()`](https://mjfrigaard.github.io/modsquad/reference/selectVarInput.md)/`Server()`
modules**

``` default
█─selectVarApp 
└─█─shinyApp 
  ├─ui = █─fluidPage 
  │      ├─█─datasetInput 
  │      │ ├─id = "data" 
  │      │ ├─filter = is.data.frame
  │      │ └─█─selectInput 
  │      │   └─inputId = "dataset" 
  │      ├─█─selectVarInput 
  │      │ ├─id = "var" 
  │      │ └─█─selectInput 
  │      │   └─inputId = "var" 
  │      └─█─tableOutput 
  │        └─"out" 
  └─server = █─function(input, output, session)
             └─█─data <- datasetServer("data")
               █─var <- selectVarServer("var", data, filter = is.numeric)
               └─output$out <- renderTable(head(var()))
             
```

**`dataset` module:**

`datasetInput("data")`

`datasetServer("data")`

**`selectVar` module:**

- [`selectVarInput()`](https://mjfrigaard.github.io/modsquad/reference/selectVarInput.md)
  displays the variables (columns) in the returned `datasets` object
  from
  [`datasetServer()`](https://mjfrigaard.github.io/modsquad/reference/datasetServer.md)
  (as `"var"`) and the rendered output (as `"out"`)  
- In
  [`selectVarServer()`](https://mjfrigaard.github.io/modsquad/reference/selectVarServer.md),
  the columns in the `data` returned from
  [`datasetServer()`](https://mjfrigaard.github.io/modsquad/reference/datasetServer.md)
  is filtered to those columns matching the `filter` argument (i.e.,
  `is.numeric`), and the selected `"var"` is displayed in `"out"`

### `selectVarApp()` Adjustments

The variable value from
[`selectVarServer()`](https://mjfrigaard.github.io/modsquad/reference/selectVarServer.md)
was originally returned with a simple call to
[`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)

``` r

selectVarServer <- function(id, data, filter = is.numeric) {
  stopifnot(is.reactive(data))
  stopifnot(!is.reactive(filter))
  
  moduleServer(id, function(input, output, session) {
    observeEvent(data(), {
      updateSelectInput(
        session = session,
        inputId = "var", 
        choices = find_vars(data = data(), filter = filter))
    })
    
    reactive(data()[[input$var]]) # <- simple reactive()
    
  })
}
```

I’ve updated this with some control flow statements to ensure the
variable is contained the data object. I’ve also changed the returned
object to be a single column `data.frame` (as opposed to a vector):

``` r

selectVarServer <- function(id, data, filter = is.numeric) {
  stopifnot(shiny::is.reactive(data))
  stopifnot(!shiny::is.reactive(filter))

  shiny::moduleServer(id, function(input, output, session) {

    shiny::observe({
      shiny::updateSelectInput(
        session, "var",
        choices = find_vars(data(), filter))
    }) |>
      shiny::bindEvent(data())

    return(
      shiny::reactive({
        if (input$var %in% names(data())) { # <- updated with control flow
          data()[input$var] # returned as a single column
        } else {
          NULL
        }
      }) |>
      shiny::bindEvent(input$var)
    )

  })
}
```

#### `selectVarApp()` Reactive values

The
[`reactiveValuesToList()`](https://rdrr.io/pkg/shiny/man/reactiveValuesToList.html)
output for both modules are below:

    $`var-var`
    [1] "Ozone"

    $`data-dataset`
    [1] "airquality"

- The first `"var"` is from the shared `id` between
  [`selectVarInput()`](https://mjfrigaard.github.io/modsquad/reference/selectVarInput.md)/[`selectVarServer()`](https://mjfrigaard.github.io/modsquad/reference/selectVarServer.md),
  the second is from the `inputId` in the
  [`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html).

- `"data"` is from the shared `id` between
  [`datasetInput()`](https://mjfrigaard.github.io/modsquad/reference/datasetInput.md)/[`datasetServer()`](https://mjfrigaard.github.io/modsquad/reference/datasetServer.md),
  and the second is from the
  [`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html).

### `selectDataVarApp()`

``` default
█─selectDataVarApp 
└─█─shinyApp 
  ├─ui = █─fluidPage 
  │      └─█─sidebarLayout 
  │        ├─█─sidebarPanel 
  │        │ └─█─selectDataVarUI 
  │        │   ├─"var" 
  │        │   ├─█─datasetInput 
  │        │   │ ├─█─NS 
  │        │   │ │ ├─id 
  │        │   │ │ └─"data" 
  │        │   │ └─filter = is.data.frame 
  │        │   └─█─selectVarInput 
  │        │     └─█─NS 
  │        │       ├─id 
  │        │       └─"var" 
  │        └─█─mainPanel 
  │          └─█─tableOutput 
  │            └─"out" 
  └─server = █─function(input, output, session)
             ├─█─var <- selectDataVarServer(id = "var", filter = is.numeric)
             │ ├─data <- datasetServer(id = "data")
             │ ├─var <- selectVarServer(id = "var", data, filter = filter) 
             │ └─var 
             └─output$out <- renderTable(head(var()))
```

**[`selectDataVarApp()`](https://mjfrigaard.github.io/modsquad/reference/selectDataVarApp.md)
nests the `dataset` and `selectVar` modules *inside* the
[`selectDataVarUI()`](https://mjfrigaard.github.io/modsquad/reference/selectDataVarUI.md)
and
[`selectDataVarServer()`](https://mjfrigaard.github.io/modsquad/reference/selectDataVarServer.md)
functions:**

Inside
[`selectDataVarUI()`](https://mjfrigaard.github.io/modsquad/reference/selectDataVarUI.md):

**`datasetInput("data")`:**

[`datasetInput()`](https://mjfrigaard.github.io/modsquad/reference/datasetInput.md)
is moved into the
[`sidebarPanel()`](https://rdrr.io/pkg/shiny/man/sidebarLayout.html) to
display the objects from the `datasets` package (`"dataset"`) matching
the `filter` argument (i.e., `is.data.frame`, `is.matrix`)

**`selectVarInput("var")`:**

`selectVarInput("var")` also displays the variables in the
[`sidebarPanel()`](https://rdrr.io/pkg/shiny/man/sidebarLayout.html)
from the returned `data` object in
[`datasetServer()`](https://mjfrigaard.github.io/modsquad/reference/datasetServer.md)

Inside
[`selectDataVarServer()`](https://mjfrigaard.github.io/modsquad/reference/selectDataVarServer.md):

**[`datasetServer()`](https://mjfrigaard.github.io/modsquad/reference/datasetServer.md):**

The `inputId` in the UI passes a `datasets` object (as `input$dataset`,
a character string) to
[`datasetServer()`](https://mjfrigaard.github.io/modsquad/reference/datasetServer.md),
which fetches and returns the object as a reactive with
[`get()`](https://rdrr.io/r/base/get.html)

**[`selectVarServer()`](https://mjfrigaard.github.io/modsquad/reference/selectVarServer.md):**

In
[`selectVarServer()`](https://mjfrigaard.github.io/modsquad/reference/selectVarServer.md),
the columns in the `data` returned from
[`datasetServer()`](https://mjfrigaard.github.io/modsquad/reference/datasetServer.md)
are filtered to only those columns matching the `filter` argument (i.e.,
`is.numeric`), and the selected `"var"` is returned as `var`

The [`var()`](https://rdrr.io/r/stats/cor.html) reactive output is
rendered in the UI

#### `selectDataVarApp()` Reactive values

By placing the
[`datasetInput()`](https://mjfrigaard.github.io/modsquad/reference/datasetInput.md)
and
[`selectVarInput()`](https://mjfrigaard.github.io/modsquad/reference/selectVarInput.md)
functions *inside* `selectDataVar()` with another call to
[`NS()`](https://rdrr.io/pkg/shiny/man/NS.html), these functions end up
with **two** appended namespaces:

    $`var-var-var`
    [1] "Ozone"

    $`var-data-dataset`
    [1] "airquality"

### `histogramApp()`

``` default
█─histogramApp 
└─█─shinyApp 
  ├─ui = █─fluidPage 
  │      ├─█─sidebarLayout 
  │      │ └─█─sidebarPanel 
  │      │   ├─█─datasetInput 
  │      │   │ ├─"data" 
  │      │   │ └─filter = is.data.frame 
  │      │   └─█─selectVarInput 
  │      │     └─"var" 
  │      └─█─mainPanel 
  │        └─█─histogramOutput 
  │          └─"hist" 
  └─server = █─function(input, output, session)
             ├─data <- datasetServer('data')
             ├─x <- selectVarServer('var', data)
             ├─histogramServer('hist', x) 
             └─output$out <- renderPrint(head(var()))
```

This
[`histogramApp()`](https://mastering-shiny.org/scaling-modules.html#case-study-histogram)
function has been slightly altered to accommodate converting the graph
output to use `ggplot2`.

### Adjustments

The original
[`histogramServer()`](https://mjfrigaard.github.io/modsquad/reference/histogramServer.md)
function uses [`shiny::req()`](https://rdrr.io/pkg/shiny/man/req.html)
to ensure the `x()` reactive is numeric
([`is.numeric()`](https://rdrr.io/r/base/numeric.html)). It then passes
this numeric vector directly to
[`hist()`](https://rdrr.io/r/graphics/hist.html) (along with the
`breaks` and title (in `main`)).

``` r

histogramServer <- function(id, x, title = reactive("Histogram")) {
  stopifnot(is.reactive(x))
  stopifnot(is.reactive(title))
  
  moduleServer(id, function(input, output, session) {
    output$hist <- renderPlot({
      req(is.numeric(x()))
      main <- paste0(title(), " [", input$bins, "]")
      hist(x(), breaks = input$bins, main = main)
    }, res = 96)
  })
}
```

I’ve changed
[`histogramServer()`](https://mjfrigaard.github.io/modsquad/reference/histogramServer.md)
slightly: I removed the
[`is.numeric()`](https://rdrr.io/r/base/numeric.html) function from
[`shiny::req()`](https://rdrr.io/pkg/shiny/man/req.html) and use
[`purrr::as_vector()`](https://purrr.tidyverse.org/reference/as_vector.html)
to convert the single column `data.frame` to a vector:

``` r

histogramServer <- function(id, x, title = reactive("Histogram")) {
  stopifnot(shiny::is.reactive(x))
  stopifnot(shiny::is.reactive(title))

  shiny::moduleServer(id, function(input, output, session) {

    output$hist <- shiny::renderPlot({
      shiny::req(x()) # require x() (but not numeric) 
      main <- paste0(title(), " [bins =", input$bins, "]")
      hist(
        purrr::as_vector(x()), # convert the single column data.frame to a vector
        breaks = input$bins,
        main = main)
    }, res = 96)

  })
}
```

#### Reactive values

The output from
[`reactiveValuesToList()`](https://rdrr.io/pkg/shiny/man/reactiveValuesToList.html)
is below:

    $`hist-bins`
    [1] 10

    $`var-var`
    [1] "Ozone"

    $`data-dataset`
    [1] "airquality"

The reason all of these modules are interchangeable is that none of them
deal with rendering outputs–all of the `*Output()`/`render()*` functions
are kept in the standalone application functions.
