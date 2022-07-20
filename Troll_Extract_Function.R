
# Title:      Function to Extract and Baro Correct Troll Data
# Objective:  Extract barometrically correct data from trolls
# Created by: Pia Benaud
# Created on: 2022-07-20


# Load packages -----------------------------------------------------------

pacman::p_load(tidyverse, lubridate, rvest, janitor)


# The function ------------------------------------------------------------
Troll_Extract <- function(Baro_folder, Level_folder, corrections){

  # Make full file paths ----------------------------------------------------
 
  Baro_paths <- list.files(Baro_folder, pattern = ".zip", full.names = TRUE) # list all of the file names
  Level_paths <- list.files(Level_folder, pattern = ".zip", full.names = TRUE) 
  
  
  # Read in the html tables -------------------------------------------------
  
  get_table <- function(file_path) {
    read_html(file_path) %>% 
      html_elements("table") %>% 
      html_table() %>% 
      .[[1]] %>% 
      as_tibble() 
  }
  
  Baro_raw <- map(Baro_paths, ~get_table(.)) 
  
  Level_raw <- map(Level_paths, ~get_table(.))
  
  
  # Name the data -----------------------------------------------------------
  
  get_name <- function(the_data){  # pull out location name
    the_data %>% 
      slice(2) %>% # row containing location name
      pull(1) %>% # pull out into 'value/string'
      str_sub(., start = 17) # removes "Location Name = "
  }
  
  names(Baro_raw) <- map(Baro_raw, ~get_name(.))
  
  names(Level_raw) <- map(Level_raw, ~get_name(.))
  
  
  # Trim to actual data -----------------------------------------------------
  
  data_trim <- function(the_data){
    the_data %>% 
      slice(24:n()) %>% 
      row_to_names(., 1) %>% 
      clean_names(.) %>% 
      rename_with(., .cols = !1, ~str_sub(., end=-8)) %>%  # remove serial number off end - alternative could be to base this all on the serial number?
      select(1:3) %>%  # dropping level off the level trolls as it isn't correct/useful
      mutate(date_time = ymd_hms(date_time)) %>% 
      mutate(across(.cols = 2:3, as.numeric))
  }
  
  Baro_data <- map(Baro_raw, ~data_trim(.))
  Level_data <- map(Level_raw, ~data_trim(.))
  
  #### NEED to have a look and see that the decimal places are being stored!!!! 
  
  
  # Make continuous 15 min col ----------------------------------------------
  
  round_15 <- function(the_data){
    the_data %>% 
      split(., names(.)) %>% # these two rows are pulling together list elements with the same name
      map(bind_rows) %>% 
      map(., ~arrange(., date_time)) %>% 
      map(., ~distinct(., date_time, .keep_all = TRUE)) %>% 
      map(., ~mutate(., datetime_15 = round_date(date_time, unit = "15 minutes"), .after = 1))
  }
  
  Baro_data <- round_15(Baro_data)
  Level_data <- round_15(Level_data)
  
  
  make_cont <- function(the_data){
    first_dt <- round_date(min(the_data$date_time), unit = "15 minutes")
    last_dt <- round_date(max(the_data$date_time), unit = "15 minutes")
    cont <- tibble(continuous_15 = seq(from = first_dt, to = last_dt, by = "15 min"))
    out <- full_join(the_data, cont, by = c("datetime_15" = "continuous_15"))
  }
  
  Baro_data <- map(Baro_data, ~make_cont(.))
  Level_data <- map(Level_data, ~make_cont(.))
  
  
  # Gap fill missing pressure data ------------------------------------------
  
  # for both baro and level
  # to do... we don't have any gaps yet
  # make filled baro col - if na average based on x measurements - sliding scale??
  
  
  # Do barometric level corrections! ----------------------------------------
  
  # need to do location fill
  get_level <- function(Baro_data, Level_data){
    
    temp_baro <- Baro_data %>% 
      bind_rows(.id = "location")
    
    temp_level <- Level_data %>% 
      bind_rows(.id = "location")
    
    temp_level <- left_join(temp_level, corrections, by = "location")
    
    out <- left_join(temp_level, temp_baro, by = "datetime_15") %>% 
      mutate(level = ((pressure_k_pa + correction) - barometric_pressure_k_pa) * 0.1019) %>% #conversion factor for m/kpa
      transmute(datetime = date_time.x, # datetime of the level sensor
                location = location.x, # location id
                level_m = level,
                air_temp_c = temperature_c.y, # baro temp
                sensor_temp_c = temperature_c.x)
    
  }
  
  the_output <- get_level(Baro_data, Level_data)
  
  # to do - apply level offset!
  
}





