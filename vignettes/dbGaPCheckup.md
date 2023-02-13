dbGaPCheckup Quick Start
================
Lacey W. Heinsberg and Daniel E. Weeks

February 13, 2023

- <a href="#1-copyright-information" id="toc-1-copyright-information">1
  Copyright information</a>
- <a href="#2-installation" id="toc-2-installation">2 Installation</a>
- <a href="#3-quick-start" id="toc-3-quick-start">3 Quick start</a>
- <a href="#4-usage" id="toc-4-usage">4 Usage</a>
- <a href="#5-example-usage" id="toc-5-example-usage">5 Example usage</a>
  - <a href="#51-load-the-dbgapcheckup-r-package"
    id="toc-51-load-the-dbgapcheckup-r-package">5.1 Load the
    <code>dbGaPCheckup</code> R package</a>
  - <a href="#52-read-in-your-subject-phenotype-data-into-dsdata"
    id="toc-52-read-in-your-subject-phenotype-data-into-dsdata">5.2 Read in
    your Subject Phenotype data into <code>DS.data</code>.</a>
  - <a href="#53-read-in-your-subject-phenotype-data-dictionary-into-dddict"
    id="toc-53-read-in-your-subject-phenotype-data-dictionary-into-dddict">5.3
    Read in your Subject Phenotype data dictionary into
    <code>DD.dict</code>.</a>
  - <a href="#54-run-the-function-check_report"
    id="toc-54-run-the-function-check_report">5.4 Run the function
    <code>check_report</code>.</a>
    - <a
      href="#541-if-needed-run-the-function-add_missing_fields-and-repeat-check_report"
      id="toc-541-if-needed-run-the-function-add_missing_fields-and-repeat-check_report">5.4.1
      If needed, run the function <code>add_missing_fields</code> and repeat
      <code>check_report</code></a>
  - <a href="#55-reporting" id="toc-55-reporting">5.5 Reporting</a>
  - <a href="#56-labelled-data" id="toc-56-labelled-data">5.6 Labelled
    data</a>
- <a href="#6-contact-information" id="toc-6-contact-information">6
  Contact information</a>
- <a href="#7-acknowledgments" id="toc-7-acknowledgments">7
  Acknowledgments</a>

# 1 Copyright information

Copyright 2022, University of Pittsburgh. All Rights Reserved. License:
[GPL-2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

# 2 Installation

To install from [CRAN](https://cran.r-project.org/) use:

    install.packages("dbGaPCheckup")

To install the development version from [GitHub](https://github.com/)
use:

    devtools::install_github("lwheinsberg/dbGaPCheckup/pkg")

# 3 Quick start

This document is designed to provide “quick start” guidance for using
the `dbGaPCheckUp` R package. Please see the table below and
`dbGaPCheckup_vignette` for more detailed information.

| Function_Name           | Function_Type         | Function_Description                                                                                                                                                                                                                                                                                                                  |
|:------------------------|:----------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| field_check             | check                 | Checks for dbGaP required fields: variable name (VARNAME), variable description (VARDESC), units (UNITS), and variable value and meaning (VALUES).                                                                                                                                                                                    |
| pkg_field_check         | check                 | Checks for package-level required fields: variable type (TYPE), minimum value (MIN), and maximum value (MAX).                                                                                                                                                                                                                         |
| dimension_check         | check                 | Checks that the number of variables match between the data set and data dictionary.                                                                                                                                                                                                                                                   |
| name_check              | check                 | Checks that variable names match between the data set and data dictionary.                                                                                                                                                                                                                                                            |
| id_check                | check                 | Checks that the first column of the data set is the primary ID for each participant labeled as SUBJECT_ID and that the values contain no spaces, padded zeros, or other illegal characters.                                                                                                                                           |
| row_check               | check                 | Checks for empty or duplicate rows in the data set.                                                                                                                                                                                                                                                                                   |
| NA_check                | check                 | Checks for NA values in the data set and, if NA values are present, also checks for an encoded NA value=meaning description.                                                                                                                                                                                                          |
| type_check              | check                 | If a TYPE field exists, this function checks for any TYPE entries that aren’t allowable per dbGaP instructions.                                                                                                                                                                                                                       |
| values_check            | check                 | Checks for potential errors in the VALUES columns by ensuring (1) required format of `VALUE=MEANING` (e.g., 0=No or 1=Yes); (2) no leading/trailing spaces near the equals sign (e.g., 0=No vs. 0 = No); (3) all variables of TYPE encoded have VALUES entries; and (4) all variables with VALUES entries are listed as TYPE encoded. |
| integer_check           | check                 | Checks for variables that appear to be incorrectly listed as TYPE integer.                                                                                                                                                                                                                                                            |
| decimal_check           | check                 | Checks for variables that appear to be incorrectly listed as TYPE decimal.                                                                                                                                                                                                                                                            |
| misc_format_check       | check                 | Checks miscellaneous dbGaP formatting requirements to ensure (1) no duplicate variable names; (2) variable names do not contain “dbgap”; (3) there are no duplicate column names in the dictionary; and (4) column names falling after VALUES column are unnamed.                                                                     |
| description_check       | check                 | Checks for unique and non-missing descriptions (VARDESC) for every variable in the data dictionary.                                                                                                                                                                                                                                   |
| minmax_check            | check                 | Checks for variables that have values exceeding the listed MIN or MAX.                                                                                                                                                                                                                                                                |
| missing_value_check     | check                 | Checks for variables that have non-encoded missing value codes.                                                                                                                                                                                                                                                                       |
| complete_check          | bulk check            | Runs the entire workflow (field_check, pkg_field_check, dimension_check, name_check, id_check, row_check, NA_check, type_check, values_check, integer_check, decimal_check, misc_format_check, description_check, minmax_check, and missing_value_check).                                                                             |
| add_missing_fields      | utility               | Adds additional fields required by this package including variable type (‘TYPE’), minimum value (‘MIN’), and maximum value (‘MAX’).                                                                                                                                                                                                   |
| name_correct            | utility               | Updates the data set so variable names match those listed in the data dictionary.                                                                                                                                                                                                                                                     |
| reorder_dictionary      | utility               | Reorders the data dictionary to match the data set.                                                                                                                                                                                                                                                                                   |
| reorder_data            | utility               | Reorders the data set to match the data dictionary.                                                                                                                                                                                                                                                                                   |
| id_first_data           | utility               | Reorders the data set so that SUBJECT_ID comes first.                                                                                                                                                                                                                                                                                 |
| id_first_dict           | utility               | Reorders the data dictionary so that SUBJECT_ID comes first.                                                                                                                                                                                                                                                                          |
| label_data              | utility, awareness    | Adds non-missing information from the data dictionary as attributes to the data.                                                                                                                                                                                                                                                      |
| value_meaning_table     | utility, awareness    | Generates a value-meaning table by parsing the VALUES fields.                                                                                                                                                                                                                                                                         |
| missingness_summary     | awareness             | Summarizes the amount of missingness in the data set.                                                                                                                                                                                                                                                                                 |
| value_missing_table     | awareness             | Checks for consistent usage of encoded values and missing value codes between the data dictionary and the data set.                                                                                                                                                                                                                   |
| dictionary_search       | awareness             | Facilitates searches of the data dictionary.                                                                                                                                                                                                                                                                                          |
| check_report            | bulk check, reporting | Generates a user-readable report of the checks run by the complete_check function.                                                                                                                                                                                                                                                    |
| create_report           | reporting, awareness  | Generates a textual and graphical report of the selected variables in HTML format.                                                                                                                                                                                                                                                    |
| create_awareness_report | reporting, awareness  | Generates an awareness report, calling missingness_summary and value_missing_table functions.                                                                                                                                                                                                                                         |

List of function names and types.

# 4 Usage

After the `dbGaPCheckup` package has been installed, you can load the R
package using this command:

`library(dbGaPCheckup)`

Then proceed as follows:

1.  Read in your data into `DS.data`;
2.  Read in your data dictionary into `DD.dict`;
3.  Run the function `check_report`, optionally defining any missing
    value codes (e.g., -9999) via the `non.NA.missing.codes` argument.

Note, as you will see below, this package requires several fields beyond
those required by the dbGaP [formatting
requirements](https://www.ncbi.nlm.nih.gov/gap/docs/submissionguide/).
Specifically, the data dictionary is required to also have `MIN`, `MAX`,
and `TYPE` fields. If your data dictionary does not include these fields
already, you can use the `add_missing_fields` function to auto fill them
(see below).

# 5 Example usage

## 5.1 Load the `dbGaPCheckup` R package

``` r
library(dbGaPCheckup)
```

## 5.2 Read in your Subject Phenotype data into `DS.data`.

``` r
DS.path <- system.file("extdata", "DS_Example.txt",
   package = "dbGaPCheckup", mustWork=TRUE)
DS.data <- read.table(DS.path, header=TRUE, sep="\t", quote="", as.is = TRUE)
```

## 5.3 Read in your Subject Phenotype data dictionary into `DD.dict`.

``` r
DD.path <- system.file("extdata", "DD_Example2f.xlsx",
   package = "dbGaPCheckup", mustWork=TRUE)
DD.dict <- readxl::read_xlsx(DD.path)
#> New names:
#> • `` -> `...15`
#> • `` -> `...16`
#> • `` -> `...17`
#> • `` -> `...18`
#> • `` -> `...19`
```

## 5.4 Run the function `check_report`.

With many functions, specification of missing value codes are important
for accurate results.

``` r
report <- check_report(DD.dict = DD.dict, DS.data = DS.data, non.NA.missing.codes=c(-4444, -9999))
#> # A tibble: 15 × 3
#>    Function            Status        Message                                                                                    
#>    <chr>               <chr>         <chr>                                                                                      
#>  1 field_check         Passed        Passed: required fields VARNAME, VARDESC, UNITS, and VALUES present in the data dictionary.
#>  2 pkg_field_check     Failed        ERROR: not all package-level required fields are present in the data dictionary. Consider …
#>  3 dimension_check     Passed        Passed: the variable count matches between the data dictionary and the data.               
#>  4 name_check          Passed        Passed: the variable names match between the data dictionary and the data.                 
#>  5 id_check            Passed        Passed: All ID variable checks passed.                                                     
#>  6 row_check           Passed        Passed: no blank or duplicate rows detected.                                               
#>  7 NA_check            Not attempted ERROR: Required pre-check pkg_field_check failed.                                          
#>  8 type_check          Failed        ERROR: TYPE column not found. Consider using the add_missing_fields function to autofill T…
#>  9 values_check        Not attempted ERROR: Required pre-check type_check failed.                                               
#> 10 integer_check       Not attempted ERROR: Required pre-check pkg_field_check failed.                                          
#> 11 decimal_check       Not attempted ERROR: Required pre-check pkg_field_check failed.                                          
#> 12 misc_format_check   Passed        Passed: no check-specific formatting issues identified.                                    
#> 13 description_check   Failed        ERROR: missing and duplicate descriptions found in data dictionary.                        
#> 14 minmax_check        Not attempted ERROR: Required pre-check pkg_field_check failed.                                          
#> 15 missing_value_check Not attempted ERROR: Required pre-check pkg_field_check failed.                                          
#> --------------------
#> pkg_field_check: Failed 
#> ERROR: not all package-level required fields are present in the data dictionary. Consider using the add_missing_fields function to auto fill these fields. 
#> $pkg_field_check.Info
#>  TYPE   MIN   MAX 
#> FALSE FALSE FALSE 
#> 
#> --------------------
#> type_check: Failed 
#> ERROR: TYPE column not found. Consider using the add_missing_fields function to autofill TYPE. 
#> $type_check.Info
#> [1] "ERROR: TYPE column not found."
#> 
#> --------------------
#> description_check: Failed 
#> ERROR: missing and duplicate descriptions found in data dictionary. 
#> $description_check.Info
#> # A tibble: 4 × 2
#>   VARNAME  VARDESC              
#>   <chr>    <chr>                
#> 1 PREGNANT <NA>                 
#> 2 REACT    <NA>                 
#> 3 HEIGHT   Height of participant
#> 4 WEIGHT   Height of participant
#> 
#> --------------------
```

### 5.4.1 If needed, run the function `add_missing_fields` and repeat `check_report`

As described in more detail in the `dbGaPCheckup_vignette` vignette,
some checks contain embedded “pre-checks” that must be passed before the
check can be run. For example, As mentioned above, this package requires
`MIN`, `MAX`, and `TYPE` fields in the data dictionary. We have created
a function to auto fill these fields that can be used to get further
along in the checks.

``` r
DD.dict.updated <- add_missing_fields(DD.dict, DS.data)
#> $Message
#> [1] "CORRECTED ERROR: not all package-level required fields were present in the data dictionary. The missing fields have now been added! TYPE was inferred from the data, and MIN/MAX have been added as empty fields."
#> 
#> $Missing
#> [1] "TYPE" "MIN"  "MAX"
```

Once the fields are added, you can return to run your checks.

``` r
report.v2 <- check_report(DD.dict = DD.dict.updated , DS.data = DS.data, non.NA.missing.codes=c(-4444, -9999))
#> # A tibble: 15 × 3
#>    Function            Status Message                                                                                    
#>    <chr>               <chr>  <chr>                                                                                      
#>  1 field_check         Passed Passed: required fields VARNAME, VARDESC, UNITS, and VALUES present in the data dictionary.
#>  2 pkg_field_check     Passed Passed: package-level required fields TYPE, MIN, and MAX present in the data dictionary.   
#>  3 dimension_check     Passed Passed: the variable count matches between the data dictionary and the data.               
#>  4 name_check          Passed Passed: the variable names match between the data dictionary and the data.                 
#>  5 id_check            Passed Passed: All ID variable checks passed.                                                     
#>  6 row_check           Passed Passed: no blank or duplicate rows detected.                                               
#>  7 NA_check            Passed Passed: no NA values detected in data set.                                                 
#>  8 type_check          Passed Passed: All TYPE entries found are accepted by dbGaP per submission instructions.          
#>  9 values_check        Passed Passed: all four VALUES checks look good.                                                  
#> 10 integer_check       Passed Passed: all variables listed as TYPE integer appear to be integers.                        
#> 11 decimal_check       Passed Passed: all variables listed as TYPE decimal appear to be decimals.                        
#> 12 misc_format_check   Passed Passed: no check-specific formatting issues identified.                                    
#> 13 description_check   Failed ERROR: missing and duplicate descriptions found in data dictionary.                        
#> 14 minmax_check        Passed Passed: when provided, all variables are within the MIN to MAX range.                      
#> 15 missing_value_check Failed ERROR: some variables have non-encoded missing value codes.                                
#> --------------------
#> description_check: Failed 
#> ERROR: missing and duplicate descriptions found in data dictionary. 
#> $description_check.Info
#> # A tibble: 4 × 2
#>   VARNAME  VARDESC              
#>   <chr>    <chr>                
#> 1 PREGNANT <NA>                 
#> 2 REACT    <NA>                 
#> 3 HEIGHT   Height of participant
#> 4 WEIGHT   Height of participant
#> 
#> --------------------
#> missing_value_check: Failed 
#> ERROR: some variables have non-encoded missing value codes. 
#> $missing_value_check.Info
#>     VARNAME VALUE MEANING  PASS
#> 16 CUFFSIZE -9999    <NA> FALSE
#> 
#> --------------------
```

Now we see that 13 out of 15 checks pass, but the workflow fails at
`description_check` and `missing_value_check`. Specifically, in
`description_check` we see that variables `PREGNANT` and `REACT` were
identified as having missing variable descriptions (`VARDESC`), and
variables `HEIGHT` and `WEIGHT` incorrectly have identical descriptions.
In `missing_value_check`, we see that the variable `CUFFSIZE` contains a
`-9999` encoded value that is not specified in a `VALUES` column. While
we have included functions that support “simple fixes”, the issues
identified here would need to be corrected manually in your data
dictionary before moving on.

## 5.5 Reporting

Note that we have also created reporting functions that generate
graphical and textual descriptions and awareness checks of the data in
HTML format (see `dbGaPCheckup_vignette` vignette:
`create_awareness_report` (Appendix A) and `create_report` (Appendix B)
for more details). These reports are designed to help you catch other
potential errors in your data set. Note that the `create_report`
generated is quite long however, so we recommend that you only submit
subsets of variables at a time. Specification of missing value codes are
also important for effective plotting.

    # Functions not run here as they work best when initiated interactively
    # Awareness Report (See Appendix A of the `dbGaPCheckup` vignette)
    create_awareness_report(DD.dict.updated, DS.data, non.NA.missing.codes=c(-9999, -4444),
       output.path= tempdir())
       
    # Data Report (See Appendix B of the `dbGaPCheckup` vignette)
    create_report(DD.dict.updated, DS.data, sex.split=TRUE, sex.name= "SEX",
       start = 3, end = 7, non.NA.missing.codes=c(-9999,-4444),
       output.path= tempdir(), open.html=TRUE)

More details on execution and interpretation have been provided in the
`dbGaPCheckup_vignette` vignette.

## 5.6 Labelled data

After your data dictionary is fully consistent with your data, you can
use the `label_data` function to convert your data to labelled data,
essentially embedding the data dictionary into the data for future use!

``` r
DS_labelled_data <- label_data(DD.dict.updated, DS.data, non.NA.missing.codes=c(-9999))
labelled::var_label(DS_labelled_data$SEX)
#> [1] "Sex assigned at birth"
labelled::val_labels(DS_labelled_data$SEX)
#>   male female 
#>      0      1
attributes(DS_labelled_data$SEX)
#> $labels
#>   male female 
#>      0      1 
#> 
#> $label
#> [1] "Sex assigned at birth"
#> 
#> $class
#> [1] "haven_labelled" "vctrs_vctr"     "integer"       
#> 
#> $TYPE
#> [1] "integer, encoded value"
labelled::na_values(DS_labelled_data$HX_DEPRESSION)
#> missing value 
#>         -9999
```

# 6 Contact information

If you have any questions or comments, please feel free to contact us!

Lacey W. Heinsberg: <law145@pitt.edu>  
Daniel E. Weeks: <weeks@pitt.edu>

Bug reports: <https://github.com/lwheinsberg/dbGaPCheckup/issues>

# 7 Acknowledgments

This package was developed with partial support from the National
Institutes of Health under award numbers R01HL093093, R01HL133040, and
K99HD107030. The `eval_function` and `dat_function` functions that form
the backbone of the awareness reports were inspired by an elegant 2016
homework answer submitted by Tanbin Rahman in our HUGEN 2070 course
‘Bioinformatics for Human Genetics’. We would also like to thank Nick
Moshgat for testing and providing feedback on our package during
development.
