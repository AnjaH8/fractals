#' Flip the data along the diagonal between the left-lower and right-upper corner
#'
#' @param df tibble with the columns x and y
#'
#' @return The flipped tibble
#' @export
#' @import dplyr
flip_x_y <- function(df) {
  return(tibble::tibble(x = df$y, y = df$x))
}

#' Flip the data along the diagonal between the left-upper and right-lower corner
#'
#' @param df tibble with the columns x and y
#' @param n number of iterations
#'
#' @return The flipped tibble
#' @export
flip_uperright_lowerleft <- function(df, n) {
  if(n == 0) {
    return(df)
  } else {
    flipped_df <- df %>%
      mutate(tempx = .data$x,
             x = -.data$y,
             y = -.data$tempx) %>%
      select(-.data$tempx)
    return(flipped_df)
  }
}

#' Move the data so that the start point of the curve is changed
#'
#' @param df tibble with x and y coordinates
#' @param new_start tibble with one x and y coordinate as new starting point
#'
#' @return the moved tibble
#' @export
#'
move_curve <- function(df, new_start) {
  df_moved <- df %>%
    mutate(x = .data$x + new_start$x,
           y = .data$y + new_start$y)
}

#' Calculation of the Hilbert curve
#' @description Recursive function that calculates the Hilbert curve after n iterations.
#'
#' @param n Iteration
#' @param prev tibble of the previous iteration
#' @importFrom utils tail
#'
#' @return The tibble with the x and y coordinates for the Hilbert curve
#' @export
hilbert_curve <- function(n, prev = tibble(x=0, y=0)){

  if(n == 0) {
    return(prev)
  } else {

    start <- tail(prev, 1)
    df_hil <- hilbert_curve(n-1)
    prev1_moved <- df_hil %>%
      move_curve(start)
    left_part <- flip_x_y(prev1_moved)
    middle1 <- tibble(x=tail(left_part,1)$x, y=(tail(left_part, 1)$y + 1))

    prev2a_moved <- df_hil %>%
      move_curve(middle1)
    upperleft_part <- left_part %>%
      bind_rows(prev2a_moved)
    middle2 <- tibble(x=(tail(upperleft_part,1)$x + 1), y=(tail(upperleft_part,1)$y))

    prev2b_moved <- df_hil %>%
      move_curve(middle2)
    upperright_part <- upperleft_part %>%
      bind_rows(prev2b_moved)
    middle3 <- tibble(x=(tail(upperright_part,1)$x), y=(tail(upperright_part,1)$y - 1))

    right_part <- flip_uperright_lowerleft(df_hil, n-1)
    right_part_moved <- right_part %>%
      move_curve(middle3)
    final <- upperright_part %>%
      bind_rows(right_part_moved)

    return(final)
  }
}
