all: data/data-merged.RData data/results.RData report/report.pdf

clean:
	rm -f data/data-merged.RData data/results.RData report/report.pdf report/report.tex

data/data-merged.RData: code/A_dataprep.R
	Rscript $<
	
data/results.RData: code/B_fit.R data/data-merged.RData
	Rscript $<
	
report/report.html: report/report.Rmd data/data-merged.RData data/results.RData
	Rscript -e 'rmarkdown::render("$<")'
