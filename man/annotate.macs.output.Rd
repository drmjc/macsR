\name{annotate.macs.output}
\alias{annotate.macs.output}
\title{annotate MACS peaks using ChIPpeakAnno}
\usage{
  annotate.macs.output(dir,
    genome = c("hg19", "hg18", "mm9", "rn4"), tss = TRUE,
    cpg = TRUE)
}
\arguments{
  \item{dir}{the path to a MACS peaks.annot directory}

  \item{genome}{one of \sQuote{hg18}, or \sQuote{hg19}}

  \item{tss}{logical: if \code{TRUE}, then annotate peaks
  with the nearest TSS}

  \item{cpg}{logical: if \code{TRUE}, then annotate peaks
  with the nearest CpG islands}
}
\value{
  nothing. it writes a <prefix>_peaks_annot.xls file. There
  are a block of columns for the nearest TSS, and a block
  for CpG islands. To interpret the new columns, see
  \code{\link[ChIPpeakAnno]{annotatePeakInBatch}}. These
  columns include:\cr \item{Ensembl ID}{The Ensembl Gene ID
  of the nearest TSS} \item{GeneSymbol}{The GeneSymbol
  assigned to the ENSG} \item{start_position}{start
  position of the feature: TSS or CpG}
  \item{end_position}{end position of the feature: TSS or
  CpG} \item{strand}{1 or + for positive strand and -1 or -
  for negative strand where the feature is located}
  \item{insideFeature}{One of these keywords:\cr \describe{
  \item{upstream}{peak resides upstream of the feature}
  \item{downstream}{peak resides downstream of the feature}
  \item{inside}{peak resides inside the feature}
  \item{overlapStart}{peak overlaps with the start of the
  feature} \item{overlapEnd}{peak overlaps with the end of
  the feature} \item{includeFeature}{peak include the
  feature entirely} } } \item{distancetoFeature}{distance
  to the nearest feature.  By default, the distance is
  calculated as the distance between the start of the
  binding site and the TSS that is the gene start for genes
  located on the forward strand and the gene end for genes
  located on the reverse strand.}
  \item{shortestDistance}{The shortest distance from either
  end of peak to either end the feature}
  \item{fromOverlappingOrNearest}{One of these keywords:\cr
  \emph{NearestStart}: indicates this feature's start
  (feature's end for features at minus strand) is closest
  to the peak start; \emph{Overlapping}: indicates this
  feature overlaps with this peak although it is not the
  nearest feature start }
}
\description{
  This compares the BED regions from running MACS to the
  nearest ENSEMBL Gene, and to CpG islands. This uses
  \code{\link[ChIPpeakAnno]{annotatePeakInBatch}} from
  ChIPpeakAnno, which has a very loose definition of close,
  ie within 0.5Mb.
}
\details{
  This uses pre-built CpG island definitions downloaded
  from UCSC.
}
\examples{
\dontrun{
dir <- "./MACS/TAMR.H3k4Me3.vs.MCF7.H3k4Me3/"
annotate.macs.output(dir, "hg19")
}
}
\author{
  Mark Cowley, 2012-03-01
}

