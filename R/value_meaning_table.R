#' @title Value-Meaning Table
#' @description This function generates a value-meaning table by parsing the VALUES fields.
#' @param DD.dict Data dictionary.
#' @return A data frame with the columns VARNAME, TYPE, VALUE, MEANING.
#' @export
#' @import tidyr
#' @importFrom magrittr %>%
#' @examples
#' data(ExampleB)
#' head(value_meaning_table(DD.dict.B))

value_meaning_table <- function(DD.dict) {

  col <- which(names(DD.dict)=="VALUES")
  
  if (length(col)==0) {
   # Return message to user that the first VALUES column that should be labeled "VALUES" cannot be found
   message <- c("A column with the heading VALUES cannot be found. Function terminated.") 
   print(message)
     
  } else {
  
    results <- data.frame(VARNAME=NA, TYPE=NA, VALUE=NA, MEANING=NA)
  
    # Temporarily remove any entries in the VALUES columns that are "INTEGERS", "DECIMALS", OR "STRINGS" 
    for (i in col:ncol(DD.dict)){
      DD.dict[col][DD.dict[,col]=="INTEGERS" | DD.dict[,col]=="DECIMALS" | DD.dict[,col]=="STRINGS" ] <- NA
    }
  
    for (var in DD.dict$VARNAME) {
      # The VALUES columns for this selected row of the data dictionary
      DD.dict_values <- DD.dict[DD.dict$VARNAME == var, col:ncol(DD.dict) ]
      type <- as.character(as.data.frame(DD.dict[DD.dict$VARNAME == var,"TYPE"]))
      if (!all(is.na(DD.dict_values))) {
      unique_levels <-
        DD.dict_values[which(!is.na(DD.dict_values) &
                             (DD.dict_values != ""))]
      ul <- data.frame(levels = t(unique_levels))
      ul.sep <- ul %>% separate(levels, c("value", "meaning"), sep = "=", extra="merge")
      for (i in seq_len(nrow(ul.sep))) { 
      results <- bind_rows(results, c(VARNAME=var,TYPE=type, VALUE=ul.sep$value[i], MEANING=ul.sep$meaning[i]))
        }
      }
    }
    results <- results[-1,]
    return(results)
  }
}
