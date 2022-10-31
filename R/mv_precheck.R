#' @title Missing Values Required Pre-checks
#' @description This function runs a workflow of the minimum number of checks required for a user to run missing_value_check; the checks include `field_check` and `pkg_field_check`.
#' @param dict Data dictionary.
#' @param data Data set.
#' @return Tibble containing the following information for each check: (1) Time (time stamp); (2) Name (name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (More detailed information about the potential errors identified).
#' @export
#' @examples
#' data(ExampleB)
#' mv_precheck(DD.dict.B, DS.data.B)

mv_precheck <- function(dict, data) {

  # Check 1: field_check
  # Run first report
  report <- field_check(dict, verbose=FALSE)
  
  # Check 2: pkg_field_check
  # Wrapped inside logic statement that there can't be any "Failed" status
  if (any(report$Status != "Failed")) {
    report <- bind_rows(report, pkg_field_check(dict, data, verbose=FALSE) )
  }
  
  # Check 3: name_check
  # Wrapped inside logic statement that there can't be any "Failed" status
  if (any(report$Status != "Failed")) {
    report <- bind_rows(report, name_check(dict, data, verbose=FALSE) )
  }

  # Return concise report based on what is in the results tibble
  return(report)
}
