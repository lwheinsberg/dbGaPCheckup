#' @title Check Report
#' @description This function generates a user-readable report of the checks run by the complete_check function.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param non.NA.missing.codes A user-defined vector of numerical missing value codes (e.g., -9999).
#' @param compact When TRUE, the function prints a compact report, listing information from only the non-passed checks.
#' @return Tibble, returned invisibly, containing the following information for each check: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (More detailed information about the potential errors identified).
#' @seealso \code{\link{complete_check}}
#' @export
#'
#' @examples
#' # Example 1: Incorrectly showing as pass check on first attempt
#' data(ExampleB)
#' report <- check_report(DD.dict.B, DS.data.B)
#' # Addition of missing value codes calls attention to error
#' # at missing_value_check
#' report <- check_report(DD.dict.B, DS.data.B, non.NA.missing.codes=c(-4444, -9999))
#'
#' # Example 2: Several fail checks or not attempted
#' data(ExampleC)
#' report <- check_report(DD.dict.C, DS.data.C, non.NA.missing.codes=c(-4444, -9999))
#' # Note you can also run report using compact=FALSE
#' report <- check_report(DD.dict.C, DS.data.C, non.NA.missing.codes=c(-4444, -9999), compact = FALSE)

check_report <- function(DD.dict, DS.data, non.NA.missing.codes = NA, compact = TRUE) {
  stopifnot("ERROR: DS.data is not a data frame" = inherits(DS.data,"data.frame"))
  stopifnot("ERROR: DD.dict is not a data frame" = inherits(DD.dict,"data.frame"))
  r <- complete_check(DD_dict = DD.dict, 
                      DS_data = DS.data, 
                      non.NA.missing.codes = non.NA.missing.codes)
  r.short.short <- r %>% select(Function, Status, Message)
  Function <- NULL
  Status <- NULL
  Message <- NULL
  if (compact == TRUE) {
    r.short <- subset(r, r$Status == "Failed" )
    if (nrow(r.short) > 0) {
      print(r.short.short)
      for (i in c(1:nrow(r.short))) {
        cat("--------------------\n")
        r.i <- r.short[i, ]
        cat(paste0(r.i$Function, ": ", r.i$Status),"\n")
        cat(r.i$Message,"\n")
        print(r.i$Information)
      }
      cat("--------------------\n")
    } else {
      print(r.short.short)
      print(paste0("All ",nrow(r)," checks passed."))
    }
  } else {
    print(r.short.short)
    for (i in c(1:nrow(r))) {
      cat("--------------------\n")
      r.i <- r[i,]
      cat(paste0(r.i$Function,": ",r.i$Status),"\n")
      cat(r.i$Message,"\n")
      print(r.i$Information)
    }
    cat("--------------------\n")
  }
  
  return(invisible(r))
}
