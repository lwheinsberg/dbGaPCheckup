#' @title Dimension Check
#' @description This function checks that the number of variables match between the data set and the data dictionary.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as the number of variables in the data set and data dictionary.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (number of variables in the data and dictionary and names of mismatched variables if applicable).
#' @export
#' @importFrom stats setNames
#' @importFrom readxl read_xlsx
#' @examples
#' # Example 1: Fail check
#' data(ExampleG)
#' dimension_check(DD.dict.G, DS.data.G)
#' print(dimension_check(DD.dict=DD.dict.G, DS.data=DS.data.G,verbose=FALSE))
#' 
#' # Example 2: Pass check
#' data(ExampleA)
#' dimension_check(DD.dict.A, DS.data.A)
#' print(dimension_check(DD.dict.A, DS.data.A,verbose=FALSE))

dimension_check <- function(DD.dict, DS.data, verbose=TRUE) {
  # If the number of columns in the data file is the same as
  # the number of rows in the data dictionary, then
  # set the check to TRUE
  DIM.CHECK <- isTRUE(all.equal(ncol(DS.data), nrow(DD.dict)))
  var.dim <- stats::setNames(c(dim(DD.dict)[1], dim(DS.data)[2]), c("Variables in dictionary", "Variables in data"))

  # Create report
  Time <- Sys.time()
  Function <- c("dimension_check")
  if (DIM.CHECK==TRUE) {
    Status <- c("Passed")
    Message <- c("Passed: the variable count matches between the data dictionary and the data.")
    Information <-  var.dim
    return_to_user <- lst(Message, Information)
  } else {
    Status <- c("Failed")
    Message <- c("ERROR: the variable count differs between the data dictionary and the data.")

    # Create a list containing the number of variables in the data dictionary and in the data
    # and a list of the mismatched/missing variables
    `%notin%` <- Negate(`%in%`)
    # Pull out mismatched column numbers
    col_no <- which(names(DS.data) %notin% DD.dict$VARNAME)
    col_no2 <- which( DD.dict$VARNAME %notin% names(DS.data))
    # Combine and de-duplicate column numbers
    mismatches <- data.frame(unique(unlist(lst(col_no, col_no2))))
    names(mismatches) <- "col_no"
    # (A) List of all variables in the data that are not listed in the data dictionary
    NamesMissingFromDictionary <- setdiff(names(DS.data),DD.dict$VARNAME)
    # (B) a list of all variables in the data dictionary that are not present in the data 
    NamesMissingFromData <- setdiff(DD.dict$VARNAME, names(DS.data))
    
    
    for (i in seq_len(nrow(mismatches))) { 
      # Store mismatched column number of interest
      pull <- mismatches$col_no[i]

      # Pull in data set names for mismatched columns
      varname <- names(DS.data)[pull]
      mismatches$Data[i] <- varname

      # Pull in dictionary names for mismatched columns
      varname <- DD.dict$VARNAME[pull]
      mismatches$Dictionary[i] <- varname
    }

    Information <- lst(var.dim, mismatches,NamesMissingFromDictionary, NamesMissingFromData )
    return_to_user <- lst(Status, var.dim, mismatches, NamesMissingFromDictionary, NamesMissingFromData)
  }
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  if (verbose==TRUE){
    print(return_to_user)
  }

  return(invisible(report))
}

