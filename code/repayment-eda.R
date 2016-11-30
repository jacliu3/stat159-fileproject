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
#Observe the relationship between repayment rate and each category 

repayment.oneyear = subset(repayment, select= RPY_1YR_RT:NOTFIRSTGEN_RPY_1YR_RT)
png('../images/one-year-repayment-by-categories.png')
par(mar = c(12, 3.1, 0.1, 1.5))
par(cex= 0.55)
boxplot(repayment.oneyear, las=2)
dev.off()
# From the plot, we observe the following variables vary accroding to categories:
# completors v.s non-completors, low income v.s mid income, v.s high-income
# pell grant v.s non pell grant 
# perform two sample t-test to completors and pell grant
sink('../data/one-year-repayment-t-test.txt')
tbl.completors <- t.test(repayment.oneyear['COMPL_RPY_1YR_RT'], repayment.oneyear['NONCOM_RPY_1YR_RT'])
tbl.pellgrant <- t.test(repayment.oneyear['PELL_RPY_1YR_RT'], repayment.oneyear['NOPELL_RPY_1YR_RT'])
cat('completors v.s. non-completors \n')
print(tbl.completors)
cat('\n\n Pell grant v.s Non pell grant')
print(tbl.pellgrant)
sink()
# Both of them are significant

repayment.threeyear = subset(repayment, select= RPY_3YR_RT:NOTFIRSTGEN_RPY_3YR_RT)
png('../images/three-year-repayment-by-categories.png')
par(mar = c(12, 3.1, 0.1, 1.5))
par(cex= 0.55)
boxplot(repayment.threeyear, las=2)
dev.off()
# three year repayment plot displays the similar result 

### The correlation between Cohort Default Rate and Repayment Rate
attach(repayment)
mat <- data.frame(CDR2, CDR3, RPY_1YR_RT, RPY_3YR_RT, RPY_5YR_RT, RPY_7YR_RT)
sink('../data/CDR_repayment_correlation.txt')
M <- cor(mat, use= "complete")
print(M)
sink()
library(corrplot)
png('../images/CDR_repayment_correlation.png')
corrplot(M, method="circle")
dev.off()
# The correlation matrix shows that all six variables are highly correlated,
# so we could pick one of them as our predictors 
