# run app for package
pkgload::load_all(
  export_all = FALSE,
  helpers = TRUE,
  attach_testthat = TRUE)
library(modsquad)
modsquad::histogramApp()
# deploy this application with
# rsconnect::deployApp()
