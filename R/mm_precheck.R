#' @title Min Max Required Pre-checks
#' @description This function runs a workflow of the minimum number of checks required for a user to run minmax_check; the checks include `pkg_field_check`, `dimension_check`, and `name_check`.
#' @param dict Data dictionary.
#' @param data Data set.
#' @return Tibble containing the following information for each check: (1) Time (time stamp); (2) Name (name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (More detailed information about the potential errors identified).
#' @export
#' @examples
#' data(ExampleB)
#' mm_precheck(DD.dict.B, DS.data.B)

mm_precheck <- function(dict, data) {

  # Check 1: field_check
  # Run first report
  report <- pkg_field_check(dict, verbose=FALSE)
  
  # Check 2: dimension_check
  # Wrapped inside logic statement that there can't be any "Failed" status
  if (all(report$Status != "Failed")) {
    report <- bind_rows(report, dimension_check(dict, data, verbose=FALSE) )
  }
  
  # Check 3: name_check
  # Wrapped inside logic statement that there can't be any "Failed" status
  if (all(report$Status != "Failed")) {
    report <- bind_rows(report, name_check(dict, data, verbose=FALSE) )
  }

  # Return concise report based on what is in the results tibble
  return(report)
}
