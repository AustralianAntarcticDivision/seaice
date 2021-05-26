.si_timedate <- function(x) {
  as.POSIXct(x, tz = "UTC")
}
.si_defaultdate <- function(x) {
  .si_timedate("2020-04-01")
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
