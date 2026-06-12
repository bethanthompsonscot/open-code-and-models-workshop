# Penguins Pipeline

A reproducible [`targets`](https://docs.ropensci.org/targets/) pipeline that cleans
penguin morphometric data, handles missing values two different ways, and produces a
side-by-side comparison figure. Built as a workshop demonstration of reproducible
analysis in R.

## What it does

The pipeline reads the penguins dataset and compares two strategies for handling
missing `sex` values:

- **Drop** — remove rows where `sex` is missing.
- **Impute** — fill missing `sex` using a per-species body-mass rule (heavier
  individuals classified male, lighter female, with the threshold learned per species).

Both cleaned datasets are plotted side by side so the effect of each choice is visible
in a single publication-ready figure.

## Data

> **We pretend that the data is confidential since many of us work with data that cannot be shared and is not included in this repository.**

The `data/` folder is intentionally excluded from version control. To run the pipeline
you must obtain `penguins.csv` separately (through the usual secure channel) and place
it at:

```
data/penguins.csv
```

The pipeline expects the following columns: `species`, `island`, `bill_len`,
`bill_dep`, `flipper_len`, `body_mass`, `sex`, `year`.

## Setup

This project uses [`renv`](https://rstudio.github.io/renv/) to pin exact package
versions, so everyone runs the same environment.

1. **Clone the repository** and open the `.Rproj` file in RStudio.
2. **Restore the packages** — renv activates automatically on open; then run:
   ```r
   renv::restore()
   ```
   This installs the exact package versions recorded in `renv.lock`.
3. **Add the data** — place `penguins.csv` in the `data/` folder (see above).
4. **Create the data and plots folders** as these won't exist. Code example below, or do this manually.
   ```r
   dir.create("plots", showWarnings = FALSE)
   ```

## Running the pipeline

```r
library(targets)

tar_make()          # build everything (or just what's out of date)
```

Useful commands while exploring:

```r
tar_visnetwork()                 # view the dependency graph
tar_read(comparison_fig)         # load the final figure
tar_read(penguins_drop_df)       # inspect any intermediate target
tar_invalidate(everything())     # force a full rebuild on next tar_make()
```

The finished figure is written to `plots/comparison.png`.

## Project structure

```
.
├── _targets.R          # pipeline definition (targets and their dependencies)
├── scripts/            # custom functions, sourced via tar_source()
├── data/               # confidential input data (NOT in version control)
├── output/             # generated figures
├── renv.lock           # pinned package versions
├── renv/               # renv activation scripts
└── README.md
```

## The pipeline

| Target              | What it does                                          |
|---------------------|-------------------------------------------------------|
| `penguins_file`     | Tracks the input CSV as a file                        |
| `penguins`          | Reads the data                                        |
| `penguins_drop_df`  | Cleaned data with missing-sex rows dropped            |
| `penguins_impute_df`| Cleaned data with missing sex imputed by body mass    |
| `figure_1`          | Side-by-side figure of the two approaches             |
| `comparison_file`   | The figure saved to `output/comparison.png`           |

## Requirements

- R (version recorded in `renv.lock`)
- Packages restored via `renv::restore()` — key ones: `targets`, `tarchetypes`,
  `tidyverse`, `cowplot`, `scales`, `visNetwork`

## Acknowledgements

The approach used here — teaching reproducible `targets` pipelines with the penguins
dataset — was inspired by [Andrew Heiss](https://www.andrewheiss.com/), assistant
professor at Georgia State University, certified RStudio instructor, and a wonderful
source of teaching materials on R, the tidyverse, and reproducible research. Many
thanks for the inspiration.
