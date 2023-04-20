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
  load(file = file.path(data_dir, paste0("cmpss", i, ".Rdata")))
  df_cmpss<- cmpss %>%
    mutate(azimuth.mean = as.numeric(azimuth.mean),
           azimuth.absolute.deviation = as.numeric(azimuth.absolute.deviation),
           azimuth.standard.deviation = as.numeric(azimuth.standard.deviation),
           azimuth.max.deviation = as.numeric(azimuth.max.deviation),
           pitch.mean = as.numeric(pitch.mean),
           pitch.absolute.deviation = as.numeric(pitch.absolute.deviation),
           pitch.standard.deviation = as.numeric(pitch.standard.deviation),
           pitch.max.deviation = as.numeric(pitch.max.deviation),
           roll.mean = as.numeric(roll.mean),
           roll.absolute.deviation = as.numeric(roll.absolute.deviation),
           roll.standard.deviation = as.numeric(roll.standard.deviation),
           roll.max.deviation = as.numeric(roll.max.deviation),
           daytime_orig = as.character(time),
           daytime = as.POSIXct(daytime_orig, format = "%Y-%m-%d %X"),
           day = sapply(daytime_orig, function(x) strsplit(x, " ")[[1]][1]),
           time_char = sapply(daytime_orig, function(x) strsplit(x, " ")[[1]][2]),
           time = as.POSIXct(time_char, format = "%H:%M:%S"),
           hour = as.numeric(sapply(time_char, function(x) strsplit(x, ":")[[1]][1])),
           minute = as.numeric(sapply(time_char, function(x) strsplit(x, ":")[[1]][2])))%>%
    select(-daytime_orig, -time_char)
  
  df_cmpss_minute <- df_cmpss %>%
    group_by(daytime, day, time, hour, minute, PK, person) %>%
      reframe(azimuth.mean = mean(azimuth.mean),
              azimuth.absolute.deviation = mean(azimuth.absolute.deviation),
              azimuth.standard.deviation = mean(azimuth.standard.deviation),
              azimuth.max.deviation = mean(azimuth.max.deviation),
              pitch.mean = mean(pitch.mean),
              pitch.absolute.deviation = mean(pitch.absolute.deviation),
              pitch.standard.deviation = mean(pitch.standard.deviation),
              pitch.max.deviation = mean(pitch.max.deviation),
              roll.mean = mean(roll.mean),
              roll.absolute.deviation = mean(roll.absolute.deviation),
              roll.standard.deviation = mean(roll.standard.deviation),
              roll.max.deviation = mean(roll.max.deviation))%>%
    arrange(daytime)
  
  df_cmpss_hour <- df_cmpss_minute %>%
    group_by(day, hour, PK, person) %>%
      reframe(azimuth.mean = mean(azimuth.mean),
              azimuth.absolute.deviation = mean(azimuth.absolute.deviation),
              azimuth.standard.deviation = mean(azimuth.standard.deviation),
              azimuth.max.deviation = mean(azimuth.max.deviation),
              pitch.mean = mean(pitch.mean),
              pitch.absolute.deviation = mean(pitch.absolute.deviation),
              pitch.standard.deviation = mean(pitch.standard.deviation),
              pitch.max.deviation = mean(pitch.max.deviation),
              roll.mean = mean(roll.mean),
              roll.absolute.deviation = mean(roll.absolute.deviation),
              roll.standard.deviation = mean(roll.standard.deviation),
              roll.max.deviation = mean(roll.max.deviation))%>%
    mutate(date = as.POSIXct(day, format = "%Y-%m-%d")) %>%
    ungroup() %>%
    select(-day)


  save(df_cmpss_hour, file = file.path(data_dir, paste0("df_cmpss_hour_", i, ".rda")))
}

