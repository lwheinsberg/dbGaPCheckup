#' @title ExampleC
#' @name ExampleC
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleC)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.C}{Data dictionary}
#' \item{DS.data.C}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example2d.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.C <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example1b.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.C <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.C, DS.data.C, file = "ExampleC.rda")
#' ```
NULL

# Used in: 
# check_report()
# row_check()