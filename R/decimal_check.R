#' @title Decimal Check
#' @description This function searches for variables that appear to be incorrectly listed as TYPE decimal. 
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as a list of variables that may be incorrectly labeled as TYPE decimal.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Names of variables that are listed as TYPE decimal, but do not appear to be decimals).
#' @export
#' @importFrom magrittr %>%
#' @import dplyr
#'
#' @examples
#' # Example 1: Fail check
#' data(ExampleF)
#' decimal_check(DD.dict.F, DS.data.F)
#' print(integer_check(DD.dict.F, DS.data.F, verbose=FALSE))
#' 
#' # Example 2: Required pre-check fails
#' data(ExampleE)
#' decimal_check(DD.dict.E, DS.data.E)
#' print(decimal_check(DD.dict.E, DS.data.E, verbose=FALSE))
#' 
#' # Example 3: Pass check
#' data(ExampleA)
#' decimal_check(DD.dict.A, DS.data.A)
#' print(decimal_check(DD.dict.A, DS.data.A, verbose=FALSE))

decimal_check <- function(DD.dict, DS.data, verbose=TRUE) {

  r <-
    mm_precheck(
      dict = DD.dict,
      data = DS.data
    )

  if (any(r$Status == "Failed")) {
    Time <- Sys.time()
    Function <- "decimal_check"
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

    # Pull out variables listed as TYPE decimal in the data dictionary
    dec.vars <- which(grepl("decimal", DD.dict$TYPE))

    # Apply inner function
    chk <- DS.data %>% 
      summarize(across(all_of(dec.vars), int_check, .names = "{.col}"))
    CHECK.decimal <- (all(chk==FALSE))
    # These are of TYPE decimal but contain all integer values
    CHECK.VARIABLES <- names(chk)[chk==TRUE]

    # Compile report information
    Time <- Sys.time()
    Function <- "decimal_check"
    if (all(chk==FALSE)) {
      Status <- "Passed"
      Message <- "Passed: all variables listed as TYPE decimal appear to be decimals."
      Information <- "NA"
      return_to_user <- lst(Message)
    } else {
      Status <- "Failed"
      Message <- "ERROR: some variables listed as TYPE decimal do not appear to be decimals."
      Information <- CHECK.VARIABLES
      return_to_user <- lst(Message, Information)
    }
  }
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  if (verbose==TRUE){
    print(return_to_user)
  }

  return(invisible(report))
}
