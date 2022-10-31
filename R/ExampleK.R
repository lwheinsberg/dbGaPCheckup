#' @title ExampleK
#' @name ExampleK
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleK)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.K}{Data dictionary}
#' \item{DS.data.K}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example2d.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.K <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example2b.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.K <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.K, DS.data.K, file = "ExampleK.rda")
#' ```
NULL

# Used in: 
# NA_check()
# row_check()