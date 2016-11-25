library(tree)
library(MASS)
library(mice)
library(VIM)
#read in repayment dataset
repayment <- read.csv(file = '../data/repayment.csv', header = TRUE, na.strings = c("NULL","PrivacySuppressed"), stringsAsFactors = FALSE)
colnames(repayment)

# 1. impute missing value Using MICE package
# There are too many NAs in the dataset, so I replace them by buidling a linear regression
# model on other fully observed variables (as 'meth = pmm' shows). Here I use the package
# MICE to predict NA values.
md.pattern(repayment)
aggr_plot <- aggr(repayment, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(repayment), cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))
tempData <- mice(repayment,m=1,maxit=2,meth='pmm',seed=500)
summary(tempData)
completedrepayment <- complete(tempData,1) #completedrepayment contains a non-NA contained dataset

#####################################################################
# 2. fit regression tree
# one year repayment rate
set.seed(1)
repayment.oneyear = subset(completedrepayment, select= RPY_1YR_RT:NOTFIRSTGEN_RPY_1YR_RT)
#select 2/3 of data
train = sample(1:nrow(repayment.oneyear), (nrow(repayment.oneyear)+1)*2/3)
tree.repayment.oneyear = tree(RPY_1YR_RT~., repayment.oneyear, subset = train)
summary(tree.repayment.oneyear) #The tree uses "NOTFIRSTGEN_RPY_1YR_RT", 
#"FIRSTGEN_RPY_1YR_RT", "FEMALE_RPY_1YR_RT" three predictors. In which the 
par(mfrow = c(1,1))
plot(tree.repayment.oneyear)
text(tree.repayment.oneyear)

#perform cross validation
cv.tree.repayment.oneyear = cv.tree(tree.repayment.oneyear)
plot(cv.tree.repayment.oneyear$size, cv.tree.repayment.oneyear$dev, type = 'b')

#prune tree
prune.repayment.oneyear = prune.tree(tree.repayment.oneyear, best = 5)
png('../images//tree.repayment.oneyear.png')
plot(prune.repayment.oneyear )
text(prune.repayment.oneyear, pretty =0)
dev.off()

########################################################################
# three year repayment
repayment.threeyear = subset(completedrepayment, select= RPY_3YR_RT:NOTFIRSTGEN_RPY_3YR_RT)
#select 2/3 of data
train = sample(1:nrow(repayment.threeyear), (nrow(repayment.threeyear)+1)*2/3)
tree.repayment.threeyear = tree(RPY_3YR_RT~., repayment.threeyear, subset = train)
summary(tree.repayment.threeyear) #The tree uses "NOTFIRSTGEN_RPY_1YR_RT", 
#"FIRSTGEN_RPY_1YR_RT", "FEMALE_RPY_1YR_RT" three predictors. In which the 
par(mfrow = c(1,1))
plot(tree.repayment.threeyear)
text(tree.repayment.threeyear)

#perform cross validation
cv.tree.repayment.threeyear = cv.tree(tree.repayment.threeyear)
plot(cv.tree.repayment.threeyear$size, cv.tree.repayment.threeyear$dev, type = 'b')

#prune tree
prune.repayment.threeyear = prune.tree(tree.repayment.threeyear, best = 6)
png('../images/repayment.threeyear.png')
plot(prune.repayment.threeyear )
text(prune.repayment.threeyear, pretty =0)
dev.off()
