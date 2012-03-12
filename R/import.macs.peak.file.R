#' import a peaks file produced by MACS
#' 
#' 2 of the most useful MACS result files are the \code{_peaks.xls} and 
#' \code{_negative_peaks.xls}. These files have slightly different formats,
#' which will differ again if you have also run \code{\link{fix.macs.output}} 
#' to 'fix' these result files.
#' 
#' @note The differences in files are:\cr
#' The \code{_peaks.xls} file has header lines, whereas \code{_negative_peaks.xls} does not.
#' Despite having the extension .xls, they can be either .tsv, or real .xls files.\cr
#' So there are 4 combinations of files: tsv or xls, and with or without header lines.
#' This function imports any of the 4 types as a \code{data.frame}.
#'
#' @note Speed\cr
#' This function is slowest if the peaks file is both XLS and contains header rows.
#' 
#' @param peaks.file The path to a single MACS peaks file. It can be either tab separated,
#' a genuine XLS file, and can contain header lines, or not.
#' @return a \code{data.frame} representation of the data rows within the MACS result
#' file
#' @author Mark Cowley, 2012-02-01
#' @export
#' @examples
#' \dontrun{
#' # import native MACS peaks files (which despite the xls extension are just tsv files)
#' macs.peaks <- import.macs.peaks.file("./DATA_peaks.xls")
#' macs.peaks <- import.macs.peaks.file("./DATA_negative_peaks.xls")
#' 
#' # fix these MACS peaks files & then import
#' macs.peaks <- fix.macs.output(".")
#' macs.peaks <- import.macs.peaks.file("./DATA_peaks.xls")
#' macs.peaks <- import.macs.peaks.file("./DATA_negative_peaks.xls")
#' }
import.macs.peaks.file <- function(peaks.file) {
	length(peaks.file) == 1 && file.exists(peaks.file) || stop("peaks.file must be the path to a single, valid file")
	if( is.excel.file(peaks.file) ) {
		peaks <- read.xls(peaks.file, check.names=FALSE)
		if( any(grepl("ARGUMENTS LIST:", peaks[,1])) ) {
			skip <- which(peaks[,1] == "name")
			peaks <- read.xls(peaks.file, skip=skip, check.names=FALSE)
		}
		peaks <- rename.column(peaks, "#NAME?", "-10*log10(pvalue)")
	}
	else if( is.tsv.file(peaks.file) ) {
		peaks.hdr <- readLines(peaks.file, 100)
		hdr.lines <- grep("^#", peaks.hdr)
		if( length(hdr.lines) == 0 ) {
			skip <- 0
			peaks.hdr <- character()
		}
		else {
			skip <- max(hdr.lines)
			peaks.hdr <- peaks.hdr[1:skip]
		}

		peaks <- read.delim(peaks.file, check.names=FALSE, skip=skip)
	}
	else {
		stop("peaks.file is neither a tsv, nor and xls file!?")
	}
	
	peaks
}
# CHANGELOG
# 2012-03-08: moved from read.xls -> xlsx::read.xlsx
# 2012-03-12: moved from xlsx::read.xlsx -> excelIO::read.xls
