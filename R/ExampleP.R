#' @title ExampleP
#' @name ExampleP
#' @description Example data set with intentional errors.
#' @usage data(ExampleP)
#' @docType data
#' @format \code{R data file} that contains a single object:
#' \describe{
#' \item{DS.data.P}{Data set}
#' }
#' @source 
#' ```
#' DS.path <- system.file("extdata", "DS_Example3b.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.P <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DS.data.P, file = "ExampleP.rda")
#' ```
NULL

# Used in: 
# id_check()