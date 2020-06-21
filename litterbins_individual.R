## For use with litterbin_locations.R

gg_all_bins <- ggmap(Melbourne) +
  geom_point(data = litter_bins,
             aes(x = longitude,
                 y = latitude,
                 colour = bin_type),
             size = 1.5) +
  scale_colour_manual("", values = c("purple", "grey33")) +
  theme_void() +
  labs(title = "City of Melbourne Litter Bin Locations",
       caption = "data: https://data.melbourne.vic.gov.au/City-Council/Street-furniture-including-bollards-bicycle-rails-/8fgn-5q6t") +
  theme(legend.position = "bottom")

ggsave("All bins map.png",
       gg_all_bins,
       width = 200,
       height = 200,
       units = "mm",
       dpi = 400)

gg_recycling_bins <- ggmap(Melbourne) +
  geom_point(data = filter(litter_bins,
                           bin_type == "Recycling Litter Bin"),
             aes(x = longitude,
                 y = latitude,
                 colour = bin_type),
             size = 1.5) +
  scale_color_manual("", values = "purple") +
  labs(title = "City of Melbourne Recycling Litter Bin Locations",
       caption = "data: https://data.melbourne.vic.gov.au/City-Council/Street-furniture-including-bollards-bicycle-rails-/8fgn-5q6t") +
  theme_void() +
  theme(legend.position = "bottom")

ggsave("Recycling bins map.png",
       gg_recycling_bins,
       width = 200,
       height = 200,
       units = "mm",
       dpi = 400)
