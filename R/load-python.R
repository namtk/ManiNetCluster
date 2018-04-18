# library(reticulate)
# use_python("/home/dnguyen/anaconda3/bin/python")
# 
# Load the module and create dummy objects from it, all of which are NULL
pyManifold <- reticulate::import_from_path(
  "pyManifold",
  file.path("inst", "python")
)
for (obj in names(pyManifold)) {
  assign(obj, NULL)
}
# Clean up
rm(pyManifold)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  pyManifold <- reticulate::import_from_path(
    "pyManifold",
    system.file("python", package = packageName()),
    # delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(pyManifold)) {
    assignInMyNamespace(obj, pyManifold[[obj]])
  }
}
