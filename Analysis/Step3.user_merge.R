# Fill users. 
data_dir = "./Data"
load(file = file.path(data_dir, "df_accel_com.rda"))
load(file = file.path(data_dir, "df_cmpss_com.rda"))
load(file = file.path(data_dir, "df_gps_com.rda"))
load(file = file.path(data_dir, "df_light_com.rda"))

users <- c("APPLE", "CHERRY", "CROCUS", "DAFODIL", 
           "DAISY", "FLOX", "IRIS", "LILY",
           "MAPLE", "ORANGE", "ORCHID", "PEONY", "ROSE",
           "SUNFLOWER", "SWEETPEA", "VIOLET")


df_accel_com_valid <- df_accel_com[df_accel_com$person %in% users, ]
length(unique(df_accel_com_valid$person))

df_cmpss_com_valid <- df_cmpss_com[df_cmpss_com$person %in% users, ]
length(unique(df_cmpss_com_valid$person))

df_gps_com_valid <- df_gps_com[df_gps_com$person %in% users, ]
length(unique(df_gps_com_valid$person))

df_light_com_valid <- df_light_com[df_light_com$person %in% users, ]
length(unique(df_light_com_valid$person))

save(df_accel_com_valid, file = file.path(data_dir, "df_accel_com_valid.rda"))
save(df_cmpss_com_valid, file = file.path(data_dir, "df_cmpss_com_valid.rda"))
save(df_gps_com_valid, file = file.path(data_dir, "df_gps_com_valid.rda"))

# Merge data. 
df_merge <- merge(df_accel_com_valid, df_cmpss_com_valid,by=c("date", "hour", "PK","person"))
df_merge <- merge(df_merge, df_gps_com_valid,by=c("date", "hour", "PK","person"))
save(df_merge, file = file.path('./Data', "df_merge.rda"))
