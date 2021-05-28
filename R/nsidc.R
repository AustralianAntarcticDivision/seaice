#' Files for each hemisphere sea ice concentration (25km)
#'
#' NSIDC passive microwave sea ice concentration since 1978.
#'
#' Time series has been expanded to be daily, by infilling a date for any missing,
#' with this indicated on the `miss` column.
#'
#' @return data frame of `date` and `url` and `miss` which is `TRUE` if infilled
#' @export
#' @aliases nsidc_north_files
#' @importFrom tibble tibble
#' @examples
#' nsidc_south_files()
#' nsidc_north_files()
nsidc_south_files <- function() {
  files <- nsidc_south_sources
  fulldates <- seq(min(files$date), max(files$date), by = "1 day")
  idx <- findInterval(as.integer(fulldates), as.integer(files$date))
  tibble::tibble(date = fulldates, url = files$url[idx], miss = duplicated(idx))
}

#' @name nsidc_south_files
#' @export
nsidc_north_files <- function() {
  files <- nsidc_north_sources
  fulldates <- seq(min(files$date), max(files$date), by = "1 day")
  idx <- findInterval(as.integer(fulldates), as.integer(files$date))
  tibble::tibble(date = fulldates, url = files$url[idx], miss = duplicated(idx))
}

#' Generate NSIDC source links from a date
#'
#' NSIDC
#'
#' Details
#' @param date date-time, date, or convertible character string
#'
#' @return FTP url of NSIDC binary file
#' @export
#' @aliases north_nsidc_ftp
#' @examples
#' south_nsidc_ftp("2010-01-01")
#' north_nsidc_ftp("2010-01-01")
south_nsidc_ftp <- function(date) {
  date <- .si_timedate(date)
  files <- nsidc_south_files()
  files$url[findInterval(date, files$date)]
}

#' @export
#' @name south_nsidc_ftp
north_nsidc_ftp <- function(date) {
  date <- .si_timedate(date)
  files <- nsidc_north_files()

  files$url[findInterval(date, files$date)]
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
#' @aliases north_nsidc_text
#' @importFrom glue glue
#' @examples
#' south_nsidc_vrt_text("2010-01-01")
#' north_nsidc_vrt_text("2010-01-01")
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

#' @export
#' @name south_nsidc_vrt_text
north_nsidc_vrt_text <- function(date) {
  date <- .si_timedate(date)

  FTP <- glue::glue("/vsicurl/{north_nsidc_ftp(date)}")
  glue::glue('<VRTDataset rasterXSize="304" rasterYSize="448">
  <VRTRasterBand dataType="Byte" band="1" subClass="VRTRawRasterBand">
    <SourceFilename relativetoVRT="1">{FTP}</SourceFilename>
    <ImageOffset>300</ImageOffset>
    <PixelOffset>1</PixelOffset>
    <LineOffset>304</LineOffset>
  </VRTRasterBand>
  <SRS>
  PROJCRS[\"WGS 84 / NSIDC Sea Ice Polar Stereographic North\",\n    BASEGEOGCRS[\"WGS 84\",\n        DATUM[\"World Geodetic System 1984\",\n            ELLIPSOID[\"WGS 84\",6378137,298.257223563,\n                LENGTHUNIT[\"metre\",1]]],\n        PRIMEM[\"Greenwich\",0,\n            ANGLEUNIT[\"degree\",0.0174532925199433]],\n        ID[\"EPSG\",4326]],\n    CONVERSION[\"US NSIDC Sea Ice polar stereographic north\",\n        METHOD[\"Polar Stereographic (variant B)\",\n            ID[\"EPSG\",9829]],\n        PARAMETER[\"Latitude of standard parallel\",70,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8832]],\n        PARAMETER[\"Longitude of origin\",-45,\n            ANGLEUNIT[\"degree\",0.0174532925199433],\n            ID[\"EPSG\",8833]],\n        PARAMETER[\"False easting\",0,\n            LENGTHUNIT[\"metre\",1],\n            ID[\"EPSG\",8806]],\n        PARAMETER[\"False northing\",0,\n            LENGTHUNIT[\"metre\",1],\n            ID[\"EPSG\",8807]]],\n    CS[Cartesian,2],\n        AXIS[\"easting (X)\",south,\n            MERIDIAN[45,\n                ANGLEUNIT[\"degree\",0.0174532925199433]],\n            ORDER[1],\n            LENGTHUNIT[\"metre\",1]],\n        AXIS[\"northing (Y)\",south,\n            MERIDIAN[135,\n                ANGLEUNIT[\"degree\",0.0174532925199433]],\n            ORDER[2],\n            LENGTHUNIT[\"metre\",1]],\n    USAGE[\n        SCOPE[\"Polar research.\"],\n        AREA[\"Northern hemisphere - north of 60N onshore and offshore, including Arctic.\"],\n        BBOX[60,-180,90,180]],\n    ID[\"EPSG\",3413]]
  </SRS>
    <GeoTransform> -3.8375000000000000e+06,  2.5000000000000000e+04,  0.0000000000000000e+00,  5.8375000000000000e+06,  0.0000000000000000e+00, -2.5000000000000000e+04</GeoTransform>

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
#' @aliases north_nsidc_vrt
#' @examples
#' south_nsidc_vrt("2010-01-01")
#' north_nsidc_vrt("2010-01-01")
south_nsidc_vrt <- function(date) {
  date <- .si_timedate(date)

  tfile <- tempfile(fileext = ".vrt")
  writeLines(south_nsidc_vrt_text(date), tfile)
  tfile
}

#' @export
#' @name south_nsidc_vrt
north_nsidc_vrt <- function(date) {
  date <- .si_timedate(date)

  tfile <- tempfile(fileext = ".vrt")
  writeLines(north_nsidc_vrt_text(date), tfile)
  tfile
}
