\name{mget2}
\alias{mget2}
\title{enhanced mget}
\usage{
  mget2(x, y, sort = TRUE, first = TRUE, na.rm = TRUE)
}
\arguments{
  \item{x}{a vector of keys, \code{NA}'s allowed.}

  \item{y}{an env, or AnnDbBimap, or ProbeAnnDbBimap}

  \item{sort}{logical: if \code{TRUE}, then sort the values
  for each key}

  \item{first}{logical: if \code{TRUE}, then choose the
  first value for each key, after the optional sort}

  \item{na.rm}{logical: remove those keys that had no
  matches? if \code{TRUE}, a vector with no \code{NA}'s
  will be returned. if \code{FALSE}, then return a list of
  key to value maps, possibly with \code{NA}'s.}
}
\value{
  either a vector or list of values, depending on the value
  of \code{na.rm}.
}
\description{
  Enchanced mget to look up x in y. Changes in addition to
  \code{\link{mget}} include:\cr * Values can be sorted
  alphanumerically\cr * Since some keys have multiple
  values, this function returns all, or just the first
  (hint; use \code{first=TRUE, sort=TRUE}), assuming that
  the first is the oldest. \cr * keys in \code{x} are
  allowed to be \code{NA} (hint: \code{na.rm=FALSE})
}
\section{TODO}{
  provide more sorting options to choose the newest.
}
\examples{
if( require(org.Hs.eg.db) ) {
  sym <- c("TP53", "INS", "EGFR", "MET", NA)
  mget2(sym, org.Hs.egSYMBOL2EG)
  mget2(sym, org.Hs.egSYMBOL2EG, na.rm=FALSE)
}
}
\author{
  Mark Cowley, 2011-08-25
}

