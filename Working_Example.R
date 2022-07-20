# Title:      Troll_Extract Example
# Objective:  Working example of the Troll_Extract function
# Created by: Pia Benaud
# Created on: 2022-07-20


# Install essential package -----------------------------------------------
 # only use as needed
#install.packages("pacman")

# Import function ---------------------------------------------------------

source("Troll_Extract_Function.R")

# Baro calibration offsets ------------------------------------------------

# corrections based on calibration certificate
corrections <- tibble(location = c("PS1", "PH3", "PC5", "PM7"),
                      correction = as.numeric(c("97.00", "96.97", "96.97", "97.02")))

# might not be needed across the board, but going to keep it as input for now as we did calibrate the level sensor on deployment ::eyeroll::
# if you didn't, just use your location names and put NA as values...

# Level offsets -----------------------------------------------------------

# to do, don't currently have the data, will need to add it to final calcs when we do


# Run the function --------------------------------------------------------
 # note: Extract folders don't have to exist

Priddo_level <- Troll_Extract(Baro_folder = "Example_data/Zip/Baro", 
                              Level_folder = "Example_data/Zip/Level",
                              corrections = corrections)


# Why not plot? -----------------------------------------------------------

Priddo_level %>% 
  ggplot() +
  geom_hline(yintercept = 0, size = 0.5, colour = "gray20", linetype = "dotted") +
  geom_path(aes(x = datetime, y = level_m, group = location, colour = location)) +
  scale_colour_viridis_d()+
  labs(x = "Date Time", y = "Level (m)", colour = "Location") +
  theme_classic() +
  theme(legend.position = "top")
