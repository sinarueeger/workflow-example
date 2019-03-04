
## Model fitting
## ///////////////////////////


load(file = here::here("results", "data-merged.RData"), verbose = TRUE)

library(dplyr)
library(broom)
## !!!! these are a super simplified model and most likely wrong! E.g. height should be transformed, and other covariates should be added.

## simple lm
## ----------------------

fit <- step(lm(height ~ . - id - height_class, data = dat),  trace = 0)
fit.simple <- tidy(fit)

## multiple lm
## ----------------------
dfFitHeight <- dat.long %>% select(-height_class) %>% group_by(genotype) %>%
    do(fit = lm(height ~ dosage, data = .)) 
fit.multiple <- tidy(dfFitHeight, fit)

## save this as an RData file
## ----------------------
save(fit.simple, fit.multiple, file = here::here("results", "results.RData"))
