#' @title Miscellaneous Format Check
#' @description This function checks miscellaneous dbGaP formatting requirements to ensure (1) no empty variable names; (2) no duplicate variable names; (3) variable names do not contain "dbgap"; (4) there are no duplicate column names in the dictionary; and (5) column names falling after `VALUES` column are unnamed. 
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as more detailed information about which formatting checks failed. 
#' @return Tibble, returned invisibly, containing: (1) Time (time stamp); (2) Name (name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Names of variables that fail one of these checks).
#' @export
#' @details Note that this check will return a WARNING for Check #5 depending on how the data set is read into R. Depending on the method used, R will automatically fill in column names after VALUES with "...col_number". This is allowed by the package, but it is NOT allowed by dbGaP, so please use caution if you write out a data set after making adjustments directly in R.
#' @examples
#' # Example 1: Fail check 
#' data(ExampleJ)
#' misc_format_check(DD.dict.J, DS.data.J)
#' print(misc_format_check(DD.dict.J, DS.data.J, verbose=FALSE))
#' 
#' # Example 2: Pass check
#' data(ExampleA)
#' misc_format_check(DD.dict.A, DS.data.A)
#' print(misc_format_check(DD.dict.A, DS.data.A, verbose=FALSE))

misc_format_check <- function (DD.dict, DS.data, verbose=TRUE) {
  r <- super_short_precheck(dict = DD.dict, data = DS.data)
  
  if (any(r$Status == "Failed")) {
    Time <- Sys.time()
    Function <- "misc_format_check"
    Status <- "Not attempted"
    row <- grep("Failed", r$Status)
    Message <- paste0("ERROR: Required pre-check ", r$Function[row], " failed.")
    Message2 <- tibble(r$Function, r$Message)
    Information <- r$Information[row]
    return_to_user <- list(Note = "Pre-check failed.", Message = Message2, Information = Information)
  } else {
    # Check 1: Empty VARNAME
    check1 <- all(!is.na(DD.dict$VARNAME))
    check1.final <- tibble(
      check.name = "Check 1",
      check.description = "Empty variable name check",
      check.status = if (check1) "Passed" else "Failed",
      details = if (check1) NA else paste0("Row(s): ", paste(which(is.na(DD.dict$VARNAME)), collapse = ", "))
    )
    
    # Check 2: Duplicate VARNAMEs
    check2 <- !any(duplicated(DD.dict$VARNAME))
    check2.final <- tibble(
      check.name = "Check 2",
      check.description = "Duplicate variable name check",
      check.status = if (check2) "Passed" else "Failed",
      details = if (check2) NA else paste(DD.dict$VARNAME[duplicated(DD.dict$VARNAME)], collapse = ", ")
    )
    
    # Check 3: dbGaP in VARNAMEs
    bad_dbgap <- grep("dbgap", DD.dict$VARNAME, ignore.case = TRUE, value = TRUE)
    check3.final <- tibble(
      check.name = "Check 3",
      check.description = "Check for use of `dbgap` in variable names",
      check.status = if (length(bad_dbgap) == 0) "Passed" else "Failed",
      details = if (length(bad_dbgap) == 0) NA else paste(bad_dbgap, collapse = ", ")
    )
    
    # Check 4: Duplicate column names in DD.dict
    dups <- names(DD.dict)[duplicated(names(DD.dict))]
    check4.final <- tibble(
      check.name = "Check 4",
      check.description = "Duplicate dictionary column name check",
      check.status = if (length(dups) == 0) "Passed" else "Failed",
      details = if (length(dups) == 0) NA else paste(unique(dups), collapse = ", ")
    )
    
    # Check 5: Columns after VALUES
    if (check4.final$check.status == "Passed" & check1.final$check.status == "Passed") {
      vcol <- which(names(DD.dict) == "VALUES")
      if (vcol == ncol(DD.dict)) {
        check5.final <- tibble(
          check.name = "Check 5",
          check.description = "Column names after `VALUES` should be blank or '...'",
          check.status = "Warning",
          details = "Only a single VALUES column was found. This is valid but uncommon. Confirm no encoded values were expected."
        )
      } else {
        after_values_columns <- names(DD.dict)[(vcol + 1):length(names(DD.dict))]
        CHECK <- tibble(
          col.name = after_values_columns,
          correct = startsWith(after_values_columns, "...") | after_values_columns == ""
        )
        check5 <- all(CHECK$correct)
        check5.final <- tibble(
          check.name = "Check 5",
          check.description = "Column names after `VALUES` should be blank or '...'",
          check.status = if (check5) "Passed" else "Failed",
          details = if (check5) NA else paste("Invalid column name(s):", paste(CHECK$col.name[!CHECK$correct], collapse = ", "))
        )
      }
    } else {
      check5.final <- tibble(
        check.name = "Check 5",
        check.description = "Column names after `VALUES` should be blank or '...'",
        check.status = "Not attempted",
        details = "Checks 1 and/or 4 failed so not attempted"
      )
    }
    
    # Bind and compile
    Information <- bind_rows(check1.final, check2.final, check3.final, check4.final, check5.final)
    Time <- Sys.time()
    Function <- "misc_format_check"
    #Status <- if (any(Information$check.status == "Failed")) "Failed" else "Passed"
    #Message <- if (Status == "Passed") "Passed: no check-specific formatting issues identified." else "ERROR: at least one check failed."
    Status <- if (any(Information$check.status == "Failed")) {
      "Failed"
    } else if (any(Information$check.status == "Warning")) {
      "Warning"
    } else {
      "Passed"
    }
    
    Message <- dplyr::case_when(
      Status == "Failed" ~ "ERROR: at least one check failed.",
      Status == "Warning" ~ "WARNING: at least one check returned a warning.",
      TRUE ~ "Passed: no check-specific formatting issues identified."
    )
    return_to_user <- list(Message = Message, Information = Information)
  }
  
  report <- tibble(Time = Time, Function = Function, Status = Status, Message = Message, Information = list(Information))
  if (verbose) print(return_to_user)
  return(invisible(report))
}
