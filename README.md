
<!-- README.md is generated from README.Rmd. Please edit that file -->

# seaice

<!-- badges: start -->

[![R-CMD-check](https://github.com/AustralianAntarcticDivision/seaice/workflows/R-CMD-check/badge.svg)](https://github.com/AustralianAntarcticDivision/seaice/actions)
<!-- badges: end -->

The goal of seaice is to read sea ice concentration data directly from
the internet. This package contains functions to find the right file URL
for a given date, for either northern or southern hemisphere data.

There are no read functions in the package itself, but there is example
code to use for this. See examples below. This package contains a file
list (where the file is on the internet, and the date it applies to) for
a data file, and will construct a raster format that can be used to read
the data directly. This happens via GDAL, using its virtual raster
format “VRT”. A temporary file is created to store the information about
the file at the URL, and then GDAL does the rest, downloading the file
and reading from it into whatever grid/projection we specify.

With this we can

-   read any date since 1978-10-26 (currently we are a bit limited to
    the latest but see todo)
-   specify a raster grid, of any resolution, any projection, and any
    extent any where on the planet (the polar regions are really the
    only relevant ones, but we can use the entire earth or part of it)
-   read both hemispheres in one call

## TODO

-   currently only NSIDC, add more providers
-   keep files up to date, started with 2021-05-23
-   be smarter about filling in missing days
-   write helpers for commonly used grids (e.g. 0.25 degree longlat,
    Mercator, or local equal area, etc)
-   write helpers for terra, stars, base image(), netcdf output,
    whatever
-   speed it up, currently a bit slow \#\# Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("AustralianAntarcticDivision/seaice")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(seaice)
source(system.file("examples/read_seaice.R", package = "seaice", mustWork = TRUE))
library(raster)  # we could use terra or stars or whatever, see todo 
#> Loading required package: sp
r <- raster(extent(-180, 180, -72, -55), res = 0.2, crs = "+proj=longlat")
(ice <- read_seaice("2020-10-15", xylim = r))
#> class      : RasterLayer 
#> dimensions : 85, 1800, 153000  (nrow, ncol, ncell)
#> resolution : 0.2, 0.2  (x, y)
#> extent     : -180, 180, -72, -55  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> source     : memory
#> names      : layer 
#> values     : 1.2, 100  (min, max)

icecol <- grey.colors(100)
zl <- c(1, 100)
plot(ice, col = icecol, zlim = zl)
```

<img src="man/figures/README-example-1.png" width="100%" />

Or we can pick our own projection/grid that we want.

``` r
rg <- raster(extent(-2e6, 2e6, -1e6, 1e6), res = 25000, crs = "+proj=laea +lat_0=-60 +lon_0=180")
pice <- read_seaice("2020-10-15", xylim = rg)
plot(pice, col = icecol, zlim = zl, asp = 1)

## hack a graticule
ll <- rgdal::project(coordinates(rg), projection(rg), inv = TRUE)
ll[ll[,1] < 0, 1] <- ll[ll[,1] < 0, 1] + 360
contour(setValues(rg, ll[,1]), add = TRUE)
contour(setValues(rg, ll[,2]), add = TRUE)
```

<img src="man/figures/README-projection-1.png" width="100%" />

## Code of Conduct

Please note that the seaice project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
