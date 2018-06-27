<!-- README.md is generated from README.Rmd. Please edit that file -->
climatedata package
===================

Working with climatedata
------------------------

To install the package run:

------------------------------------------------------------------------

This package currently contains one function for downloading [CHELSA climate data](http://chelsa-climate.org/). It can download current and future scenarios for bioclim data. Other variables and other climate datasets should be implemented later.

*Important* - `get_chelsa()` function only works on UNIX system with 7z installed. Figure out how to unzip .7z files without using external software (if possible).

To retrieve [WorldClim data](http://worldclim.org/), use [`raster::getData()`](https://www.rdocumentation.org/packages/raster/versions/2.6-7/topics/getData) function.

Note to self: there was some activity related with this in "<https://github.com/gndaskalova/grabr>", but the project isn't going anywhere now it seems...
