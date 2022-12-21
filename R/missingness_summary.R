#' @title Missingness Summary
#' @description This awareness function summarizes the amount of missingness in the data set.
#' @param DS.data Data set.
#' @param non.NA.missing.codes A user-defined vector of numerical missing value codes (e.g., -9999).
#' @param threshold Threshold for missingness of concern (as a percent).
#' @return Tibble containing: (1) Message containing information on the number of variables with a % missingness greater than the threshold; (2) Missingness by variable summary; and (3) Summary of missingness for variables with a missingness level greater than the threshold.
#' @seealso \code{\link{create_awareness_report}}
#' @export
#' @importFrom magrittr %>%
#' @importFrom questionr freq.na
#' @importFrom graphics hist
#' @import dplyr
#' @import questionr
#' @examples
#' # Correct useage
#' data(ExampleA)
#' missingness_summary(DS.data.A, non.NA.missing.codes=c(-4444, -9999))

missingness_summary <- function(DS.data, non.NA.missing.codes=NA, threshold=95) {

  # Replace numeric missing codes with NA values
  dataset_na <- DS.data
  for (value in na.omit(non.NA.missing.codes)) {
    dataset_na <- dataset_na %>% 
      mutate(across(everything(), ~na_if(.x, value)))
  }

  # Calculate missingness summary across variables
  full_missingness_summary <- data.frame(freq.na(dataset_na))
  names(full_missingness_summary)[2] <- "percent_missingness"
  # Create a histogram to visually display summary of missingness for user
  histogram_summary <- hist(full_missingness_summary$percent_missingness, col="skyblue3", main="Percent Missingness for Data Set",  xlab = "Percent Missingness")
  # Create a truncated threshold report to return to user
  threshold_summary <- subset(full_missingness_summary, full_missingness_summary$percent_missingness>threshold)

  # Print histogram for user
  histogram_summary

  # Return information to the user
  Message <- paste0("There are ", dim(threshold_summary)[1], " variables with a percent missingness > ", threshold, "% in your data set.")
  return_to_user <- lst(Message, threshold_summary, full_missingness_summary)
  return(return_to_user)
}
