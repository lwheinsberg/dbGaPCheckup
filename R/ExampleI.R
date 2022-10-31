#' @title ExampleI
#' @name ExampleI
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleI)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.I}{Data dictionary}
#' \item{DS.data.I}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example2c.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.I <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example2c.txt",package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.I <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.I, DS.data.I, file = "ExampleI.rda")
#' ```
NULL

# Used in: 
# minmax_check()