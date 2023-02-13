## R CMD check 

We checked our package 'as-cran' using the following versions of R:

* platform: aarch64-apple-darwin20 (64-bit)
* R version 4.2.1 (2022-06-23) 

and 

* platform: x86_64-w64-mingw32 (64-bit)
* R Under development (unstable) (2023-02-13 r83816 ucrt)

0 ERRORs | 0 WARNINGs | 0 NOTEs

Using check_rhub(), we also checked our package on the following versions of R:

* platform: linux-x86_64-fedora-clang
* R version 4.2.2 (2022-10-31) -- "Innocent and Trusting"

and 

* linux-x86_64-ubuntu-gcc
* R version 4.2.2 (2022-10-31) -- "Innocent and Trusting"

There was one NOTE specific to both linux platforms:

* checking examples ... [28s/108s] NOTE
Examples with CPU (user + system) or elapsed time > 5s
                     user system elapsed
value_missing_table 5.262  0.004  18.939
label_data          4.536  0.004  16.756
complete_check      3.277  0.012  11.960
check_report        2.375  0.008   8.746

  Timing was not an issue on several other test machines. 
  
And one NOTE specific to only the Fedora linux platform:

* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found

  As described [here](https://groups.google.com/g/r-sig-mac/c/7u_ivEj4zhM?pli=1), our understanding is that this is an old bug/issue which is located at the testing           environment.

## Downstream dependencies

revdep check results show no downstream dependencies. 
