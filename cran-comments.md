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
   
This is a resubmission after CRAN feedback

* If there are references describing the methods in your package, please 
add these in the description field of your DESCRIPTION file in the form
authors (year) <doi:...>
authors (year) <arXiv:...>
authors (year, ISBN:...)
or if those are not available: <https:...>
with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for 
auto-linking. (If you want to add a title as well please put it in 
quotes: "Title")

* Please add \value to .Rd files regarding exported methods and explain 
the functions results in the documentation. Please write about the 
structure of the output (class) and also what the output means. (If a 
function does not return a value, please document that too, e.g. 
\value{No return value, called for side effects} or similar)
Missing Rd-tags:
      dat_function.Rd: \value
      dat_function_selected.Rd: \value
      dictionary_search.Rd: \value
      dup_values.Rd: \value
      eval_function.Rd: \value
      int_check.Rd: \value

* \dontrun{} should only be used if the example really cannot be executed 
(e.g. because of missing additional software, missing API keys, ...) by 
the user. That's why wrapping examples in \dontrun{} adds the comment 
("# Not run:") as a warning for the user. Does not seem necessary. 
Please replace \dontrun with \donttest.

Please unwrap the examples if they are executable in < 5 sec, or replace 
dontrun{} with \donttest{}.

  Resolution: Replaced \dontrun{} with \donttest{} as suggested.
  
## Downstream dependencies

First submission - no downstream dependencies. 