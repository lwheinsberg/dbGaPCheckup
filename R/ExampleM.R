#' @title ExampleM
#' @name ExampleM
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleM)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.M}{Data dictionary}
#' \item{DS.data.M}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example2b.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.M <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.M <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.M, DS.data.M, file = "ExampleM.rda")
#' ```
NULL

# Used in: 
# name_check()
# name_correct()