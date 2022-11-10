#' @title Create Report
#' @description This function calls eval_function to generate a textual and graphical report of the selected variables in HTML format, and optionally opens it in the web browser.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param sex.split When TRUE, split reports by the field named as defined by the sex.name variable.
#' @param sex.name Character string specifying the name of the sex field.
#' @param start Staring index of the first select trait.
#' @param end   Ending index of the last selected trait.
#' @param non.NA.missing.codes A user-defined vector of numerical missing value codes (e.g., -9999).
#' @param output.path Path to the folder in which to create the HTML report document.
#' @param open.html If TRUE, open the HTML report document in the web browser.
#' @param fn.stem File name stem. 
#' @return Full path to the HTML report document.
#' @export
#' @import pander
#' @import ggplot2
#' @import tidyr
#' @import formatR
#' @importFrom utils browseURL
#'
#' @examples
#' \donttest{
#' data(ExampleB)
#' create_report(DD.dict.B, DS.data.B, sex.split=TRUE, sex.name= "SEX",
#'    start = 3, end = 7, non.NA.missing.codes=c(-9999,-4444),
#'    output.path= tempdir(), open.html = FALSE)
#' }

create_report <- function(DD.dict, DS.data, sex.split = FALSE, sex.name = NULL, start = 1, end = 1, non.NA.missing.codes=NA, output.path = tempdir(), open.html = TRUE, fn.stem="Report") {
  
  # Temporarily remove any entries in the VALUES columns that are "INTEGERS", "DECIMALS", OR "STRINGS" 
  col <- which(names(DD.dict)=="VALUES")
  for (i in col:ncol(DD.dict)){
    DD.dict[i][DD.dict[,i]=="INTEGERS" | DD.dict[,i]=="DECIMALS" | DD.dict[,i]=="STRINGS" ] <- NA
  }
  
  # Adjust VALUES column names in the data dictionary
  n <- min(grep("VALUES",names(DD.dict)) + 1)
  n.max <- ncol(DD.dict)
  names(DD.dict)[n:n.max] <- paste0("VALUES",seq(1,n.max-n+1))

    if (sex.split) {
      if (is.null(sex.name)) {
        stop("ERROR: sex.split is TRUE but sex.name is NULL.")
      }

      if (!is.null(sex.name)) {
        if (!(sex.name %in% names(DS.data))) {
          stop(paste0("ERROR: The variable ", sex.name," was not present in the data."))
        }
      }
    }
  # Create a temporary data set based on the specification of non-NA missing value codes
    dataset_na <- DS.data
    for (value in na.omit(non.NA.missing.codes)) {
      dataset_na <- dataset_na %>% na_if(value)
    }

  Rmd.file <- system.file("rmd","dbGaP_check_report.Rmd", package="dbGaPCheckup", mustWork = TRUE)
  Html.file <- paste0(fn.stem, "-", paste0(format(Sys.time(), "%Y%m%d_%H%M%S")), ".html")
  Report.file <- file.path(output.path,Html.file)
  rmarkdown::render(
    Rmd.file, params = list(
      DS.data = DS.data,
      DD.dict = DD.dict,
      start = start,
      end = end,
      sex.split = sex.split,
      sex.name = sex.name,
      dataset.na = dataset_na
    ),
    output_file = Report.file
  )
  if (open.html) {
    browseURL(Report.file)
  }
  return(Report.file)
}
