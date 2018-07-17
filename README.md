<!-- README.md is generated from README.Rmd. Please edit that file -->
climatedata package
===================

Working with climatedata
------------------------

To install the package run:

``` r
devtools::install_github("mirzacengic/climatedata")
```

#### List of functions:

-   `get_chelsa()` -- download current or future climatic layers for CHELSA climate.
-   `check_models()` -- retrieve a list of available models and RCP scenarios for future climate.

**NOTE:** This package relies on the [archive package](https://github.com/jimhester/archive) for extracting 7zip files. This package is not available on CRAN, so please install the development version in order to use `climatedata` package.

``` r
devtools::install_github("jimhester/archive")
```

Usage:
------

``` r
library(climatedata)
library(tidyverse)
library(archive)
# Get models with all 4 RCP scenarios
models_all_rcp <- check_models() %>% 
group_by(model) %>%
  mutate(n = n()) %>%
  ungroup() %>%
  filter(n == 4) %>%
  distinct(model) %>%
  pull()

my_output_directory <- "/vol/milkunarc/mcengic/Data_RAW/CHELSA/Future_2050"


chelsa_bioclim <- get_chelsa(output_dir = my_output_directory, period = "future",
                             future_years = "2041-2060", scenario_string = "rcp85",
                             model_string = models_all_rcp, return_raster = FALSE)
```

------------------------------------------------------------------------

This package currently contains one function for downloading [CHELSA climate data](http://chelsa-climate.org/). It can download past, current, and future scenarios for bioclim data. Other variables and other climate datasets will be implemented later.

~~**Important** - `get_chelsa()` function only works on UNIX system with 7z installed. Figure out how to unzip .7z files without using external software (if possible).~~

Meanwhile, `get_chelsa()` function was updated to use `archive::archive_extract()` function.

To retrieve [WorldClim data](http://worldclim.org/), use [`raster::getData()`](https://www.rdocumentation.org/packages/raster/versions/2.6-7/topics/getData) function.

Note to self: there was some activity related with this in "<https://github.com/gndaskalova/grabr>", but the project isn't going anywhere now it seems...
