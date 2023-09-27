#' @title Values Missing Table Awareness Function
#' @description This function checks for consistent usage of encoded values and missing value codes between the data dictionary and the data itself.  
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param non.NA.missing.codes A user-defined vector of numerical missing value codes (e.g., -9999).
#' @return A list, returned invisibly,with two components:
#' \itemize{
#'  \item{"report"}{Tibble containing: (1) Name (Name of the function) and (2) Information (Details of all potential flagged variables).}
#'  \item{"tb"}{Tibble with detailed information used to construct the Information.}
#' }
#' @details For each variable, we have three sets of possible values: the set D of all the unique values observed
#' in the data, the set V of all the values explicitly encoded in the VALUES columns of the data dictionary, and 
#' the set M of the missing value codes defined by the user via the `non.NA.missing.codes` argument.
#' This function examines various intersections of these three sets, providing awareness
#' checks to the user about possible issues of concern.  While ideally all defined values in set V should
#' be observed in the data (e.g., in set D), it is not necessarily an error if one does not. This function 
#' checks for:
#' 
#' (A) In Set M and Not in Set D: If the user defines a missing value code that is not present in the data.
#' 
#' (B) In Set V and Not in Set D: If a VALUES entry defines an encoded code value, but that code value is not present in the data.
#' 
#' (C) In Set M and Not in Set V: If the user defines a missing value code that is not defined in a VALUES entry.
#' 
#' (D) M in Set D and Not in Set V: If a defined global missing value code is present in the data for a given variable, but that variable does not have a corresponding VALUES entry.
#' 
#' (E) (Set V values that are not in Set M) that are NOT in Set D = (Set V not in M) not in D: If a VALUES entry is not defined as a missing value code AND is not detected in the data.
#' @seealso \code{\link{create_awareness_report}}
#' @seealso \code{\link{value_meaning_table}}
#' @export
#' @import dplyr
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#' @examples
#' data(ExampleB)
#' value_missing_table(DD.dict.B, DS.data.B, non.NA.missing.codes = c(-9999))
#' print(value_missing_table(DD.dict.B, DS.data.B, non.NA.missing.codes = c(-9999)))
#' results <- value_missing_table(DD.dict.B, DS.data.B, non.NA.missing.codes = c(-9999))
#' results$report$Information$details

value_missing_table <- function(DD.dict, DS.data, non.NA.missing.codes=NA){
   tb <- as_tibble(value_meaning_table(DD.dict))
   #
   # Not in Set M vs. In Set D
   # Look for extreme negative outliers in Set D?
     
   # Check the Set V of encoded values vs. the Set M.
   # Not in Set V vs. In Set M
   # In Set V vs. Not in Set M
   # Grep for the Meaning strings for 'miss'?
   #   Check for M in Set D but Not in Set V
   # Is the current value in the data
   tb$VInD <- NA
   # The count of unique values observed in the data
   tb$NumUniqDVs <- NA
   # Are all the listed missing value codes in the data
   tb$AllMInD <- NA
   # Are any of the listed missing value codes in the data
   tb$AnyMInD <- NA
   # The missing value codes that are in the data
   # In Set M and in Set D
   tb$MInD <- ""
   # The missing value codes that are not in the data
   # In Set M but Not in Set D
   tb$MNotInD <- ""
   # Check that all of the Set V of encoded values are in the data Set D
   tb$AllVsInD <- NA
   # In Set V but Not in Set D
   tb$VsNotInD <- ""
   # Defined Value codes that are in Set M: are they all also in Set D?
   tb$AllDefVsInMInD <- NA
   # Set V in Set M but Not in Set D
   tb$DefVsInMNotInD <- ""
   # Not in Set V vs. In Set D
   setM <- non.NA.missing.codes
   # In Set M vs Not in Set V: 
   # If the user defines a missing value code that is not defined in a VALUES entry.
   tb$AllSetMInSetV <- NA
   tb$SetMsNotInSetV <- ""
   # # M in Set D and Not in Set V
   tb$All_MInSetD_InSetV <- NA
   tb$setMInDNotInV <- ""
   ###### NEW GitHub Issue 36 ########
   # (Set V Not in Set M) Not in Set D
   tb$All_VNotInM_NotInD <- NA
   tb$setVNotInM_NotInD <- ""
   ###### NEW GitHub Issue 36 ########
   
   tb$NsetD <- NA
   tb$NsetM <- NA
   tb$NsetV <- NA
   tb$NsetDAndSetV <- NA
   tb$NsetMAndSetV <- NA
   tb$NsetDAndSetM <- NA
   tb$setV <- NA
   tb$setD <- NA
   tb$setM <- NA
   tb$setDnotM <- NA
   tb$setVnotM <- NA
   tb$N_DnotM <- NA
   tb$N_VnotM <- NA
   tb$DnotM_eq_VnotM <- NA
   tb$DnotM_sub_VnotM <- NA
# Set up a list of all defined VALUES (Set V), a list of all user-defined missing value
# codes (Set M), and a list of all unique values in the data for the current 
# variable X under consideration (Set D) 
     VARNAME <- NULL
     VALUE <- NULL
   for (i in seq_len(nrow(tb))) { 
     trait <- tb[i, ]$VARNAME
     # This is a single value, on the current row i of the tb
     val <- tb[i, ]$VALUE
     setD <- unique(DS.data %>% 
                      select(all_of(trait)) %>% 
                      pull(trait))
     tb$VInD[i] <- val %in% setD
     tb$NumUniqDVs[i] <- length(setD)
     # (A) In Set M and Not in Set D: 
     # If the user defines a missing value code that is not present in the data.
     tb$AllMInD[i] <- all(setM %in% setD)
     tb$AnyMInD[i] <- any(setM %in% setD)
     if (tb$AnyMInD[i]) {
       tb$MInD[i] <- lst(setM[(setM %in% setD)])
     }
     if (!tb$AllMInD[i]) {
       tb$MNotInD[i] <- lst(setM[!(setM %in% setD)])
     }
     # (B) In Set V and Not in Set D: 
     # If a VALUES entry defines an encoded code value, but that code value is not present in the data.
     setV <- tb %>% 
       filter(VARNAME == trait) %>% pull(VALUE)
     tb$AllVsInD[i] <- all(setV %in% setD)
     if (!tb$AllVsInD[i]) {
       tb$VsNotInD[i] <- lst(setV[!(setV %in% setD)])
     }
     DefinedSetVsInM <- setV[setV %in% setM]
     tb$AllDefVsInMInD[i] <- all(DefinedSetVsInM %in% setD)
     if (!tb$AllDefVsInMInD[i]) {
       tb$DefVsInMNotInD[i] <- lst(DefinedSetVsInM[!(DefinedSetVsInM %in% setD)])
     }
     
     # (C) In Set M and Not in Set V 
     # If the user defines a missing value code that is not defined in a VALUES entry.
     tb$AllSetMInSetV[i] <- all(setM %in% setV)
     if (!tb$AllSetMInSetV[i]) {
       tb$SetMsNotInSetV[i] <- lst(setM[!(setM %in% setV)])
     }
     
     # (D) M in Set D and Not in Set V: 
     # If a defined global missing value code is present in the data for a given variable, but that variable does not have a corresponding VALUES entry.
     tmp <- setdiff(setM[(setM %in% setD)], setV)
     if (length(tmp) > 0) {
       tb$All_MInSetD_InSetV[i] <- FALSE
       tb$setMInDNotInV[i] <- lst(tmp)
     } else {
       tb$All_MInSetD_InSetV[i] <- TRUE
     }
     
     ###### NEW GitHub Issue 36 ########
     # (E) (Set V values that are not in Set M) that are NOT in Set D = (Set V\M)\D
     tmp <- setdiff(setV[!(setV %in% setM)], setD)
     if (length(tmp) > 0) {
       tb$All_VNotInM_NotInD[i] <- FALSE
       tb$setVNotInM_NotInD[i] <- lst(tmp)
     } else {
       tb$All_VNotInM_NotInD[i] <- TRUE
     }
     ###### NEW GitHub Issue 36 ########
     
     # We have value-level checks and variable-level checks
     tb$NsetD[i] <- length(setD)
     tb$NsetM[i] <- length(setM)
     tb$NsetV[i] <- length(setV)
     tb$NsetDAndSetV[i] <- length(intersect(as.character(setD), as.character(setV)))
     tb$NsetMAndSetV[i] <- length(intersect(as.character(setM), as.character(setV)))
     tb$NsetDAndSetM[i] <- length(intersect(as.character(setD), as.character(setM)))
     tb$setD[i] <- lst(setD)
     tb$setM[i] <- lst(setM)
     tb$setV[i] <- lst(setV)
     tb$setDnotM[i] <- lst(sort(setdiff(as.character(setD),as.character(setM))))
     tb$setVnotM[i] <- lst(sort(setdiff(as.character(setV),as.character(setM))))
     setDnotM <- sort(setdiff(as.character(setD),as.character(setM)))
     setVnotM <- sort(setdiff(as.character(setV),as.character(setM)))
     tb$N_DnotM[i] <- length(sort(setdiff(as.character(setD),as.character(setM))))
     tb$N_VnotM[i] <- length(sort(setdiff(as.character(setV),as.character(setM))))
     tb$DnotM_eq_VnotM[i] <- isTRUE(all.equal(as.character(setDnotM),as.character(setVnotM)))
     tb$DnotM_sub_VnotM[i] <- all(as.character(setDnotM) %in% as.character(setVnotM))
   }

   #
   # (A) In Set M and Not in Set D: 
   # If the user defines a missing value code that is not present in the data.
   r <- tb %>% 
     select(VARNAME, .data$AllMInD, .data$NsetD, .data$NsetM, .data$NsetDAndSetM, .data$MNotInD, .data$MInD) %>% 
     filter(.data$AllMInD == FALSE) %>% distinct()
   CheckA.AllMInD <- nrow(r) == 0
   check.name <- "Check A: In M, Not in D"
   check.description <- "All missing value codes are in the data"
   if (CheckA.AllMInD==TRUE) {
     check.status <- "Passed"
     details <- lst(CheckA.AllMInD = "Passed")
   } else {
     check.status <- "Flag"
     details <- lst(CheckA.AllMInD = r)
   }
   CheckA.AllMInD.final <- tibble(check.name, check.description, check.status, details)
   
   # (B) In Set V and Not in Set D: 
   # If a VALUES entry defines an encoded code value, but that code value is not present in the data.
   r <- tb %>% 
     select(VARNAME, .data$AllVsInD, .data$NsetD, .data$NsetV, .data$NsetDAndSetV, .data$VsNotInD) %>% 
     filter(.data$AllVsInD == FALSE) %>% 
     distinct()
   CheckB.AllVsInD <- nrow(r) == 0
   check.name <- "Check B: In V, Not in D"
   check.description <- "All value codes are in the data"
   if (CheckB.AllVsInD==TRUE) {
     check.status <- "Passed"
     details <- lst(CheckB.AllVsInD = "Passed")
   } else {
     check.status <- "Flag"
     details <- lst(CheckB.AllVsInD = r)
   }
   CheckB.AllVsInD.final <- tibble(check.name, check.description, check.status, details)
   
   # (C) In Set M and Not in Set V 
   # If the user defines a missing value code that is not defined in a VALUES entry.
   r <- tb %>% 
     select(VARNAME, .data$AllSetMInSetV, .data$NsetV, .data$NsetM, .data$NsetMAndSetV, .data$SetMsNotInSetV) %>% 
     filter(.data$AllSetMInSetV == FALSE) %>% 
     distinct()
   CheckC.AllSetMInSetV <- nrow(r) == 0
   check.name <- "Check C: In M, Not in V"
   check.description <- "All missing value codes are in the VALUES"
   if (CheckC.AllSetMInSetV==TRUE) {
     check.status <- "Passed"
     details <- lst(CheckC.AllSetMInSetV = "Passed")
   } else {
     check.status <- "Flag"
     details <- lst(CheckC.AllSetMInSetV = r)
   }
   CheckC.AllSetMInSetV.final <- tibble(check.name, check.description, check.status, details)
   
   # (D) M in Set D and Not in Set V: 
   # If a defined global missing value code is present in the data for a given variable, but that variable does not have a corresponding VALUES entry.
   r <- tb %>% 
     select(VARNAME, .data$All_MInSetD_InSetV, .data$setMInDNotInV) %>% 
     filter(.data$All_MInSetD_InSetV == FALSE) %>% 
     distinct()
   CheckD.All_MInSetD_InSetV <- nrow(r) == 0
   check.name <- "Check D: In M & in D, not in V"
   check.description <- "All missing value codes are in the data and in values"
   if (CheckD.All_MInSetD_InSetV==TRUE) {
     check.status <- "Passed"
     details <- lst(CheckD.All_MInSetD_InSetV = "Passed")
   } else {
     check.status <- "Flag"
     details <- lst(CheckD.All_MInSetD_InSetV = r)
   }
   CheckD.All_MInSetD_InSetV.final <- tibble(check.name, check.description, check.status, details)
   
   ###### NEW GitHub Issue 36 ########
   # (E) (Set V values that are not in Set M) that are NOT in Set D = (Set V\M)\D
   # If a value code is NOT present in M and is NOT present in the data for a given variable
   r <- tb %>% 
     select(VARNAME, .data$All_VNotInM_NotInD, .data$setVNotInM_NotInD) %>% 
     filter(.data$All_VNotInM_NotInD == FALSE) %>% 
     distinct()
   CheckE.All_VNotInM_NotInD <- nrow(r) == 0
   check.name <- "Check E: V NOT in M, NOT in D"
   check.description <- "All value codes no defined as a missing value code are in the data"
   if (CheckE.All_VNotInM_NotInD==TRUE) {
     check.status <- "Passed"
     details <- lst(CheckE.All_VNotInM_NotInD = "Passed")
   } else {
     check.status <- "Flag"
     details <- lst(CheckE.All_VNotInM_NotInD = r)
   }
   CheckE.All_VNotInM_NotInD.final <- tibble(check.name, check.description, check.status, details)
   ###### NEW GitHub Issue 36 ########
   
   # (F) Awareness: number unique values in D vs number of values in V
   countTable.DvsV <- tb %>% 
     select(VARNAME, .data$NsetD, .data$NsetV, .data$NsetDAndSetV) %>% 
     mutate(Ndiff = .data$NsetD - .data$NsetV) %>% 
     filter(.data$Ndiff != 0) %>%  
     arrange(.data$Ndiff) %>% 
     distinct()
   
   check.name <- "Awareness: NsetD vs. NsetV"
   check.description <- "Size of Set D vs size of set V"
   check.status <- "Info"
   details <- lst(countTable.DvsV)
   check.DvsV <- tibble(check.name, check.description, check.status, details)
   
   # (G) Awareness: number unique values in D\M vs. number of values in V\M
   countTable.DnotMvsVnotM <- tb %>% 
     select(VARNAME, .data$DnotM_sub_VnotM, .data$DnotM_eq_VnotM, .data$N_DnotM, .data$N_VnotM) %>% 
     mutate(Ndiff = .data$N_DnotM - .data$N_VnotM) %>% 
     filter(.data$DnotM_sub_VnotM == FALSE) %>%  
     arrange(.data$N_DnotM, .data$Ndiff) %>% 
     distinct()

   check.name <- "Awareness: N_DnotM vs. N_VnotM"
   check.description <- "Size of Set D\\M vs size of set V\\M"
   check.status <- "Info"
   details <- lst(countTable.DnotMvsVnotM)
   check.DnotMvsVnotM <- tibble(check.name, check.description, check.status, details)
   
   
   Information <- bind_rows(CheckA.AllMInD.final, CheckB.AllVsInD.final, CheckC.AllSetMInSetV.final, CheckD.All_MInSetD_InSetV.final, CheckE.All_VNotInM_NotInD.final, check.DvsV, check.DnotMvsVnotM)
   
   # Compile report
   Time <- Sys.time()
   Function <- "value_missing_table"
   if (all(Information %>% filter(check.status != "Info") %>% pull(check.status) =="Passed")){
     Status <- "Passed"
     Message <- c("Check passed: missing value codes, Values, and data are consistent.")
     return_to_user <- lst(Message, Information)
   } else {
     Status <- "Flag"
     Message <- c("Flag: at least one check flagged.")
     Information <- Information
       return_to_user <- lst(Message, Information)
   }
   
   
   report <- tibble(Function, Information=Information) 
   
   
   print(return_to_user)
  
   
   return(invisible(list(report=report,tb=tb)))
   
}
