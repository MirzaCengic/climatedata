#' Get CHELSA climate data
#'
#' Download data from CHELSA climatologies. This function retrieves files from the server via dowload request.
#' \strong{NOTE:} If CHELSA files already exist in \code{output_dir}, they will be loaded instead.
#' Specify other folder or remove the files to download them. Currently the function only works on UNIX with 7zip installed and added in PATH!
#'
#'
#' @param type Character. Currently only "bioclim".
#' @param layer Numeric. Select which bioclim layer(s) is/are downloaded.
#' You can choose to download any of 19 bioclimatic layers.
#' To download bioclim layer 1, use \code{layer = 1}, or use \code{layer = 1:19}to download all layers as a rasterstack. . See details \strong{ADD LATER!}
#' @param period Character. Which time period to download for climate layers. One in c("current", "future").
#'
#' @param model_string Character. Which climatic model to download for future period. Only available if \code{period} = "future".
#' Available options are c("ACCESS1-0", "BNU-ESM", "CCSM4", "CESM1-BGC", "CESM1-CAM5", "CMCC-CMS", "CMCC-CM",
#' "CNRM-CM5", "CSIRO-Mk3-6-0", "CanESM2", "FGOALS-g2", "FIO-ESM", "GFDL-CM3", "GFDL-ESM2G",
#' "GFDL-ESM2M", "GISS-E2-H-CC", "GISS-E2-H", "GISS-E2-R-CC", "GISS-E2-R", "HadGEM2-AO", "HadGEM2-CC",
#' "IPSL-CM5A-LR", "IPSL-CM5A-MR", "MIROC-ESM-CHEM", "MIROC-ESM", "MIROC5", "MPI-ESM-LR",
#' "MPI-ESM-MR", "MRI-CGCM3", "MRI-ESM1", "NorESM1-M", "bcc-csm1-1", "inmcm4")
#'
#' @param scenario_string Character. Which RCP scenario to download. Available options are c("rcp26", "rcp45", "rcp60", "rcp85").
#'
#' @param future_years Character. Which time period to download for future scenario.
#' Available options are c("2041-2060", "2061-2080") for years 2050 and 2070.
#' @param output_dir Directory where the output is stored. Files are downloaded to a temporary file
#' !!CHANGE LATER TO outdir ONE!!, and extracted to the directory. If some of the downloaded files
#' already exist in the folder, they will be loaded instead. Delete the files from the folder manually to download again
#'
#' @param temp_dir Directory in which the temporarily downloaded files will be stored. Default is \code{temp_dir} = tempdir().
#' @param tmp_keep Logical. Should the temporary files be deleted after unzipping. Default is FALSE (files are deleted by default).
#' @param return_raster Logical. Should the function attempt to load the downloaded files into a RasterStack.
#' Default is TRUE. Otherwise NULL.
#' @param load_old Logical. If TRUE, function will try to load files in the output_dir. Experimental. Default is FALSE.
#'
#' @return Raster* object or NULL. See \code{return_raster} argument.
#' @export
#'
#' @examples
#' output_dir <- milkunize("Projects/Crete/data-raw/Chelsa")
#' chelsa_bioclim <- get_chelsa(layer = 1:19, output_dir = output_dir)
#' @importFrom fs file_temp
#' @importFrom raster raster stack

get_chelsa <- function(type = "bioclim", layer, period, model_string, scenario_string, future_years,
                       output_dir, temp_dir = tempdir(), tmp_keep = FALSE, return_raster = TRUE, load_old = FALSE)
{
  # Argument checking - fail if one of 19 layers isn't requested
  stopifnot(layer %in% 1:19, type == "bioclim", period %in% c("current", "future"))

  if (period == "future")
  {
    stopifnot(future_years %in% c("2041-2060", "2061-2080"), scenario_string %in% c("rcp26", "rcp45", "rcp60", "rcp85"),
              model_string %in% c("ACCESS1-0", "BNU-ESM", "CCSM4", "CESM1-BGC", "CESM1-CAM5", "CMCC-CMS", "CMCC-CM",
                                  "CNRM-CM5", "CSIRO-Mk3-6-0", "CanESM2", "FGOALS-g2", "FIO-ESM", "GFDL-CM3", "GFDL-ESM2G",
                                  "GFDL-ESM2M", "GISS-E2-H-CC", "GISS-E2-H", "GISS-E2-R-CC", "GISS-E2-R", "HadGEM2-AO", "HadGEM2-CC",
                                  "IPSL-CM5A-LR", "IPSL-CM5A-MR", "MIROC-ESM-CHEM", "MIROC-ESM", "MIROC5", "MPI-ESM-LR",
                                  "MPI-ESM-MR", "MRI-CGCM3", "MRI-ESM1", "NorESM1-M", "bcc-csm1-1", "inmcm4"))
  }


  # Check if files already exist in the folder
  if (load_old)
  {
    if (length(list.files(output_dir, pattern = "CHELSA_bio10_*.*.tif", full.names = TRUE)) > 0)
    {
      raster_stack <- raster::stack(list.files(output_dir, pattern = "CHELSA_bio10_*.*.tif", full.names = TRUE))
      return(raster_stack)
    }
  }

  layerf <- sprintf("%02d", layer)
  # Check if input is correct
  stopifnot(layerf %in% sprintf("%02d", 1:19))

  # Loop over layers - download, unzip and remove zipped file (only bioclim for now)
  if (period == "current")
  {
    for (i in layerf)
    {
      layer_url <- paste0("https://www.wsl.ch/lud/chelsa/data/bioclim/integer/CHELSA_bio10_", i, "_land.7z")

      temporary_file <- fs::file_temp(ext = ".7z", tmp_dir = temp_dir)
      download.file(layer_url, temporary_file)

      unzip_call <- paste0('7z e -o', output_dir," ", temporary_file)
      system(unzip_call)
      # Delete temporary files if tmp_keep argument
      if (!tmp_keep)
      {
        fs::file_delete(temporary_file)
      }
    }
  }

  # Download CHELSA climate data for future years
  if (period == "future")
  {
    for (future_y in future_years) # Loop over the future years
    {
      for (scenario_s in scenario_string) # Loop over RCP scenarios
      {
        for (model_s in model_string) # Loop over climate models
        {
          for (i in layerf) # Loop over bioclim layers
          {

            layer_url <- paste0("https://www.wsl.ch/lud/chelsa/data/cmip5/", future_y, "/bioclim/",
                                "CHELSA_bio_mon_", model_s, "_", scenario_s, "_r1i1p1_g025.nc_",
                                i, "_", future_y, ".7z")
            print(layer_url)
            temporary_file <- fs::file_temp(ext = ".7z", tmp_dir = temp_dir)
            download.file(layer_url, temporary_file)

            unzip_call <- paste0('7z e -o', output_dir," ", temporary_file)
            system(unzip_call)
            if (!tmp_keep)
            {
              fs::file_delete(temporary_file)
            }
          } # Bioclim layer closing
        } # Model string closing
      } # Scenario string closing
    } # Future years closing
  } # Period closing

  # Return raster stack if specified (check if it works with many many future data)
  if (return_raster)
  {
    raster_stack <- raster::stack(list.files(output_dir, pattern = "CHELSA_bio10_*.*.tif", full.names = TRUE))
    return(raster_stack)
  } else {
    return(NULL) # Should this be NULL or something else
  }
}
