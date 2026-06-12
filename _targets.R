# packages needed to run targets pipeline
library(targets)
library(tarchetypes)

# Set target options:
# Packages that your targets need for their tasks i.e. whatever you used to create your functions 
tar_option_set(
  packages = c("tidyverse", "visNetwork", "cowplot") 
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source("scripts")

# Replace the target list below with your own:
list(
  # creates a file path
  tar_target(penguins_file, "data/penguins.csv", format = "file"),
  # reads data from the file path and stores as .rds
  # 1) look at the read_penguins function in functions
  # 2) tar_glimpse() to see the network
  # 3) load the data and inspect in workshop.R
  tar_target(penguins, read_penguins(penguins_file)) 
  # apply drop_na function for penguin sex (Bethan)
  
  # apply impute function for penguin sex (Dan)
  
  # create plot side by side using the two different dfs (Bethan)
  
  # save plot 
  #tar_target(
    #comparison_file,
    #ggsave("plots/comparison.png", figure_1,
           #width = 10, height = 5, dpi = 300),
    #format = "file"
  #)
)
