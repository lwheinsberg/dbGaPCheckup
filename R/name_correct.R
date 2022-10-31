#' @title Name Correction Utility Function 
#' @description This utility function updates the data dictionary so variable names match those listed in the data set.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @return Updated data dictionary with variables reordered to match the data set. 
#' @export
#' @details Recommend use with caution; perform name_check first. 
#' @examples
#' data(ExampleM)
#' name_check(DD.dict.M, DS.data.M)
#' DS.data_updated <- name_correct(DD.dict.M, DS.data.M)
#' name_check(DD.dict.M, DS.data_updated)

name_correct <- function(DD.dict, DS.data) {
  
  # If the variable names match between the data dictionary and the data
  # then set the check to TRUE
  CHECK.name <- isTRUE(all.equal(names(DS.data), DD.dict$VARNAME))
    
  suppressWarnings(col_no <- which(names(DS.data) != DD.dict$VARNAME))
  Information <- bind_rows(Data=paste0("Data: ",names(DS.data)[col_no]), Dict=paste0("Dict: ",DD.dict$VARNAME[col_no]))
      
  Message <- c("CORRECTED ERROR: the variable names differ between the data dictionary and the data. **ALERT** Renaming variable(s) to match those listed in the data dictionary.")
  Information <- bind_rows(Data=paste0("Original data name: ",names(DS.data)[col_no]), Dict=paste0("Dictionary name: ",DD.dict$VARNAME[col_no]), New.Data=paste0("New data name:", DD.dict$VARNAME[col_no]))
  DS.data_updated <- DS.data
  names(DS.data_updated)[col_no] <- DD.dict$VARNAME[col_no]
  return_to_user <- lst(Message, Information)
  print(return_to_user)
  return(DS.data_updated)
}