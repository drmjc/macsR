\name{writeLines.xls}
\alias{writeLines.xls}
\title{Write a vector out to an xls file.}
\usage{
  writeLines.xls(x, file, names = TRUE)
}
\arguments{
  \item{x}{a vector}

  \item{file}{the path to an output file}

  \item{names}{logical: if \code{TRUE}, then write out a 2
  column table of names then value, if \code{FALSE}, then
  write out just the values in \code{x}.}
}
\value{
  nothing.
}
\description{
  Write a vector out to an xls file. If the vector has
  names, then optionally write out a two column xls file
  with names in 1st col, data in 2nd. See the help for
  \code{\link{write.xls}} for the configuration required.
}
\author{
  Mark Cowley, 2009-02-03
}
\seealso{
  \code{\link{write.xls}}
}

