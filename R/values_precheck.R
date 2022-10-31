#' @title Values Pre-Check
#' @description This function runs a workflow of the minimum number of checks required for a user to run values_check; the checks include `field_check`, and `type_check`.
#' @param dict Data dictionary.
#' @return Tibble containing the following information for each check: (1) Time (time stamp); (2) Name (name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (More detailed information about the potential errors identified).
#' @export
#' @examples
#' data(ExampleB)
#' values_precheck(DD.dict.B)

values_precheck <- function(dict) {

  # Check 1: field_check
  # Run first report
  report <- field_check(dict, verbose=FALSE)
  
  # Check 2: type_check
  # Wrapped inside logic statement that there can't be any "Failed" status
  if (all(report$Status != "Failed")) {
    report <- bind_rows(report, type_check(dict, verbose=FALSE) )
  }
  
  # Return concise report based on what is in the results tibble
  return(report)
}
