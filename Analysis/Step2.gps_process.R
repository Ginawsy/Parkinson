library(dplyr)
library(ggplot2)
library(scales)
library(grid)

get_notifications <- FALSE
if (get_notifications) {
  library(RPushbullet)
  options(error = function() {
    pbPost("note", "Error!", geterrmessage(), recipients = c(1, 2))
  })
}

data_dir <- "./Data"

rms <- function(x, y, z) {
  sqrt((x^2 + y^2 + z^2)/3)
}

for (i in 1:14) {
  load(file = file.path(data_dir, paste0("gps", i, ".Rdata")))
  df_gps<- gps %>%
    mutate(latitude = as.numeric(latitude),
           longitude = as.numeric(longitude),
           altitude = as.numeric(altitude),
           daytime_orig = as.character(time),
           daytime = as.POSIXct(daytime_orig, format = "%Y-%m-%d %X"),
           day = sapply(daytime_orig, function(x) strsplit(x, " ")[[1]][1]),
           time_char = sapply(daytime_orig, function(x) strsplit(x, " ")[[1]][2]),
           time = as.POSIXct(time_char, format = "%H:%M:%S"),
           hour = as.numeric(sapply(time_char, function(x) strsplit(x, ":")[[1]][1])),
           minute = as.numeric(sapply(time_char, function(x) strsplit(x, ":")[[1]][2])))%>%
    select(-daytime_orig, -time_char)
  
  df_gps_minute <- df_gps %>%
    group_by(daytime, day, time, hour, minute, PK, person) %>%
    reframe(latitude = mean(latitude),
              longitude = mean(longitude),
              altitude = mean(altitude))%>%
    arrange(daytime)
  
  df_gps_hour <- df_gps_minute %>%
    group_by(day, hour, PK, person) %>%
    reframe(latitude = mean(latitude),
              longitude = mean(longitude),
              altitude = mean(altitude))%>%
    
    mutate(date = as.POSIXct(day, format = "%Y-%m-%d")) %>%
    ungroup() %>%
    select(-day)
 
  save(df_gps_hour, file = file.path(data_dir, paste0("df_gps_hour_", i, ".rda")))
}

