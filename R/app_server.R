#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_path
#' @noRd
app_server <- function(input, output, session) {

  fractal <- reactive({
    hilbert_curve(input$iteration)
  })

  output$fplot <- renderPlot({
    ffplot(fractal())
  }, width = 500, height = 500)
}
