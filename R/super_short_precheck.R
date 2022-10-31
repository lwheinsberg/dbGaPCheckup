#' @title Very Truncated Pre-check
#' @description This function runs a workflow of the minimum number of checks required for a user to run dbGaPCheckup_required_field_check; the checks include `dbGaP_required_field_check`, `dimension_check`, and `name_check`.
#' @param dict Data dictionary.
#' @param data Data set.
#' @return Tibble containing the following information for each check: (1) Time (time stamp); (2) Name (name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (More detailed information about the potential errors identified).
#' @export
#' @examples
#' # Example 1: Pass check
#' data(ExampleB)
#' super_short_precheck(DD.dict.B, DS.data.B)

super_short_precheck <- function(dict, data) {

  # Check 1: field_check
  # Run first report
  report <- field_check(dict, verbose=FALSE)

  # Return concise report based on what is in the results tibble
  return(report)
}
