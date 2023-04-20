#----------------------------------------------------------------------
# Aggregate by user
load(file = file.path('./Data', "df_gps_com_valid.rda"))
data_dir = "./Fig"

df_gps_com_by_user <- df_gps_com_valid %>%
  group_by(person) %>%
  summarise(
            user_type = head(PK, 1),
            latitude = mean(latitude),
            longitude= mean(longitude),
            altitude= mean(altitude),
            )

vars_user <- names(df_gps_com_by_user[3:5])

pdf(file.path(data_dir, "feaure_importance.pdf"))
for (var_user in vars_user) {
  print(var_user)
  p <- ggplot(data = df_gps_com_by_user,
              aes_string(x = as.factor(df_gps_com_by_user$user_type), y = var_user )) +
    geom_boxplot() + geom_point(aes_string(color = "user_type"))
  print(p)
}
dev.off()
