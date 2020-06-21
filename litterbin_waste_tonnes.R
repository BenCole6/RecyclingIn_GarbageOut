library(pacman)
p_load(tidyverse,
       lubridate,
       plotly,
       readxl,
       ggplot2,
       ggmap,
       gridExtra,
       forecast)

Melb_Waste <- read_csv("../Waste_collected_per_month.csv")

Melb_Waste$date <- str_remove(Melb_Waste$date,
                              pattern = " 12:00:00 AM")

Melb_Waste$date <- mdy(Melb_Waste$date)

Melb_Waste <- arrange(Melb_Waste,
                      date)


ggplot(Melb_Waste,
       aes(x = date,
           y = public_litter_bins)) +
  geom_smooth() +
  geom_line(size = 1) +
  labs(title = "Waste Collected from Melbourne City Litter Bins",
       x = "Date",
       y = "Tonnes of Waste") +
  theme_minimal()
