###########################################################################
###########################################################################
###                                                                     ###
###                         TIDYTUESDAY WEEK 24                         ###
###                            CATS VS. DOGS                            ###
###                                                                     ###
###########################################################################
###########################################################################

source(here::here("src", "setup.R"))

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
dat_with_states <- left_join(dat, coord_states %>% select(-subregion), by = "state") 

## sanity check
stopifnot(nrow(dat_with_states %>% filter(is.na(lat))) == 0)

##///////////////////////////////////////////////////////////////
##                          Summarise                          //
##///////////////////////////////////////////////////////////////

summary_cats_and_dogs <- skimr::skim(dat %>% select(state, n_households:ratio_population))

##///////////////////////////////////////////////////////////////
##                          Visualise                          //
##///////////////////////////////////////////////////////////////

#' Map cats and dog data
#'
#' @param variable variable name to represent the \code{fill} of the map
#' @param data dataset that contains the variable names long, lat, state and variable.
#'
#' @return ggplot2 object
#'
#' @examples
#' map_cats_and_dogs("ratio_population", dat_with_states)
#' 
map_cats_and_dogs <- function(variable, data) {
  
  qp <- ggplot(data = data) +
    geom_polygon(aes_string(
      x = "long",
      y = "lat",
      fill = variable,
      group = "state"
    )) +
    coord_fixed(1.3) + 
    theme_void() +
    theme(legend.position = "top")
  
  ## add scale
  if (str_detect(variable, "ratio")) {
    scale_to_add <- scale_fill_gradient2(midpoint = 1,
                                      low = "#2166ac",
                                      high = "#b2182b") 
  } else {
    scale_to_add <- scale_fill_gradient(low = "white", high = "#2166ac")
    
  }

  qp <- qp + scale_to_add
    
  return(qp)
  
}


plots_cats_and_dogs <- purrr::map(dat_with_states %>% select(n_households:ratio_population) %>% names(),  ~map_cats_and_dogs(., dat_with_states))


##///////////////////////////////////////////////////////////////
##                       SAVE RESULTS                          //
##///////////////////////////////////////////////////////////////

save(summary_cats_and_dogs, plots_cats_and_dogs, file = here::here("data", "results_cats_and_dogs.RData"))
