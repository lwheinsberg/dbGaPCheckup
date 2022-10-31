#' @title ExampleA
#' @name ExampleA
#' @description Example data set and data dictionary with no errors.
#' @usage data(ExampleA)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.A}{Data dictionary}
#' \item{DS.data.A}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example1.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.A <- readxl::read_xlsx(DD.path)
#' path <- system.file("extdata", "DS_Example.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.A <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.A, DS.data.A, file = "ExampleA.rda")
#' ```
NULL


# Used in: 
# complete_check()
# decimal_check()
# description_check()
# dimension_check()
# field_check()
# id_check()
# integer_check()
# minmax_check()
# misc_format_check()
# missingness_summary()
# NA_check()
# name_check()
# pkg_field_check()
# short_field_check()
# values_check()