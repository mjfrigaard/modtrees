library(shiny)

app_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
invisible(sapply(app_files, source, local = FALSE))

shinyApp(ui = app_ui(), server = app_server)
