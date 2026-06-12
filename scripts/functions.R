read_penguins <- function(x) {
  read_csv(x, col_types = cols())
}

# choose to drop any NA values
drop_empty_rows <- function(df) {
  df %>%
    filter(!if_all(
      c(bill_len, bill_dep, flipper_len, body_mass, sex),
      is.na
    ))
}

# option 1 choose to drop where sex is NA (Bethan)

drop_na_penguins <- function(df) {
  df %>% 
    drop_na(sex)
}

# option 2 choose to impute  NA sex values

impute_sex_by_mass <- function(df) {
  
  thresholds <- df %>%
    filter(!is.na(sex), !is.na(body_mass)) |>
    group_by(species, sex) |>
    summarise(mean_mass = mean(body_mass), .groups = "drop") |>
    pivot_wider(names_from = sex, values_from = mean_mass) |>
    mutate(threshold = (female + male) / 2) |>
    select(species, threshold)
  
  df %>%
    left_join(thresholds, by = "species") |>
    mutate(
      guess = if_else(body_mass >= threshold, "male", "female"),
      sex   = coalesce(as.character(sex), guess)
    ) %>%
    select(-threshold, -guess)
}


# Make one boxplot of body mass by sex, faceted/coloured by species
plot_mass_by_sex <- function(x, title) {
  ggplot(x, aes(x = sex, y = body_mass, fill = sex)) +
    # raw data behind the summary — readers trust what they can see
    geom_jitter(aes(colour = sex),
                width = 0.18, alpha = 0.35, size = 1.1, show.legend = FALSE) +
    geom_boxplot(width = 0.5, alpha = 0.85,
                 outlier.shape = NA, colour = "grey25") +
    facet_wrap(~ species) +
    scale_fill_manual(values = c(female = "#1B9E77", male = "#D95F02")) +
    scale_colour_manual(values = c(female = "#1B9E77", male = "#D95F02")) +
    scale_y_continuous(labels = scales::label_number(scale = 1e-3, suffix = "k")) +
    labs(title = title, x = NULL, y = "Body mass (g)") +
    theme_minimal(base_size = 13) +
    theme(
      legend.position   = "none",
      plot.title        = element_text(face = "bold", size = 13, margin = margin(b = 8)),
      strip.text        = element_text(face = "bold", size = 11),
      strip.background  = element_rect(fill = "grey95", colour = NA),
      panel.grid.minor  = element_blank(),
      panel.grid.major.x = element_blank(),
      axis.title.y      = element_text(margin = margin(r = 8)),
      plot.margin       = margin(10, 14, 10, 10)
    )
}

# Combine the two cleaned datasets into one side-by-side figure
make_comparison_figure <- function(dropped, imputed) {
  p_drop   <- plot_mass_by_sex(dropped, "Dropped missing sex")
  p_impute <- plot_mass_by_sex(imputed, "Imputed missing sex")
  
  cowplot::plot_grid(
    p_drop, p_impute,
    labels = c("A", "B"),
    nrow = 1
  )
}
