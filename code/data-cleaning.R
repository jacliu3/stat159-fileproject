library(mice)
library(VIM)
earnings.data <- read.csv("../data/earnings.csv", stringsAsFactors = FALSE,
                          na.strings = "PrivacySuppressed")
financial.data <- read.csv("../data/financial.csv", stringsAsFactors = FALSE,
                           na.strings = "PrivacySuppressed")
repayment.data <- read.csv("../data/repayment.csv", stringsAsFactors = FALSE,
                           na.strings = "PrivacySuppressed")
comb.data <- cbind(earnings.data, financial.data)

# Replace NULL values with 0
comb.data[which(comb.data == "NULL", arr.ind = TRUE)] <- 0
repayment.data[which(repayment.data == "NULL", arr.ind = TRUE)] <- 0

# Remove samples and columns with over 30% NA values 
# We remove columns first to preserve the rows
comb.data <- comb.data[ , -which(colMeans(is.na(comb.data)) > 0.3)]
removedRows = which(rowMeans(is.na(comb.data)) > 0.3)
comb.data <- comb.data[-removedRows, ]
repayment.data <- repayment.data[-removedRows, ]

# Impute missing values -- takes awhile
imp.data <- kNN(comb.data, imp_var = FALSE)

# Feature selection 
features <- c("COUNT_NWNE_P10", "MN_EARN_WNE_P10", "COUNT_WNE_INDEP0_P10",
             "COUNT_WNE_INDEP0_INC1_P10", "D150_4_POOLED", "PCTFLOAN", "DEBT_MDN",
             "DEBT_N", "DEP_DEBT_N", "LOAN_EVER")

# Save relevant features/data
imp.data <- imp.data[, features]
save(imp.data, file = "../data/imputed.Rdata")
save(repayment.data, file="../data/repayment.Rdata")

