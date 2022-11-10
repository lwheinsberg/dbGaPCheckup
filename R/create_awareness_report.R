#' @title Create Awareness Report
#' @description This function generates an awareness report in HTML format, and optionally opens it in the web browser.
#' @param DD.dict Data dictionary.
#' @param DS.data Data set.
#' @param non.NA.missing.codes A user-defined vector of numerical missing value codes (e.g., -9999).
#' @param threshold Threshold for missingness of concern (as a percent).
#' @param output.path Path to the folder in which to create the HTML report document.
#' @param open.html If TRUE, open the HTML report document in the web browser.
#' @param fn.stem File name stem.
#' @return Full path to the HTML report document.
#' @seealso \code{\link{value_missing_table}}
#' @seealso \code{\link{missingness_summary}}
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
#' create_awareness_report(DD.dict.B, DS.data.B, non.NA.missing.codes=c(-9999),
#'    output.path= tempdir(), open.html = FALSE)
#' }

create_awareness_report <- function(DD.dict, DS.data, non.NA.missing.codes=NA, threshold=95, output.path = tempdir(), open.html = TRUE, fn.stem = "AwarenessReport") {

  Rmd.file <- system.file("rmd","dbGaP_awareness_report.Rmd", package="dbGaPCheckup", mustWork = TRUE)
  Html.file <- paste0(fn.stem, "-", paste0(format(Sys.time(), "%Y%m%d_%H%M%S")), ".html")
  Report.file <- file.path(output.path,Html.file)
  rmarkdown::render(
    Rmd.file, params = list(
      DS.data = DS.data,
      DD.dict = DD.dict,
      non.NA.missing.codes = non.NA.missing.codes, 
      threshold = threshold
    ),
    output_file = Report.file
  )
  if (open.html) {
    browseURL(Report.file)
  }
  return(Report.file)
}
