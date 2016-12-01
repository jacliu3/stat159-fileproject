library(gbm)
set.seed(8898)

# Load data into numeric data fram
load("../data/imputed.Rdata")
load("../data/repayment.Rdata")
imp.data <- data.frame(as.matrix(sapply(imp.data, as.numeric)))
x <- cbind(imp.data, CDR = as.numeric(repayment.data))

# Fit model
train.indices <- sample(nrow(x), as.integer(nrow(x)*4/5))
fit1 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian",
            cv.folds = 3, n.trees = 100)
fit2 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 3, n.trees = 75)
fit3 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 3, n.trees = 150)
fit4 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 3, shrinkage = 0.01)
fit5 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 3, shrinkage = 0.001)
fit6 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 3, shrinkage = 0.1)
fit7 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 3, shrinkage = 0.1, bag.fraction = 0.4)
fit8 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 3, shrinkage = 0.1, bag.fraction = 0.6)
fits <- list(fit1, fit2, fit3, fit4, fit5, fit6, fit7, fit8)

# Select best model
best.gbm <- fit1
for (fit in fits){
  if (mean(fit$cv.error - best.gbm$cv.error) < 0){
    best.gbm <- fit
  }
}
  
# Calculate validation error 
pred <- predict(best.gbm, x[-train.indices, ])
gbm.mse <- mean((pred - x[-train.indices, 'CDR'])^2)
rel.gbm.mse <- gbm.mse / mean(x[-train.indices, 'CDR']) * 100

# Save results (data and visuals)
save(best.gbm, gbm.mse, rel.gbm.mse, file = "../data/fitted-gbm.Rdata")

og <- par()
par(mar = c(6, 10, 2, 2), cex.axis = 0.75)
png(file = "../images/gbm-features.png", width = 800, height = 450)
summary(best.gbm, las = 1)
dev.off()
par <- og

pred6 <- predict(fit6, x[-train.indices, ])
png(file = "../images/gbm-predictions.png")
plot(pred, x[-train.indices, "CDR"])
