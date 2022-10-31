#' @title ExampleL
#' @name ExampleL
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleL)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.L}{Data dictionary}
#' \item{DS.data.L}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example2b.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.L <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example2c.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.L <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.L, DS.data.L, file = "ExampleL.rda")
#' ```
NULL

# Used in: 
# dbGaPCeckup_vignette