#' @title Add Missing Fields
#' @description This function adds additional fields required by this package including variable type (`TYPE`), minimum value (`MIN`), and maximum value (`MAX`).
#' @param DD.dict Data dictionary.
#' @param DS.data Data set. 
#' @return A data frame containing the updated data dictionary with missing fields added in, or NULL if any required pre-checks fail. 
#' @export
#' @details Even though MIN, MAX, and TYPE are not required by dbGaP, our package was created to use these variables in a series of other checks and awareness functions (e.g., render_report, values_check, etc.). MIN/MAX columns will be added as empty columns as dbGaP instructions state that the MIN and MAX should be the "logical" MIN/MAX for the data, not necessarily the observed MIN/MAX, which would be study and variable specific. TYPE will be inferred from the data set and data dictionary VALUES columns. Note however, that if the VALUES columns are not set up correctly, then this function can't properly infer the data TYPE from the data set and data dictionary.  
#' @importFrom tibble add_column
#' @import tibble
#' @examples
#' # Example
#' data(ExampleD)
#' DD.dict.updated <- add_missing_fields(DD.dict.D, DS.data.D)

add_missing_fields <- function(DD.dict, DS.data){

  DD.dict <- as_tibble(DD.dict)
  # Call required pre-check (must pass dimension/name check)
  r <-
    short_precheck(
      dict = DD.dict,
      data = DS.data
    )
  
  if (any(r$Status == "Failed")) {
    Function <- "dbGaPCheckup_required_field_check"
    Status <- "Failed"
    Message <- tibble(Function=r$Function, Message=r$Message)
    row <- grep("Failed", r$Status)
    Information <- r$Information[row]
    return_to_user <-
      lst(Note = "Pre-check failed.",
          Message = Message,
          Information = Information)
    print(return_to_user)
    return(NULL)
  } else {
    # Check for TYPE field
    TYPE <- ('TYPE' %in% names(DD.dict))
    
    # Check for MIN field
    MIN <- ('MIN' %in% names(DD.dict))
    
    # Check for MAX field
    MAX <- ('MAX' %in% names(DD.dict))
    
    # Create named vector of all check values
    CHECK.required.fields <- unlist(lst(TYPE, MIN, MAX))
    
    # Store values column numbers now, so we can rearrange them back on the end 
    lastfirst <- which(names(DD.dict)=="VALUES")
    lastlast <- ncol(DD.dict)
      
    # Add MIN and MAX as empty fields 
    if (MIN==FALSE & MAX==FALSE & TYPE==FALSE) {
      DD.dict.updated <- DD.dict %>% 
        add_column(MIN = NA, MAX = NA, TYPE = NA) %>% 
        relocate(lastfirst:lastlast, .after=last_col())
    }
    if (MIN==FALSE & MAX==FALSE & TYPE==TRUE) {
      DD.dict.updated <- DD.dict %>% 
        add_column(MIN = NA, MAX = NA) %>% 
        relocate(lastfirst:lastlast, .after=last_col())
    }
    if (MIN==TRUE & MAX==TRUE & TYPE==FALSE) {
      DD.dict.updated <- DD.dict %>% 
        add_column(TYPE = NA) %>% 
        relocate(lastfirst:lastlast, .after=last_col())
    }
      
    # Temporarily remove any entries in the VALUES columns that are "INTEGERS", "DECIMALS", OR "STRINGS" 
    # (in case someone followed along with weird dbGaP data dict examples)
    col <- which(names(DD.dict.updated)=="VALUES")
    for (i in col:ncol(DD.dict.updated)){
      DD.dict.updated[i][DD.dict.updated[,i]=="INTEGERS" | 
                DD.dict.updated[,i]=="DECIMALS" |
                DD.dict.updated[,i]=="STRINGS" ] <- NA
    }
      
    # Infer type from the data 
    if (TYPE==FALSE) {
      #DD.dict <<- DD.dict %>% add_column(TYPE = NA)
      for (i in seq_along(DS.data)) {
        col.i <- DS.data %>% select(i) %>% pull()
        if ((inherits(col.i, "numeric") | 
            inherits(col.i, "integer")) &&
            int_check(col.i)==TRUE & 
            is.na(DD.dict.updated$VALUES[i])) {
          DD.dict.updated$TYPE[i] <- "integer"
        }
        if ((inherits(col.i, "numeric") | 
            inherits(col.i, "integer")) && 
            int_check(col.i)==TRUE & 
            !is.na(DD.dict.updated$VALUES[i])) {
          DD.dict.updated$TYPE[i] <- "integer, encoded value"
        }
        if ((inherits(col.i, "numeric") | 
            inherits(col.i, "integer")) && 
            int_check(col.i)==FALSE & 
            is.na(DD.dict.updated$VALUES[i])) {
          DD.dict.updated$TYPE[i] <- "decimal"
        }
        if ((inherits(col.i, "numeric") | 
            inherits(col.i, "integer")) && 
            int_check(col.i)==FALSE & 
            !is.na(DD.dict.updated$VALUES[i])) {
          DD.dict.updated$TYPE[i] <- "decimal, encoded value"
        }
        if (inherits(col.i, "character") & is.na(DD.dict.updated$VALUES[i])) {
          DD.dict.updated$TYPE[i] <- "string"
        }
        if (inherits(col.i, "character") & !is.na(DD.dict.updated$VALUES[i])) {
          DD.dict.updated$TYPE[i] <- "string, encoded value"
        }
      }
    } # End TYPE=false logic
  Message <- c("CORRECTED ERROR: not all package-level required fields were present in the data dictionary. The missing fields have now been added! TYPE was inferred from the data, and MIN/MAX have been added as empty fields.")
  Missing <- names(which(CHECK.required.fields==FALSE))
  return_to_user <- lst(Message, Missing)
  print(return_to_user)
  return(DD.dict.updated)
  }
}
