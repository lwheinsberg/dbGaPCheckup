#' @title Row Check
#' @description This function checks for empty or duplicate rows in the data set and data dictionary.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as the row numbers of any problematic rows.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (A list of problematic row and participant ID numbers).
#' @export
#' @importFrom magrittr %>%
#' @import dplyr
#' @examples
#' # Example 1: Fail check
#' data(ExampleK)
#' row_check(DD.dict.K, DS.data.K)
#' print(row_check(DD.dict.K, DS.data.K, verbose=FALSE))
#'
#' # Example 2: Pass check
#' data(ExampleC)
#' row_check(DD.dict.C, DS.data.C)
#' print(row_check(DD.dict.C, DS.data.C, verbose=FALSE))

row_check <- function(DD.dict, DS.data, verbose=TRUE) {

  # Function contains 2 checks:
  # 1. check for empty rows
  # 2. check for duplicate/identical rows
  
  # Check for TYPE field
  chk <- ('SUBJECT_ID' %in% names(DS.data))
  
  Time <- Sys.time()
  Function <- "row_check"
  
  if (chk==TRUE) {

    # Check 1: Empty rows (data set)
    check1 <- isTRUE(nrow(DS.data[rowSums(is.na(DS.data)) == ncol(DS.data), ])==0)
    Empty_DataSet_RowNumbers <- row.names(DS.data[rowSums(is.na(DS.data)) == ncol(DS.data), ])

    # Check 2: Duplicate/identical rows (data set)
    check2 <- isTRUE(nrow(DS.data[duplicated(DS.data),])==0)
    Duplicate_DataSet_RowNumbers <- row.names(DS.data[duplicated(DS.data),])
    Duplicated_SubjectIDs <- DS.data[1][Duplicate_DataSet_RowNumbers,]
    
    # Check 3: Empty rows (data dictionary)
    DD.dict <- data.frame(DD.dict)
    check3 <- isTRUE(nrow(DD.dict[rowSums(is.na(DD.dict)) == ncol(DD.dict), ])==0)
    Empty_DataDictionary_RowNumbers <- row.names(DD.dict[rowSums(is.na(DD.dict)) == ncol(DD.dict), ])
    
    # Check 4: Duplicate/identical rows (data dictionary)
    check4 <- isTRUE(nrow(DD.dict[duplicated(DD.dict),])==0)
    Duplicated_DataDictionary_RowNumbers <- row.names(DD.dict[duplicated(DD.dict),])
    

    # Compile report information
    Information <- lst(Empty_DataSet_RowNumbers, Duplicate_DataSet_RowNumbers, Duplicated_SubjectIDs,  Empty_DataDictionary_RowNumbers, Duplicated_DataDictionary_RowNumbers)

    if (check1==TRUE & check2==TRUE & check3==TRUE & check4==TRUE) {
      Status <- "Passed"
      Message <- c("Passed: no blank or duplicate rows detected in data set or data dictionary.")
      return_to_user <- lst(Message)
    } else {
      Status <- "Failed"
      Message <- c("ERROR: duplicate and/or blank rows detected in the data set and/or data dictionary.")
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
