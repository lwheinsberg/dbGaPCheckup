#' @title Complete Check 2
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
#' complete_check2(DD.dict.B, DS.data.B)
#' # Rerun check after defining missing value codes
#' complete_check(DD.dict.B, DS.data.B, non.NA.missing.codes=c(-9999, -4444))
#'
#' # Example 2
#' data(ExampleA)
#' complete_check2(DD.dict.A, DS.data.A, non.NA.missing.codes=c(-9999, -4444))
#' 
#' # Example 3
#' data(ExampleD)
#' results <- complete_check2(DD.dict.D, DS.data.D, non.NA.missing.codes=c(-9999, -4444))  
#' # View output in greater detail
#' results$Message[2] # Recommend using add_missing_fields
#' results$Information$pkg_field_check.Info # We see that MIN, MAX, and TYPE are all missing
#' # Use the add_missing_fields function to add in data
#' DD.dict.updated <- add_missing_fields(DD.dict.D, DS.data.D)
#' # Be sure to call in the new version of the dictionary (DD.dict.updated)
#' complete_check2(DD.dict.updated, DS.data.D)

complete_check2 <- function(DD_dict, DS_data, non.NA.missing.codes=NA, reorder.dict=FALSE, name.correct=FALSE) {
  stopifnot("ERROR: DS_data is not a data frame" = inherits(DS_data,"data.frame"))
  stopifnot("ERROR: DD_dict is not a data frame" = inherits(DD_dict,"data.frame"))
  
  # Initialize the report
  report <- NULL
  
  # Check 1: field_check
  # Run first report
  #report <- field_check(DD_dict, verbose=FALSE)
  # Note: Edits made in response to issue #6; ChatGPT used for help in creating the structure of the tryCatch solution
  tryCatch({
    field_result <- field_check(DD_dict, verbose = FALSE)
    report <- bind_rows(report, field_result)
  }, error = function(e) {
    message("field_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "field_check",
      Status = "Error",
      Message = paste("field_check encountered an error:", e$message),
      Information = NA
    ))
  })
  
  # Check 2: pkg_field_check
  #report <- bind_rows(report, pkg_field_check(DD_dict, DS_data, verbose=FALSE))
  tryCatch({
    pkg_field_result <- pkg_field_check(DD_dict, DS_data, verbose = FALSE)
    report <- bind_rows(report, pkg_field_result)
  }, error = function(e) {
    message("pkg_field_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "pkg_field_check",
      Status = "Error",
      Message = paste("pkg_field_check encountered an error:", e$message),
      Information = NA
    ))
  })
  
  # Check 3: dimension_check
  #report <- bind_rows(report, dimension_check(DD_dict, DS_data, verbose=FALSE))
  tryCatch({
    dimension_result <- dimension_check(DD_dict, DS_data, verbose = FALSE)
    report <- bind_rows(report, dimension_result)
  }, error = function(e) {
    message("dimension_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "dimension_check",
      Status = "Error",
      Message = paste("dimension_check encountered an error:", e$message),
      Information = NA
    ))
  })
  
  # Check 4: name_check
  #report <- bind_rows(report, name_check(DD_dict, DS_data, verbose=FALSE))
  tryCatch({
    name_result <- name_check(DD_dict, DS_data, verbose = FALSE)
    report <- bind_rows(report, name_result)
  }, error = function(e) {
    message("name_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "name_check",
      Status = "Error",
      Message = paste("name_check encountered an error:", e$message),
      Information = NA
    ))
  })
  
  # Check 5: id_check
  #report <- bind_rows(report, id_check(DS_data, verbose=FALSE))
  tryCatch({
    id_result <- id_check(DS_data, verbose = FALSE)
    report <- bind_rows(report, id_result)
  }, error = function(e) {
    message("id_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "id_check",
      Status = "Error",
      Message = paste("id_check encountered an error:", e$message),
      Information = NA
    ))
  })

  # Check 6: row_check
  #report <- bind_rows(report, row_check(DD_dict, DS_data, verbose=FALSE))
  tryCatch({
    row_result <- row_check(DD_dict, DS_data, verbose = FALSE)
    report <- bind_rows(report, row_result)
  }, error = function(e) {
    message("row_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "row_check",
      Status = "Error",
      Message = paste("row_check encountered an error:", e$message),
      Information = NA
    ))
  })

  # Check 7: NA_check
  #report <- bind_rows(report, NA_check(DD_dict, DS_data, verbose=FALSE))
  tryCatch({
    NA_result <- NA_check(DD_dict, DS_data, verbose = FALSE)
    report <- bind_rows(report, NA_result)
  }, error = function(e) {
    message("NA_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "NA_check",
      Status = "Error",
      Message = paste("NA_check encountered an error:", e$message),
      Information = NA
    ))
  })

  # Check 8: type_check
  #report <- bind_rows(report, type_check(DD_dict, verbose=FALSE))
  tryCatch({
    type_result <- type_check(DD_dict, verbose = FALSE)
    report <- bind_rows(report, type_result)
  }, error = function(e) {
    message("type_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "type_check",
      Status = "Error",
      Message = paste("type_check encountered an error:", e$message),
      Information = NA
    ))
  })

  # Check 9: values_check
  #report <- bind_rows(report, values_check(DD_dict, verbose=FALSE))
  tryCatch({
    values_result <- values_check(DD_dict, verbose = FALSE)
    report <- bind_rows(report, values_result)
  }, error = function(e) {
    message("values_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "values_check",
      Status = "Error",
      Message = paste("values_check encountered an error:", e$message),
      Information = NA
    ))
  })

  # Check 10: integer_check
  #report <- bind_rows(report, integer_check(DD_dict, DS_data, verbose=FALSE))
  tryCatch({
    integer_result <- integer_check(DD_dict, DS_data, verbose = FALSE)
    report <- bind_rows(report, integer_result)
  }, error = function(e) {
    message("integer_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "integer_check",
      Status = "Error",
      Message = paste("integer_check encountered an error:", e$message),
      Information = NA
    ))
  })

  # Check 11: decimal_check
  #report <- bind_rows(report, decimal_check(DD_dict, DS_data, verbose=FALSE))
  tryCatch({
    decimal_result <- decimal_check(DD_dict, DS_data, verbose = FALSE)
    report <- bind_rows(report, decimal_result)
  }, error = function(e) {
    message("decimal_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "decimal_check",
      Status = "Error",
      Message = paste("decimal_check encountered an error:", e$message),
      Information = NA
    ))
  })
 
  # Check 12: misc_format_check
  #report <- bind_rows(report, misc_format_check(DD_dict, DS_data, verbose=FALSE))
  tryCatch({
    misc_format_result <- misc_format_check(DD_dict, DS_data, verbose = FALSE)
    report <- bind_rows(report, misc_format_result)
  }, error = function(e) {
    message("misc_format_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "misc_format_check",
      Status = "Error",
      Message = paste("misc_format_check encountered an error:", e$message),
      Information = NA
    ))
  })
  
  # Check 13: description_check
  #report <- bind_rows(report, description_check(DD_dict, verbose=FALSE))
  tryCatch({
    description_result <- description_check(DD_dict, verbose = FALSE)
    report <- bind_rows(report, description_result)
  }, error = function(e) {
    message("description_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "description_check",
      Status = "Error",
      Message = paste("description_check encountered an error:", e$message),
      Information = NA
    ))
  })
  
  # Check 14: minmax_check
  #report <- bind_rows(report, minmax_check(DD_dict, DS_data, non.NA.missing.codes=non.NA.missing.codes, verbose=FALSE))
  tryCatch({
    minmax_result <- minmax_check(DD_dict, DS_data, verbose = FALSE)
    report <- bind_rows(report, minmax_result)
  }, error = function(e) {
    message("minmax_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "minmax_check",
      Status = "Error",
      Message = paste("minmax_check encountered an error:", e$message),
      Information = NA
    ))
  })
 
  # Check 15: missing_value_check
  #report <- bind_rows(report, missing_value_check(DD_dict, DS_data, verbose=FALSE, non.NA.missing.codes=non.NA.missing.codes))
  tryCatch({
    missing_value_result <- missing_value_check(DD_dict, DS_data, verbose = FALSE)
    report <- bind_rows(report, missing_value_result)
  }, error = function(e) {
    message("missing_value_check encountered an error:", e$message)
    report <- bind_rows(report, data.frame(
      Time = Sys.time(),
      Name = "missing_value_check",
      Status = "Error",
      Message = paste("missing_value_check encountered an error:", e$message),
      Information = NA
    ))
  })
 
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
