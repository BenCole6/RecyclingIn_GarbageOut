library(pacman)
p_load(tidyverse,
       lubridate,
       plotly,
       readxl,
       ggplot2,
       ggmap)

Furniture_Melb <- read_csv("../Melb_public_furniture.csv")

Recycling_bins <- filter(Furniture_Melb,
                         str_detect(DESCRIPTION,
                                    regex("recycling", ignore_case = TRUE)))

Other_bins <- filter(Furniture_Melb,
                     !str_detect(DESCRIPTION,
                                 regex("recycling", ignore_case = TRUE)),
                     str_detect(DESCRIPTION,
                                regex("bin", ignore_case = TRUE)))


litter_bins <- filter(Furniture_Melb,
                      str_detect(DESCRIPTION,
                                 regex("bin", ignore_case = TRUE)))

coordinates <- str_split(litter_bins,
                         pattern = ", ",
                         n = 2)

litter_bins <- mutate(litter_bins,
                      CoordinateLocation = str_remove_all(CoordinateLocation,
                                                          pattern = "\\(|\\)"),
                      latitude = as.numeric(str_split_fixed(CoordinateLocation,
                                                            ", ", 2)[1]),       
                      longitude = as.numeric(str_split_fixed(CoordinateLocation,
                                                             ", ", 2)[2]),
                      bin_type = if_else(str_detect(DESCRIPTION,
                                                    regex("recycling", ignore_case = TRUE)),
                                         true = "Recycling Litter Bin",
                                         false = "Waste Litter Bin"))

min_lat <- min(litter_bins$latitude)*0.99
min_lon <- min(litter_bins$longitude)*0.99

max_lat <- max(litter_bins$latitude)*1.01
max_lon <- max(litter_bins$longitude)*1.01

Melbourne <- get_stamenmap(bbox = c(left = min_lon, bottom = min_lat,
                                    max_lon = 144.982785, max_lat = -37.796165),
                           zoom = 15, crop = FALSE)

ggmap(Melbourne) +
  geom_point(data = litter_bins,
             aes(x = longitude,
                 y = latitude),
             size = 4)
