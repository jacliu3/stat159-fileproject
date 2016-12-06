# Variables
DATAURL = https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-All-Data-Elements.csv
CSV = data/Most-Recent-Cohorts-All-Data-Elements.csv
DATAR = code/data-extraction.R code/data-cleaning.R
LABEL = code/label.R code/repayment-eda.R

# Targets
.PHONY: data clean-data preprocess logistic gbm models report slides clean session


data:
	curl $(DATAURL) --output $(CSV)

clean-data: data $(DATAR)
	Rscript $(DATAR)

preprocess: data $(LABEL)
	Rscript $(LABEL)

logistic: code/logistic-regression.R clean-data
	Rscript $<

gbm: code/gbm.R clean-data
	Rscript $<

models: gbm logistic

report: models report/report.Rnw report/sections/*.Rnw
	R CMD Sweave report/report.Rnw

slides: slides/slides.Rmd
	Rscript -e "library(rmarkdown); render('slides/slides.Rmd')"

clean:
	rm -f report/report.pdf
	rm -f report/report.html

session:
	bash session.sh


