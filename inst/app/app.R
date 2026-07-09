library(shiny)

# Source all helper files in R/ (relative to inst/app/ when run via shinyAppDir)
app_files <- list.files(path = "R", pattern = "\\.R$", full.names = TRUE)
invisible(sapply(app_files, source, local = FALSE))

shinyApp(ui = movies_ui(), server = movies_server)
