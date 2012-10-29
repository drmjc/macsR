\name{mget.chain}
\alias{mget.chain}
\title{Lookup keys in a chain of 2 environment or AnnDbBimap objects}
\usage{
  mget.chain(keys, a, b, debug = FALSE)
}
\arguments{
  \item{keys}{a vector of search keys which must be found
  in a}

  \item{a}{an environment, or AnnDbBimap object}

  \item{b}{an environment, or AnnDbBimap object}

  \item{debug}{logical: if \code{TRUE}, then a 3 column
  \code{data.frame} is returned, containing the keys,
  intermediate result, then final value. If \code{FALSE},
  the default, return a named vector of values}
}
\value{
  For the N search keys, either return a named vector, of
  length N of mapped values, or a 3 column, N row
  \code{data.frame}, if \code{debug=TRUE}. if there is no
  mapped value for a key, \code{NA} is returned.
}
\description{
  Sometimes you need to chain (or JOIN) a few mapping
  tables together in order to get the end result. For
  example, Using the annotation.db packages, if you need to
  go from GENESYMBOL to GENENAME, you have to go via the
  ENTREZGENE ID. You would lookup the entrez gene ID for
  each SYMBOL, using the org.Hs.egSYMBOL2EG AnnDbBimap,
  which can sometimes return \code{NA}'s. Then take those
  Entrez Gene ID's and look them up in the
  org.Hs.egGENENAME table. This function does the hard work
  for you.
}
\note{
  this returns only the first match for each key, along
  each of the mapping steps, where \dQuote{first} is
  defined in \code{\link{mget2}}.
}
\examples{
if( require(org.Hs.eg.db) ) {
  geneids <- c("TP53", "INS", "KRAS")
  mget.chain(geneids, org.Hs.egSYMBOL2EG, org.Hs.egGENENAME, FALSE)
  mget.chain(geneids, org.Hs.egSYMBOL2EG, org.Hs.egGENENAME, TRUE)
}
}
\author{
  Mark Cowley, 2011-09-21
}

