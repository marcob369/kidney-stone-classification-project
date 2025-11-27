"
title: Kidney stone modelling
author: Marco Brega
date: 2025-11-18

"

#Before running any script, execute: renv::restore()
#You may need to install Rtools

library(tidyverse)
library(GGally)
library(class)
library(gmodels)
library(caret)
library(purrr)

#Importing and tidying data
df_kidney_stones <- read_csv("kindey stone urine analysis.csv")

df_kidney_stones <- df_kidney_stones %>%
  mutate(target = factor(target, labels = c("Stone absent","Stone present")))

#There are no NAs
sum(is.na(df_kidney_stones)) 

#Removing outliers, which are present in ph and calc
summary(df_kidney_stones)
boxplot(df_kidney_stones)

df_kidney_stones <- df_kidney_stones %>%
  filter(ph > (quantile(ph, 0.25) - 1.5*IQR(ph)), ph < (quantile(ph, 0.75) + 1.5*IQR(ph))) %>%
  filter(calc > (quantile(calc, 0.25) - 1.5*IQR(calc)), calc < (quantile(calc, 0.75) + 1.5*IQR(calc)))


#Evaluating distribution and correlation between variables
ggpairs(df_kidney_stones[1:6], aes(color = df_kidney_stones$target))


#Conducting PCA in order to apply dimensionality recuction
df_kidney_stones_scaled <- scale(df_kidney_stones[1:6])
PCA1 <- prcomp(df_kidney_stones_scaled)
summary(PCA1)
biplot(PCA1)

#Possible to simplify model keeping just variables pH and gravity
df_kidney_stones_simplified <- df_kidney_stones %>%
  select("gravity","ph","target") %>%
  mutate(
    gravity = scale(gravity),
    ph = scale(ph)
  )

#Evaluating linear relationship between variables
ggplot(df_kidney_stones_simplified, aes(x = ph, y = gravity)) +
  geom_point() +
  geom_smooth(method = 'lm', se = FALSE) +
  labs(
    title = "Estimated Linear relationship between Specific gravity and pH"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5)
  )

cor(df_kidney_stones_simplified$gravity, df_kidney_stones_simplified$ph)

lm_ph_gravity <- lm(gravity ~ ph, data = df_kidney_stones_simplified)
summary(lm_ph_gravity)

#Splitting into train and test datasets
set.seed(123)
test_indexes <- sample(
  1:nrow(df_kidney_stones_simplified), 
  size = 0.2*nrow(df_kidney_stones_simplified),
  replace = FALSE
  )

X_train <- df_kidney_stones_simplified[-test_indexes,-3]
X_test <- df_kidney_stones_simplified[test_indexes,-3]
y_train <- df_kidney_stones_simplified$target[-test_indexes]
y_test <- df_kidney_stones_simplified$target[test_indexes]

#Creating KNN model
model_parameters <- data.frame(matrix(nrow = 10, ncol = 11))
colnames(model_parameters) <- c(
  "Sensitivity",
  "Specificity",
  "Pos_Pred_Value",
  "Neg_Pred_Value",
  "Precision",
  "Recall",
  "F1",
  "Prevalence",
  "Detection_Rate",
  "Detection_Prevalence",
  "Balanced_Accuracy"
)

for (k in c(1:nrow(model_parameters))){
  print(k)
  
  knn_model_k <- knn(
    train = X_train, 
    test = X_test,
    cl = y_train,
    k = k
  )

  knn_model_k_confusion_matrix <- confusionMatrix(
    data = knn_model_k,
    reference = y_test,
    positive = "Stone present"
  )
  
  print(knn_model_k_confusion_matrix)
  
  model_parameters[k,] <- knn_model_k_confusion_matrix$byClass
}

model_parameters

#Plotting sensitivity and F1 vs. k
ggplot(data = model_parameters) +
  labs(
    x = "k",
    y = "Metric value",
    title = "Sensitivity and F1 score for k in range 1-10"
  ) +
  geom_line(
    aes(
      x = 1:nrow(model_parameters),
      y = Sensitivity,
      color = "Sensitivity"
    )
  ) +
  geom_line(
    aes(
      x = 1:nrow(model_parameters),
      y = F1,
      color = "F1"
    )
  ) +
  scale_color_manual(
    name = "Metric",
    values = c(
      "Sensitivity" = "blue",
      "F1" = "red"
    )
  ) +
  theme(
    plot.title = element_text(hjust = 0.5)
  )

#Model with chosen values of k
knn_model_4_def <- model_parameters[4,]





