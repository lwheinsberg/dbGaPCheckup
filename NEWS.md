## dbGaP version 1.2.0

- New function `duplicated_id_check()` checks for duplicated subject IDs in the data set (returns a warning, as this is allowed in longitudinal studies)
- New function `ascii_check()` scans both the data dictionary and data set for (1) non-ASCII characters (e.g., é, ñ) and (2) newline (\n) and carriage return (\r) characters
- New helper ascii_cleaner() cleans a data frame by (1) converting smart quotes to straight quotes, replacing accented characters with ASCII equivalents, removing newline and carriage return characters
- complete_check(): updated to include both duplicated_id_check() and ascii_check()
- values_check(): updated Check 1 to require each VALUES cell contain exactly one equals sign (=) (e.g., 1=Yes vs. 1=Yes; 0=No), in alignment with dbGaP formatting requirements
- misc_format_check(): now prevents errors when the VALUES column is the last column in the data dictionary (i.e., no columns follow) - this does return a WARNING, however, as this structure is valid but expected to be uncommon
- integer_check(): resolved a rare error when the TYPE column contains malformed or unexpected values
- Documentation: Updated to emphasize the importance of reading CSVs using readr::read_csv(..., na = c("", "NA")) or read.csv(..., na.strings = c("", "NA")) to correctly interpret missing cells, particularly in the VALUES column. (See GitHub Issue #16 for discussion)

## dbGaP version 1.1.1

- minmax_check: adjusted  to return a sorted list of out of range values and polished documentation to be more informative
- values_check: corrected bug in code that was not detecting leading/trailing zeros in VALUES columns
- name_correct: when a user runs name_correct when it is not needed a new message informing them of no discrepancies detected will print

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

