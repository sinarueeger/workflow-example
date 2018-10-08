
## for a basic example run 
## drake::drake_example("main")
## for other examples see
## drake::drake_examples()

library(drake)
library(tidyverse)
library(broom)
library(here)
pkgconfig::set_config("drake::strings_in_dots" = "literals")

## if you need to rerun everything
## drake::clean(destroy = TRUE)

## create softlinks for data
## ---------------------------

fs::link_create(here("..", "data", "genotyping_data_subset_train.bim"), "genotyping_data_subset_train.bim")
fs::link_create(here("..", "data", "genotyping_data_subset_train.raw"), "genotyping_data_subset_train.raw")
fs::link_create(here("..", "data", "training_set_details.txt"), "training_set_details.txt")

## check supporting files
## -------------------------

file.exists(here("..", "src", "functions.R"))
file.exists("raw_data.xlsx")
file.exists("report.Rmd")

# Your custom code is a bunch of functions.
## -------------------------

source(here("..", "src", "functions.R"))

# The workflow plan data frame outlines what you are going to do.

plan <- drake_plan(
  dat.gt.raw = read_gt_data("genotyping_data_subset_train.raw"),
  dat.gt.info.raw = read_gtinfo_data(glue::glue("genotyping_data_subset_train.bim")),
  dat.gt.info = dat.gt.info.raw %>%
    rename(chr = X1, snp = X2, pos = X4, A_minor = X5, A_major = X6) %>% select(-X3),
  dat.gt = dat.gt.raw %>% select(-FID, -MAT, -PAT, -SEX, -PHENOTYPE) %>% rename(id = IID) %>% select_at(vars(-ends_with('HET'))),
  dat.pheno = read_pheno_data(glue::glue("training_set_details.txt")),
  dat = full_join(dat.gt, dat.pheno),
  dat.long = tidyr::gather(dat, genotype, dosage, -c(id, height, height_class)), 
  plot = plot_genotype_phenotype(data = dat.long), 
  fit.multiple = lm_multiple_height(dat),
  fit.simple = lm_simple_height(dat.long),
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.pdf"),
    quiet = TRUE
  )
)


## check graph
## -----------
config <- drake_config(plan) 
vis_drake_graph(config) 

# run the plan 
## ---------------
make(plan)


## check graph
## -----------

config <- drake_config(plan) 
vis_drake_graph(config) 


## unlink files again
## ----------------------
fs::link_delete("genotyping_data_subset_train.bim")
fs::link_delete("genotyping_data_subset_train.raw")
fs::link_delete("training_set_details.txt")


