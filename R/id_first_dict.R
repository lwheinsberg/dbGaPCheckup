#' @title Relocate SUBJECT_ID to First Column of Data Dictionary
#' @description This utility function reorders the data dictionary so that SUBJECT_ID comes first.
#' @param DD.dict Data dictionary.
#' @return Updated data dictionary with SUBJECT_ID as first variable. 
#' @export
#' @details SUBJECT_ID is required to be the first column of the data set and first variable listed in the data dictionary. 
#' @examples
#' data(ExampleQ)
#' head(DD.dict.Q)
#' DD.dict.updated <- id_first_dict(DD.dict.Q)
#' head(DD.dict.updated)

id_first_dict <- function(DD.dict) {
  
  dict.id <- ('SUBJECT_ID' %in% DD.dict$VARNAME)
  
  stopifnot("ERROR: SUBJECT_ID variable missing from data dictinoary" = isTRUE(dict.id))
  
  id.no <- which(DD.dict$VARNAME=="SUBJECT_ID")
  DD.dict.updated <- DD.dict[c(id.no, 1:(id.no-1), (id.no+1):nrow(DD.dict)), ] 

  
  return(DD.dict.updated)
}

