\name{is.tsv.file}
\alias{is.tsv.file}
\title{is the file a tab separated text file?}
\usage{
  is.tsv.file(path)
}
\arguments{
  \item{path}{a character vector: the path(s) to file(s)
  which must exist}
}
\value{
  a named logical vector of length(path), where names are
  the paths, and values are \code{TRUE} if the path is an
  excel file, \code{FALSE} otherwise.
}
\description{
  Rather than just checking the file extension, this
  function checks whether the contents of the file contain
  tabs. The file paths must exist, they must be ASCII test,
  and must have at least one tab in one of the lines to
  qualify.
}
\note{
  We could make this more stringent by requiring that all
  lines contain the same number of tabs, but need to
  consider how to skip header lines, and column name lines
  which can contain NCOL-1 columns (if written using
  write.table)
}
\examples{
\dontrun{
is.tsv.file("./tmp.xls")
is.tsv.file("./tmp.tsv")
is.tsv.file("./tmp.csv")
is.tsv.file(c("./tmp.xls", "./tmp.tsv", "./tmp.csv"))
}
}
\author{
  Mark Cowley, 2012-02-01
}

