#' @title ExampleJ
#' @name ExampleJ
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleJ)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.J}{Data dictionary}
#' \item{DS.data.J}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example2d.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.J <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example2.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.J <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.J, DS.data.J, file = "ExampleJ.rda")
#' ```
NULL

# Used in: 
# misc_format_check()