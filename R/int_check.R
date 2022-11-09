#' @title Integer Check Base Function
#' @description This function checks for integer values.
#' @param data Number or vector of numbers.
#' @return Logical, TRUE if all non-missing entries in the input vector are integers.
#' @export

# int_check called in both integer_check and decimal_check functions
int_check <- function(data) {
  (isTRUE(all(data == floor(data), na.rm=TRUE)))
}
