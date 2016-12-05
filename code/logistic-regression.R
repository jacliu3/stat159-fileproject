library (caret)
set.seed(1)
load("../data/imputed.Rdata")
load("../data/repayment.Rdata")
features <- c("COUNT_NWNE_P10","MN_EARN_WNE_P10", "COUNT_WNE_INDEP0_P10",
              "COUNT_WNE_INDEP0_INC1_P10", "D150_4_POOLED", "PCTFLOAN",
              "DEBT_MDN", "DEBT_N", "DEP_DEBT_N", "LOAN_EVER")
label <- as.numeric(repayment.data)
model.variables <- data.frame(as.matrix(sapply(imp.data[features], as.numeric)))
comb.data <- cbind(label, model.variables)

# University with CDR3 higher than 15% is classified as high risk
comb.data[ , 1] <- ifelse(comb.data[ , 1] > 0.15, 1, 0)

# Useful statistics of the accuracy
stats.df <- as.data.frame(matrix(0, nrow = 5, ncol = 3))
names(stats.df) <- c("Precision", "Recall", "F1")

# 5-Fold Cross Validation
folds <- sample(5, nrow(comb.data), replace = T)
error <- NULL
abserror <- NULL
response <- NULL
value <- NULL
for (k in 1:5){
  train <- subset(1:nrow(comb.data), folds != k)
  test <- subset(1:nrow(comb.data), folds == k)
  fit <- glm(label ~ ., data=comb.data[train, ])
  response <- predict(fit, comb.data[test, -1], type = "response")
  response <- as.factor(ifelse(response > 0.5, 1, 0))
  y <- as.factor(comb.data[test, 1])
  precision <- posPredValue(response, y)
  recall <- sensitivity(response, y)
  F1 <- (2 * precision * recall) / (precision + recall)
  stats.df[k, ] <- c(precision, recall,F1)
}

write.csv(stats.df, file = "../data/logistic-result.csv", row.names = TRUE)
