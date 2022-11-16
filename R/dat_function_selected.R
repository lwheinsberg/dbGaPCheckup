#' @title Data Selected Utility Function
#' @description This function calls eval_function to generate a textual and graphical report of the selected variables.
#' @param dataset Data set.
#' @param dictionary Data dictionary.
#' @param sex.split When TRUE, split reports by the field named 'Sex'.
#' @param sex.name Character string giving the name of the sex field.
#' @param start Staring index of the first selected trait.
#' @param end   Ending index of the last selected trait.
#' @param dataset.na Data set with missing values set to NA.
#' @param h.level Header level for pandoc function.
#' @return Invisible NULL, called for its side effects
#' @export

dat_function_selected <-function(dataset, dictionary, sex.split = FALSE,sex.name = NULL, start = 1,end = 1, dataset.na, h.level=2){
  if (end < start) {
    stop("ERROR: end needs to be greater than or equal to start.")
  }
  if (start < 1) {
    stop("ERROR: start needs to be greater than or equal to 1.")
  }
  if (end > ncol(dataset)) {
    stop("ERROR: end needs to be less than or equal to the number of columns in the dataset.")
  }
  phenotype<-dictionary$VARNAME
  phenotype<-as.character(phenotype)
  for(i in start:end){
    dictionary_pheno<-dictionary[dictionary$VARNAME==phenotype[i],]
    eval_function(dataset=dataset,dictionary =dictionary_pheno,sex.split=sex.split, sex.name = sex.name, dataset.na = dataset.na, h.level=h.level)
  }
  return(invisible(NULL))
}
