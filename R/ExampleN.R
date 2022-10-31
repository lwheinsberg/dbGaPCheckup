#' @title ExampleN
#' @name ExampleN
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleN)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.N}{Data dictionary}
#' \item{DS.data.N}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example2e.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.N <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.N <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.N, DS.data.N, file = "ExampleN.rda")
#' ```
NULL

# Used in: 
# reorder_dictionary()