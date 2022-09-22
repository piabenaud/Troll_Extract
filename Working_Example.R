# Title:      Troll_Extract Example
# Objective:  Working example of the Troll_Extract function
# Created by: Pia Benaud
# Created on: 2022-07-20


# Install essential package -----------------------------------------------
 # only use as needed
#install.packages("pacman")

# Import functions --------------------------------------------------------

source("Troll_Functions.R")


# Extract and baro correct ------------------------------------------------

Priddo_level <- Troll_Extract(Baro_folder = "Example_data/Zip/Baro", 
                              Level_folder = "Example_data/Zip/Level",
                              corrections_csv = "Example_data/priddo_corrections.csv")


# Calculate WTD -----------------------------------------------------------

Priddo_WTD <- Calc_WTD(the_data = Priddo_level,
                       corrections_csv = "Example_data/priddo_corrections.csv")


# Why not plot? -----------------------------------------------------------

Priddo_WTD %>% 
  ggplot() +
  geom_hline(yintercept = 0, size = 0.5, colour = "gray20", linetype = "dotted") +
  geom_line(aes(x = datetime, y = WTD_m, group = location, colour = location)) +
  scale_colour_viridis_d()+
  scale_y_reverse() + # y axis reversed to help with realistic visualisation
  labs(x = "Date Time", y = "Water Table Depth (m)", colour = "Location") +
  theme_classic() +
  theme(legend.position = "top")
