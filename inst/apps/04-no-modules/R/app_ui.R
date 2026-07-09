app_ui <- function() {
  shiny::fluidPage(
    shiny::titlePanel("Simple App (no modules)"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::sliderInput("n", "Number of points:", min = 10, max = 200, value = 50)
      ),
      shiny::mainPanel(
        shiny::plotOutput("scatter")
      )
    )
  )
}
