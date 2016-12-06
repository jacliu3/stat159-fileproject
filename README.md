# STAT 159 - fall-2016 final project

This repository holds the final project for the fall 2016 Statistics 159 at UC Berkeley --  College Student Loan Default Risk Modeling.

This project is about applying computational toolkit R and following the rule of scientific reproducibility to perform a complete modeling process on *College Scorecard* dataset (by U.S Department of Education) at https://collegescorecard.ed.gov/data/

The report of this project can be found in this directory:
```
stat159-final-project/
	.gitignore
	README.md
	LICENSE
	Makefile
	session-info.txt
	session.sh                    
	code/
		README.md
	  	...
	data/
		...
	images/
		...
	report/
		report.Rmd
		report.pdf
		sections/
			...
	shiny/
		...
```

###If you want to recreate our analysis and report, you can:
1. git clone the repository or download it.
2. In your terminal,`cd` into directory
3. Run the Makefile in terminal by typing command `make clean` in order to remove old report
4. Type `make` in terminal again and then it will execute all scripts and get all output such as `report.pdf`.

Additional make commands include:

data: downloads the Most-Recent-Cohorts-All-Data-Elements.csv file into data subdirectory 

report: generates the report.pdf file from the various sections

slides: generates the slides.Rmd

session: generates the session-info.txt file

clean: delete report pdf and html

clean-data: run data cleaning R scripts

preprocess: run data cleaning R scripts

logistic: run logistic regression script

gbm: run gbm script

models: run both logistic and gbm scripts


Author: Jacqueline Liu, Steven Chen, Zhongling Jiang

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>. 

All source code (i.e. code in R script files) is licensed under GNU General Public License, version 3. See the LICENSE file for more information
