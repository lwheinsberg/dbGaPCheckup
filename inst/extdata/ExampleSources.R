#' dbGaPCheckup Bundled Examples
#' @format A variety of bundled example data sets for illustrating dbGaPCheckup function utility

# Good data set/dictionary, no errors: Example A 
# Data sets/dictionaries with errors: Examples B-P

# Example A 
DD.path <- system.file("extdata", "DD_Example1.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.A <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.A <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.A, DS.data.A, file = "ExampleA.rda")
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


# Example B 
DD.path <- system.file("extdata", "DD_Example1b.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.B <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example1b.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.B <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.B, DS.data.B, file = "ExampleB.rda")
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

# Example C
DD.path <- system.file("extdata", "DD_Example2d.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.C <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example1b.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.C <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.C, DS.data.C, file = "ExampleC.rda")
# Used in: 
# check_report()
# row_check()

# Example D 
path <- system.file("extdata", "DD_Example2f.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.D <- readxl::read_xlsx(path)
DS.path <- system.file("extdata", "DS_Example.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.D <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.D, DS.data.D, file = "ExampleD.rda")
# Used in:
# add_missing_fields()
# complete_check()
# pkg_field_check()
# dbGaPCeckup_vignette

# Example E
DD.path <- system.file("extdata", "DD_Example2b.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.E <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example2.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.E <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.E, DS.data.E, file = "ExampleE.rda")
# Used in: 
# decimal_check()
# values_check()

# Example F
DD.path <- system.file("extdata", "DD_Example4.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.F <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example3d.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.F <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.F, DS.data.F, file = "ExampleF.rda")
# Used in: 
# decimal_check()

# Example G 
DD.path <- system.file("extdata", "DD_Example2.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.G <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.G <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.G, DS.data.G, file = "ExampleG.rda")
# Used in: 
# description_check()
# dimension_check()

# Example H 
DD.path <- system.file("extdata", "DD_Example1.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.H <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example3c.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.H <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.H, DS.data.H, file = "ExampleH.rda")
# Used in: 
# integer_check()

# Example I 
DD.path <- system.file("extdata", "DD_Example2c.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.I <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example2c.txt",package = "dbGaPCheckup", mustWork=TRUE)
DS.data.I <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.I, DS.data.I, file = "ExampleI.rda")
# Used in: 
# minmax_check()

# Example J 
DD.path <- system.file("extdata", "DD_Example2d.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.J <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example2.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.J <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.J, DS.data.J, file = "ExampleJ.rda")
# Used in: 
# misc_format_check()

# Example K
DD.path <- system.file("extdata", "DD_Example2d.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.K <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example2b.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.K <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.K, DS.data.K, file = "ExampleK.rda")
# Used in: 
# NA_check()
# row_check()

# Example L 
DD.path <- system.file("extdata", "DD_Example2b.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.L <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example2c.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.L <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.L, DS.data.L, file = "ExampleL.rda")
# Used in: 
# dbGaPCeckup_vignette

# Example M 
DD.path <- system.file("extdata", "DD_Example2b.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.M <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.M <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.M, DS.data.M, file = "ExampleM.rda")
# Used in: 
# name_check()
# name_correct()

# Example N 
DD.path <- system.file("extdata", "DD_Example2e.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.N <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.N <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.N, DS.data.N, file = "ExampleN.rda")
# Used in: 
# reorder_dictionary()

# Example O 
DS.path <- system.file("extdata", "DS_Example3.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.O <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DS.data.O, file = "ExampleO.rda")
# Used in: 
# id_check()

# Example P 
DS.path <- system.file("extdata", "DS_Example3b.txt", package = "dbGaPCheckup", mustWork=TRUE)
DS.data.P <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DS.data.P, file = "ExampleP.rda")
# Used in: 
# id_check()

# Example Q 
DD.path <- system.file("extdata", "DD_Example5.xlsx", package = "dbGaPCheckup", mustWork=TRUE)
DD.dict.Q <- readxl::read_xlsx(DD.path)
DS.path <- system.file("extdata", "DS_Example5.txt", package = "dbGaPCheckup", mustWork=TRUE) ### FIX THIS 
DS.data.Q <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
save(DD.dict.Q, DS.data.Q, file = "ExampleQ.rda")
# Used in: 
# id_first_data()
# id_first_dict()