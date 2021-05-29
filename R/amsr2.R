#' Files for sea ice concentration (3.125km)
#'
#' Artist AMSR2 near-real-time 3.125km sea ice concentration
#'
#' Near-real-time passive microwave estimates of daily sea ice concentration at 3.125km spatial resolution (full Antarctic coverage).
#'
#' Time series has been expanded to be daily, by infilling a date for any missing,
#' with this indicated on the `miss` column.
#'
#' @return data frame of `date` and `url` and `miss` which is `TRUE` if infilled
#' @export
#' @importFrom tibble tibble
#' @examples
#' amsr2_south_files()
amsr2_south_files <- function() {
  files <- amsr2_south_sources
  fulldates <- seq(min(files$date), max(files$date), by = "1 day")
  idx <- findInterval(as.integer(fulldates), as.integer(files$date))
  tibble::tibble(date = fulldates, url = files$url[idx], miss = duplicated(idx))
}


#' Generate amsr2 source links from a date
#'
#' Artist AMSR2 near-real-time 3.125km sea ice concentration
#'
#' Details
#' @param date date-time, date, or convertible character string
#'
#' @return url
#' @export
#' @examples
#' amsr2_south_url("2010-01-01")
amsr2_south_url <- function(date) {
  if (missing(date)) date <- .si_default_date()
  date <- .si_timedate(date)
  files <- amsr2_south_files()
  files$url[findInterval(date, files$date)]
}


#' Generate AMSR VSI path
#'
#' NSIDC
#'
#' Details
#' @param date date-time, date, or convertible character string
#'
#' @return VRT text, used by GDAL
#' @export
#' @importFrom glue glue
#' @examples
#' amsr2_south_vsi("2010-01-01")
amsr2_south_vsi <- function(date) {
  if (missing(date)) date <- .si_default_date()

  date <- .si_timedate(date)

  VSI <- glue::glue("/vsicurl/{amsr2_south_url(date)}")
  VSI
}





