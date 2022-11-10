#' @title Data Dictionary Search
#' @description This awareness function helps you search the data dictionary for a specific term; intended for use as an investigative aid to supplement other checks in this package.
#' @param DD.dict Data dictionary.
#' @param search.term Search term.
#' @param search.column Column of the data dictionary to search.
#' @return Tibble containing dictionary rows in which the search term was detected in specified column or an error message if the search column could not be detected.
#' @export
#' @importFrom magrittr %>%
#' @import dplyr
#'
#' @examples

#' # Successful search
#' data(ExampleB)
#' dictionary_search(DD.dict.B, search.term=c("skinfold"), search.column=c("VARDESC"))
#' # Attempted search in wrong column
#' dictionary_search(DD.dict.B, search.term=c("skinfold"), search.column=c("VARIABLE_DESCRIPTION"))

dictionary_search <- function(DD.dict, search.term=c("blood pressure"), search.column=c("VARDESC")) {

  if (search.column %in% names(DD.dict)) {
    col.no <- which(names(DD.dict)==search.column)
    Message <- DD.dict[grep(search.term, unlist(DD.dict[,col.no]), ignore.case = TRUE),]
  } else {
    Message <- paste0("ERROR: ", search.column, " is not a column name in the data dictionary.")
  }
  print(Message)
}
