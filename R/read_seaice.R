


#' Generate NSIDC source links from a date
#'
#' NSIDC
#'
#' Details
#' @param date date-time, date, or convertible character string
#'
#' @return FTP url of NSIDC binary file
#' @export
#'
#' @examples
#' south_nsidc_ftp("2010-01-01")
south_nsidc_ftp <- function(date) {
  date <- .si_timedate(date)

  nsidc_south_files$url[findInterval(date, nsidc_south_files$date)]
}

#' Generate NSIDC Virtual Raster text from a date
#'
#' NSIDC
#'
#' Details
#' @param date date-time, date, or convertible character string
#'
#' @return VRT text, used by GDAL
#' @export
#'
#' @examples
#' south_nsidc_vrt_text("2010-01-01")
south_nsidc_vrt_text <- function(date) {
  date <- .si_timedate(date)

  FTP <- glue::glue("/vsicurl/{south_nsidc_ftp(date)}")
  glue::glue(
    '<VRTDataset rasterXSize="316" rasterYSize="332">
  <VRTRasterBand dataType="Byte" band="1" subClass="VRTRawRasterBand">
    <SourceFilename relativetoVRT="1">{FTP}</SourceFilename>
    <ImageOffset>300</ImageOffset>
    <PixelOffset>1</PixelOffset>
    <LineOffset>316</LineOffset>
  </VRTRasterBand>
  <SRS>PROJCRS[\"WGS 84 / NSIDC Sea Ice Polar Stereographic South\",\n    BASEGEOGCRS[\"WGS 84\",\n        DATUM[\"World Geodetic System 1984\",\n            ELLIPSOID[\"WGS 84\",6378137,298.257223563,\n                LENGTHUNIT[\"metre\",1]]],\n        PRIMEM[\"Greenwich\",0,\n            ANGLEUNIT[\"degree\",0.0174532925199433]],\n        ID[\"EPSG\",4326]],\n    CONVERSION[\"US NSIDC Sea Ice polar stereographic south\",\n        METHOD[\"Polar Stereographic (variant B)\",\n            ID[\"EPSG\",9829]],\n        PARAMETER[\"Latitude of standard parallel\",-70,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8832]],\n        PARAMETER[\"Longitude of origin\",0,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8833]],\n        PARAMETER[\"False easting\",0,\n            LENGTHUNIT[\"metre\",1],\n            ID[\"EPSG\",8806]],\n        PARAMETER[\"False northing\",0,\n            LENGTHUNIT[\"metre\",1],\n            ID[\"EPSG\",8807]]],\n    CS[Cartesian,2],\n        AXIS[\"easting (X)\",north,\n            MERIDIAN[90,\n                ANGLEUNIT[\"degree\",0.0174532925199433]],\n            ORDER[1],\n            LENGTHUNIT[\"metre\",1]],\n        AXIS[\"northing (Y)\",north,\n            MERIDIAN[0,\n                ANGLEUNIT[\"degree\",0.0174532925199433]],\n            ORDER[2],\n            LENGTHUNIT[\"metre\",1]],\n    USAGE[\n        SCOPE[\"Polar research.\"],\n        AREA[\"Southern hemisphere - south of 60S onshore and offshore - Antarctica.\"],\n        BBOX[-90,-180,-60,180]],\n    ID[\"EPSG\",3976]]</SRS>
  <GeoTransform> -3.9500000000000000e+06,  2.5000000000000000e+04,  0.0000000000000000e+00,  4.3500000000000000e+06,  0.0000000000000000e+00, -2.5000000000000000e+04</GeoTransform>
</VRTDataset>'
  )
}
#' Generate NSIDC filename
#'
#' Temp file contains text of Virtual Raster
#'
#' Details
#' @param date date-time, date, or convertible character string
#'
#' @return VRT tempfile, to be used by GDAL
#' @export
#'
#' @examples
#' south_nsidc_vrt("2010-01-01")
south_nsidc_vrt <- function(date) {
  date <- .si_timedate(date)

  tfile <- tempfile(fileext = ".vrt")
  writeLines(south_nsidc_vrt_text(date), tfile)
  tfile
}
