<!-- README.md is generated from README.Rmd. Please edit that file -->
climatedata package
===================

Working with climatedata
------------------------

To install the package run:

``` r
devtools::install_github("mirzacengic/climatedata")
```

``` r
library(climatedata)
library(tidyverse)

# Get models with all 4 RCP scenarios
models_all_rcp <- check_models() %>% 
group_by(model) %>%
  mutate(n = n()) %>%
  ungroup() %>%
  filter(n == 4) %>%
  distinct(model) %>%
  pull()

output_dir <- "/vol/milkunarc/mcengic/Data_RAW/CHELSA/Future_2050"


chelsa_bioclim <- get_chelsa(layer = 1:19, output_dir = output_dir, period = "future",
                             future_years = "2041-2060", scenario_string = "rcp85",
                             model_string = models_all_rcp, return_raster = FALSE)
```

------------------------------------------------------------------------

This package currently contains one function for downloading [CHELSA climate data](http://chelsa-climate.org/). It can download current and future scenarios for bioclim data. Other variables and other climate datasets should be implemented later.

*Important* - `get_chelsa()` function only works on UNIX system with 7z installed. Figure out how to unzip .7z files without using external software (if possible).

To retrieve [WorldClim data](http://worldclim.org/), use [`raster::getData()`](https://www.rdocumentation.org/packages/raster/versions/2.6-7/topics/getData) function.

Note to self: there was some activity related with this in "<https://github.com/gndaskalova/grabr>", but the project isn't going anywhere now it seems...
