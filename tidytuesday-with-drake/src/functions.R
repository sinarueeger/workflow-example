
#' Map cats and dog data
#'
#' @param variable variable name to represent the \code{fill} of the map
#' @param data dataset that contains the variable names long, lat, state and variable.
#'
#' @return ggplot2 object

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

