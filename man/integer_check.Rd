% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/integer_check.R
\name{integer_check}
\alias{integer_check}
\title{Integer Check}
\usage{
integer_check(DD.dict, DS.data, verbose = TRUE)
}
\arguments{
\item{DD.dict}{Data dictionary.}

\item{DS.data}{Data set.}

\item{verbose}{When TRUE, the function prints the Message out, as well as a list of variables that may be incorrectly labeled as TYPE integer.}
}
\value{
Tibble, returned invisibly, containing: (1) Time (Time stamp); (2) Name (Name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (Names of variables that are listed as TYPE integer, but do not appear to be integers).
}
\description{
This function searches for variables that appear to be incorrectly listed as TYPE integer.
}
\examples{
# Example 1: Fail check
data(ExampleH)
integer_check(DD.dict.H, DS.data.H)
print(integer_check(DD.dict.H, DS.data.H, verbose=FALSE))

# Example 2: Pass check
data(ExampleA)
integer_check(DD.dict.A, DS.data.A)
print(integer_check(DD.dict.A, DS.data.A, verbose=FALSE))

data(ExampleR)
integer_check(DD.dict.R, DS.data.R)
print(integer_check(DD.dict.R, DS.data.R, verbose=FALSE))
}
