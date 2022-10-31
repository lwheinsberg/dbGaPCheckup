#' @title ID Check
#' @description This function checks that the first column of the data set is the primary ID for each participant labeled as `SUBJECT_ID` and that values contain no illegal characters or padded zeros.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as more detailed diagnostic information.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Detailed information about the four ID checks that were performed).
#' @export
#' @details  Subject IDs should be an integer or string value. Integers should not have zero padding. IDs should not have spaces. Specifically, only the following characters can be included in the ID: English letters, Arabic numerals, period (.), hyphen (-), underscore (_), at symbol (@), and the pound sign (#). 
#' @examples
#' # Example 1: Fail check, 'SUBJECT_ID' not present
#' data(ExampleO)
#' id_check(DS.data.O)
#' print(id_check(DS.data.O, verbose=FALSE))
#'
#' # Example 2: Fail check, 'SUBJECT_ID' includes illegal spaces
#' data(ExampleP)
#' id_check(DS.data.P)
#' results <- id_check(DS.data.P)
#' results$Information[[1]]$details
#' print(id_check(DS.data.P, verbose=FALSE))
#'
#' # Example 3: Pass check
#' data(ExampleA)
#' id_check(DS.data.A)
#' print(id_check(DS.data.A, verbose=FALSE))

id_check <- function(DS.data, verbose=TRUE){

  # Function contains 5 checks to meet dbGaP requirements that "The primary
  # ID in each subject phenotypes file should be the SUBJECT_ID."
  # 1. Is column 1 SUBJECT_ID
  # 2. If not, is SUBJECT_ID in the data set?
  # 3. SUBJECT_ID can contain only the following characters: English letters,
  # Arabic numerals, period (.), hyphen (-), underscore (_), at symbol (@), 
  # and the pound sign (#).
  # 4. Zero padding is not allowed for SUBJECT_ID 
  

  # Check 1: Column 1 is labeled as 'SUBJECT_ID'
  x <- names(DS.data)[1]
  y <- which(names(DS.data)=="SUBJECT_ID")
  if (x=="SUBJECT_ID"){
    check1 <- TRUE
    check2 <- TRUE
  } else {
    check1 <- FALSE
    # Check 2: If 'SUBJECT_ID' is not the name of column 1,
    # is SUBJECT_ID any column name in the data set?
    if (c("SUBJECT_ID") %in% names(DS.data)) {
      check2 <- TRUE
    } else {
      check2 <- FALSE
    }
  }

  # Create information reports
  # Check 1
  check.name <- "Check 1"
  check.description <- "Column 1 is labeled as 'SUBJECT_ID'."
  if (check1==TRUE) {
    check.status <- "Passed"
    details <- paste0("The first column name is ", x, ".")
  } else {
    check.status <- "Failed"
    details <- paste0("The first column name is ", x, ". The name of the first column should be 'SUBJECT_ID'.")
  }
  check1.final <- tibble(check.name, check.description, check.status, details)

  # Check 2
  check.name <- "Check 2"
  check.description <- "'SUBJECT_ID' is a column name in the data set."
  if (check2==TRUE) {
    check.status <- "Passed"
    if (check1==FALSE) {
      details <- paste0("'SUBJECT_ID' is the name of column ", y, ". Please reoder data set so 'SUBJECT_ID' is the name of column 1.")
    } else {
      details <- paste0("'SUBJECT_ID' is the name of column ", y, ".")
    }
  } else {
    check.status <- "Failed"
    details <- paste0("'SUBJECT_ID' is not a column name in this data set.")
  }
  check2.final <- tibble(check.name, check.description, check.status, details)

  # Check 3: If checks 1 or 2 pass, check that there are no illegal characters
  # within the 'SUBJECT_ID' formatting
  check.name <- "Check 3"
  if (check1==TRUE | check2==TRUE) {
    #trouble_rows <- grep(" ", DS.data$SUBJECT_ID)
    trouble_rows <- grep(pattern = "([^A-Za-z0-9\\.\\-_@#])", DS.data$SUBJECT_ID, perl=TRUE, value=TRUE)
    if (length(trouble_rows)==0) {
      check3 <- TRUE
      check.status <- "Passed"
      details <- "No illegal characters detected in 'SUBJECT_ID'."
    } else {
      check3 <- FALSE
      check.status <- "Failed"
      details <- paste0("Illegal characters detected in 'SUBJECT_ID' for ", length(trouble_rows), " row(s). SUBJECT_ID may contain only: English letters, Arabic numerals, period (.), hyphen (-), underscore (_), at symbol (@), and the pound sign (#). No spaces or other characters are allowed.")
    }
  } else {
    check3 <- FALSE
    check.status <- "Failed"
    details <- "Checks 1 and 2 failed, so Check 3 was not performed."
  }
  check3.final <- tibble(check.name, check.description, check.status, details)
  
  # Check 4: If checks 1 or 2 pass, check that there are no padded zeros
  # within the 'SUBJECT_ID' formatting
  check.name <- "Check 4"
  check.description <- "No leading zeros detected in 'SUBJECT_ID' column."
  if (check1==TRUE | check2==TRUE) {
    trouble_rows <- grep("^0", DS.data$SUBJECT_ID)
    if (length(trouble_rows)==0) {
      check4 <- TRUE
      check.status <- "Passed"
      details <- paste0("No leading zeros detected in 'SUBJECT_ID'.")
    } else {
      check4 <- FALSE
      check.status <- "Failed"
      details <- paste0("Leading zeros detected in 'SUBJECT_ID' for ", length(trouble_rows), " row(s).")
    }
  } else {
    check4 <- FALSE
    check.status <- "Failed"
    details <- "Checks 1 and 2 failed, so Check 4 was not performed."
  }
  check4.final <- tibble(check.name, check.description, check.status, details)
  
  # Create information summary
  Information <- bind_rows(check1.final, check2.final, check3.final, check4.final)

  # Compile report for return to user
  Time <- Sys.time()
  Function <- "id_check"
  if (all(Information$check.status=="Passed")) {
    Status <- "Passed"
    Message <- c("Passed: All ID variable checks passed.")
    return_to_user <- lst(Message, Information)
  } else {
    Status <- "Failed"
    Message <- c("ERROR: not all ID variable requirements are met. See Information for more details.")
    return_to_user <- lst(Message, Information)
  }
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  # If verbose=TRUE, print message
  if (verbose==TRUE){
    print(return_to_user)
  }

  # Invisible return of report
  return(invisible(report))
}
