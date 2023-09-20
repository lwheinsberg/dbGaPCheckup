## R CMD check 

We checked our package 'as-cran' using the following versions of R:

* platform: aarch64-apple-darwin20 (64-bit)
* R version 4.2.1 (2022-06-23) 

0 ERRORs | 0 WARNINGs | 0 NOTEs

and 

* platform: x86_64-w64-mingw32 (64-bit)
* R Under development (unstable) (2023-02-13 r83816 ucrt)

0 ERRORs | 0 WARNINGs | 1 NOTEs

There was one NOTE using the Windows platform:

* R Under development (unstable) (2023-09-19 r85177 ucrt)



Using check_rhub(), we also checked our package on the following versions of R:

* platform: linux-x86_64-fedora-clang
* R Under development (unstable) (2023-06-09 r84528) -- "Unsuffered Consequences"

and 

* linux-x86_64-ubuntu-gcc
* R version 4.3.0 (2023-04-21) -- "Already Tomorrow"

0 ERRORs | 0 WARNINGs | 1 NOTEs

* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found

  As described [here](https://groups.google.com/g/r-sig-mac/c/7u_ivEj4zhM?pli=1), our understanding is that this is an old bug/issue which is located at the testing environment.

## Downstream dependencies

revdep check results show no downstream dependencies. 
