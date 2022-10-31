#' @title ExampleB
#' @name ExampleB
#' @description Example data set and data dictionary with intentional errors.
#' @usage data(ExampleB)
#' @docType data
#' @format \code{R data file} that contains two objects:
#' \describe{
#' \item{DD.dict.B}{Data dictionary}
#' \item{DS.data.B}{Data set}
#' }
#' @source 
#' ```
#' DD.path <- system.file("extdata", "3b_SSM_DD_Example1b.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
#' DD.dict.B <- readxl::read_xlsx(DD.path)
#' DS.path <- system.file("extdata", "DS_Example1b.txt", package = "dbGaPCheckup", mustWork=TRUE)
#' DS.data.B <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
#' save(DD.dict.B, DS.data.B, file = "ExampleB.rda")
#' ```
NULL


# Used in: 
# check_report()
# complete_check()
# create_awareness_report() 
# create_report()
# dictionary_search()
# label_data()
# missing_value_check()
# mm_precheck()
# mv_precheck()
# NA_precheck()
# name_precheck()
# short_precheck()
# super_short_precheck()
# type_check()
# value_meaning_table()
# value_missing_table()
# values_precheck()