#' @title Miscellaneous Format Check
#' @description This function checks miscellaneous dbGaP formatting requirements to ensure (1) no duplicate variable names; (2) variable names do not contain "dbgap"; (3) there are no duplicate column names in the dictionary; and (4) column names falling after `VALUES` column are unnamed. 
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as more detailed information about which formatting checks failed. 
#' @return Tibble, returned invisibly, containing: (1) Time (time stamp); (2) Name (name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Names of variables that fail one of these checks).
#' @export
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
  
  # 1. Check for duplicate names
  # 2. Check that "dbgap" is not used as a variable name
  # 3. Check that column names falling after `VALUES` column are blank
  

  # Call required_check
  r <-
    super_short_precheck(
      dict = DD.dict,
      data = DS.data
    )

  if (any(r$Status == "Failed")) {
    Time <- Sys.time()
    Function <- "misc_format_check"
    Status <- "Not attempted"
    row <- grep("Failed", r$Status)
    Message <- paste0("ERROR: Required pre-check ", r$Function[row], " failed.")
    Message2 <- tibble(r$Function, r$Message)
    Information <- r$Information[row]
    return_to_user <-
      lst(Note = "Pre-check failed.",
          Message = Message2,
          Information = Information)
    chk <- FALSE
  } else {

    # 1. Check for duplicate names
    check1 <- all(!isFALSE(duplicated(DD.dict$VARNAME)))
    check1.vnames <- names(duplicated(DD.dict$VARNAME))
    check.name <- "Check 1"
    check.description <- "Duplicate variable name check"
    if (check1==TRUE) {
      check.status <- "Passed"
      details <- NA
    } else {
      check.status <- "Failed"
      details <- check1.vnames
    }
    check1.final <- tibble(check.name, check.description, check.status, details)

    # 2. Check that "dbgap" is not used as a variable name
    # Grep dbgap out of data dictionary variable names column
    check2 <- isTRUE(nrow(DD.dict[grep("dbgap",DD.dict$VARNAME,ignore.case = TRUE),])==0)
    check2.vnames <- unlist(DD.dict[grep("dbgap",DD.dict$VARNAME,ignore.case = TRUE), c("VARNAME")])
    check.name <- "Check 2"
    check.description <- "Check for use of `dbgap` in variable names"
    if (check2==TRUE) {
      check.status <- "Passed"
      details <- NA
    } else {
      check.status <- "Failed"
      details <- check2.vnames
    }
    check2.final <- tibble(check.name, check.description, check.status, details)
    
    # Check 3: Check for duplicate names in DD.dict 
    check3 <- all(isFALSE(duplicated(names(DD.dict))))
    check3.vnames <- names(DD.dict)[duplicated(names(DD.dict))]
    check.name <- "Check 3"
    check.description <- "Duplicate dictionary column name check"
    if (check3==TRUE) {
      check.status <- "Passed"
      details <- NA
    } else {
      check.status <- "Failed"
      details <- unique(check3.vnames)
    }
    check3.final <- tibble(check.name, check.description, check.status, details)

    
    # 4. Check that column names falling after `VALUES` column are blank
    if (all(check3.final$check.status=="Passed")) {
      vcol <- which(names(DD.dict)=="VALUES")+1
      CHECK <- NULL
      for (col in vcol:ncol(DD.dict)) {
        col.name <- names(DD.dict)[col]
        correct <- isTRUE(startsWith(col.name, "..."))
        values <- data.frame(col.name, correct)
        CHECK <- bind_rows(CHECK, values)
      }
      check4 <- all(CHECK$correct==TRUE)
      check4.vnames <- subset(CHECK, correct==FALSE)
      check.name <- "Check 4"

      check.description <- "Column names after `VALUES` should be empty"
      if (check4==TRUE) {
        check.status <- "Passed"
        details <- NA
      } else {
        check.status <- "Failed"
        details <- check4.vnames
      }
      
    } else {
      check.name <- "Check 4"
      check.description <- "Column names after `VALUES` should be empty"
      check.status <- "Not attempted"
      details <- "Check 3 failed so not attempted"
    }
    check4.final <- tibble(check.name, check.description, check.status, details)
    Information <- bind_rows(check1.final, check2.final, check3.final, check4.final)

    # Compile report
    Time <- Sys.time()
    Function <- "misc_format_check"
    if (all(Information$check.status=="Passed")){
      Status <- "Passed"
      Message <- c("Passed: no check-specific formatting issues identified.")
      return_to_user <- lst(Message, Information)
    } else {
      Status <- "Failed"
      Message <- c("ERROR: at least one check failed.")
      Information <- Information
      return_to_user <- lst(Message, Information)
    }
  }

  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  if (verbose==TRUE){
    print(return_to_user)
  }
  return(invisible(report))
}
