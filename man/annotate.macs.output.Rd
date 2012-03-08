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
  nothing. it writes a <prefix>_peaks_annot.xls file. To
  interpret the new columns, see
  \code{\link[ChIPpeakAnno]{annotatePeakInBatch}}
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

