r <- raster::raster()

vfile <- south_nsidc_vrt(as.Date("1978-10-26"))


ex <- c(-180, 180, -90, 90)
dm <- c(360, 180)
library(vapour)
v <- vapour_warp_raster(vfile, extent = ex, dimension = dm,
                        wkt = vapour_srs_wkt("+proj=longlat"))


