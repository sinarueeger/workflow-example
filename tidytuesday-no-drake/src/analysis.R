###########################################################################
###########################################################################
###                                                                     ###
###                         TIDYTUESDAY WEEK 24                         ###
###                            CATS VS. DOGS                            ###
###                                                                     ###
###########################################################################
###########################################################################

library(ggplot2)
library(magrittr)
library(readr)
library(dplyr)

##////////////////////////////////////////////////////////////////
##                             Data                             //
##////////////////////////////////////////////////////////////////

## download file
download.file("https://raw.github.com/rfordatascience/tidytuesday/master/data/2018-09-11/cats_vs_dogs.csv", here::here("data", "cats_vs_dogs.csv"))

## read in file
dat <- readr::read_csv(here::here("data", "cats_vs_dogs.csv"))

##////////////////////////////////////////////////////////////////
##                             Tidy                             //
##////////////////////////////////////////////////////////////////

dat <- dat %>% mutate(state = tolower(state))

##///////////////////////////////////////////////////////////////
##                          Transform                          //
##///////////////////////////////////////////////////////////////

##--------------
##  add diff  --
##--------------

dat <- dat %>% mutate(ratio_avg_per_household = avg_cats_per_household/avg_dogs_per_household, ratio_population = cat_population/dog_population)


##-------------------------
##  add geospatial data  --
##-------------------------

## get coordinate data
coord_states <- ggplot2::map_data("state") %>% rename(state = region)

## add geo coordinates for each state
dat <- left_join(dat, coord_states %>% select(-subregion), by = "state") 

## sanity check
stopifnot(nrow(dat %>% filter(is.na(lat))) == 0)

##///////////////////////////////////////////////////////////////
##                          Visualise                          //
##///////////////////////////////////////////////////////////////

ggplot(data = dat) + 
  geom_polygon(aes(x = long, y = lat, fill = ratio_population, group = state)) + 
  coord_fixed(1.3) +
  scale_fill_gradient2("#Cats/#Dogs", midpoint = 1, low = "#2166ac", high = "#b2182b") + 
  theme_void() + 
  theme(legend.position = "top")

#ggplot(data = dat) + 
#  geom_polygon(aes(x = long, y = lat, fill = ratio_avg_per_household, group = state)) + 
#  coord_fixed(1.3) +
#  scale_fill_gradient2("Avg #Cats/HH / Avg#Dogs/HH",  midpoint = 1) +
#  theme_void() + 
#  theme(legend.position = "top")
