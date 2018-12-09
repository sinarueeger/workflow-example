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
download.file("https://raw.github.com/rfordatascience/tidytuesday/master/data/2018-09-11/cats_vs_dogs.csv", "cats_vs_dogs.csv")

source(here::here("src", "setup.R"))
source(here::here("src", "functions.R"))


##--------------
##  plan     --
##--------------

plan <- drake_plan(
  raw_data = readr::read_csv(file_in("cats_vs_dogs.csv")) %>% 
    mutate(state = tolower(state)) %>%
    select(-X1),
  data = raw_data %>% 
    mutate(ratio_avg_per_household = avg_cats_per_household/avg_dogs_per_household, ratio_population = cat_population/dog_population),
  coord_states = ggplot2::map_data("state") %>% rename(state = region),
  data_with_states = left_join(data, coord_states %>% select(-subregion), by = "state"),
  summary_cats_and_dogs = skimr::skim(data %>% select(state, n_households:ratio_population)),
  #plots_cats_and_dogs = purrr::map(data_with_states %>% select(n_households:ratio_population) %>% names(),  ~map_cats_and_dogs(., data_with_states)),
  plots_cats_and_dogs = map_cats_and_dogs("ratio_population", data_with_states),
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
