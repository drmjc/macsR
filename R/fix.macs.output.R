#' fix MACS result files
#' 
#' MACS (Model-based Analysis of ChIP-Seq) is a very popular program for identifying
#' peaks in ChIP-Seq data.
#' It's output is pretty good, but IMO can be improved:\cr
#' - The peaks XLS files could be a proper XLS files
#' - the -10*LOG10(pvalue) in peaks xls files is confusing, so create a proper P-value column
#' - There is no \dQuote{name} column in the peaks xls files to match up to the names in the BED files
#' - an IGV/UCSC-friendly coordinate aids following up regions
#' - useful to have BED files at various FDR thresholds.
#' It's also useful to make BED files with only the statistically significant peaks within.
#' 
#' @param dir a character(1) pointing to a directory containing MACS results
#' @param fdr.thresh an integer vector: Create 1 BED file per fdr.thresh, containing only
#' those peaks with FDR < fdr.thresh, named ...-fdr%d.xls. Note in these files FDR
#' are represented as percentages, so we suggest starting with \code{c(5, 10, 25)},
#' Set to \code{NULL} to skip this step.
#' @return Invisibly returns the positive peaks table.
#' It destructively edits some files in a MACS results directory, but does save the original
#' peaks.xls files as *peaks_original.xls
#' @author Mark Cowley, 2012-01-30
#' @export
#' @examples
#' \dontrun{
#' fix.macs.output("/path/to/macs/results")
#' fix.macs.output("/path/to/macs/results", fdr.thresh=10)
#' fix.macs.output("/path/to/macs/results", fdr.thresh=c(5,10,25))
#' peaks <- fix.macs.output("/path/to/macs/results")
#' }
fix.macs.output <- function(dir, fdr.thresh=c(5,10,15,25)) {
	!missing(dir) && is.dir(dir) || stop("dir must exist & should contain MACS result files")
	
	peaks.files <- dir(dir, pattern="_peaks.xls$", full.names=TRUE)
	(length(peaks.files) %in% c(1,2)) && all(file.exists(peaks.files)) || stop("there must be 1 or 2 peaks files within the dir")

	peaks.file <- grep("negative", peaks.files, invert=TRUE, value=TRUE)
	length(peaks.file) == 1 || stop("there must be a file ending in _peaks.xls")
	
	if( is.macs.fixed(dir) ) {
		peaks <- import.macs.peaks.file(peaks.file)
		invisible(peaks)
	}
	
	peaks <- .fix.macs.output.peaks.file(peaks.file)

	neg.peaks.file <- grep("negative", peaks.files, invert=FALSE, value=TRUE)
	if( length(neg.peaks.file) == 1 ) {
		.fix.macs.output.peaks.file(neg.peaks.file)
	}
	else {
		cat("No _negative_peaks.xls file found. Assuming you ran MACS without a control sample\n")
	}
	
	for(i in seq(along=fdr.thresh)) {
		f <- fdr.thresh[i]
		# create a BED file for a range of FDR thresholds.
		if( any(peaks$"FDR(%)" < f) ) {
			a <- subset(peaks, peaks$"FDR(%)" < f)
			a <- a[, c("chr", "start", "end", "name", "-10*log10(pvalue)")]
			a$start <- a$start - 1
			tmp.f <- sub(".xls", sprintf("-FDR%d.bed", f), peaks.file)
			write.delim(a, tmp.f, col.names=FALSE)
		}
	}
	
	invisible( peaks )
}
# CHANGELOG
# 2012-02-15: works on MACS results with/without a control reference sample.
# 2012-03-08: skips fixing if it's already been fixed.


.fix.macs.output.peaks.file <- function(peaks.file) {
	peaks <- import.macs.peaks.file(peaks.file)
	
	if( "name" %in% colnames(peaks) ) {
		cat("The presence of a 'name' column implies you have already run this function. skipping\n")
		invisible()
	}
	# the negative peaks xls file doesn't have an FDR(%) column
	isNegativePeaksFile <- ! "FDR(%)" %in% colnames(peaks)
	
	# add a name column
	prefix <- "MACS_peak"
	if( isNegativePeaksFile ) prefix <- "MACS_negative_peak"
	peaks$name <- sprintf("%s_%d", prefix, 1:nrow(peaks))
	peaks <- move.column(peaks, "name", 1)
	
	# does a FDR(%) column exist?
	if( isNegativePeaksFile )
		peaks$"FDR(%)" <- NA

	# fix the P value column from '=-10*LOG10(pvalue)' to natural scale
	peaks$P.Value <- 10^(peaks[,8]/-10)
	peaks <- peaks[order(peaks$"FDR(%)", peaks$P.Value, decreasing=FALSE), ]
	
	peaks$"IGV coordinate" <- sprintf("%s:%s-%s", peaks$chr, peaks$start, peaks$end)
	
	file.rename(peaks.file, sub("\\.xls$", "_original.xls", peaks.file))
	
	# OUT <- file(peaks.file, "w")
	# writeLines(peaks.hdr, OUT)
	# write.xls(peaks, OUT, na="")
	# close(OUT)
	write.xls(peaks, peaks.file, row.names=FALSE)
	
	invisible(peaks)
}
