#' Full text search of Elasticsearch
#'
#' @export
#' @name Search
#' @template search_par
#' @template search_egs
#' @param body Query, either a list or json.
#' @param scroll (character) Specify how long a consistent view of the index 
#' should be maintained for scrolled search, e.g., "30s", "1m". See 
#' \code{\link{units-time}}.
#' @param search_path (character) The path to use for searching. Default 
#' to \code{_search}, but in some cases you may already have that in the base 
#' url set using \code{\link{connect}}, in which case you can set this 
#' to \code{NULL}
#' @seealso  \code{\link{Search_uri}} \code{\link{Search_template}} 
#' \code{\link{scroll}} \code{\link{count}} \code{\link{validate}}

Search <- function(index=NULL, type=NULL, q=NULL, df=NULL, analyzer=NULL, default_operator=NULL,
  explain=NULL, source=NULL, fields=NULL, sort=NULL, track_scores=NULL, timeout=NULL,
  terminate_after=NULL, from=NULL, size=NULL, search_type=NULL, lowercase_expanded_terms=NULL,
  analyze_wildcard=NULL, version=FALSE, lenient=FALSE, body=list(), raw=FALSE, asdf=FALSE, scroll=NULL,
  search_path="_search", ...) {

  search_POST(search_path, cl(index), type,
    args = ec(list(df = df, analyzer = analyzer, default_operator = default_operator, 
      explain = explain, `_source` = source, fields = cl(fields), sort = cl(sort), 
      track_scores = track_scores, timeout = cn(timeout), 
      terminate_after = cn(terminate_after), from = cn(from), size = cn(size), 
      search_type = search_type, lowercase_expanded_terms = lowercase_expanded_terms, 
      analyze_wildcard = analyze_wildcard, version = as_log(version), q = q, 
      scroll = scroll, lenient = as_log(lenient))), body, raw, asdf, ...)
}

search_POST <- function(path, index=NULL, type=NULL, args, body, raw, asdf, ...) {
  if (!inherits(raw, "logical")) {
    stop("'raw' parameter must be `TRUE` or `FALSE`", call. = FALSE)
  }
  if (!inherits(asdf, "logical")) {
    stop("'asdf' parameter must be `TRUE` or `FALSE`", call. = FALSE)
  }
  checkconn(...)
  conn <- es_get_auth()
  url <- make_url(conn)
  url <- construct_url(url, path, index, type)
  url <- prune_trailing_slash(url)
  body <- check_inputs(body)
  tt <- POST(url, make_up(), es_env$headers, ..., query = args, body = body)
  geterror(tt)
  res <- cont_utf8(tt)
  if (raw) res else jsonlite::fromJSON(res, asdf)
}
