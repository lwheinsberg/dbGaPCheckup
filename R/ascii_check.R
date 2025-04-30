#' @title ASCII Character Check
#' @description This function scans both the data dictionary and data set for problematic characters that may interfere with dbGaP submission requirements. Specifically, it checks for: (1) Non-ASCII characters (e.g., with accents) and (2) Newline and carriage return characters (e.g., line breaks). It returns a list of any variable names (columns), row numbers, and values where these issues are detected.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as detailed information on non-ASCII locations.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Column, row, and value of detected non-ASCII characters).
#' @export
#' @examples
#' # Passed example
#' data(ExampleA)
#' ascii_check(DD.dict.A, DS.data.A) 
#'
#' # Failed example
#' data(ExampleT)
#' ascii_check(DD.dict.T, DS.data.T)

ascii_check <- function(DD.dict, DS.data, verbose = TRUE) {
  
  detect_non_ascii <- function(df, file_name) {
    issues <- list()
    
    for (col in names(df)) {
      if (is.character(df[[col]])) {
        column_data <- df[[col]]
        
        # 1. Check for non-ASCII
        bad_rows_ascii <- which(!is.na(column_data) & !grepl("^[\x20-\x7E]*$", column_data))
        if (length(bad_rows_ascii) > 0) {
          for (row in bad_rows_ascii) {
            issues[[length(issues) + 1]] <- data.frame(
              file = file_name,
              column = col,
              row = row,
              value = column_data[row],
              issue_type = "Non-ASCII character",
              stringsAsFactors = FALSE
            )
          }
        }
        
        # 2. Check for newlines or carriage returns
        bad_rows_newline <- which(!is.na(column_data) & grepl("[\r\n]", column_data))
        if (length(bad_rows_newline) > 0) {
          for (row in bad_rows_newline) {
            issues[[length(issues) + 1]] <- data.frame(
              file = file_name,
              column = col,
              row = row,
              value = column_data[row],
              issue_type = "Newline or carriage return",
              stringsAsFactors = FALSE
            )
          }
        }
        
      }
    }
    
    if (length(issues) > 0) do.call(rbind, issues) else NULL
  }
  
  Time <- Sys.time()
  Function <- "ascii_check"
  
  issues.dict <- detect_non_ascii(DD.dict, "Data dictionary")
  issues.data <- detect_non_ascii(DS.data, "Data set")
  
  Information <- dplyr::bind_rows(issues.dict, issues.data)
  
  if (nrow(Information) == 0) {
    Status <- "Passed"
    Message <- "Passed: no non-ASCII characters detected in data dictionary or data set."
    return_to_user <- list(Message = Message)
  } else {
    Status <- "Failed"
    Message <- "ERROR: non-ASCII characters detected. See Information for details."
    return_to_user <- list(Message = Message, Information = Information)
  }
  
  report <- tibble::tibble(
    Time = Time,
    Function = Function,
    Status = Status,
    Message = Message,
    Information = list(Information)
  )
  
  if (verbose) print(return_to_user)
  
  return(invisible(report))
}
