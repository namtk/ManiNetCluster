library(reticulate)
use_python("/home/dnguyen/anaconda3/bin/python")

nmspaceLoad <- function(name) {
  # Load the module and create dummy objects from it, all of which are NULL
  py_module <- reticulate::import_from_path(
    name,
    file.path("inst", "python")
  )
  for (obj in names(py_module)) {
    assign(obj, NULL)
  }
  # Clean up
  rm(py_module)
  
  # Now all those names are in the namespace, and ready to be replaced on load
  .onLoad <- function(libname, pkgname) {
    py_module <- reticulate::import_from_path(
      name,
      system.file("python", package = packageName()),
      delay_load = TRUE
    )
    # assignInMyNamespace(...) is meant for namespace manipulation
    for (obj in names(py_module)) {
      assignInMyNamespace(obj, py_module[[obj]])
    }
  }
}

allfilenames <- c("kmedoids", "distance", "neighborhood", "util", "alignment", "correspondence",
              "dtw", "embedding", "viz", "warping")
lapply(allfilenames, nmspaceLoad)
