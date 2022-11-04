## R CMD check 

We checked our package 'as-cran' using the following versions of R:

* platform: aarch64-apple-darwin20 (64-bit)
* R version 4.2.1 (2022-06-23) 

and 

* platform: x86_64-w64-mingw32 (64-bit)
* R Under development (unstable) (2022-10-11 r83083 ucrt)

There was only one 'New submission' note:

0 ERRORs | 0 WARNINGs | 1 NOTE

* New submission

  This is the first submission of this R package.
  
Using check_rhub(), we also checked our package on the following versions of R:

* platform: linux-x86_64-fedora-clang
* R version 4.2.2 (2022-10-31) -- "Innocent and Trusting"

and 

* linux-x86_64-ubuntu-gcc
* R version 4.2.2 (2022-10-31) -- "Innocent and Trusting"

There are three NOTEs specific to linux platforms:

* New submission

  This is the first submission of this R package.

* Possibly misspelled words in DESCRIPTION:
  dbGaP (3:8, 10:205)
  Phenotypes (10:193)
  
  These words are not misspelled. 
  
* checking examples ... [27s/96s] NOTE
Examples with CPU (user + system) or elapsed time > 5s
                     user system elapsed
value_missing_table 5.262  0.004  18.939
label_data          4.536  0.004  16.756
complete_check      3.277  0.012  11.960
check_report        2.375  0.008   8.746

   Timing was not an issue on several other test machines. 
  
## Downstream dependencies

First submission - no downstream dependencies. 