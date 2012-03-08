#' annotatePeakInBatch.example1
#' 
#' annotate myPeakList (RangedData) with TSS.human.NCBI36 (RangedData)
#' @author Julie Zhu
#' @export
annotatePeakInBatch.example1 <- function() {
	data(myPeakList)
	data(TSS.human.NCBI36)
	annotatedPeak = annotatePeakInBatch(myPeakList[1:6,], AnnotationData=TSS.human.NCBI36)
	res <- as.data.frame(annotatedPeak)
	res
}
	
#' annotatePeakInBatch.example2
#' 
#' you have a list of transcription factor biding sites from literature and
#' are interested in determining the extent of the overlap to the list of peaks from 
#' your experiment. Prior calling the function annotatePeakInBatch, need to represent
#' both dataset as RangedData where start is the start of the binding site, end is 
#' the end of the binding site, names is the name of the binding site, 
#' space and strand are the chromosome name and strand where the binding site is located.
#' @author Julie Zhu
#' @export
annotatePeakInBatch.example2 <- function() {
	myexp = RangedData(
		IRanges(start=c(1543200,1557200,1563000,1569800,167889600,100,1000),
			    end=c(1555199,1560599,1565199,1573799,167893599,200,1200),
				names=c("p1","p2","p3","p4","p5","p6", "p7")
		),
		strand=as.integer(1),
		space=c(6,6,6,6,5,4,4)
	)
	literature = RangedData(
		IRanges(
			start=c(1549800,1554400,1565000,1569400,167888600,120,800),
			end=c(1550599,1560799,1565399,1571199,167888999,140,1400),
			names=c("f1","f2","f3","f4","f5","f6","f7")
		),
		strand=c(1,1,1,1,1,-1,-1),
		space=c(6,6,6,6,5,4,4)
	)
	annotatedPeak1 = annotatePeakInBatch(myexp, AnnotationData = literature)
	# pie(table(as.data.frame(annotatedPeak1)$insideFeature))
	res <- as.data.frame(annotatedPeak1)
	res
}

#' annotatePeakInBatch.example3
#' @author Julie Zhu
#' @export
annotatePeakInBatch.example3 <- function() {
	### use BED2RangedData or GFF2RangedData to convert BED format or GFF format
	###  to RangedData before calling annotatePeakInBatch
	test.bed = data.frame(
		cbind(
			chrom = c("4", "6"), 
			chromStart=c("100", "1000"),
			chromEnd=c("200", "1100"), 
			name=c("peak1", "peak2")
		)
	)
	test.rangedData = BED2RangedData(test.bed)

	literature = RangedData(
		IRanges(
			start=c(1549800,1554400,1565000,1569400,167888600,120,800),
			end=c(1550599,1560799,1565399,1571199,167888999,140,1400),
			names=c("f1","f2","f3","f4","f5","f6","f7")
		),
		strand=c(1,1,1,1,1,-1,-1),
		space=c(6,6,6,6,5,4,4)
	)
	res <- as.data.frame(annotatePeakInBatch(test.rangedData, AnnotationData = literature))
	
	res
}

#' annotatePeakInBatch.example4
#' @author Julie Zhu
#' @export
annotatePeakInBatch.example4 <- function() {
	test.GFF = data.frame(
		cbind(
			seqname  = c("chr4", "chr4"), 
			source=rep("Macs", 2), 
			feature=rep("peak", 2), 
			start=c("100", "1000"), 
			end=c("200", "1100"), 
			score=c(60, 26), 
			strand=c(1, 1), 
			frame=c(".", 2), 
			group=c("peak1", "peak2")
		)
	)
	test.rangedData = GFF2RangedData(test.GFF)
	
	literature = RangedData(
		IRanges(
			start=c(1549800,1554400,1565000,1569400,167888600,120,800),
			end=c(1550599,1560799,1565399,1571199,167888999,140,1400),
			names=c("f1","f2","f3","f4","f5","f6","f7")
		),
		strand=c(1,1,1,1,1,-1,-1),
		space=c(6,6,6,6,5,4,4)
	)

	res <- as.data.frame(annotatePeakInBatch(test.rangedData, AnnotationData = literature))
	
	res
}
