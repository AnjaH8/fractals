#' Create a plot of the fractal
#'
#' @param df tibble with the data
#' @param x x-coordinates
#' @param y y-coordinates
#'
#' @return a ggplot object
#' @export
ffplot <- function(df, x = x, y = y) {
  ggplot(df, ggplot2::aes(x, y)) +
    geom_path() +
    ggplot2::theme_void()

}
