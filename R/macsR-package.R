#' Facilitate analysis of MACS results
#' 
#' MACS (model based analysis for ChIP-Seq) is a popular program for converting
#' ChIP-Seq reads into peaks. If produces a number of output files in a
#' directory, which to my mind can be improved a little. This package imports
#' MACS results, improves the result files, and annotates peaks with their
#' nearest TSS and CpG island.
#' 
#' \code{\link{import.macs.peaks.file}} is used to import MACS results.
#' 
#' \code{\link{fix.macs.output}} is used to \sQuote{fix} or improve the
#' usability of MACS results, particularly for the end user who wants to get
#' genomic coordinates in UCSC-style strings, and get BED files of just the
#' significant peaks.
#' 
#' \code{\link{annotate.macs.output}} is used to annotate peaks by their
#' closest TSS or CpG island. This uses ChIPpeakAnno, and pre-built TSS and
#' CpG-island definitions, the former are from Ensembl, and the latter are from
#' UCSC.
#' 
#' \tabular{ll}{ 
#' Package: \tab macsR\cr
#' Type: \tab Package\cr
#' Version: \tab 1.0\cr
#' Date: \tab 2012-03-05\cr
#' License: \tab GPL2\cr
#' LazyLoad: \tab yes\cr
#' }
#' 
#' @name macsR-package
#' @aliases macsR macsR-package
#' @docType package
#' @author Mark Cowley <m.cowley@@garvan.org.au>
#' @seealso \code{\link{import.macs.peaks.file}}, \code{\link{fix.macs.output}},
#'   \code{\link{annotate.macs.output}}
#' @references \url{http://liulab.dfci.harvard.edu/MACS/}
#' @keywords package
NULL
