# File: ./tests/testthat/test-shinytest2-gghistApp.R
# derived from: https://rstudio.github.io/shinytest2/articles/robust.html#example
# App file: ./app.R
library(shinytest2)
# remotes::install_github("rstudio/chromote", force = TRUE, quiet = TRUE)
library(chromote)
library(vdiffr)

test_that("{shinytest2}: gghistApp", {
  skip_if_not_installed("vdiffr")

  app <- AppDriver$new(app_dir = system.file("dev", "gghistApp",
                                             package = "modsquad"),
                       height = 750, width = 1200)

  # Verify initial data
  app_init_data <- app$get_value(input = "data-dataset")
  waldo::compare(app_init_data, "BOD")
  expect_equal(
    object = app_init_data,
    expected = "BOD")

  # Verify initial variable
  app_init_var <- app$get_value(input = "var-var")
  waldo::compare(app_init_var, "Time")
  expect_equal(
    object = app_init_var,
    expected = "Time")

  # Verify exported data
  app$set_inputs(`data-dataset` = "mtcars")
  app_exp_x_01 <- app$get_value(export = "hist-x")
  waldo::compare(
    x = app_exp_x_01,
    y = mtcars[1])
  expect_equal(
    object = app_exp_x_01,
    expected = mtcars[1])

  # Verify exported var
  app$set_inputs(`var-var` = "disp")
  app_exp_plot_obj_01 <- app$get_value(export = "hist-plot_obj")
  waldo::compare(
    x = app_exp_plot_obj_01,
    y = purrr::as_vector(mtcars['disp']))
  expect_equal(
    object = app_exp_plot_obj_01,
    expected = purrr::as_vector(mtcars['disp']))

  # Verify `hist-bins` changes
  app$set_inputs(`hist-bins` = 15)
  app_set_bins_01 <- app$get_value(input = "hist-bins")
  waldo::compare(app_set_bins_01, 15L)
  expect_equal(
    object = app_set_bins_01,
    expected = 15)

  exp_values <- app$get_values()$export

  expect_true(is.data.frame(exp_values$`hist-x`))
  expect_equal(exp_values$`hist-x`, mtcars['disp'])

  expect_true(is.numeric(exp_values$`hist-plot_obj`))
  expect_equal(
    object = exp_values$`hist-plot_obj`,
    expected = purrr::as_vector(mtcars['disp']))

  # print(str(exp_values))
  # Verify plot ----
  gg2_plot <- app$get_value(output = "hist-hist")
  expect_equal(gg2_plot$alt, "Plot object")
  vdiffr::expect_doppelganger(
      title = "mtcars_disp_plot",
      fig = ggplot2::ggplot(data = exp_values$`hist-x`,
              mapping =
              ggplot2::aes(x = disp)
          ) +
            ggplot2::geom_histogram(bins = exp_values$`hist-bins`) +
            ggplot2::labs(
              title = paste0(exp_values$`hist-title`,
                             " [bins = ",
                             exp_values$`hist-bins`, "]"),
              y = "Count",
              x = names(exp_values$`hist-x`)
            ) +
            ggplot2::theme_minimal()
      )

  app$set_inputs(`data-dataset` = "USArrests")
  app$set_inputs(`var-var` = 'UrbanPop')
  app$set_inputs(`hist-bins` = 15)

  exp_values <- app$get_values()$export

  vdiffr::expect_doppelganger(
    title = "usaarrests_plot",
    fig = ggplot2::ggplot(data = exp_values$`hist-x`,
            mapping =
            ggplot2::aes(x = UrbanPop)
        ) +
          ggplot2::geom_histogram(bins = exp_values$`hist-bins`) +
          ggplot2::labs(
            title = paste0(exp_values$`hist-title`,
                           " [bins = ",
                           exp_values$`hist-bins`, "]"),
            y = "Count",
            x = names(exp_values$`hist-x`)
          ) +
          ggplot2::theme_minimal()
    )

  # SET -----
  app$set_inputs(`data-dataset` = "sleep")
  app$set_inputs(`var-var` = 'extra')
  app$set_inputs(`hist-bins` = 8)
  # GET ----
  exp_values <- app$get_values()$export
  # EXPECT ----
  vdiffr::expect_doppelganger(
    title = "sleep_extra_plot",
    fig = ggplot2::ggplot(data = exp_values$`hist-x`,
            mapping =
            ggplot2::aes(x = extra)
        ) +
          ggplot2::geom_histogram(bins = exp_values$`hist-bins`) +
          ggplot2::labs(
            title = paste0(exp_values$`hist-title`,
                           " [bins = ",
                           exp_values$`hist-bins`, "]"),
            y = "Count",
            x = names(exp_values$`hist-x`)
          ) +
          ggplot2::theme_minimal()
    )

  app$stop()

})
