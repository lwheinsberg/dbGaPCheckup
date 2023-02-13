## dbGaPCheckup version 1.0.2

- remove row numbers from data set files 
- rename data dictionary files by removing "SSM" acronym (done to avoid confusion as this means “subject sample mapping” and is intended for use with other dbGaP data files)
- updated id_check() to include a check for missing SUBJECT_IDs (not allowed by dbGaP)
- update row_check() to check for duplicate and empty rows in the data dictionary (and not just the data set)
- update misc_format_check() to check that there are no missing VARNAME cells

## dbGaPCheckup version 1.0.1 

- apply na_if() to one column at a time (vs. entire data frame at once) to maintain compatibility with next version of dplyr

## dbGaPCheckup version 1.0.0

### NEWS.md setup 

- added NEWS.md

