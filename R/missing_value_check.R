#' @title Missing Value Check
#' @description This function flags variables that have non-encoded missing value codes.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as a list of variables that have non-encoded missing values.
#' @param non.NA.missing.codes A user-defined vector of numerical missing value codes (e.g., -9999).
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (A list of variables where a missing value code is not properly encoded).
#' @export
#' @import dplyr
#' @importFrom ggplot2 .data
#' @examples
#' data(ExampleB)
#' missing_value_check(DD.dict.B, DS.data.B, non.NA.missing.codes = c(-9999,-4444))
#' 
#' data(ExampleS)
#' missing_value_check(DD.dict.S, DS.data.S, non.NA.missing.codes = c(-9999,-4444))

missing_value_check <- function(DD.dict, DS.data, verbose=TRUE, non.NA.missing.codes=NA){
  
  r <-
    mv_precheck(
      dict = DD.dict,
      data = DS.data
    )
  
  if (any(r$Status == "Failed")) {
    Time <- Sys.time()
    Function <- "missing_value_check"
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
  
  # Temporarily remove any entries in the VALUES columns that are "INTEGERS", "DECIMALS", OR "STRINGS" 
  col <- which(names(DD.dict)=="VALUES")
  for (i in col:ncol(DD.dict)){
    DD.dict[i][DD.dict[,i]=="INTEGERS" | DD.dict[,i]=="DECIMALS" | DD.dict[,i]=="STRINGS" ] <- NA
  }
  
  # For every variable that contains a specific non NA missing value code,
  # does it have a corresponding VALUES entry like '-9999=missing'?
  codes <- c(NA, unique(na.omit(non.NA.missing.codes))) # Update, automatically including NA
  col <- which(names(DD.dict)=="VALUES")
  tb <- value_meaning_table(DD.dict)
  results <- data.frame(VARNAME=NA, VALUE=NA, MEANING=NA, PASS=NA)
  for (code in codes) {
    # Find columns that actually used the code in the data DS.data
    #m.cols <- # Update 8-21-2023, before this was excluding NA, now we automatically include it
    #  DS.data %>% 
    #  select_if( ~ any(. %in% na.omit(code))) %>% 
    #  names()
    m.cols <-
      DS.data %>% 
      select_if( ~ any(. %in% code)) %>% 
      names()
    # Find columns in the data dictionary that specify a value for the given code
    if (is.na(code)) { # Change to resolve issue #10: make this search conditional upon code being NA or non-NA
      DD.cols <- tb %>% 
        filter(.data$VALUE=="NA") 
    } else {
      DD.cols <- tb %>% 
        filter(.data$VALUE==code) 
    }
    for (var in m.cols) {
      # Check if the current variable is listed in the data dictionary as having this code
      pass <- var %in% DD.cols$VARNAME
      if (var %in% DD.cols$VARNAME) {
        v <- DD.cols %>% 
          filter(.data$VARNAME==var) %>% 
          pull(.data$VALUE)
      } else {
        v <- NA
      }
      results <- bind_rows(results, c(VARNAME=var,VALUE=code, MEANING=v, PASS=pass))
    }
  }
  results <- results[-1,]

  # Compile report information
  Time <- Sys.time()
  Function <- "missing_value_check"
  Information <- subset(results, results$PASS==FALSE)
  if (all(results$PASS==TRUE)) {
    Status <- "Passed"
    Message <- c("Passed: all missing value codes have a corresponding VALUES entry.")
    return_to_user <- lst(Message)
  } else {
    Status <- "Failed"
    Message <- c("ERROR: some variables have non-encoded missing value codes.")
    return_to_user <- lst(Message, Information)
  }
}
    report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  if (verbose==TRUE){
    print(return_to_user)
  }

  return(invisible(report))

}
