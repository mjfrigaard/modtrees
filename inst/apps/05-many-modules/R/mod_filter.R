mod_filter_ui <- function(id) {
  ns <- NS(id)
  shiny::tagList(
    shiny::selectInput(ns("species"), "Species:", choices = unique(iris$Species)),
    shiny::sliderInput(ns("sepal_len"), "Min sepal length:",
                       min = 4, max = 8, value = 4, step = 0.1)
  )
}

mod_filter_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    shiny::reactive({
      list(species = input$species, sepal_len = input$sepal_len)
    })
  })
}
