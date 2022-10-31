#' @title ExampleF
#' @name ExampleF
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleF)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.F}{Data dictionary}
#' \item{DS.data.F}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example4.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.F <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example3d.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.F <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.F, DS.data.F, file = "ExampleF.rda")
#' ```
NULL

# Used in: 
# decimal_check()