#' @title ExampleG
#' @name ExampleG
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleG)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.G}{Data dictionary}
#' \item{DS.data.G}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example2.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.G <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.G <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.G, DS.data.G, file = "ExampleG.rda")
#' ```
NULL

# Used in: 
# description_check()
# dimension_check()