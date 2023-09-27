## dbGaP version 1.1.0 

- added an informative error message when the required VALUES column is missing
- adjusted values_check to temporarily create dummy names for blank-named columns beyond VALUES to prevent function from dying if column names after VALUES are blank strings
- corrected minmax_check and integer_check bugs that occurred when SUBJECT_ID was a character vector
- adjusted misc_format_check to return a WARNING that alerts users if they read in a data set and R automatically fills in column names after VALUES (which is allowed by the package, but not dbGaP itself)
- adjusted NA_check to correctly capture NA=N/A VALUES
- corrected bug in type_check that was allowing some non-allowable TYPE entries to pass 
- corrected but in missing_value_check that was flagging some variables even when they had properly encoded NA=N/A VALUES
- made complete_check more robust to errors by wrapping functions in tryCatch
- used seealso to link utility functions to relevant check functions 

## dbGaPCheckup version 1.0.2

- removed row numbers from data set files 
- renamed data dictionary files by removing "SSM" acronym (done to avoid confusion as this means “subject sample mapping” and is intended for use with other dbGaP data files)
- updated id_check() to include a check for missing SUBJECT_IDs (not allowed by dbGaP)
- updated row_check() to check for duplicate and empty rows in the data dictionary (and not just the data set)
- updated misc_format_check() to check that there are no missing VARNAME cells

## dbGaPCheckup version 1.0.1 

- apply na_if() to one column at a time (vs. entire data frame at once) to maintain compatibility with next version of dplyr

## dbGaPCheckup version 1.0.0

### NEWS.md setup 

- added NEWS.md

