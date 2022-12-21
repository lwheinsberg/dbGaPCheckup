#' @title Mimimum and Maximum Values Check
#' @description This function flags variables that have values exceeding the `MIN` or `MAX` listed in the data dictionary.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as a list of variables that violate the listed `MIN` or `MAX`.
#' @param non.NA.missing.codes A user-defined vector of numerical missing value codes (e.g., -9999).
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (A list of variables that exceed the listed `MIN` or `MAX` values).
#' @export
#' @importFrom magrittr %>%
#' @importFrom stats na.omit
#' @import dplyr
#' @examples
#' # Example 1
#' # Fail check (incorrectly flagging NA value codes -9999
#' # and -4444 as outside of the min max range)
#' data(ExampleA)
#' minmax_check(DD.dict.A, DS.data.A)
#' # View out of range values:
#' details <- minmax_check(DD.dict.A, DS.data.A)$Information
#' details[[1]]$OutOfRangeValues
#' # Attempt 2, specifying -9999 and -4444 as missing value
#' # codes so check works correctly
#' minmax_check(DD.dict.A, DS.data.A, non.NA.missing.codes=c(-9999, -4444))
#'
#' # Example 2
#' data(ExampleI)
#' minmax_check(DD.dict.I, DS.data.I, non.NA.missing.codes=c(-9999, -4444))
#' # View out of range values:
#' details <- minmax_check(DD.dict.I, DS.data.I, non.NA.missing.codes=c(-9999, -4444))$Information
#' details[[1]]$OutOfRangeValues

minmax_check <- function(DD.dict, DS.data, verbose=TRUE, non.NA.missing.codes=NA){

  # Adding in call to required_check
  r <-
    mm_precheck(
      dict = DD.dict,
      data = DS.data
    )

  if (any(r$Status == "Failed")) {
    Time <- Sys.time()
    Function <- "minmax_check"
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
    dataset_na <- DS.data
    for (value in na.omit(non.NA.missing.codes)) {
      dataset_na <- dataset_na %>% 
        mutate(across(everything(), ~na_if(.x, value)))
    }

    CHECK.combined <- NULL

    for (row in seq_len(nrow(DD.dict))) {

      # Extract the minimum and maximum values for this trait
      range_dictionary <- c(DD.dict$MIN[row],DD.dict$MAX[row])

      # The number of the column containing the selected trait
      ind <- which(names(dataset_na)==DD.dict$VARNAME[row])
      trait <- as.character(DD.dict$VARNAME[row])
      listed_min <- DD.dict$MIN[row]
      listed_max <- DD.dict$MAX[row]

      # Add in safety check
      if (sum(names(dataset_na)==DD.dict$VARNAME[row]) == 0) {
        stop(paste0("ERROR: ", DD.dict$VARNAME[row], " not found in the data set"))
      }

      if (!is.factor(dataset_na[, ind])) {
        flagged <- dataset_na[which(dataset_na[, ind] < range_dictionary[1] | dataset_na[, ind] > range_dictionary[2]), , drop = FALSE]
        row.names(flagged) <- NULL
        if (nrow(flagged) > 0) {
          chk <- FALSE
          out_of_range <- unique(flagged[, ind])
        } else {
          chk <- TRUE
          out_of_range <- NA
        }
      }

    # Here compile the information for each variable
    CHECK <- tibble(Trait=trait, Check=chk, ListedMin=listed_min, ListedMax=listed_max, OutOfRangeValues=list(out_of_range))
    CHECK.combined <- bind_rows(CHECK.combined, CHECK)
    }

    chk <- isTRUE(all(CHECK.combined$Check))

    # Compile report information
    Time <- Sys.time()
    Function <- "minmax_check"
    Information <- subset(CHECK.combined, CHECK.combined$Check==FALSE)
    if (all(chk==TRUE)) {
      Status <- "Passed"
      Message <- c("Passed: when provided, all variables are within the MIN to MAX range.")
      return_to_user <- lst(Message)
    } else {
      Status <- "Failed"
      Message <- c("ERROR: some variables have values outside of the MIN to MAX range.")
      return_to_user <- lst(Message, Information)
    }
  }
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  if (verbose==TRUE){
    print(return_to_user)
  }

  return(invisible(report))
}
