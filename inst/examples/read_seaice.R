.si_standard_version_check <- function() {
  vers <- try(packageVersion("vapour"), silent = TRUE)
  if (inherits(vers, "try-error")) vers <- "0."
  if (vers < "0.5.5.9602") {
    stop("the development version of {vapour} is required, at least 0.5.5.9602

         to install please run

         remotes::install_github(\"hypertidy/vapour\")

         you might need to install.packages(\"remotes\") first ;)

         and if an earlier version of {vapour} is installed try restarting R first
         ")
  }

}



read_amsr2 <- function(date, xylim = NULL, ...) {
  .si_standard_version_check()

  ## replace with the files function doing a guess at the file names, eventually build a time-map of the tokens
  if (seaice:::.si_timedate(date) > amsr2_south_sources$date[nrow(amsr2_south_sources)]) {
    stop(glue::glue("latest available date is {amsr2_south_sources$date[nrow(amsr2_south_sources)]} atm"))
  }

  if (seaice:::.si_timedate(date) < amsr2_south_sources$date[1]) {
    stop(glue::glue("earliest available date is {amsr2_south_sources$date[1]} atm"))
  }

  if (missing(date)) {
    ## replace with lookup info about what dates there are
    date <- max(amsr2_south_sources$date)
  }
  ext <- seaice:::.si_amsr2_defaultgrid(xylim)

  vfile <- amsr2_south_vsi(date)
    prj <- ext@crs@projargs
    if (is.na(prj) || nchar(prj) == 0) stop("no valid projection metadata on 'xylim', this must be present")
    l <- vapour::vapour_warp_raster(vfile, extent = raster::extent(ext), dimension = dim(ext)[2:1],
                                         wkt = vapour::vapour_srs_wkt(raster::projection(ext)))[[1L]]

  raster::setValues(ext, l)
}



read_seaice <- function(date, xylim = NULL, ..., rescale = TRUE, hemi = c("both", "north", "south"), .local_root = NULL) {
 .si_standard_version_check()
date <- seaice:::.si_timedate(date)
    ## replace with the files function doing a guess at the file names, eventually build a time-map of the tokens
latest <- seaice:::.si_default_date()
  if (date > latest) {
    stop(sprintf("latest available date is %s atm", latest))
  }

  if (date < seaice:::.si_timedate("1978-10-26")) {
    stop("earliest available date is 1978-10-26 atm")
  }

  if (missing(date)) {
    ## replace with lookup info about what dates there are
    date <- seaice:::.si_defaultdate()
  }
  hemi <- match.arg(hemi)
  ii <- switch(hemi,
               both = 1:2, north = 2, south = 1)
  ext <- seaice:::.si_nsidc_defaultgrid(xylim)
  l <- vector("list", length(ii))
  for (i in ii) {
    if (i == 1) {
      vfile <- nsidc_south_vrt(date, .local_root = .local_root)
    } else {
      vfile <- nsidc_north_vrt(date, .local_root = .local_root)
    }
    prj <- ext@crs@projargs
    if (is.na(prj) || nchar(prj) == 0) stop("no valid projection metadata on 'xylim', this must be present")
    l[[i]] <- vapour::vapour_warp_raster(vfile, extent = raster::extent(ext), dimension = dim(ext)[2:1],
                                         wkt = vapour::vapour_srs_wkt(raster::projection(ext)))[[1L]]

  }
  if (length(ii) == 2L) {
    vals1 <- l[[1L]]
    vals2 <- l[[2L]]
    vals1[vals1 > 250 | vals1 < 1] <- NA
    vals2[vals2 > 250 | vals2 < 1] <- NA
    out <- ifelse(is.na(vals1), vals2, vals1)

  } else {
    out <- unlist(l)
  }
  if (rescale) {
    out <- seaice:::.si_rescale(out)
    out[out > 100] <- NA
    out[out < 1] <- NA
  }
  raster::setZ(raster::setValues(ext, out), date[1L])
}
