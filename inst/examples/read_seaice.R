read_seaice <- function(date, xylim = NULL, ..., hemi = c("both", "north", "south")) {

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
    ## replace with the files function doing a guess at the file names, eventually build a time-map of the tokens
  if (date > seaice:::.si_timedate("2021-05-23")) {
    stop("latest available date is 2021-05-23 atm")
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
  ext <- seaice:::.si_defaultgrid(xylim)
  l <- vector("list", length(ii))
  for (i in ii) {
    if (i == 1) {
      vfile <- nsidc_south_vrt(date)
    } else {
      vfile <- nsidc_north_vrt(date)
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
  raster::setValues(ext, seaice:::.si_rescale(out))
}
