#' @title ExampleE
#' @name ExampleE
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleE)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.E}{Data dictionary}
#' \item{DS.data.E}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example2b.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.E <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example2.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.E <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.E, DS.data.E, file = "ExampleE.rda")
#' ```
NULL

# Used in: 
# decimal_check()
# values_check()