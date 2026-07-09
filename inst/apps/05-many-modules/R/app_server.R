app_server <- function(input, output, session) {
  mod_header_server("header")
  filter_vals <- mod_filter_server("filter")
  mod_table_server("table",  filter = filter_vals)
  mod_chart_server("chart",  filter = filter_vals)
  mod_footer_server("footer")
}
