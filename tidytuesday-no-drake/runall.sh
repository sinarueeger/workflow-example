#!/bin/bash

Rscript --vanilla src/analysis.R
Rscript --vanilla -e "rmarkdown::render(\"report/report.Rmd\")"
