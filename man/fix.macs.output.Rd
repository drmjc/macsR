\name{fix.macs.output}
\alias{fix.macs.output}
\title{fix MACS result files}
\usage{
  fix.macs.output(dir, fdr.thresh = c(5, 10, 15, 25))
}
\arguments{
  \item{dir}{a character(1) pointing to a directory
  containing MACS results}

  \item{fdr.thresh}{an integer vector: Create 1 BED file
  per fdr.thresh, containing only those peaks with FDR <
  fdr.thresh, named ...-fdr\%d.xls. Note in these files FDR
  are represented as percentages, so we suggest starting
  with \code{c(5, 10, 25)}, Set to \code{NULL} to skip this
  step.}
}
\value{
  Invisibly returns the positive peaks table. It
  destructively edits some files in a MACS results
  directory, but does save the original peaks.xls files as
  *peaks_original.xls
}
\description{
  MACS (Model-based Analysis of ChIP-Seq) is a very popular
  program for identifying peaks in ChIP-Seq data. It's
  output is pretty good, but IMO can be improved:\cr - The
  peaks XLS files could be a proper XLS files - the
  -10*LOG10(pvalue) in peaks xls files is confusing, so
  create a proper P-value column - There is no
  \dQuote{name} column in the peaks xls files to match up
  to the names in the BED files - an IGV/UCSC-friendly
  coordinate aids following up regions - useful to have BED
  files at various FDR thresholds. It's also useful to make
  BED files with only the statistically significant peaks
  within.
}
\examples{
\dontrun{
fix.macs.output("/path/to/macs/results")
fix.macs.output("/path/to/macs/results", fdr.thresh=10)
fix.macs.output("/path/to/macs/results", fdr.thresh=c(5,10,25))
peaks <- fix.macs.output("/path/to/macs/results")
}
}
\author{
  Mark Cowley, 2012-01-30
}

