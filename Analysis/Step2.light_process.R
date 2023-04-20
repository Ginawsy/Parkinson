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
  load(file = file.path(data_dir, paste0("light", i, ".Rdata")))
  
  if (class(light) != "list"){
  df_light<- light %>%
    mutate(value = as.numeric(value),
           daytime_orig = as.character(time),
           daytime = as.POSIXct(daytime_orig, format = "%Y-%m-%d %X"),
           day = sapply(daytime_orig, function(x) strsplit(x, " ")[[1]][1]),
           time_char = sapply(daytime_orig, function(x) strsplit(x, " ")[[1]][2]),
           time = as.POSIXct(time_char, format = "%H:%M:%S"),
           hour = as.numeric(sapply(time_char, function(x) strsplit(x, ":")[[1]][1])),
           minute = as.numeric(sapply(time_char, function(x) strsplit(x, ":")[[1]][2])))%>%
    select(-daytime_orig, -time_char)
  
  df_light_minute <- df_light %>%
    group_by(daytime, day, time, hour, minute, PK, person) %>%
    reframe(value = mean(value))%>%
    arrange(daytime)
  
  df_light_hour <- df_light_minute %>%
    group_by(day, hour, PK, person) %>%
    reframe(value = mean(value))%>%
    mutate(date = as.POSIXct(day, format = "%Y-%m-%d")) %>%
    ungroup() %>%
    select(-day)
  
  save(df_light_hour, file = file.path(data_dir, paste0("df_light_hour_", i, ".rda")))
  }
}

