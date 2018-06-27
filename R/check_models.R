#' Check models
#' Check which models and which RCP scenarios are available for download
#'
#' @return data.frame
#' @export
#'
#' @examples
#' library(climatedata)
#' check_models()
check_models <- function()
{
  path <- system.file(package="climatedata")
  scenarios <- readRDS(file.path(path, "data/available_scenarios.rds"))
  return(scenarios)
}

