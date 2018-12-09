
library(drake)
library(ggplot2)
library(magrittr)
library(readr)
library(dplyr)
library(stringr)
library(purrr)
pkgconfig::set_config("drake::strings_in_dots" = "literals") # New file API


map_cats_and_dogs <- function(data) {
  
  qp <- ggplot(data = data) +
    geom_polygon(aes_string(
      x = "long",
      y = "lat",
      fill = "ratio_population",
      group = "state"
    )) +
    coord_fixed(1.4) + 
    theme_void() +
    theme(legend.position = "top")
  
  ## add scale
  # if (str_detect(variable, "ratio")) {
  scale_to_add <- scale_fill_gradient2(midpoint = 1,
                                       low = "#2166ac",
                                       high = "#b2182b") 
  # } else {
  #   scale_to_add <- scale_fill_gradient(low = "white", high = "#2166ac")
  
  #}
  
  qp <- qp + scale_to_add
  
  return(qp)
  
}




