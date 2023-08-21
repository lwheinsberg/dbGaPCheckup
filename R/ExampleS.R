#' @title ExampleS
#' @name ExampleS
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleS)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.S}{Data dictionary}
#' \item{DS.data.S}{Data set}
#' }
#' @source 
#' ```
#'DS.path <- system.file("extdata", "DS_Example6.txt", package = "dbGaPCheckup", mustWork=TRUE)  
#'DS.data.S <- read.table(DS.path, header=TRUE, sep="\t", quote="")
#'DD.path <- system.file("extdata", "DD_Example5b.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#'DD.dict.S1 <- readxl::read_xlsx(DD.path)
#'DD.dict.S <- reorder_dictionary(DD.dict.S1, DS.data.S)
#'save(DD.dict.S, DS.data.S, file = "ExampleS.rda")
#' ```
NULL

# Used in: 
# NA_check()
# missing_value_check()