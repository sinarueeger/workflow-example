
read_gt_data <- function(path)
{
  readr::read_delim(path, delim = " ")
}

read_gtinfo_data <- function(path)
{
  readr::read_tsv(path, col_names = FALSE)
}

read_pheno_data <- function(path)
{
  readr::read_delim(path, delim = " ")
}


plot_genotype_phenotype <- function(data) {
  ggplot(data = data) + 
    geom_boxplot(aes(dosage, height, group = dosage)) + 
    facet_wrap(~genotype) + 
    theme_bw()
}