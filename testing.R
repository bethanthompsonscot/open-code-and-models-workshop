penguins %>% dim()

penguins %>% 
  drop_empty_rows() %>% 
  dim()

df_a <- penguins %>% 
  drop_empty_rows() %>% 
  drop_na_penguins() 

df_b <- penguins %>% 
  drop_empty_rows() %>% 
  impute_sex_by_mass() 

a <- plot_mass_by_sex(penguins, "Test Plot")
b <- plot_mass_by_sex(penguins, "Test Plot 2")

make_comparison_figure(df_a, df_b)
