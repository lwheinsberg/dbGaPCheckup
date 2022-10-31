#' @title Description Check
#' @description This function checks that there is a unique description for every variable in the data dictionary (`VARDESC` column).
#' @param DD.dict Data dictionary.
#' @param verbose When TRUE, the function prints the Message out, as well as a list of the variables that are missing a `VARDESC` or have a duplicated `VARDESC`.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Names of the variables with missing or duplicated descriptions).
#' @export
#' @examples
#' # Example 1: Fail check 
#' data(ExampleG)
#' description_check(DD.dict.G)
#' print(description_check(DD.dict.G, verbose=FALSE))
#' 
#' # Example 2: Pass check
#' data(ExampleA)
#' description_check(DD.dict.A)
#' print(description_check(DD.dict.A, verbose=FALSE))

description_check <- function(DD.dict, verbose=TRUE){
  
  # Check for VARNAME AND VARDESC field
  chk <- ('VARDESC' %in% names(DD.dict))
  chk2 <- ('VARNAME' %in% names(DD.dict))
  
  # Create report
  Time <- Sys.time()
  Function <- c("description_check")
  
  if (chk==TRUE & chk2==TRUE) {

    # Flag variables with missing descriptions
    miss_vars <- DD.dict[is.na(DD.dict$VARDESC), c("VARNAME","VARDESC")]

    # Flag variables with identical descriptions
    dup_vars <- DD.dict[(duplicated(DD.dict$VARDESC)) | (duplicated(DD.dict$VARDESC, fromLast = TRUE)), c("VARNAME","VARDESC")]

    # Bind together
    trouble_vars <- unique(bind_rows(miss_vars, dup_vars))

    # If the number of variables with a missing description equals 0,
    # then set check to TRUE; if >0, false
    DESC.CHECK <- (dim(trouble_vars)[1]==0 )

    if (all(DESC.CHECK==TRUE)) {
      Status <- c("Passed")
      Message <- c("Passed: unique description present for all variables in the data dictionary.")
      Information <- c("NA. All variables have a description.")
      return_to_user <- lst(Message)
    } else {
      Status <- c("Failed")
      if (dim(miss_vars)[1]!=0 & dim(dup_vars)[1]!=0) {
        Message <- c("ERROR: missing and duplicate descriptions found in data dictionary.")
      }
      if (dim(miss_vars)[1]!=0 & dim(dup_vars)[1]==0) {
        Message <- c("ERROR: missing descriptions found in data dictionary.")
      }
      if (dim(miss_vars)[1]==0 & dim(dup_vars)[1]!=0) {
        Message <- c("ERROR: duplicate descriptions found in data dictionary.")
      }
      Information <- trouble_vars
      return_to_user <- lst(Message, Information)
    }
  } else { # if VARNAME or VARDESC are not present in the dict 
      Status <- "Failed"
      Message <- "ERROR: VARNAME and/or VARDESC columns not found. Fields required for this check."
      Information <- "ERROR: VARNAME and/or VARDESC columns not found."
      return_to_user <- lst(Message)
    }
  
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  if (verbose==TRUE){
    print(return_to_user)
  }

  return(invisible(report))
}
