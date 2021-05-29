amsr2_south_sources <- dplyr::transmute(raadfiles::amsr2_3k_daily_files(),

                                     date, url = sprintf("https://seaice%s", gsub(".*seaice", "", fullname)))

usethis::use_data(amsr2_south_sources, overwrite = TRUE)
