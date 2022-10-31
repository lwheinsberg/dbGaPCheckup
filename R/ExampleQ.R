#' @title ExampleQ
#' @name ExampleQ
#' @description Example data set and data dictionary with no errors.
#' @usage data(ExampleQ)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.Q}{Data dictionary}
#' \item{DS.data.Q}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example5.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.Q <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example5.txt", package = "dbGaPCheckup", mustWork=TRUE) ### FIX THIS 
#' DS.data.Q <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.Q, DS.data.Q, file = "ExampleQ.rda")
#' ```
NULL


# Used in: 
# id_first_data()
# id_first_dict()