# Load the module and create dummy objects from it, all of which are NULL
neighborhood <- reticulate::import_from_path(
  "neighborhood",
  file.path("inst", "python")
)
for (obj in names(neighborhood)) {
  assign(obj, NULL)
}
# Clean up
rm(neighborhood)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  neighborhood <- reticulate::import_from_path(
    "neighborhood",
    system.file("python", package = packageName()),
    delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(neighborhood)) {
    assignInMyNamespace(obj, neighborhood[[obj]])
  }
}
