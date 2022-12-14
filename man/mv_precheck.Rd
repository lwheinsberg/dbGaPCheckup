% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mv_precheck.R
\name{mv_precheck}
\alias{mv_precheck}
\title{Missing Values Required Pre-checks}
\usage{
mv_precheck(dict, data)
}
\arguments{
\item{dict}{Data dictionary.}

\item{data}{Data set.}
}
\value{
Tibble containing the following information for each check: (1) Time (time stamp); (2) Name (name of the function); (3) Status (Passed/Failed); (4) Message (A copy of the message the function printed out); (5) Information (More detailed information about the potential errors identified).
}
\description{
This function runs a workflow of the minimum number of checks required for a user to run missing_value_check; the checks include \code{field_check} and \code{pkg_field_check}.
}
\examples{
data(ExampleB)
mv_precheck(DD.dict.B, DS.data.B)
}
