ffplot <- function(df, x = x, y = y) {
  ggplot(df, aes(x, y)) +
    geom_path()

}
