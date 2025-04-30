#' @title Duplicated ID Check
#' @description This function checks whether any duplicated SUBJECT_ID values are present in the dataset.
#'              While duplication may be expected in longitudinal data, it may indicate an error in cross-sectional submissions.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as more detailed diagnostic information.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Warning); (4) Message (A copy of the message the function printed out); (5) Information (Details about duplicated SUBJECT_ID values).
#' @export
#' @details  Duplicated Subject IDs are allowed in longitudinal data sets. This is an informational check. 
#' @seealso \code{\link{id_check}}
#' @examples
#' # Example 1: Warning, duplicated 'SUBJECT_ID'
#' data(ExampleT)
#' duplicated_id_check(DS.data.T)
#' 
#' # Example 2: Pass check 
#' data(ExampleA)
#' duplicated_id_check(DS.data.A)

duplicated_id_check <- function(DS.data, verbose = TRUE) {
  
  # Check that SUBJECT_ID exists
  if (!"SUBJECT_ID" %in% names(DS.data)) {
    Status <- "Not attempted"
    Message <- "WARNING: SUBJECT_ID column not found in dataset. Check was not performed."
    Information <- NA
  } else {
    # Check for duplicated IDs
    dup_ids <- DS.data$SUBJECT_ID[duplicated(DS.data$SUBJECT_ID)]
    
    if (length(dup_ids) > 0) {
      Status <- "Warning"
      Message <- paste0("WARNING: duplicated SUBJECT_ID values detected; if expected due to longitudinal data, this can be ignored - otherwise, please review.")
      Information <- tibble(Duplicated_SUBJECT_IDs = unique(dup_ids))
    } else {
      Status <- "Passed"
      Message <- "Passed: no duplicated SUBJECT_ID values found."
      Information <- tibble(Duplicated_SUBJECT_IDs = character(0))
    }
  }
  
  # Compile report for return to user 
  Time <- Sys.time()
  Function <- "duplicated_id_check"
  
  report <- tibble(Time, Function, Status, Message, Information = list(Information))
  
  if (verbose) {
    print(list(Message = Message, Information = Information))
  }
  
  return(invisible(report))
}
