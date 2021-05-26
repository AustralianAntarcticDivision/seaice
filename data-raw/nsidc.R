## code to prepare `DATASET` dataset goes here

#nsidc_south_files <- raadfiles::nsidc_daily_files()
nsidc_south_sources <- dplyr::transmute(raadtools::icefiles(hemisphere = "south"),
                                     date, url = sprintf("ftp://sidads%s", gsub(".*sidads", "", fullname)))

nsidc_north_sources <- dplyr::transmute(raadtools::icefiles(hemisphere = "north"),
                                        date, url = sprintf("ftp://sidads%s", gsub(".*sidads", "", fullname)))


usethis::use_data(nsidc_south_sources, overwrite = TRUE)
usethis::use_data(nsidc_north_sources, overwrite = TRUE)
