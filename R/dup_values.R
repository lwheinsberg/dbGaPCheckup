#' @title Duplicate Values Function
#' @description This function checks for duplicate VALUES column names in the data dictionary.
#' @param DD.dict Data dictionary.
#' @return Logical, TRUE if only one VALUES column is detected.
#' @export

# int_check called in both integer_check and decimal_check functions
dup_values <- function(DD.dict) {
  vcol <- which(names(DD.dict)=="VALUES")
  if (length(vcol)==1) {
    chk <- TRUE
  } else {
    chk <- FALSE
  }
  return(chk)
}