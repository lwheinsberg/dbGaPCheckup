#' @title Data Utility Function
#' @description This function calls eval_function to generate a textual and graphical report of the selected variables.
#' @param DS.dataset Data set.
#' @param DD.dictionary Data dictionary.
#' @param sex.split When TRUE, split reports by the field named by the sex.name string.
#' @param sex.name Character string giving the name of the sex field.
#' @param DS.dataset.na Data set with missing values set to NA.
#' @return Invisible NULL, called for its side effects.
#' @export

dat_function <- function(DS.dataset, DD.dictionary, sex.split = FALSE, sex.name = NULL,DS.dataset.na){
  phenotype<-DD.dictionary$VARNAME
  phenotype<-as.character(phenotype)
  for(i in 1:length(phenotype)){
    dictionary_pheno <-DD.dictionary[DD.dictionary$VARNAME==phenotype[i],]
    eval_function(dataset=DS.dataset,dictionary=dictionary_pheno,sex.split = sex.split, sex.name = sex.name,dataset.na = DS.dataset.na)
  }
  return(invisible(NULL))
}

