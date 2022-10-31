#' @title Package Required Field Check
#' @description This function checks for additional fields required by this package including variable type (`TYPE`), minimum value (`MIN`), and maximum value (`MAX`).
#' @param DD.dict Data dictionary.
#' @param DS.data Data set. 
#' @param verbose When TRUE, the function prints the Message out, as well as a list of the fields not found in the data dictionary.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Named vector of TRUE/FALSE values alerting user if checks passed (TRUE) or failed (FALSE) for `TYPE`, `MIN`, and `MAX`).
#' @export
#' @details Even though MIN, MAX, and TYPE are not required by dbGaP, our package was created to use these variables in a series of other checks and awareness functions (e.g., render_report, values_check, etc.). If this function fails, the add_missing_fields function can be used. 
#' @importFrom tibble add_column
#' @import tibble
#' @seealso \code{\link{add_missing_fields}}
#' @examples
#' # Example 1: Fail check
#' data(ExampleD)
#' pkg_field_check(DD.dict.D, DS.data.D)
#' # Use the add_missing_fields function to add in data
#' DD.dict.updated <- add_missing_fields(DD.dict.D, DS.data.D)
#' # Be sure to call in the new version of the dictionary (DD.dict.updated)
#' pkg_field_check(DD.dict.updated, DS.data.D) 
#' 
#' # Example 2: Pass check
#' data(ExampleA)
#' pkg_field_check(DD.dict.A, DS.data.A)
#' print(pkg_field_check(DD.dict.A, DS.data.A, verbose=FALSE))

pkg_field_check <- function(DD.dict, DS.data, verbose=TRUE){
  
  # Check for TYPE field
  TYPE <- ('TYPE' %in% names(DD.dict))

  # Check for MIN field
  MIN <- ('MIN' %in% names(DD.dict))

  # Check for MAX field
  MAX <- ('MAX' %in% names(DD.dict))

  # Create named vector of all check values
  CHECK.required.fields <- unlist(lst(TYPE, MIN, MAX))
  
  # Compile report for return to user
  Time <- Sys.time()
  Function <- "pkg_field_check"
  Information <- CHECK.required.fields
  if (all(CHECK.required.fields==TRUE)) {
    Status <- "Passed"
    Message <- c("Passed: package-level required fields TYPE, MIN, and MAX present in the data dictionary.")
    return_to_user <- lst(Message)
  } else {
    Status <- "Failed"
    Message <- c("ERROR: not all package-level required fields are present in the data dictionary. Consider using the add_missing_fields function to auto fill these fields.")
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
