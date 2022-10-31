#' @title ExampleH
#' @name ExampleH
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleH)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.H}{Data dictionary}
#' \item{DS.data.H}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example1.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.H <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example3c.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.H <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.H, DS.data.H, file = "ExampleH.rda")
#' ```
NULL

# Used in: 
# integer_check()