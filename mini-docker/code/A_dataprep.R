## Data cleaning
## ///////////////////////////

source("code/functions.R")
library(glue)
library(dplyr)

## get all the data
## -----------------

dat.gt.raw <- read_gt_data("data/genotyping_data_subset_train.raw")

dat.gt.info.raw <- read_gtinfo_data(glue::glue("data/genotyping_data_subset_train.bim"))

dat.pheno <- read_pheno_data(glue::glue("data/training_set_details.txt"))

## prepare the gt and the gt.info data
## -----------------

dat.gt.info <- dat.gt.info.raw %>%
  dplyr::rename(chr = X1, snp = X2, pos = X4, A_minor = X5, A_major = X6) %>% dplyr::select(-X3)

dat.gt <- dat.gt.raw %>% dplyr::select(-FID, -MAT, -PAT, -SEX, -PHENOTYPE) %>% dplyr::rename(id = IID) %>% dplyr::select_at(vars(-ends_with('HET')))

## join the gt and pheno data
## ---------------------------

dat <- dplyr::full_join(dat.gt, dat.pheno)

## turn dat from wide to long
## ---------------------------

dat.long <- tidyr::gather(dat, genotype, dosage, -c(id, height, height_class))

## save this as an RData file
## ---------------------------
if(!dir.exists("results")) dir.create("results")

save(dat, dat.long, file = here::here("results", "data-merged.RData"))
