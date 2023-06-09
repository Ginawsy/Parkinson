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
  load(file = file.path(data_dir, paste0("accel", i, ".Rdata")))
df_accel<- accel %>%
  mutate(x.mean = as.numeric(x.mean),
         x.absolute.deviation = as.numeric(x.absolute.deviation),
         x.standard.deviation = as.numeric(x.standard.deviation),
         x.max.deviation = as.numeric(x.max.deviation),
         x.PSD.1 = as.numeric(x.PSD.1),
         x.PSD.3 = as.numeric(x.PSD.3),
         x.PSD.6 = as.numeric(x.PSD.6),
         x.PSD.10 = as.numeric(x.PSD.10),
         y.mean = as.numeric(y.mean),
         y.absolute.deviation = as.numeric(y.absolute.deviation),
         y.standard.deviation = as.numeric(y.standard.deviation),
         y.max.deviation = as.numeric(y.max.deviation),
         y.PSD.1 = as.numeric(y.PSD.1),
         y.PSD.3 = as.numeric(y.PSD.3),
         y.PSD.6 = as.numeric(y.PSD.6),
         y.PSD.10 = as.numeric(y.PSD.10),
         z.mean = as.numeric(z.mean),
         z.absolute.deviation = as.numeric(z.absolute.deviation),
         z.standard.deviation = as.numeric(z.standard.deviation),
         z.max.deviation = as.numeric(z.max.deviation),
         z.PSD.1 = as.numeric(z.PSD.1),
         z.PSD.3 = as.numeric(z.PSD.3),
         z.PSD.6 = as.numeric(z.PSD.6),
         z.PSD.10 = as.numeric(z.PSD.10),
         daytime_orig = as.character(time),
         daytime = as.POSIXct(daytime_orig, format = "%Y-%m-%d %X"),
         day = sapply(daytime_orig, function(x) strsplit(x, " ")[[1]][1]),
         time_char = sapply(daytime_orig, function(x) strsplit(x, " ")[[1]][2]),
         time = as.POSIXct(time_char, format = "%H:%M:%S"),
         hour = as.numeric(sapply(time_char, function(x) strsplit(x, ":")[[1]][1])),
         minute = as.numeric(sapply(time_char, function(x) strsplit(x, ":")[[1]][2])))%>%
  select(-daytime_orig, -time_char)

df_accel_minute <- df_accel %>%
  group_by(daytime, day, time, hour, minute, PK, person) %>%
  reframe(x.mean = mean(x.mean),
            x.absolute.deviation = mean(x.absolute.deviation),
            x.standard.deviation = mean(x.standard.deviation),
            x.max.deviation = mean(x.max.deviation),
            x.PSD.1 = mean(x.PSD.1),
            x.PSD.3 = mean(x.PSD.3),
            x.PSD.6 = mean(x.PSD.6),
            x.PSD.10 = mean(x.PSD.10),
            y.mean = mean(y.mean),
            y.absolute.deviation = mean(y.absolute.deviation),
            y.standard.deviation = mean(y.standard.deviation),
            y.max.deviation = mean(y.max.deviation),
            y.PSD.1 = mean(y.PSD.1),
            y.PSD.3 = mean(y.PSD.3),
            y.PSD.6 = mean(y.PSD.6),
            y.PSD.10 = mean(y.PSD.10),
            z.mean = mean(z.mean),
            z.absolute.deviation = mean(z.absolute.deviation),
            z.standard.deviation = mean(z.standard.deviation),
            z.max.deviation = mean(z.max.deviation),
            z.PSD.1 = mean(z.PSD.1),
            z.PSD.3 = mean(z.PSD.3),
            z.PSD.6 = mean(z.PSD.6),
            z.PSD.10 = mean(z.PSD.10),
            PK=PK) %>%
  arrange(daytime)

df_accel_hour <- df_accel_minute %>%
  group_by(day, hour, PK, person) %>%
  reframe(nsamples = length(hour),
            x.mean = mean(x.mean),
            x.absolute.deviation = mean(x.absolute.deviation),
            x.standard.deviation = mean(x.standard.deviation),
            x.max.deviation = mean(x.max.deviation),
            x.PSD.1 = mean(x.PSD.1),
            x.PSD.3 = mean(x.PSD.3),
            x.PSD.6 = mean(x.PSD.6),
            x.PSD.10 = mean(x.PSD.10),
            y.mean = mean(y.mean),
            y.absolute.deviation = mean(y.absolute.deviation),
            y.standard.deviation = mean(y.standard.deviation),
            y.max.deviation = mean(y.max.deviation),
            y.PSD.1 = mean(y.PSD.1),
            y.PSD.3 = mean(y.PSD.3),
            y.PSD.6 = mean(y.PSD.6),
            y.PSD.10 = mean(y.PSD.10),
            z.mean = mean(z.mean),
            z.absolute.deviation = mean(z.absolute.deviation),
            z.standard.deviation = mean(z.standard.deviation),
            z.max.deviation = mean(z.max.deviation),
            z.PSD.1 = mean(z.PSD.1),
            z.PSD.3 = mean(z.PSD.3),
            z.PSD.6 = mean(z.PSD.6),
            z.PSD.10 = mean(z.PSD.10)) %>%
  filter(nsamples >= 5) %>% # at least 5 seconds of samples
  mutate(date = as.POSIXct(day, format = "%Y-%m-%d")) %>%
  ungroup() %>%
  select(-c(nsamples, day))

df_accel_combinedxyz <- df_accel_hour %>%
  mutate(xyz.mean = rms(x.mean, y.mean, z.mean), 
         xyz.absolute.deviation = rms(x.absolute.deviation, y.absolute.deviation, z.absolute.deviation),
         xyz.standard.deviation = rms(x.standard.deviation, y.standard.deviation, z.standard.deviation),
         xyz.max.deviation = rms(x.max.deviation, y.max.deviation, z.max.deviation),
         xyz.PSD.1 = rms(x.PSD.1, y.PSD.1, z.PSD.1),
         xyz.PSD.3 = rms(x.PSD.3, y.PSD.3, z.PSD.3),
         xyz.PSD.6 = rms(x.PSD.6, y.PSD.6, z.PSD.6),
         xyz.PSD.10 = rms(x.PSD.10, y.PSD.10, z.PSD.10)) %>%
  select(starts_with("xyz"), date, hour, PK, person) 

save(df_accel_combinedxyz, file = file.path(data_dir, paste0("df_accel_combinedxyz_", i, ".rda")))
}

