% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/value_missing_table.R
\name{value_missing_table}
\alias{value_missing_table}
\title{Values Missing Table Awareness Function}
\usage{
value_missing_table(DD.dict, DS.data, non.NA.missing.codes = NA)
}
\arguments{
\item{DD.dict}{Data dictionary.}

\item{DS.data}{Data set.}

\item{non.NA.missing.codes}{A user-defined vector of numerical missing value codes (e.g., -9999).}
}
\value{
A list, returned invisibly,with two components:
\itemize{
\item{"report"}{Tibble containing: (1) Name (Name of the function) and (2) Information (Details of all potential flagged variables).}
\item{"tb"}{Tibble with detailed information used to construct the Information.}
}
}
\description{
This function checks for consistent usage of encoded values and missing value codes between the data dictionary and the data itself.
}
\details{
For each variable, we have three sets of possible values: the set D of all the unique values observed
in the data, the set V of all the values explicitly encoded in the VALUES columns of the data dictionary, and
the set M of the missing value codes defined by the user via the \code{non.NA.missing.codes} argument.
This function examines various intersections of these three sets, providing awareness
checks to the user about possible issues of concern.  While ideally all defined values in set V should
be observed in the data (e.g., in set D), it is not necessarily an error if one does not. This function
checks for:

(A) In Set M and Not in Set D: If the user defines a missing value code that is not present in the data.

(B) In Set V and Not in Set D: If a VALUES entry defines an encoded code value, but that code value is not present in the data.

(C) In Set M and Not in Set V: If the user defines a missing value code that is not defined in a VALUES entry.

(D) M in Set D and Not in Set V: If a defined global missing value code is present in the data for a given variable, but that variable does not have a corresponding VALUES entry.

(E) (Set V values that are not in Set M) that are NOT in Set D = (Set V not in M) not in D: If a VALUES entry is not defined as a missing value code AND is not detected in the data.
}
\examples{
data(ExampleB)
value_missing_table(DD.dict.B, DS.data.B, non.NA.missing.codes = c(-9999))
print(value_missing_table(DD.dict.B, DS.data.B, non.NA.missing.codes = c(-9999)))
results <- value_missing_table(DD.dict.B, DS.data.B, non.NA.missing.codes = c(-9999))
results$report$Information$details
}
\seealso{
\code{\link{create_awareness_report}}

\code{\link{value_meaning_table}}
}
