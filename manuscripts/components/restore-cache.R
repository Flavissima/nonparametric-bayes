#!/usr/bin/R

# restore cache file
archive <- "nonparametric-bayes-cache.tar.gz"

setwd("components")
download.file(paste0("http://two.ucdavis.edu/~cboettig/data/", archive), archive)
untar(archive)
unlink(archive)
setwd("..")


