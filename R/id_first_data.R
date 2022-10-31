#' @title Relocate SUBJECT_ID to First Column of Data Set
#' @description This utility function reorders the data set so that SUBJECT_ID comes first.
#' @param DS.data Data set.
#' @return Updated data set with SUBJECT_ID as first column. 
#' @export
#' @details SUBJECT_ID is required to be the first column of the data set and first variable listed in the data dictionary. 
#' @examples 
#' data(ExampleQ)
#' head(DS.data.Q)
#' DS.data.updated <- id_first_data(DS.data.Q)
#' head(DS.data.updated)

id_first_data <- function(DS.data) {
  
  # Store column numbers of SUBJECT_ID
  data.id <- ('SUBJECT_ID' %in% names(DS.data))
  
  stopifnot("ERROR: SUBJECT_ID column missing from data set." = isTRUE(data.id))
  
  DS.data.updated <- DS.data %>% 
      relocate(SUBJECT_ID)
  
  SUBJECT_ID <- NULL
  
  return(DS.data.updated)
}