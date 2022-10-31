#' @title ExampleD
#' @name ExampleD
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleD)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.D}{Data dictionary}
#' \item{DS.data.D}{Data set}
#' }
#' @source 
#' ```
#' path <- system.file("extdata", "3b_SSM_DD_Example2f.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.D <- readxl::read_xlsx(path)
#' DS.path <- system.file("extdata", "DS_Example.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.D <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.D, DS.data.D, file = "ExampleD.rda")
#' ```
NULL

# Used in: 
# add_missing_fields()
# complete_check()
# pkg_field_check()
# dbGaPCeckup_vignette