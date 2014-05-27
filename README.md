Druid Benchmark
===============

Code for our benchmarking blog post:
[http://druid.io/blog/2014/03/17/benchmarking-druid.html](http://druid.io/blog/2014/03/17/benchmarking-druid.html)


Prerequisites
=============

- R (http://www.r-project.org/)
Installation Steps
  - install R on ubuntu (http://cran.r-project.org/bin/linux/ubuntu/README)
      sudo vi /etc/apt/sources.list
      deb http://cran.rstudio.com/bin/linux/ubuntu precise/
      sudo apt-get update
      sudo apt-get install r-base-core
  - fix missing curl-config issue
      sudo apt-get install libcurl4-gnutls-dev librtmp-dev
  - install devtools/RDruid/microbenchmark
      install.packages("devtools")
      devtools::install_github("RDruid", "metamx")
      install.packages("microbenchmark")

Add new tests
=============

Add tests under testcases, the f/w will execute all the cases mentioned in the test sequentially.
