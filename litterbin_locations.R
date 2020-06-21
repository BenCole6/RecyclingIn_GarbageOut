library(pacman)
p_load(tidyverse,
       lubridate,
       plotly,
       readxl,
       ggplot2,
       ggmap,
       gridExtra)

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

litter_bins <- mutate(litter_bins,
                      CoordinateLocation = str_remove_all(CoordinateLocation,
                                                          pattern = "\\(|\\)"),
                      bin_type = if_else(str_detect(DESCRIPTION,
                                                    regex("recycling", ignore_case = TRUE)),
                                         true = "Recycling Litter Bin",
                                         false = "Waste Litter Bin"))

bin_coordinates <- str_split_fixed(litter_bins$CoordinateLocation,
                                   pattern = ", ",
                                   n = 2)

litter_bins <- cbind(litter_bins, bin_coordinates)

litter_bins <- rename(litter_bins,
                      latitude = `1`,
                      longitude = `2` )

litter_bins <- mutate(litter_bins,
                      latitude = as.double(latitude),
                      longitude = as.double(longitude))

min_lat <- min(litter_bins$latitude) - 0.005
min_lon <- min(litter_bins$longitude) - 0.005

max_lat <- max(litter_bins$latitude) + 0.005
max_lon <- max(litter_bins$longitude) + 0.005

Melbourne <- get_stamenmap(bbox = c(left = min_lon, bottom = min_lat,
                                    right = max_lon, top = max_lat),
                           zoom = 14)

gg_all_bins <- ggmap(Melbourne) +
  geom_point(data = litter_bins,
             aes(x = longitude,
                 y = latitude,
                 colour = bin_type),
             size = 1.5) +
  scale_colour_manual("", values = c("purple", "grey33")) +
  theme_void() +
  theme(legend.position = "bottom")

gg_recycling_bins <- ggmap(Melbourne) +
  geom_point(data = filter(litter_bins,
                           bin_type == "Recycling Litter Bin"),
             aes(x = longitude,
                 y = latitude,
                 colour = bin_type),
             size = 1.5) +
  scale_color_manual("", values = "purple") +
  theme_void() +
  theme(legend.position = "bottom")

litter_bins_grid <- grid.arrange(gg_all_bins, gg_recycling_bins,
                                 nrow = 1,
                                 top = "Litter Bin Locations, Melbourne City Council\n")

ggsave("Litter bins map.png",
       litter_bins_grid,
       width = 400,
       height = 225,
       units = "mm",
       dpi = 400)
