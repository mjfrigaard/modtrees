app_ui <- function() {
  shiny::fluidPage(
    mod_header_ui("header"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(mod_filter_ui("filter")),
      shiny::mainPanel(
        mod_table_ui("table"),
        mod_chart_ui("chart")
      )
    ),
    mod_footer_ui("footer")
  )
}
