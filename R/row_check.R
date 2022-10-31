#' @title Row Check
#' @description This function checks for empty or duplicate rows in the data set.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as the row numbers of any problematic rows.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (A list of problematic row and participant ID numbers).
#' @export
#' @importFrom magrittr %>%
#' @import dplyr
#' @examples
#' # Example 1: Fail check
#' data(ExampleK)
#' row_check(DS.data.K)
#' print(row_check(DS.data.K, verbose=FALSE))
#'
#' # Example 2: Pass check
#' data(ExampleC)
#' row_check(DS.data.C)
#' print(row_check(DS.data.C, verbose=FALSE))

row_check <- function(DS.data, verbose=TRUE) {

  # Function contains 2 checks:
  # 1. check for empty rows
  # 2. check for duplicate/identical rows

  # ID check is a required pre-check for this function
  #r <-
  #  id_check(
  #    DS.data = DS.data,
  #    verbose = FALSE
  #  )

  #if (r$Status == "Failed") {
  #  Time <- Sys.time()
  #  Function <- "id_check"
  #  Status <- "Failed"
  #  Message <- r$Message

  #  Information <- r$Information[[1]]
  #  return_to_user <-
  #    lst(Message = r$Message,
  #        Information = Information)
  #} else {
  
  # Check for TYPE field
  chk <- ('SUBJECT_ID' %in% names(DS.data))
  
  Time <- Sys.time()
  Function <- "row_check"
  
  if (chk==TRUE) {

    # Check 1: Empty rows
    check1 <- isTRUE(nrow(DS.data[rowSums(is.na(DS.data)) == ncol(DS.data), ])==0)
    empty_row_numbers <- row.names(DS.data[rowSums(is.na(DS.data)) == ncol(DS.data), ])

    # Check 2: Duplicate/identical rows
    check2 <- isTRUE(nrow(DS.data[duplicated(DS.data),])==0)
    duplicated_row_numbers <- row.names(DS.data[duplicated(DS.data),])
    duplicated_SUBJECT_ID <- DS.data[1][duplicated_row_numbers,]

    # Compile report information
    Information <- lst(empty_row_numbers, duplicated_row_numbers, duplicated_SUBJECT_ID)

    if (check1==TRUE & check2==TRUE) {
      Status <- "Passed"
      Message <- c("Passed: no blank or duplicate rows detected.")
      return_to_user <- lst(Message)
    } else {
      Status <- "Failed"
      if (check1==FALSE & check2==TRUE) {
        Message <- c("ERROR: duplicate rows detected.")
      }
      if (check1==TRUE & check2==FALSE) {
        Message <- c("ERROR: blank rows detected.")
      }
      if (check1==FALSE & check2==FALSE) {
        Message <- c("ERROR: blank and duplicate rows detected.")
      }
      return_to_user <- lst(Message, Information)
    }
  } else {
    Status <- "Failed"
    Message <- "ERROR: SUBJECT_ID column not found. See id_check function for details."
    Information <- "ERROR: SUBJECT_ID column not found."
    return_to_user <- lst(Message)
  }
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  if (verbose==TRUE){
    print(return_to_user)
  }

  return(invisible(report))
}
