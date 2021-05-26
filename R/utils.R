globalVariables("nsidc_south_files")

.si_rescale <- function(x) {
  x[x > 250] <- NA
  x / 2.5
}
.si_timedate <- function(x) {
  as.POSIXct(x, tz = "UTC")
}
.si_defaultdate <- function(x) {
  max(nsidc_south_files$date)
}
.si_defaultgrid <- function(x) {

  if (missing(x) || is.null(x)) {
    return(raster::raster(raster::extent(-180, 180, -90, 90), res = 0.25, crs = "OGC:CRS84"))
  }
  if (inherits(x, "RasterLayer")) {
      return(x)
    } else {
      ext <- raster::raster(x, res = 0.25, crs = "OGC:CRS84")
      if (is.na(raster::projection(ext))) {
        ext <- raster::projection(ext) <- "+proj=longlat +datum=WGS84"
      }
    }



  ext
}
