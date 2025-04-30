#' @title ASCII Cleaner
#' @description This function scans a data frame for common problematic characters and returns a cleaned version by:
#' - Converting smart quotes (e.g., curved) to ASCII quotes (e.g., " and ')
#' - Replacing accented characters with ASCII equivalents (e.g., e, n)
#' - Removing newline and carriage return characters (that create line breaks)
#' @param df A data frame to clean.
#' @return A cleaned data frame with ASCII-safe text.
#' @seealso \code{\link{ascii_check}}
#' @export
#' @examples
#' data(ExampleT)
#' ascii_check(DD.dict.T, DS.data.T)
#' DD.dict_updated <- ascii_cleaner(DD.dict.T)
#' ascii_check(DD.dict_updated, DS.data.T)

ascii_cleaner <- function(df) {
  # Load stringi for Unicode normalization and transliteration
  if (!requireNamespace("stringi", quietly = TRUE)) {
    stop("Please install the 'stringi' package to use ascii_cleaner().")
  }
  
  # Function to clean a character vector
  clean_text <- function(x) {
    x <- stringi::stri_replace_all_regex(x, '[\u201C\u201D]', '"')  # Smart double quotes → "
    x <- stringi::stri_replace_all_regex(x, '[\u2018\u2019]', "'")  # Smart single quotes → '
    x <- stringi::stri_replace_all_fixed(x, "\r", "")      # Carriage returns
    x <- stringi::stri_replace_all_fixed(x, "\n", "")      # Newlines
    x <- stringi::stri_trans_general(x, "Latin-ASCII")     # Accented letters → ASCII
    return(x)
  }
  
  # Copy of original
  cleaned <- df
  
  for (col in names(cleaned)) {
    if (is.character(cleaned[[col]])) {
      cleaned[[col]] <- clean_text(cleaned[[col]])
    }
  }
  
  return(cleaned)
}
