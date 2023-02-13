#' @title Complete Check
#' @description This function runs a full workflow check including `field_check`, `pkg_field_check`, `dimension_check`, `name_check`, `id_check`, `row_check`, `NA_check`, `type_check`, `values_check`, `integer_check`, `decimal_check`, `misc_format_check`,  `description_check`, `minmax_check`, and `missing_value_check`.
#' @param DD_dict Data dictionary.
#' @param DS_data Data set.
#' @param non.NA.missing.codes A user-defined vector of encoded, numerical (i.e., non-NA) missing value codes (e.g., -9999).
#' @param reorder.dict When TRUE, and only if the names between the data and data dictionary match perfectly but are in the wrong order, the function will reorder the rows of the dictionary to match the columns of the data; note please use with caution: we recommend first running the function with the default set to FALSE to understand potential errors.
#' @param name.correct When TRUE, if name mismatches are identified, the function will rename the variable names in the data set to match the data dictionary; note please use with caution: we recommend first running the function with the default set to FALSE to identify order/dimension mismatches (vs. name mismatches).
#' @return Tibble containing the following information for each check: (1) Time (time stamp); (2) Name (name of the function); (3) Status (Passed/Failed/Warning); (4) Message (A copy of the message the function printed out); (5) Information (More detailed information about the potential errors identified).
#' @seealso \code{\link{check_report}}
#' @export
#' @examples
#' # Example 1
#' # Note in this example, the missing value codes are not defined,
#' # so the last check ('missing_value_check') doesn't know to
#' # to check for encoded values
#' data(ExampleB)
#' complete_check(DD.dict.B, DS.data.B)
#' # Rerun check after defining missing value codes
#' complete_check(DD.dict.B, DS.data.B, non.NA.missing.codes=c(-9999, -4444))
#'
#' # Example 2
#' data(ExampleA)
#' complete_check(DD.dict.A, DS.data.A, non.NA.missing.codes=c(-9999, -4444))
#' 
#' # Example 3
#' data(ExampleD)
#' results <- complete_check(DD.dict.D, DS.data.D, non.NA.missing.codes=c(-9999, -4444))  
#' # View output in greater detail
#' results$Message[2] # Recommend using add_missing_fields
#' results$Information$pkg_field_check.Info # We see that MIN, MAX, and TYPE are all missing
#' # Use the add_missing_fields function to add in data
#' DD.dict.updated <- add_missing_fields(DD.dict.D, DS.data.D)
#' # Be sure to call in the new version of the dictionary (DD.dict.updated)
#' complete_check(DD.dict.updated, DS.data.D)

complete_check <- function(DD_dict, DS_data, non.NA.missing.codes=NA, reorder.dict=FALSE, name.correct=FALSE) {
  stopifnot("ERROR: DS_data is not a data frame" = inherits(DS_data,"data.frame"))
  stopifnot("ERROR: DD_dict is not a data frame" = inherits(DD_dict,"data.frame"))
  
  # Check 1: field_check
  # Run first report
  report <- field_check(DD_dict, verbose=FALSE)
  
  # Check 2: pkg_field_check
  report <- bind_rows(report, pkg_field_check(DD_dict, DS_data, verbose=FALSE))
  
  # Check 3: dimension_check
  report <- bind_rows(report, dimension_check(DD_dict, DS_data, verbose=FALSE))
  
  # Check 4: name_check
  report <- bind_rows(report, name_check(DD_dict, DS_data, verbose=FALSE))
  
  # Check 5: id_check
  report <- bind_rows(report, id_check(DS_data, verbose=FALSE))

  # Check 6: row_check
  report <- bind_rows(report, row_check(DD_dict, DS_data, verbose=FALSE))

  # Check 7: NA_check
  report <- bind_rows(report, NA_check(DD_dict, DS_data, verbose=FALSE))

  # Check 8: type_check
  report <- bind_rows(report, type_check(DD_dict, verbose=FALSE))

  # Check 9: values_check
  report <- bind_rows(report, values_check(DD_dict, verbose=FALSE))

  # Check 10: integer_check
  report <- bind_rows(report, integer_check(DD_dict, DS_data, verbose=FALSE))

  # Check 11: decimal_check
  report <- bind_rows(report, decimal_check(DD_dict, DS_data, verbose=FALSE))
 
  # Check 12: misc_format_check
  report <- bind_rows(report, misc_format_check(DD_dict, DS_data, verbose=FALSE))
  
  # Check 13: description_check
  report <- bind_rows(report, description_check(DD_dict, verbose=FALSE))
  
  # Check 14: minmax_check
  report <- bind_rows(report, minmax_check(DD_dict, DS_data, non.NA.missing.codes=non.NA.missing.codes, verbose=FALSE))
 
  # Check 15: missing_value_check
  report <- bind_rows(report, missing_value_check(DD_dict, DS_data, verbose=FALSE, non.NA.missing.codes=non.NA.missing.codes))
 
  names(report$Information)[1] <- "field_check.Info"
  names(report$Information)[2] <- "pkg_field_check.Info"
  names(report$Information)[3] <- "dimension_check.Info"
  names(report$Information)[4] <- "name_check.Info"
  names(report$Information)[5] <- "id_check.Info"
  names(report$Information)[6] <- "row_check.Info"
  names(report$Information)[7] <- "NA_check.Info"
  names(report$Information)[8] <- "type_check.Info"
  names(report$Information)[9] <- "values_check.Info"
  names(report$Information)[10] <- "integer_check.Info"
  names(report$Information)[11] <- "decimal_check.Info"
  names(report$Information)[12] <- "misc_formatting_check.Info"
  names(report$Information)[13] <- "description_check.Info"
  names(report$Information)[14] <- "minmax_check.Info"
  names(report$Information)[15] <- "missing_value_check.Info"
  
  # .... Plan to expand as more checks are added .... #

  # Return concise report based on what is in the results tibble
  return(report)
}
