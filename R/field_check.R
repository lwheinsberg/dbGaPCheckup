#' @title Field Check
#' @description This function checks for dbGaP required fields variable name (`VARNAME`), variable description (`VARDESC`), units (`UNITS`), and variable value and meaning (`VALUES`).
#' @param DD.dict Data dictionary.
#' @param verbose When TRUE, the function prints the Message out, as well as a list of the fields not found in the data dictionary.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Named vector of TRUE/FALSE values alerting user if checks passed (TRUE) or failed (FALSE) for `VARNAME`, `VARDESC`, `UNITS`, and `VALUE`).
#' @export
#' @examples
#' data(ExampleA)
#' field_check(DD.dict.A)
#' print(field_check(DD.dict.A, verbose=FALSE))

field_check <- function(DD.dict, verbose=TRUE){

  # Check for VARNAME field
  # If VARNAME present in data dictionary names, then TRUE
  # If VARNAME missing from data dictionary names then FALSE
  VARNAME <- ('VARNAME' %in% names(DD.dict))

  # Check for VARDESC field
  VARDESC <- ('VARDESC' %in% names(DD.dict))

  # Check for UNITS field
  UNITS <- ('UNITS' %in% names(DD.dict))

  # Check for VALUES field
  VALUES <- ('VALUES' %in% names(DD.dict))

  # Create named vector of all check values
  CHECK.required.fields <- unlist(lst(VARNAME, VARDESC, UNITS, VALUES))

  # Compile report for return to user
  Time <- Sys.time()
  Function <- "field_check"
  Information <- CHECK.required.fields
  if (all(CHECK.required.fields==TRUE)) {
    Status <- "Passed"
    Message <- c("Passed: required fields VARNAME, VARDESC, UNITS, and VALUES present in the data dictionary.")
    return_to_user <- lst(Message)
  } else {
    Status <- "Failed"
    Message <- c("ERROR: not all required fields are present in the data dictionary.")
    Missing <- names(which(CHECK.required.fields==FALSE))
    return_to_user <- lst(Message, Missing)
  }
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  # If verbose=TRUE, print message
  if (verbose==TRUE){
    print(return_to_user)
  }

  # Invisible return of report
  return(invisible(report))
}

