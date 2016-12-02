library(mice)
library(VIM)
library(corrplot)

earnings.data <- read.csv("../data/earnings.csv", stringsAsFactors = FALSE,
                          na.strings = "PrivacySuppressed")
financial.data <- read.csv("../data/financial.csv", stringsAsFactors = FALSE,
                           na.strings = "PrivacySuppressed")
repayment.data <- read.csv("../data/repayment.csv", stringsAsFactors = FALSE,
                           na.strings = "PrivacySuppressed")
comb.data <- cbind(earnings.data, financial.data)

# Remove samples and columns with over 30% NA values 
# We remove columns first to preserve the rows
comb.data <- comb.data[ , -which(colMeans(is.na(comb.data)) > 0.3)]
removedRows = which(rowMeans(is.na(comb.data)) > 0.3)
comb.data <- comb.data[-removedRows, ]
repayment.data <- repayment.data[-removedRows, ]

# Feature selection 
# Repayment labels
png(height=1000, width=1000, file="../images/repayment_correlation.png")
repayment.data <- data.frame(as.matrix(sapply(repayment.data, as.numeric)))
repayment.cor = cor(repayment.data, use="complete.obs")
corrplot(repayment.cor, tl.cex=0.5, type="lower")
dev.off()

# Financial featurses
png(height=1000, width=1000, file="../images/financial_correlation.png")
financial.data <- data.frame(as.matrix(sapply(financial.data, as.numeric)))
financial.cor = cor(financial.data, use="complete.obs")
corrplot(financial.cor, tl.cex=0.5, type="lower")
dev.off()

# Earning features
png(height=1000, width=1000, file="../images/earning_correlation.png")
earnings.data <- data.frame(as.matrix(sapply(earnings.data, as.numeric)))
earnings.cor = cor(earnings.data, use="complete.obs")
corrplot(earnings.cor, tl.cex=0.5, type="lower")
dev.off()

# Final features. Label will be CDR3
features = c("COUNT_NWNE_P10","MN_EARN_WNE_P10","COUNT_WNE_INDEP0_P10",
             "COUNT_WNE_INDEP0_INC1_P10","D150_4_POOLED","PCTFLOAN",
             "DEBT_MDN","DEBT_N","DEP_DEBT_N","LOAN_EVER")

# Replace NULL values with 0 and remove samples without label
# Remove irrelevant features
comb.data <- comb.data[ , features]
comb.data[which(comb.data == "NULL", arr.ind = TRUE)] <- 0
missing <- which(repayment.data["CDR3"] == "NULL")
comb.data <- comb.data[-missing, ]
repayment.data <- repayment.data[-missing, "CDR3"]

# Impute missing values -- takes awhile
imp.data <- kNN(comb.data, imp_var = FALSE)
save(imp.data, file = "../data/imputed.Rdata")
save(repayment.data, file="../data/repayment.Rdata")
