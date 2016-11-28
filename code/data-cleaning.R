library(mice)
earnings.data <- read.csv("../data/earnings.csv", stringsAsFactors = FALSE,
                          na.strings = "PrivacySuppressed")
financial.data <- read.csv("../data/financial.csv", stringsAsFactors = FALSE,
                           na.strings = "PrivacySuppressed")

comb.data <- cbind(earnings.data, financial.data)

# Replace NULL values with 0
comb.data[which(comb.data == "NULL", arr.ind = TRUE)] <- 0

# Remove samples and columns with over 30% NA values 
# We remove columns first to preserve the rows
comb.data <- comb.data[ , -which(colMeans(is.na(comb.data)) > 0.3)]
comb.data <- comb.data[-which(rowMeans(is.na(comb.data)) > 0.3), ]

# Impute missing values -- takes awhile
imp.data <- kNN(comb.data)
save(imp.data, file = "../data/imputed.Rdata")

# Feature selection 

