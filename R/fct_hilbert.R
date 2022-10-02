#' Title
#'
#' @param df
#'
#' @return
#' @export
#' @import dplyr
#'
#' @examples
flip_x_y <- function(df) {
  return(tibble::tibble(x = df$y, y = df$x))
}

flip_uperright_lowerleft <- function(df, n) {
  if(n == 0) {
    return(df)
  } else {
    flipped_df <- df %>%
      mutate(tempx = x,
             x = -y,
             y = -tempx) %>%
      select(-tempx)
    return(flipped_df)
  }
}

hilbert_curve <- function(n, prev = tibble(x=0, y=0)){

  if(n == 0) {
    return(prev)
  } else {

    start <- tail(prev, 1)
    df_hil <- hilbert_curve(n-1)
    prev1_moved <- df_hil %>%
      mutate(x = x + start$x,
             y = y + start$y)
    left_part <- flip_x_y(prev1_moved)
    middle1 <- tibble(x=tail(left_part,1)$x, y=(tail(left_part, 1)$y + 1))

    prev2a_moved <- df_hil %>%
      mutate(x = x + middle1$x,
             y = y + middle1$y)
    upperleft_part <- left_part %>%
      bind_rows(prev2a_moved)
    middle2 <- tibble(x=(tail(upperleft_part,1)$x + 1), y=(tail(upperleft_part,1)$y))

    prev2b_moved <- df_hil %>%
      mutate(x = x + middle2$x,
             y = y + middle2$y)
    upperright_part <- upperleft_part %>%
      bind_rows(prev2b_moved)
    middle3 <- tibble(x=(tail(upperright_part,1)$x), y=(tail(upperright_part,1)$y - 1))

    right_part <- flip_uperright_lowerleft(df_hil, n-1)
    right_part_moved <- right_part %>%
      mutate(x = x + middle3$x,
             y = y + middle3$y)
    final <- upperright_part %>%
      bind_rows(right_part_moved)

    return(final)
  }
}
