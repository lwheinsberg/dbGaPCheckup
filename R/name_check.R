#' @title Name Check
#' @description This function checks if the variable names match between the data dictionary and the data.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param verbose When TRUE, the function prints the Message out, as well as a list of the non-matching variable names.
#' @return Tibble, returned invisibly, containing: (1) Time (time stamp); (2) Name (name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Names of variables that mismatch between the data and data dictionary).
#' @export
#' @examples
#' # Example 1: Fail check (name mismatch)
#' data(ExampleM)
#' name_check(DD.dict.M, DS.data.M)
#' DS.data_updated <- name_correct(DD.dict.M, DS.data.M)
#' name_check(DD.dict.M, DS.data_updated)
#'
#' # Example 2: Pass check
#' data(ExampleA)
#' name_check(DD.dict.A, DS.data.A)
#' print(name_check(DD.dict.A, DS.data.A, verbose=FALSE))

name_check <- function(DD.dict, DS.data, verbose=TRUE) {

  # Dimension check is a required pre-check for this function
  r <-
    name_precheck(
      dict = DD.dict,
      data = DS.data
    )

  if (any(r$Status == "Failed")) {
    Time <- Sys.time()
    Function <- "name_check"
    Status <- "Not attempted"
    row <- grep("Failed", r$Status)
    Message <- paste0("ERROR: Required pre-check ", r$Function[row], " failed.")
    Message2 <- tibble(r$Function, r$Message)
    Information <- r$Information[row]
    return_to_user <-
      lst(Note = "Pre-check failed.",
          Message = Message2,
          Information = Information)
    #return_to_user <-
    #  lst(Message = Message,
    #      Information = lst(var.dim=r$Information[[1]]$var.dim, mismatches=r$Information[[1]]$mismatches))
  } else {

    # If the variable names match between the data dictionary and the data
    # then set the check to TRUE
    CHECK.name <- isTRUE(all.equal(names(DS.data), DD.dict$VARNAME))

    # Compile report
    Time <- Sys.time()
    Function <- "name_check"
    if (CHECK.name==TRUE) {
      Status <- "Passed"
      Message <- c("Passed: the variable names match between the data dictionary and the data.")
      Information <- c("Variable names matched")
      return_to_user <- lst(Message)
    } else {

      suppressWarnings(col_no <- which(names(DS.data) != DD.dict$VARNAME))
      Information <- bind_rows(Data=paste0("Data: ",names(DS.data)[col_no]), Dict=paste0("Dict: ",DD.dict$VARNAME[col_no]))

      if (!all(names(DS.data)==DD.dict$VARNAME) && all(sort(names(DS.data))==sort(DD.dict$VARNAME))) {
        Status <- "Failed"
        Message <- c("ERROR: the variable names match between the data dictionary and the data, but they are in the wrong order. Consider using reorder_dictionary function to automatically reorder the dictionary so that you can continue working through the checks.")
      }

      
     if (!all(names(DS.data)==DD.dict$VARNAME) && !all(sort(names(DS.data))==sort(DD.dict$VARNAME))) {
        Status <- "Failed"
        Message <- c("ERROR: the variable names DO NOT match between the data dictionary and the data. If the intention behind the variable names is correct, consider using the name_correct function to automatically rename variables to match.")
      }

    }
  }
  return_to_user <- lst(Message, Information)
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  if (verbose==TRUE){
    print(return_to_user)
  }
  return(invisible(report))
}


#if (all(names(DS.data)==DD.dict$VARNAME)) print('Perfect match in same order')
#if (!all(names(DS.data)==DD.dict$VARNAME) && all(sort(names(DS.data))==sort(DD.dict$VARNAME))) print('Perfect match in wrong order') <- OPTION TO REORDER
#if (!all(names(DS.data)==DD.dict$VARNAME) && !all(sort(names(DS.data))==sort(DD.dict$VARNAME))) print('Not a perfect match') <- MOVE FROM HERE TO NAME CHECK FOR MORE DETAILS
