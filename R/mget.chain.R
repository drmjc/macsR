#' Lookup keys in a chain of 2 environment or AnnDbBimap objects
#' 
#' Sometimes you need to chain (or JOIN) a few mapping tables together
#' in order to get the end result.
#' For example, Using the annotation.db packages, if you need to go from
#' GENESYMBOL to GENENAME, you have to go via the ENTREZGENE ID.
#' You would lookup the entrez gene ID for
#' each SYMBOL, using the org.Hs.egSYMBOL2EG AnnDbBimap, 
#' which can sometimes return \code{NA}'s. Then take
#' those Entrez Gene ID's and look them up in the org.Hs.egGENENAME
#' table. This function does the hard work for you.
#' @note this returns only the first match for each key, along each of 
#' the mapping steps, where \dQuote{first} is defined in \code{\link{mget2}}.
#' 
#' @param keys a vector of search keys which must be found in a
#' @param a an environment, or AnnDbBimap object
#' @param b an environment, or AnnDbBimap object
#' @param debug logical: if \code{TRUE}, then a 3 column \code{data.frame} is
#' returned, containing the keys, intermediate result, then final value. If 
#' \code{FALSE}, the default, return a named vector of values
#' @return For the N search keys, either return a named vector, of length N of mapped 
#' values, or a 3 column, N row \code{data.frame}, if
#' \code{debug=TRUE}. if there is no mapped value for a key, \code{NA} is 
#' returned.
#' @author Mark Cowley, 2011-09-21
#' @export
#' @examples
#' if( require(org.Hs.eg.db) ) {
#'   geneids <- c("TP53", "INS", "KRAS")
#'   mget.chain(geneids, org.Hs.egSYMBOL2EG, org.Hs.egGENENAME, FALSE)
#'   mget.chain(geneids, org.Hs.egSYMBOL2EG, org.Hs.egGENENAME, TRUE)
#' }
#' 
mget.chain <- function(keys, a, b, debug=FALSE) {
	length(intersect(keys, Rkeys(a))) > 0 || stop("none of your keys found in first env/map")
	length(intersect(Lkeys(a), Lkeys(b))) > 0 || stop("a and b are incompatible - no overlaps found")
	map <- data.frame(SearchKeys=keys, intermediate=NA, value=NA)
	map$intermediate <- mget2(keys, a, first=TRUE, na.rm=FALSE)
	
	idx <- !is.na(map$intermediate)
	a2b <- mget2(map$intermediate[idx], b, first=TRUE, na.rm=FALSE)
	map$value[idx] <- a2b
	
	if( debug ) {
		res <- map
	}
	else {
		res <- map[,3]
		names(res) <- map[,1]
	}
	
	res
}
