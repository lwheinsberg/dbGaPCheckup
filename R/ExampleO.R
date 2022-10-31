#' @title ExampleO
#' @name ExampleO
#' @description Example data set with intentional errors.
#' @usage data(ExampleO)
#' @docType data
#' @format \code{R data file} that contains a single object:
#' \describe{
#' \item{DS.data.O}{Data set}
#' }
#' @source 
#' ```
#' DS.path <- system.file("extdata", "DS_Example3.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.O <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DS.data.O, file = "ExampleO.rda")
#' ```
NULL

# Used in: 
# id_check()