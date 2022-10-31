#' @title Reorder Data Dictionary Utility Function 
#' @description This utility function reorders the data dictionary to match the data set.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @return Updated data dictionary with variables reordered to match the data set. 
#' @export
#' @examples
#' data(ExampleN)
#' name_check(DD.dict.N, DS.data.N)
#' DD.dict_updated <- reorder_dictionary(DD.dict.N, DS.data.N)
#' name_check(DD.dict_updated, DS.data.N)

reorder_dictionary <- function(DD.dict, DS.data) {
  
    # If the variable names match between the data dictionary and the data
    # then set the check to TRUE
    CHECK.name <- isTRUE(all.equal(names(DS.data), DD.dict$VARNAME))
    
    suppressWarnings(col_no <- which(names(DS.data) != DD.dict$VARNAME))
    Information <- bind_rows(Data=paste0("Data: ",names(DS.data)[col_no]), Dict=paste0("Dict: ",DD.dict$VARNAME[col_no]))
      
    if (!all(names(DS.data)==DD.dict$VARNAME) && all(sort(names(DS.data))==sort(DD.dict$VARNAME))) {
      Message <- c("CORRECTED ERROR: the variable names match between the data dictionary and the data, but they were in the wrong order. ***ALERT**** this function has temporarily reordered the dictionary to match the data so that you can continue working through the checks.")
      # Double << needed for scoping assignment to parent environment
      DD.dict_updated <- DD.dict[match(names(DS.data), DD.dict$VARNAME),]
      Information$New.Dict <- Information$Data
    }
      
   if (!all(names(DS.data)==DD.dict$VARNAME) && !all(sort(names(DS.data))==sort(DD.dict$VARNAME))) {
      Message <- c("ERROR: the variable names DO NOT match between the data dictionary and the data, but you attempted to use the reorder dictionary function. ***ALERT**** reordering FAILED. Please correct error before continuing.")
      Information <- "Function error"
    }
      
  return_to_user <- lst(Message, Information)
  print(return_to_user)
  return(DD.dict_updated)
}