#' @title Label the data
#' @description Using the information in the data dictionary, this function adds non-missing information from the data dictionary as attributes to the data.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param non.NA.missing.codes A user-defined vector of numerical missing value codes (e.g., -9999).
#' @return A tibble containing the labelled data set, with the data dictionary information embedded as attributes and variables labelled using Haven SPSS conventions.
#' @export
#' @import dplyr
#' @import rlang
#' @import labelled
#' @examples
#' data(ExampleB)
#' DS_labelled_data <- label_data(DD.dict.B, DS.data.B, non.NA.missing.codes=c(-9999))
#' labelled::var_label(DS_labelled_data$SEX)
#' labelled::val_labels(DS_labelled_data$SEX)
#' attributes(DS_labelled_data$SEX)
#' labelled::na_values(DS_labelled_data$HX_DEPRESSION)

label_data <- function(DD.dict, DS.data, non.NA.missing.codes=NA) {
  # Assumption: The variables in the dictionary and the data are in the same order
  stopifnot("The variables in the data dictionary and in the data must be in the same order" = (all.equal(DD.dict$VARNAME, names(DS.data))) )
  
  # Assumes VARNAME is in the first column of the data dictionary
  # and VARDESC is in the second column.
  stopifnot("VARNAME and VARDESC must be the first two columns in the data dictionary" = 
              (names(DD.dict)[1] == "VARNAME" & names(DD.dict)[2] == "VARDESC"))
  
  DS.data <- as_tibble(DS.data)
  tbl1 <- value_meaning_table(DD.dict)
  for (trait in DD.dict$VARNAME) {
    var.desc <- DD.dict %>% filter(VARNAME==trait) %>% pull(VARDESC)
    DS.data <- DS.data %>% set_variable_labels(!!trait := var.desc)
    
    tmp <- tbl1 %>% filter(VARNAME==trait)
    if (nrow(tmp) > 0) {
      if (all(grepl("integer", tmp$TYPE, ignore.case = TRUE))) {
        vlab <- as.integer(tmp$VALUE)
      }
      if (all(grepl("decimal", tmp$TYPE, ignore.case = TRUE))) {
        vlab <- as.numeric(tmp$VALUE)
      }
      names(vlab) <- tmp$MEANING
      if (all(!is.na(non.NA.missing.codes))) {
        vMissLab <- vlab[vlab %in% non.NA.missing.codes]
        vNonMissLab <- vlab[!(vlab %in% non.NA.missing.codes)]
        if (length(vMissLab) > 0) {
          DS.data <- DS.data %>% 
            set_value_labels(!!trait := vNonMissLab) %>% 
            set_na_values(!!trait := vMissLab)
        } else {
          DS.data <- DS.data %>% 
            set_value_labels(!!trait := vNonMissLab)  
        }
      } else {
      DS.data <- DS.data %>% set_value_labels(!!trait := vlab)
      }
    }
    
    VARNAME <- NULL 
    VARDESC <- NULL
    
    trait2 <- rlang::enquo(trait)
    # Add non-missing non-VALUES information as attributes
    # Assumes VARNAME is in the first column of the data dictionary
    # and VARDESC is in the second column.
    for (varname in names(DD.dict)[c(3:(grep("VALUES",names(DD.dict)) -1))]) {
      var.attr <- DD.dict %>% filter(VARNAME==trait) %>% pull(!! varname)
      if (!is.na(var.attr)) {
        attr(DS.data[[rlang::as_name(trait2)]], varname) <- var.attr
      }
    }


  }
  return(DS.data)
}

