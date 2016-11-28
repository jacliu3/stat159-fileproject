# Part of our data cleaning process involves dealing with NA values. There are three types
# of NA value in this dataset: NULL and 'PrivacySuppressed' and actual NA's. So I suggest when we are
# loading dataset, we could add 'na.string ="PrivacySuppressed', turning 
# PrivacySuppressed into NA's. And then turn NULL values into 0.

# We claim here that for those features that contain over 10 (or 20) percent of NA values,
# they should be discarded. 

# cs229.stanford.edu/proj2015/212_report.pdf
# MICE package

# Example: Repayment Data

# Function that calculates the proportion of NA's in a feature
pMiss <- function(x){ sum(is.na(x)) / length(x)*100 } 
repayment <- read.csv(file = '../data/repayment.csv', header = TRUE,
                      na.strings = "PrivacySuppressed", stringsAsFactors = FALSE)
repayment[which(repayment == "NULL", arr.ind = TRUE)] <- 0
vars.na <- apply(repayment, 2, pMiss)
repayment.clean <- repayment[ , -which(vars.na > 30)] 
