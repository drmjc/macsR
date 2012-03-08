#' annotate MACS peaks using ChIPpeakAnno
#' 
#' This compares the BED regions from running MACS to the nearest ENSEMBL
#' Gene, and to CpG islands. This uses \code{\link[ChIPpeakAnno]{annotatePeakInBatch}}
#' from ChIPpeakAnno, which has a very loose definition of close, ie
#' within 0.5Mb.
#' 
#' This uses pre-built CpG island definitions downloaded from UCSC.
#'
#' @param dir the path to a MACS peaks.annot directory
#' @param genome one of \sQuote{hg18}, or \sQuote{hg19}
#' @param tss logical: if \code{TRUE}, then annotate peaks with the nearest TSS
#' @param cpg logical: if \code{TRUE}, then annotate peaks with the nearest CpG islands
#' @return nothing. it writes a <prefix>_peaks_annot.xls file. To interpret
#' the new columns, see \code{\link[ChIPpeakAnno]{annotatePeakInBatch}}
#' @author Mark Cowley, 2012-03-01
#' @importFrom ChIPpeakAnno BED2RangedData annotatePeakInBatch
#' @importFrom plyr join
#' @importMethodsFrom IRanges as.data.frame
#' @export
#' @examples
#' \dontrun{
#' dir <- "./MACS/TAMR.H3k4Me3.vs.MCF7.H3k4Me3/"
#' annotate.macs.output(dir, "hg19")
#' }
annotate.macs.output <- function(dir, genome=c("hg19", "hg18", "mm9", "rn4"), tss=TRUE, cpg=TRUE) {
	length(dir) == 1 && is.dir(dir) || stop("dir must be the path to a macs peaks.annot directory.")
	dir <- get.full.path(dir)
	SUPPORTED.GENOMES <- c("hg19", "hg18")
	genome <- genome[1]
	genome %in% SUPPORTED.GENOMES || stop("genome is unsupported.")
	################################################################################
	saf <- getOption("stringsAsFactors")
	on.exit(options(stringsAsFactors=saf))
	options(stringsAsFactors=FALSE)
	################################################################################

	################################################################################
	# which genome?
	annoData <- switch(genome,
		hg19={data(TSS.human.GRCh37);  TSS.human.GRCh37},
		hg18={data(TSS.human.NCBI36);  TSS.human.NCBI36},
		 mm9={data(TSS.mouse.NCBIM37); TSS.mouse.NCBIM37},
		 rn4={data(TSS.rat.RGSC3.4);   TSS.rat.RGSC3.4},
		stop("unsupported genome")
	)
	cpgData <- switch(genome,
		hg19={data(CpG.human.GRCh37);  CpG.human.GRCh37},
		hg18={data(CpG.human.NCBI36);  CpG.human.NCBI36},
		 mm9={data(CpG.mouse.NCBIM37); CpG.mouse.NCBIM37},
		 rn4={data(CpG.rat.RGSC3.4);   CpG.rat.RGSC3.4},
		stop("unsupported genome")
	)
	################################################################################
	
	################################################################################
	# setup the input/output file paths
	# bed.file <- "TAMR.vs.MCF7.MBD2_peaks.bed"
	bed.file <- dir(dir, pattern="_peaks.bed", full=TRUE)
	bed.file <- grep("_negative_peaks.bed", bed.file, invert=TRUE, value=TRUE)
	cat("peaks file:", bed.file, "\n")
	(length(bed.file) == 1) || stop("bed.file must exist")

	# macs.peaks.file <- "TAMR.vs.MCF7.MBD2_peaks.xls"
	macs.peaks.file <- dir(dir, pattern="_peaks.xls", full=TRUE)
	macs.peaks.file <- grep("_negative_peaks.xls", macs.peaks.file, invert=TRUE, value=TRUE)
	(length(macs.peaks.file) == 1) || stop("macs.peaks.file must exist")

	peaks.annot.file <- sub("_peaks.xls", "_peaks_annot.xlsx", macs.peaks.file)
	################################################################################
	
	################################################################################
	# import peaks
	peaks.bed <- read.delim(bed.file, header=FALSE)
	# head(peaks.bed)

	peaks.RangedData <- BED2RangedData(peaks.bed, FALSE)
	# peaks.RangedData
	################################################################################
	
	#
	# import peaks & join to closest gene and CpG island
	# 
	peaks.annot <- import.macs.peaks.file(macs.peaks.file)
	
	################################################################################
	message("Annotating peaks to nearest ENSG TSS...")
	if( tss ) {
		peaks.annot.tss <- annotatePeakInBatch(peaks.RangedData, AnnotationData = annoData, output="both", multiple=TRUE, maxgap=0)
		message("done")
		#  user  system elapsed 
		# 75.06    1.56   77.13
	
		peaks.annot.tss <- as.data.frame(peaks.annot.tss)
		peaks.annot.tss <- peaks.annot.tss[,-match(c("space", "start", "end", "width", "names"), colnames(peaks.annot.tss))]
		library(org.Hs.eg.db)
		peaks.annot.tss$GeneSymbol <- mget.chain(as.character(peaks.annot.tss$feature), org.Hs.egENSEMBL2EG, org.Hs.egSYMBOL)
		peaks.annot.tss <- rename.column(peaks.annot.tss, "feature", "Ensembl ID")
		peaks.annot.tss <- rename.column(peaks.annot.tss, "peak", "name")
		peaks.annot.tss <- move.column(peaks.annot.tss, "strand", "insideFeature")
		peaks.annot.tss <- move.column(peaks.annot.tss, "GeneSymbol", "start_position")

		peaks.annot <- plyr::join(peaks.annot, peaks.annot.tss, by="name", type="full")
	}
	else {
		message("skipping")
	}
	################################################################################
	
	################################################################################
	message("Annotating peaks to nearest CpG...")
	if( cpg ) {
		peaks.annot.cpg <- annotatePeakInBatch(peaks.RangedData, AnnotationData = cpgData, output="both", multiple=T, maxgap=0)
		message("done")

		peaks.annot.cpg <- as.data.frame(peaks.annot.cpg)
		peaks.annot.cpg <- peaks.annot.cpg[,-match(c("space", "start", "end", "width", "names"), colnames(peaks.annot.cpg))]
		library(org.Hs.eg.db)
		peaks.annot.cpg <- rename.column(peaks.annot.cpg, "feature", "CpG island")
		peaks.annot.cpg <- rename.column(peaks.annot.cpg, "peak", "name")
		peaks.annot.cpg <- move.column(peaks.annot.cpg, "strand", "insideFeature")
		
		peaks.annot <- plyr::join(peaks.annot, peaks.annot.cpg, by="name", type="full")
	}
	else {
		message("skipping")
	}
	################################################################################
	
	################################################################################
	# @TODO
	# allow custom bed files to be imported & use this code to facilitate the import:
	# custom.bed <- read.delim(custom.bed.file, skip=1, header=F)
	# # head(custom.bed)
	# #     V2     V3     V4       V5
	# # 1 chr1  28735  29810 CpG: 116
	# # 2 chr1 135124 135563  CpG: 30
	# custom.RangedData <- BED2RangedData(custom.bed, FALSE)
	################################################################################
	
	message("Writing xlsx to: ", peaks.annot.file, "...")
	write.xlsx(peaks.annot, peaks.annot.file, row.names=FALSE)	
	message("done")
}
