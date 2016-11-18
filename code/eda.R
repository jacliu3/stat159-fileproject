Most.Recent.Cohorts.All.Data.Elements <- read.csv("~/stats_159/stat159_final_project/data/Most-Recent-Cohorts-All-Data-Elements.csv", stringsAsFactors=FALSE)
dim(Most.Recent.Cohorts.All.Data.Elements)
Financial.Aid <- Most.Recent.Cohorts.All.Data.Elements[,c(395,438,1504:1537,1605,1709:1711)]

save(Financial.Aid, Most.Recent.Cohorts.All.Data.Elements, file = '../../data/Financial_aid.RData')
