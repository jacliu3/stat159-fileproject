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
            cv.folds = 5, n.trees = 100)
fit2 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 5, shrinkage = 0.01)
fit3 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 5, shrinkage = 0.001)
fit4 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 5, shrinkage = 0.1)
fit5 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 5, shrinkage = 0.1, bag.fraction = 0.4)
fit6 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 5, shrinkage = 0.1, bag.fraction = 0.6)
fit7 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 5, shrinkage = 0.1, n.trees = 150)
fit8 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 5, shrinkage = 0.1, n.trees = 75)
fit9 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 5, shrinkage = 0.1, n.trees = 300)
fit10 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
            cv.folds = 5, shrinkage = 0.1, n.trees = 500)
fit11 <- gbm(CDR~., data = x[train.indices, ], distribution = "gaussian", 
             cv.folds = 5, shrinkage = 0.1, n.trees = 1000)
fits <- list(fit1, fit2, fit3, fit4, fit5, fit6, fit7, fit8, fit9, fit10, fit11)

# Select best model
avg.error <- sapply(fits, function(x) {mean(abs(x$cv.error))})
best.gbm <- fits[[which.min(avg.error)]]
  
# Calculate validation error using mean absolute error
pred <- predict(best.gbm, x[-train.indices, ])
label <- x[-train.indices, 'CDR']
gbm.abse <- mean(abs(pred - label))
rel.gbm.abse <- gbm.abse / mean(label) * 100

# Save results (data and visuals)
save(best.gbm, gbm.abse, rel.gbm.abse, pred, label, file = "../data/fitted-gbm.Rdata")

og <- par()
par(mar = c(6, 10, 2, 2), cex.axis = 0.75)
png(file = "../images/gbm-features.png", width = 800, height = 450)
summary(best.gbm, las = 1)
dev.off()
par <- og

png(file = "../images/gbm-predictions.png")
plot(pred, label,
     ylab = "observed", xlab = "predicted") + abline(a = 0, b = 1, col = "blue") 
dev.off()
