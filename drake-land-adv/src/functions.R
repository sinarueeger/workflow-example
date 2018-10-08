
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
    theme_bw() + 
    xlab("genotype dosage") + 
    scale_x_continuous(breaks = c(0, 1, 2)) ## pretty x labels
}


## these are a super simplified model and most likely wrong! E.g. height should be transformed, and other covariates should be added.

lm_multiple_height <- function(data)
{
  fit <- step(lm(height ~ . - id - height_class, data = data),  trace = 0)
  return(tidy(fit))
}
  
lm_simple_height <- function(data.long)
{
  dfFitHeight <- data.long %>% select(-height_class) %>% group_by(genotype) %>%
    do(fit = lm(height ~ dosage, data = .)) 
  
  dfFitCoef <- tidy(dfFitHeight, fit)
  return(dfFitCoef)
  
}
