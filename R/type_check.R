#' @title Type Check
#' @description If a TYPE field exists, this function checks for any TYPE entries that aren't allowable per dbGaP instructions. 
#' @param DD.dict Data dictionary. 
#' @param verbose When TRUE, the function prints the Message out, as well as more detailed diagnostic information.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (List of illegal TYPE entries).
#' @export
#' @details Allowable entries in TYPE column include: integer; decimal; encoded value; or string. For mixed values, list all types present using commas to separate (e.g., integer, encoded value). 
#' @examples
#' data(ExampleB)
#' type_check(DD.dict.B)
#' print(type_check(DD.dict.B, verbose=FALSE))

type_check <- function(DD.dict, verbose=TRUE){

  # Check for TYPE field
  chk <- ('TYPE' %in% names(DD.dict))
  
  if (chk==TRUE) {
    types <- unique(DD.dict$TYPE)
    DD.dict$TYPE <- gsub("integer", "", DD.dict$TYPE, fixed=TRUE)
    DD.dict$TYPE <- gsub("decimal", "", DD.dict$TYPE, fixed=TRUE)
    DD.dict$TYPE <- gsub("encoded value", "", DD.dict$TYPE, fixed=TRUE)
    DD.dict$TYPE <- gsub("string", "", DD.dict$TYPE, fixed=TRUE)
    DD.dict$TYPE <- gsub(",", "", DD.dict$TYPE, fixed=TRUE)
    DD.dict$TYPE <- trimws(DD.dict$TYPE)
    DD.dict$TYPE[DD.dict$TYPE == ""] <- NA
    chk2 <- all(is.na(DD.dict$TYPE))
  } else {
    chk2 <- FALSE
    Status <- "Failed"
    Message <- "ERROR: TYPE column not found. Consider using the add_missing_fields function to autofill TYPE."
    Information <- "ERROR: TYPE column not found."
    return_to_user <- lst(Message)
  }
  
  if (chk==TRUE & chk2==TRUE) {
    Status <- "Passed"
    Message <- "Passed: All TYPE entries found are accepted by dbGaP per submission instructions."
    Information <- types
    return_to_user <- lst(Message, Information)
  } 
  
  if (chk==TRUE & chk2==FALSE) {
    Status <- "Failed"
    Message <- "ERROR: Some TYPE entries are not allowable per dbGaP submission instructions."
    Information <- unique(DD.dict$TYPE[!is.na(DD.dict$TYPE)])
    IllegalEntries <- unique(DD.dict$TYPE[!is.na(DD.dict$TYPE)])
    return_to_user <- lst(Message,  IllegalEntries)
  }
  
  # Compile report for return to user
  Time <- Sys.time()
  Function <- "type_check"
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))
  
  # If verbose=TRUE, print message
  if (verbose==TRUE){
    print(return_to_user)
  }
  
  # Invisible return of report
  return(invisible(report))
}