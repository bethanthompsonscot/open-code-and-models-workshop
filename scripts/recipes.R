drop_all_na <- function(df) {
  
  df %>% 
    drop_empty_rows() %>% 
    drop_na_penguins()
}

drop_impute <- function(df) {
  
  df %>% 
    drop_empty_rows() %>% 
    impute_sex_by_mass()
}
