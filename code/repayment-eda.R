repayment <- read.csv(file = '../data/repayment.csv', header = TRUE, na.strings = c("NULL","PrivacySuppressed"), stringsAsFactors = FALSE)

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
# Both of them are suginificant

repayment.threeyear = subset(repayment, select= RPY_3YR_RT:NOTFIRSTGEN_RPY_3YR_RT)
png('../images/three-year-repayment-by-categories.png')
par(mar = c(12, 3.1, 0.1, 1.5))
par(cex= 0.55)
boxplot(repayment.threeyear, las=2)
dev.off()
# three year repayment plot displays the similar result 