#' @title Missing Value (NA) Check
#' @description Checks for NA values in the data set; if NA values are present, also performs check for NA value=meaning.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as the number of NA values observed in the data set. 
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (the number of NA values in the data set and information on if NA is a properly encoded value).
#' @export
#' @importFrom magrittr %>%
#' @import dplyr
#'
#' @examples
#' # Example 1: Fail check
#' data(ExampleK)
#' NA_check(DD.dict.K, DS.data.K)
#' print(NA_check(DD.dict.K, DS.data.K, verbose=FALSE))
#'
#' # Example 2: Pass check
#' data(ExampleA)
#' NA_check(DD.dict.A, DS.data.A)
#' print(NA_check(DD.dict.A, DS.data.A, verbose=FALSE))
#' 
#' # Example 3: Pass check (though missing_value_check detects a more specific error)
#' data(ExampleS)
#' NA_check(DD.dict.S, DS.data.S)

NA_check <- function(DD.dict, DS.data, verbose=TRUE) {
  
  r <-
    NA_precheck(
      dict = DD.dict,
      data = DS.data
    )
  
  if (any(r$Status == "Failed")) {
    Time <- Sys.time()
    Function <- "NA_check"
    Status <- "Not attempted"
    row <- grep("Failed", r$Status)
    Message <- paste0("ERROR: Required pre-check ", r$Function[row], " failed.")
    Message2 <- tibble(r$Function, r$Message)
    Information <- r$Information[row]
    return_to_user <-
      lst(Note = "Pre-check failed.",
          Message = Message2,
          Information = Information)
  } else {
  
  # Compile report information
  Time <- Sys.time()
  Function <- "NA_check"
  Information <- paste0("There are ", sum(is.na(DS.data)), " NA values in your data set.")

  if (sum(is.na(DS.data))==0){
    chk <- TRUE
  }

  if (sum(is.na(DS.data))>0){
    tb <- value_meaning_table(DD.dict)
    non.NA.missing.codes <- NULL
    #if (NA %in% tb$VALUE){ # Line corrected via Issue 8 
    if ("NA" %in% tb$VALUE) {
      chk <- TRUE
    } else {
      chk <- FALSE
    }
  }

  if (sum(is.na(DS.data))==0){
    Status <- "Passed"
    Message <- c("Passed: no NA values detected in data set.")
    return_to_user <- lst(Message)
  }

  if (sum(is.na(DS.data))>0 & chk==FALSE) {
    Status <- "Failed"
    Message <- c("Error: your data set contains NA values with no encoded NA value=meaning found. If you choose to retain NA values, NA must be specified as a missing value code in VALUES fields as a dbGaP requirement.")
    return_to_user <- lst(Message, Information)
  }

  if (sum(is.na(DS.data))>0 & chk==TRUE) {
    Status <- "Passed"
    Message <- c("Passed: your data set contains NA values that appear to be correctly specified as a missing value code in the VALUES fields.")
    return_to_user <- lst(Message, Information)
  }
}
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  if (verbose==TRUE){
    print(return_to_user)
  }

  return(invisible(report))
}
