#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL

#' Files for NSIDC sea ice concentration
#'
#' The file list is cached to avoid determining the exact file name ... we
#' might come up with a better solution. The available dates are also padded
#' out to allow the last valid date to stand in for a missing one.
#' @docType data
#' @aliases nsidc_north_sources
#' @format data frame of `date` and `url`
"nsidc_south_sources"


#' Files for AMSR2 sea ice concentration
#'
#' The file list is cached to avoid determining the exact file name ... we
#' might come up with a better solution. The available dates are also padded
#' out to allow the last valid date to stand in for a missing one.
#' @docType data
#' @format data frame of `date` and `url`
"amsr2_south_sources"
