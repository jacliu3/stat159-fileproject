library (caret)
set.seed(1)
load("../data/imputed.Rdata")
load("../data/repayment.Rdata")
features <- c("COUNT_NWNE_P10","MN_EARN_WNE_P10","COUNT_WNE_INDEP0_P10","COUNT_WNE_INDEP0_INC1_P10","D150_4_POOLED","PCTFLOAN","DEBT_MDN","DEBT_N","DEP_DEBT_N","LOAN_EVER")
model.label <- repayment.data["CDR3"]
model.variables <- imp.data[features]

comb.data <- cbind(model.label, model.variables)
comb.data <- data.frame(as.matrix(sapply(comb.data, as.numeric)))
#University with CDR3 higher than 15% is classified as high risk
comb.data[,1] <- ifelse(comb.data[,1] > 0.15, 1, 0)

#useful statistics of the accuracy
stats = function(response, y){
  precision <- posPredValue(response, y)
  recall <- sensitivity(response, y)
  F1 <- (2 * precision * recall) / (precision + recall)
  cat("Precision:", precision, "Recall:", recall, "F1:",F1, "\n")
}

#5-Fold Cross Validation
folds = sample(5, nrow(comb.data), replace = T)
error <- NULL
abserror = NULL
response=NULL
value = NULL
for (k in 1:5){
  train = subset(1:nrow(comb.data), folds != k)
  test = subset(1:nrow(comb.data), folds == k)
  fit = glm(CDR3 ~ . , data=comb.data[train,])
  response = predict(fit, comb.data[test,-1], type="response")
  response = as.factor(ifelse(response > 0.5, 1, 0))
  y = as.factor(comb.data[test,1])
  stats(response, y)
}


