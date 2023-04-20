# Model Prediction Part
library(dplyr)
library(ggplot2)
library(scales) 
library(grid) 
library(GGally)
library(ggmap)
percaccuracy <- function(predicted, actual) {
  return(mean(predicted == actual)*100)
}

load(file = file.path('./Data', "df_merge.rda"))
data_dir = "./Fig"

#SVM
library(kernlab)

users_all <- unique(df_merge$person)

prob_svm <- pred_svm <- actual <- rep(NA, length(users_all))

vars <- names(df_merge)
vars <- vars[4:27]

model_data <- data.frame(df_merge[, names(df_merge) %in% vars],
                         class = factor(df_merge$PK))
my_contrasts <- contrasts(model_data$class) <- matrix(c(-1, 1), nrow = 2)

for (i in seq_along(users_all)) {
  indices_user_select <- df_merge$person == users_all[i]
  print(sum(indices_user_select))
  mod <- ksvm(class~ ., data = model_data[-indices_user_select, ],
              type = "C-bsvc", kernel = "rbfdot",
              kpar = list(sigma = 0.1), C = 10, prob.model = TRUE, 
              contrasts = list(x = my_contrasts))

  prob <- mean(predict(mod, model_data[indices_user_select, ], 
                       type = "response") == 1)
  pred <- ifelse(prob > 0.5, 1, 0)

  prob_svm[i] <- prob
  pred_svm[i] <- pred
  actual[i] <- unique(as.character(model_data$class[indices_user_select]))
}

percaccuracy(pred_svm, actual)
data.frame(prob_svm, pred_svm, actual)

# SVM: with only three features
model_data2 <- data.frame(df_merge[25:27], class = factor(df_merge$PK))
users_all <- unique(df_merge$person)

for (i in seq_along(users_all)) {
  indices_user_select <- df_merge$person == users_all[i]
  print(sum(indices_user_select))
  mod <- ksvm(class~ ., data = model_data2[-indices_user_select, ],
              type = "C-bsvc", kernel = "rbfdot",
              kpar = list(sigma = 0.1), C = 10, prob.model = TRUE)
  
  prob <- mean(predict(mod, model_data2[indices_user_select, ], 
                       type = "response") == 1)
  pred <- ifelse(prob > 0.5, 1, 0)
  
  prob_svm[i] <- prob
  pred_svm[i] <- pred
  actual[i] <- unique(as.character(model_data2$class[indices_user_select]))
}
percaccuracy(pred_svm, actual)
data.frame(prob_svm, pred_svm, actual)

# RF
library(randomForest)

prob_rf <- pred_rf <- actual <- rep(NA, length(users_all))
for (i in seq_along(users_all)) {
  indices_user_select <- df_merge$person == users_all[i]
  mod <- randomForest(class ~ ., data = model_data[-indices_user_select, ], ntree = 1000,
                      importance = TRUE, do.trace = 10)
  prob <- mean(predict(mod, model_data[indices_user_select, ], 
                       type = "response") == "1")
  pred <- ifelse(prob > 0.5, "1", "0")
  prob_rf[i] <- prob
  pred_rf[i] <- pred
  actual[i] <- unique(as.character(model_data$class[indices_user_select]))
}

percaccuracy(pred_rf, actual)
data.frame(prob_rf, pred_rf, actual)

# Relative importance (RF)
mod_rf <- randomForest(class ~ ., data = model_data, ntree = 1000,
                       importance = TRUE, do.trace = 10)
mod_rf_impt <- importance(mod_rf)

# varImpPlot(mod_rf)
mod_rf_impt_df <- data.frame(Variable = dimnames(mod_rf_impt)[[1]], 
                             MeanDecreaseMSE = mod_rf_impt[, 1],
                             MeanDecreaseNodeImpurity = mod_rf_impt[, 2])
mod_rf_impt_df <- mod_rf_impt_df[order(mod_rf_impt_df$MeanDecreaseMSE, decreasing = TRUE), ]
mod_rf_impt_df$Variable <- factor(mod_rf_impt_df$Variable, 
                                  levels = rev(mod_rf_impt_df$Variable))
num_plot <- 20
p <- ggplot(data = head(mod_rf_impt_df, num_plot),
            aes(x = MeanDecreaseMSE, y = Variable)) +
  geom_point(shape = 19, size = 3, col = "blue") +
  xlab("Relative importance") + ylab("") + 
  xlim(range(head(mod_rf_impt_df$MeanDecreaseMSE, num_plot))) +
  theme(plot.background = element_rect(fill = "transparent", colour = NA))
pdf(file.path(data_dir, "rf-importance.pdf"), height = 7)
print(p)
dev.off()