\name{import.macs.peaks.file}
\alias{import.macs.peaks.file}
\title{import a peaks file produced by MACS}
\usage{
  import.macs.peaks.file(peaks.file)
}
\arguments{
  \item{peaks.file}{The path to a single MACS peaks file.
  It can be either tab separated, a genuine XLS file, and
  can contain header lines, or not.}
}
\value{
  a \code{data.frame} representation of the data rows
  within the MACS result file
}
\description{
  2 of the most useful MACS result files are the
  \code{_peaks.xls} and \code{_negative_peaks.xls}. These
  files have slightly different formats, which will differ
  again if you have also run \code{\link{fix.macs.output}}
  to 'fix' these result files.
}
\note{
  The differences in files are:\cr The \code{_peaks.xls}
  file has header lines, whereas \code{_negative_peaks.xls}
  does not. Despite having the extension .xls, they can be
  either .tsv, or real .xls files.\cr So there are 4
  combinations of files: tsv or xls, and with or without
  header lines. This function imports any of the 4 types as
  a \code{data.frame}.

  Speed\cr This function is slowest if the peaks file is
  both XLS and contains header rows.
}
\examples{
\dontrun{
# import native MACS peaks files (which despite the xls extension are just tsv files)
macs.peaks <- import.macs.peaks.file("./DATA_peaks.xls")
macs.peaks <- import.macs.peaks.file("./DATA_negative_peaks.xls")

# fix these MACS peaks files & then import
macs.peaks <- fix.macs.output(".")
macs.peaks <- import.macs.peaks.file("./DATA_peaks.xls")
macs.peaks <- import.macs.peaks.file("./DATA_negative_peaks.xls")
}
}
\author{
  Mark Cowley, 2012-02-01
}

