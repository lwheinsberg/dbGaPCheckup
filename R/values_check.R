#' @title Values Check
#' @description This function checks for potential errors in the VALUES columns by ensuring (1) required format of `VALUE=MEANING` (e.g., 0=Yes or 1=No); (2) no leading/trailing spaces near the equals sign; (3) all variables of TYPE encoded have VALUES entries; and (4) all variables with VALUES entries are listed as TYPE encoded.
#' @param DD.dict Data dictionary.
#' @param verbose When TRUE, the function prints the Message out, as well as a list of variables that fail one of the values checks.
#' @return Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Details of which checks passed/failed for which value=meaning instances).
#' @export
#' @import tidyr
#' @examples
#' # Example 1: Fail check
#' data(ExampleE)
#' values_check(DD.dict.E)
#' print(values_check(DD.dict.E, verbose=FALSE))
#' 
#' # Example 2: Pass check
#' data(ExampleA)
#' values_check(DD.dict.A)
#' print(values_check(DD.dict.A, verbose=FALSE))

values_check <- function(DD.dict, verbose=TRUE) {
  
  # Add required_check as pre-check
  r <-
    values_precheck(
      dict = DD.dict
    )
  
  if (any(r$Status == "Failed")) {
    Time <- Sys.time()
    Function <- "values_check"
    Status <- "Not attempted"
    row <- grep("Failed", r$Status)
    Message <- paste0("ERROR: Required pre-check ", r$Function[row], " failed.")
    Message2 <- tibble(r$Function, r$Message)
    Information <- r$Information[row]
    return_to_user <-
      lst(Note = "Pre-check failed.",
          Message = Message2,
          Information = Information)
  } else {
    
    chk <- dup_values(DD.dict)
    if (chk==TRUE) {
      
    # Check 1: Is an = present in all values columns (VALUE=MEANING)?  
    # Check 2: Are there leading/trailing spaces near the first equal sign?
    # Check 3: Do all variables of TYPE encoded have at least one VALUES entry?
    # Check 4: Are all variables with at least one VALUES entry of TYPE encoded?
  
    # Temporarily remove any entries in the VALUES columns that are "INTEGERS", "DECIMALS", OR "STRINGS" 
    col <- which(names(DD.dict)=="VALUES")
    for (i in col:ncol(DD.dict)){
      DD.dict[i][DD.dict[,i]=="INTEGERS" | DD.dict[,i]=="DECIMALS" | DD.dict[,i]=="STRINGS" ] <- NA
    }

    # Perform checks 1-2 via loop (as the number of VALUES columns can vary greatly across data sets)

    ##### Check 1: Is an equals sign present for all non-NA values columns? #####
    # Store number of the first VALUES column
    vcol <- which(names(DD.dict)=="VALUES")
    # Create empty object to store results in
    v.check <- NULL
    # Loop through all VALUES columns to perform check
    for (col in vcol:ncol(DD.dict)) {
      # If dim=0, TRUE; else, FALSE
      # For values columns that are not NA, are there equals signs in them?
      values.check <- (dim(DD.dict[!is.na(DD.dict[col]) & !grepl("=", unlist(DD.dict[col])), c("VARNAME", names(DD.dict)[col])])[1]==0)
      # Store column name
      column_name <- names(DD.dict[,col])

      # Store information listed in values column
      if (values.check==FALSE){
        vname <- unlist(DD.dict[!is.na(DD.dict[col]) & !grepl("=", unlist(DD.dict[col])), c("VARNAME")])
        type <- unlist(DD.dict[!is.na(DD.dict[col]) & !grepl("=", unlist(DD.dict[col])), c("TYPE")])
        problematic_description <- unlist(DD.dict[!is.na(DD.dict[col]) & !grepl("=", unlist(DD.dict[col])), c(names(DD.dict)[col])])
      } else {
        vname <- NA
        type <- NA
        problematic_description <- NA
      }

      # Create data frame with column name, check value, and problematic description (if applicable)
      v.check.comb <- data.frame(column_name, values.check, vname, type, problematic_description)
      # Bind each loop into final check
      v.check <- bind_rows(v.check.comb, v.check)
    }
    # Clean up check 1 results
    rownames(v.check) <- 1:nrow(v.check)
    v.check$check <- "Check 1: Is an equals sign present for all values columns?"
    VALUES.CHECK1 <- (isTRUE(all(v.check$values.check)))
    VALUES.CHECK1.details <- v.check
    if (isTRUE(VALUES.CHECK1)) {
      check.name <- "Check 1"
      check.description <- "Is an equals sign present for all values columns?"
      check.status <- "Passed"
      check1.final <- data.frame(check.name, check.description, check.status)
    }

    ##### Check 2: Are there any leading/trailing spaces near the first equals sign? #####
    v.check <- NULL
    vcol <- which(names(DD.dict)=="VALUES")
    for (col in vcol:ncol(DD.dict)) {
      # Step 1: Extract the column
      a <- data.frame(DD.dict[,col])

      # Step 2: Split extracted column by first equals sign
      names(a)[1] <- "VALUE.RAW"
      VALUE.RAW <- NULL
      suppressWarnings(temp <- separate(data = a, col = VALUE.RAW,  c("value","meaning"), sep="=", extra="merge"))

      # Step 3: Grep for trailing space in first column (value)
      trouble_rows1 <- grep("\\s+$", temp$value)

      # Step 4: Grep for leading space in second column (meaning)
      trouble_rows2 <- grep("^\\s+", temp$meaning)

      # Step 5: Merge trouble row numbers
      trouble_rows <- c(unique(trouble_rows1, trouble_rows2))

      # Step 6: Determine pass/fail check
      if (length(trouble_rows) == 0){
        values.check <- TRUE
      } else {
        values.check <- FALSE
      }

      # Step 7: Extract detailed information about trouble_rows
      column_name <- names(DD.dict[,col])

      if (length(trouble_rows) != 0){
        vname <- unlist(rownames(DD.dict)[trouble_rows])
        type <- unlist(DD.dict$TYPE)[trouble_rows]
        problematic_description <- unlist(DD.dict[col])[trouble_rows]
      } else {
        vname <- NA
        type <- NA
        problematic_description <- NA
      }

      v.check.comb <- data.frame(column_name, values.check, vname, type, problematic_description)
      v.check <- bind_rows(v.check.comb, v.check)
    }
    rownames(v.check) <- 1:nrow(v.check)
    v.check$check <- "Check 2: Are there any leading/trailing spaces near the first equals sign?"
    VALUES.CHECK2 <- (isTRUE(all(v.check$values.check)))
    VALUES.CHECK2.details <- v.check
    if (isTRUE(VALUES.CHECK2)) {
      check.name <- "Check 2"
      check.description <- "Are there any leading/trailing spaces near the first equals sign?"
      check.status <- "Passed"
      check2.final <- data.frame(check.name, check.description, check.status)
    }

    #####  Check 3: Do all variables of TYPE encoded have at least one VALUES entry? #####
    v.check <- NULL
    values.check <- (dim(DD.dict[is.na(DD.dict$VALUES) & grepl("encoded value", DD.dict$TYPE), c("VARNAME","VALUES")])[1]==0)
    column_name <- "VALUES"

    if (values.check==FALSE){
      vname <- unlist(DD.dict[is.na(DD.dict$VALUES) & grepl("encoded value", DD.dict$TYPE), c("VARNAME")])
      type <- unlist(DD.dict[is.na(DD.dict$VALUES) & grepl("encoded value", DD.dict$TYPE), c("TYPE")])
      problematic_description <- unlist(DD.dict[is.na(DD.dict$VALUES) & grepl("encoded value", DD.dict$TYPE), c("VALUES")])
    } else {
      vname <- NA
      type <- NA
      problematic_description <- NA
    }

    v.check.comb <- data.frame(column_name, values.check, vname, type, problematic_description)
    v.check <- bind_rows(v.check.comb, v.check)

    rownames(v.check) <- 1:nrow(v.check)
    v.check$check <- "Check 3: Do all variables of TYPE encoded have at least one VALUES entry?"
    VALUES.CHECK3 <- (isTRUE(all(v.check$values.check)))
    VALUES.CHECK3.details <- v.check
    if (isTRUE(VALUES.CHECK3)) {
      check.name <- "Check 3"
      check.description <- "Do all variables of TYPE encoded have at least one VALUES entry?"
      check.status <- "Passed"
      check3.final <- data.frame(check.name, check.description, check.status)
    }


    ##### Check 4: Are all variables with VALUES entries of TYPE encoded? #####
    v.check <- NULL
    values.check <- (dim(DD.dict[!grepl("encoded value", DD.dict$TYPE) & grepl("=", DD.dict$VALUES), c("VARNAME","TYPE", "VALUES")])[1]==0)

    column_name <- "VALUES"

    if (values.check==FALSE){
      vname <- unlist(DD.dict[!grepl("encoded value", DD.dict$TYPE) & grepl("=", DD.dict$VALUES), c("VARNAME")])
      type <- unlist(DD.dict[!grepl("encoded value", DD.dict$TYPE) & grepl("=", DD.dict$VALUES), c("TYPE")])
      problematic_description <- unlist(DD.dict[!grepl("encoded value", DD.dict$TYPE) & grepl("=", DD.dict$VALUES), c("VALUES")])
    } else {
      vname <- NA
      type <- NA
      problematic_description <- NA
    }

    v.check.comb <- data.frame(column_name, values.check, vname, type, problematic_description)
    v.check <- bind_rows(v.check.comb, v.check)

    rownames(v.check) <- 1:nrow(v.check)
    v.check$check <- "Check 4: Are all variables with VALUES entries of TYPE encoded?"
    VALUES.CHECK4 <- (isTRUE(all(v.check$values.check)))
    VALUES.CHECK4.details <- v.check

    if (isTRUE(VALUES.CHECK4)) {
      check.name <- "Check 4"
      check.description <- "Are all variables with VALUES entries of TYPE encoded?"
      check.status <- "Passed"
      check4.final <- data.frame(check.name, check.description, check.status)
    }
    
    # Compile report
    Time <- Sys.time()
    Function <- "values_check"
    VALUES.CHECK <- unlist(lst(VALUES.CHECK1, VALUES.CHECK2, VALUES.CHECK3, VALUES.CHECK4))

    if (all(VALUES.CHECK==TRUE)) {
      Status <- "Passed"
      Message <- c("Passed: all four VALUES checks look good.")
      Information <- bind_rows(check1.final, check2.final, check3.final, check4.final)
      #Information <- VALUES.CHECK
      return_to_user <- lst(Message, Information)
    } else {
      Status <- "Failed"
      Message <- c("ERROR: at least one VALUES check flagged potentials issues. See Information for more details.")
      Information2 <-  bind_rows(VALUES.CHECK1.details, VALUES.CHECK2.details, VALUES.CHECK3.details, VALUES.CHECK4.details)
      Information <- subset(Information2, values.check==FALSE)
      #Problem_Variables <- Information %>% select(column_name, vname, type, problematic_description, check)
      return_to_user <- lst(Message, Information)
    } 
  } else {
    Time <- Sys.time()
    Function <- "values_check"
    Status <- "Not attempted"
    Message <- "VALUES column name duplicated or missing. Check not performed."
    Information <- names(DD.dict)[duplicated(names(DD.dict))]
    return_to_user <- lst(Message)
  }
}
  report <- tibble(Time, Function, Status, Message, Information=lst(Information))

  if (verbose==TRUE){
    print(return_to_user)
  }
  return(invisible(report))
}
