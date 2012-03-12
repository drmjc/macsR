#' has a MACS result dir been fixed already?
#'
#' @inheritParams fix.macs.output
#' @return logical
#' @author Mark Cowley, 2012-03-08
#' @export 
is.macs.fixed <- function(dir) {
	!missing(dir) && is.dir(dir) || stop("dir must exist & should contain MACS result files")
	
	peaks.files <- dir(dir, pattern="_peaks.xls$", full=TRUE)
	(length(peaks.files) %in% c(1,2)) && all(file.exists(peaks.files)) || stop("there must be 1 or 2 peaks files within the dir")

	peaks.file <- grep("negative", peaks.files, invert=TRUE, value=TRUE)
	length(peaks.file) == 1 || stop("there must be a file ending in _peaks.xls")
	
	# peaks <- import.macs.peaks.file(peaks.file)
	# res <- "name" %in% colnames(peaks)
	res <- is.excel.file(peaks.file)
	
	res
}
