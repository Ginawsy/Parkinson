data_dir = "./Data"

# Combine accel 
load(file = file.path(data_dir, "df_accel_combinedxyz_1.rda"))
df_accel_com <- df_accel_combinedxyz

for (i in 2:14){
  load(file = file.path(data_dir, paste0("df_accel_combinedxyz_", i, ".rda")))
  df_accel_com <- rbind(df_accel_com, df_accel_combinedxyz)
}
save(df_accel_com, file = file.path(data_dir, "df_accel_com.rda"))

# Combine cmpss
load(file = file.path(data_dir, "df_cmpss_hour_1.rda"))
df_cmpss_com <- df_cmpss_hour

for (i in 2:14){
  load(file = file.path(data_dir, paste0("df_cmpss_hour_", i, ".rda")))
  df_cmpss_com <- rbind(df_cmpss_com, df_cmpss_hour)
}
save(df_cmpss_com, file = file.path(data_dir, "df_cmpss_com.rda"))

# Combine gps
load(file = file.path(data_dir, "df_gps_hour_1.rda"))
df_gps_com <- df_gps_hour

for (i in 2:14){
  load(file = file.path(data_dir, paste0("df_gps_hour_", i, ".rda")))
  df_gps_com <- rbind(df_gps_com, df_gps_hour)
}
save(df_gps_com, file = file.path(data_dir, "df_gps_com.rda"))

# Combine light
load(file = file.path(data_dir, "df_light_hour_1.rda"))
df_light_com <- df_light_hour

for (i in 2:8){
  load(file = file.path(data_dir, paste0("df_light_hour_", i, ".rda")))
  df_light_com <- rbind(df_light_com, df_light_hour)
}
save(df_light_com, file = file.path(data_dir, "df_light_com.rda"))
