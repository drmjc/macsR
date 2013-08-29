macsR
=====

An R package for handling MACS (ChIP-Seq) result files

Description
===========
MACS (model based analysis for ChIP-Seq) is a
popular program for converting ChIP-Seq reads into
peaks. If produces a number of output files in a
directory, which to my mind can be improved a little.
This R package imports these results, can improve the
result files, and can annotate peaks with their nearest
TSS and CpG island.

Installation
============

    install.packages(c("plyr", "IRanges"))
    source("http://bioconductor.org/biocLite.R")
    biocLite(c("ChIPpeakAnno", "AnnotationDbi"))
    library(devtools)
    install_github("excelIO", "drmjc")
    install_github("mjcbase", "drmjc")
    install_github("genomics", "drmjc")

Usage
=====
Extensive package documentations is available via:

	library(macsR)
	?macsR
	
