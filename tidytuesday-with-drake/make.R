###########################################################################
###########################################################################
###                                                                     ###
###                         TIDYTUESDAY WEEK 24                         ###
###                            CATS VS. DOGS                            ###
###                                                                     ###
###########################################################################
###########################################################################


##--------------
##  setup     --
##--------------

source(here::here("src", "setup.R"))
source(here::here("src", "functions.R"))
## download data -----------
download.file("https://raw.github.com/rfordatascience/tidytuesday/master/data/2018-09-11/cats_vs_dogs.csv", "cats_vs_dogs.csv")

##--------------
##  plan     --
##--------------

plan <- drake_plan(
  ## read in data ------------
  raw_data = readr::read_csv(file_in("cats_vs_dogs.csv")) %>% mutate(state = tolower(state)),
  
  ## transform data ----------
  data = raw_data %>% mutate(ratio_avg_per_household = avg_cats_per_household/avg_dogs_per_household, ratio_population = cat_population/dog_population),
  
  ## get coordinates ---------
  coord_states = ggplot2::map_data("state") %>% rename(state = region),
  
  ## add geo coordinates for each state
  data_with_states = left_join(data, coord_states %>% select(-subregion), by = "state"),
  
  ## summarise ---------------
  summary_cats_and_dogs = skimr::skim(data %>% select(state, n_households:ratio_population)),
  
  ## plots -------------------
  
  plots_cats_and_dogs = purrr::map(data_with_states %>% select(n_households:ratio_population) %>% names(),  ~map_cats_and_dogs(., data_with_states)),
 
  ## report ------------------ 
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)



##------------------------
##  drake functions     --
##------------------------


config <- drake_config(plan) 
vis_drake_graph(config) 

# run the plan 
make(plan)


config <- drake_config(plan) 
vis_drake_graph(config) 

## remove results
clean()
