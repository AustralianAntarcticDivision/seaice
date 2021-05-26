## code to prepare `DATASET` dataset goes here

#nsidc_south_files <- raadfiles::nsidc_daily_files()
nsidc_south_files <- raadtools::icefiles()
fulldates <- seq(min(nsidc_south_files$date), max(nsidc_south_files$date), by = "1 day")

ftp <- sprintf("ftp://sidads%s", gsub(".*sidads", "", nsidc_south_files$fullname))
idx <- findInterval(as.integer(fulldates), as.integer(nsidc_south_files$date))
nsidc_south_files <- tibble::tibble(date = fulldates, url = ftp[idx], miss = duplicated(idx))

usethis::use_data(nsidc_south_files, overwrite = TRUE)
