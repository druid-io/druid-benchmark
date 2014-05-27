#!/bin/sh

# install R on ubuntu (http://cran.r-project.org/bin/linux/ubuntu/README)
sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu precise/" >> /etc/apt/sources.list      
sudo apt-get update
# fix for missing curl-config issue
sudo apt-get install r-base-core libcurl4-gnutls-dev librtmp-dev

