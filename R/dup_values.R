#' @title Duplicate Values Function
#' @description This function checks for duplicate VALUES column names in the data dictionary.
#' @param DD.dict Data dictionary.
#' @export

# int_check called in both integer_check and decimal_check functions
dup_values <- function(DD.dict) {
  vcol <- which(names(DD.dict)=="VALUES")
  if (length(vcol)==1) {
    chk <- TRUE
    #Message <- NA
  } else {
    chk <- FALSE
  }
  
  #if (length(vcol)>1) {
  #  chk <- FALSE
  #  Message <- "ERROR: Multiple columns with name VALUES."
  #}
  
  #if (length(vcol) == 0) {
  #  chk <- ('VALUES' %in% names(DD.dict))
  #  Message <- "ERROR: VALUES is not a column name in the data dictionary."
  #}
  isTRUE(chk)
}