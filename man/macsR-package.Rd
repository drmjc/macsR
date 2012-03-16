\docType{package}
\name{macsR-package}
\alias{macsR}
\alias{macsR-package}
\title{Facilitate analysis of MACS results}
\description{
  MACS (model based analysis for ChIP-Seq) is a popular
  program for converting ChIP-Seq reads into peaks. If
  produces a number of output files in a directory, which
  to my mind can be improved a little. This package imports
  MACS results, improves the result files, and annotates
  peaks with their nearest TSS and CpG island.
}
\details{
  \code{\link{import.macs.peaks.file}} is used to import
  MACS results.

  \code{\link{fix.macs.output}} is used to \sQuote{fix} or
  improve the usability of MACS results, particularly for
  the end user who wants to get genomic coordinates in
  UCSC-style strings, and get BED files of just the
  significant peaks.

  \code{\link{annotate.macs.output}} is used to annotate
  peaks by their closest TSS or CpG island. This uses
  ChIPpeakAnno, and pre-built TSS and CpG-island
  definitions, the former are from Ensembl, and the latter
  are from UCSC.
}
\section{MACS version}{
  This package expects macs14 to be installed.
}

\section{MACS installation on OSX 10.7.3}{
  \cr Download the tar.gz:
  \url{https://github.com/downloads/taoliu/MACS/MACS-1.4.1.tar.gz}\cr
  unpack & install to home dir:\cr \code{$ python setup.py
  install --user}\cr copy binaries from \code{./bin} to
  \code{~/bin/macs14} & make executable\cr Edit
  \code{$HOME/.bashrc} file:\cr \code{export
  PATH=$PATH:~/bin/macs14}\cr \code{export
  PYTHONPATH=~/Library/Python/2.7/lib/python/site-packages:$PYTHONPATH}
}

\section{MACS installation on Ubuntu}{
  Download & install the Debian package:
  \url{http://liulab.dfci.harvard.edu/MACS/Download.html}
}
\author{
  Mark Cowley <m.cowley@garvan.org.au>
}
\references{
  \url{http://liulab.dfci.harvard.edu/MACS/}
}
\seealso{
  \code{\link{import.macs.peaks.file}},
  \code{\link{fix.macs.output}},
  \code{\link{annotate.macs.output}}
}
\keyword{package}

