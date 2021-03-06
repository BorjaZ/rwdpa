#' WDPA API: countries
#'
#' @export
#' @param country_code (character) ISO3 country code ID
#' @param geojson (logical) If `TRUE` returns the GeoJSON representation of the
#' geometry of the protected areas. Default: `FALSE`
#' @param page (integer) page to retrieve. Default: 1
#' @param per_page (character) results to retrieve per page. Default: 25
#' @param token (character) token. see [rwdpa] for help on tokens
#' @param ... curl options passed on to [crul::HttpClient]
#' @details This function uses the Protected Planet API
#' @references <https://api.protectedplanet.net/documentation>
#' @examples \dontrun{
#' wdpa_api_countries(per_page = 1)
#' (x <- wdpa_api_countries(per_page = 1, geojson = TRUE))
#' x$geojson
#' wdpa_api_countries()
#' wdpa_api_countries(per_page = 3, page = 2)
#' wdpa_api_countries(country_code = 'BEN')
#' wdpa_api_countries(country_code = 'BEN', geojson = TRUE)
#' }
wdpa_api_countries <- function(country_code = NULL, geojson = FALSE, page = 1,
  per_page = 25, token = NULL, ...) {

  res <- wdpa_api_countries_(country_code, geojson, page, per_page, token, ...)
  res$raise_for_status()
  if (is.null(country_code)) {
    jsonlite::fromJSON(res$parse("UTF-8"))$countries
  } else {
    jsonlite::fromJSON(res$parse("UTF-8"))$country
  }
}

wdpa_api_countries_ <- function(country_code = NULL, geojson = FALSE, page = 1,
  per_page = 25, token = NULL, ...) {

  assert(country_code, 'character')
  assert(geojson, 'logical')
  assert(page, c('integer', 'numeric'))
  assert(per_page, c('integer', 'numeric'))
  if (!is.null(country_code)) {
    path <- file.path("v3/countries", country_code)
    args <- cpt(list(with_geometry = tolower(geojson)))
  } else {
    path <- "v3/countries"
    args <- cpt(list(with_geometry = tolower(geojson), page = page,
      per_page = per_page))
  }
  args$token <- check_key(token)
  wdpaGET2(path, args, ...)
}
