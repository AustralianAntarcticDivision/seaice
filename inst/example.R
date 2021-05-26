





read_seaice <- function(date, xylim = NULL) {
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
  ext <- seaice:::.si_defaultgrid(xylim)
  vfile <- south_nsidc_vrt(date)
  v <- vapour::vapour_warp_raster(vfile, extent = raster::extent(ext), dimension = dim(ext)[2:1],
                          wkt = vapour_srs_wkt(raster::projection(ext)))

  raster::setValues(ext, seaice:::.si_rescale(unlist(v)))
}

par(mfrow = c(2, 1))
d1 <- read_seaice("2020-10-01", raster(extent(100, 180, -70, -60),res = 0.2,  crs = "+proj=longlat"))
plot(d1, zlim = c(0.1, 100), col = grey.colors(64))
d2 <- read_seaice("2021-01-01", raster(extent(100, 180, -70, -60),res = 0.2,  crs = "+proj=longlat"))
plot(d2, zlim = c(0.1, 100), col = grey.colors(64))

















.icebreaks <- c(2, 47, 62, 77, 92.5625, 104, 116, 123.984375, 132, 138, 144,
                150, 155, 159.828125, 164, 168, 172, 175, 178, 180, 182, 185,
                187, 189, 191, 193, 195, 196, 198, 199, 200, 202, 203, 205, 206,
                207, 208, 209, 211, 212, 213, 214, 215, 216, 217.1875, 219, 220,
                221, 222, 223, 224, 225, 226, 227, 229, 230, 232, 233, 234, 236,
                238, 239, 242, 245, 250)

im <- function(x, extent, dm, ..., col = grey.colors(64), breaks = .icebreaks, asp = 1) {
  xx <- seq(extent[1], extent[2], length.out = dm[1])
  yy <- seq(extent[3], extent[4], length.out = dm[2])

  image(xx, yy, matrix(x[[1]], dm[1])[,dm[2]:1], asp = asp, col = col, breaks = breaks, ...)
}


date <- "2010-01-04"


ex <- c(-180, 180, -90, 90)
dm <- c(64, 64)
crs <- "+proj=longlat"


b <- 1e6
ex <- c(-b, b, -b, b)
crs <- "+proj=eqc +lat_0=-60"
library(vapour)
dates <- seq(as.Date("2002-01-01"), by = "15 days", length = 20)
for (i in seq_along(dates)) {
  date <- dates[i]
  vfile <- south_nsidc_vrt(as.Date(date))

  v <- vapour_warp_raster(vfile, extent = ex, dimension = dm,
                        wkt = vapour_srs_wkt(crs))
 im(v, ex, dm, main = format(date, "%Y-%m-%d"))

}



