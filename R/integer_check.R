#' @title Integer Check
#' @description This function searches for variables that appear to be incorrectly listed as TYPE integer.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as a list of variables that may be incorrectly labeled as TYPE integer.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Names of variables that are listed as TYPE integer, but do not appear to be integers).
#' @export
#' @importFrom magrittr %>%
#' @import dplyr
#'
#' @examples
#' # Example 1: Fail check
#' data(ExampleH)
#' integer_check(DD.dict.H, DS.data.H)
#' print(integer_check(DD.dict.H, DS.data.H, verbose=FALSE))
#' 
#' # Example 2: Pass check
#' data(ExampleA)
#' integer_check(DD.dict.A, DS.data.A)
#' print(integer_check(DD.dict.A, DS.data.A, verbose=FALSE))
#' 
#' data(ExampleR)
#' integer_check(DD.dict.R, DS.data.R)
#' print(integer_check(DD.dict.R, DS.data.R, verbose=FALSE))

integer_check <- function(DD.dict, DS.data, verbose=TRUE) {
  # Adding in call to required_check
  r <-
    mm_precheck(
      dict = DD.dict,
      data = DS.data
    )

  if (any(r$Status == "Failed")) {
    Time <- Sys.time()
    Function <- "integer_check"
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
    # Store list of integer variables
    int.vars <- which(grepl("integer", DD.dict$TYPE))
    
    # Find non-numeric columns in int.vars NEW 8-21-2023
    non_numeric_vars <- int.vars[!sapply(DS.data[, int.vars], is.numeric)]
    
    # Apply int_function only to numeric columns NEW 8-21-2023
    int.vars <- int.vars[sapply(DS.data[, int.vars], function(x) is.numeric(x))]

    # Apply int_function NEW 8-21-2023
    #chk <-
    #  DS.data %>% 
    #    summarize(across(all_of(int.vars), int_check, .names = "{.col}"))
    #CHECK.integer <- (all(chk == TRUE))
    #CHECK.VARIABLES <- names(chk)[chk == FALSE]
    
    if (length(int.vars) > 0) {
      chk <-
        DS.data %>%
        summarize(across(all_of(int.vars), int_check, .names = "{.col}"))
      CHECK.integer <- all(chk == TRUE)
      CHECK.VARIABLES <- names(chk)[chk == FALSE]
    } else {
      CHECK.integer <- TRUE
      CHECK.VARIABLES <- character(0)  # No integer columns found
    }
    
    # Combine failed integer checks and non-numeric columns
    other.vars <- names(DS.data[non_numeric_vars])
    CHECK.VARIABLES <- c(CHECK.VARIABLES, other.vars)

    # Compile report information
    Time <- Sys.time()
    Function <- "integer_check"
    Information <- CHECK.VARIABLES

    if (all(chk == TRUE)) {
      Status <- "Passed"
      Message <-
        c("Passed: all variables listed as TYPE integer appear to be integers.")
      return_to_user <- lst(Message)
    } else {
      Status <- "Failed"
      Message <-
        c("ERROR: some variables listed as TYPE integer do not appear to be integers.")
      return_to_user <- lst(Message, Information)
    }
  }

  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  # If verbose=TRUE, print message
  if (verbose==TRUE){
    print(return_to_user)
  }

  return(invisible(report))
}
