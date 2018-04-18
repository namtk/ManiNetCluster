library(reticulate)
use_python("/home/dnguyen/anaconda3/bin/python")

##############################################################################
# Load the module and create dummy objects from it, all of which are NULL
kmedoids <- reticulate::import_from_path(
  "kmedoids",
  file.path("inst", "python")
)
for (obj in names(kmedoids)) {
  assign(obj, NULL)
}
# Clean up
rm(kmedoids)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  kmedoids <- reticulate::import_from_path(
    "kmedoids",
    system.file("python", package = packageName()),
    delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(kmedoids)) {
    assignInMyNamespace(obj, kmedoids[[obj]])
  }
}

##############################################################################
# Load the module and create dummy objects from it, all of which are NULL
distance <- reticulate::import_from_path(
  "distance",
  file.path("inst", "python")
)
for (obj in names(distance)) {
  assign(obj, NULL)
}
# Clean up
rm(distance)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  distance <- reticulate::import_from_path(
    "distance",
    system.file("python", package = packageName()),
    delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(distance)) {
    assignInMyNamespace(obj, distance[[obj]])
  }
}

##############################################################################
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

##############################################################################
# Load the module and create dummy objects from it, all of which are NULL
util <- reticulate::import_from_path(
  "util",
  file.path("inst", "python")
)
for (obj in names(util)) {
  assign(obj, NULL)
}
# Clean up
rm(util)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  util <- reticulate::import_from_path(
    "util",
    system.file("python", package = packageName()),
    delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(util)) {
    assignInMyNamespace(obj, util[[obj]])
  }
}

##############################################################################
# Load the module and create dummy objects from it, all of which are NULL
alignment <- reticulate::import_from_path(
  "alignment",
  file.path("inst", "python")
)
for (obj in names(alignment)) {
  assign(obj, NULL)
}
# Clean up
rm(alignment)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  alignment <- reticulate::import_from_path(
    "alignment",
    system.file("python", package = packageName()),
    delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(alignment)) {
    assignInMyNamespace(obj, alignment[[obj]])
  }
}

##############################################################################
# Load the module and create dummy objects from it, all of which are NULL
correspondence <- reticulate::import_from_path(
  "correspondence",
  file.path("inst", "python")
)
for (obj in names(correspondence)) {
  assign(obj, NULL)
}
# Clean up
rm(correspondence)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  correspondence <- reticulate::import_from_path(
    "correspondence",
    system.file("python", package = packageName()),
    delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(correspondence)) {
    assignInMyNamespace(obj, correspondence[[obj]])
  }
}

##############################################################################
# Load the module and create dummy objects from it, all of which are NULL
dtw <- reticulate::import_from_path(
  "dtw",
  file.path("inst", "python")
)
for (obj in names(dtw)) {
  assign(obj, NULL)
}
# Clean up
rm(dtw)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  dtw <- reticulate::import_from_path(
    "dtw",
    system.file("python", package = packageName()),
    delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(dtw)) {
    assignInMyNamespace(obj, dtw[[obj]])
  }
}

##############################################################################
# Load the module and create dummy objects from it, all of which are NULL
embedding <- reticulate::import_from_path(
  "embedding",
  file.path("inst", "python")
)
for (obj in names(embedding)) {
  assign(obj, NULL)
}
# Clean up
rm(embedding)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  embedding <- reticulate::import_from_path(
    "embedding",
    system.file("python", package = packageName()),
    delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(embedding)) {
    assignInMyNamespace(obj, embedding[[obj]])
  }
}

##############################################################################
# Load the module and create dummy objects from it, all of which are NULL
viz <- reticulate::import_from_path(
  "viz",
  file.path("inst", "python")
)
for (obj in names(viz)) {
  assign(obj, NULL)
}
# Clean up
rm(viz)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  viz <- reticulate::import_from_path(
    "viz",
    system.file("python", package = packageName()),
    delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(viz)) {
    assignInMyNamespace(obj, viz[[obj]])
  }
}

##############################################################################
# Load the module and create dummy objects from it, all of which are NULL
warping <- reticulate::import_from_path(
  "warping",
  file.path("inst", "python")
)
for (obj in names(warping)) {
  assign(obj, NULL)
}
# Clean up
rm(warping)

# Now all those names are in the namespace, and ready to be replaced on load
.onLoad <- function(libname, pkgname) {
  warping <- reticulate::import_from_path(
    "warping",
    system.file("python", package = packageName()),
    delay_load = TRUE
  )
  # assignInMyNamespace(...) is meant for namespace manipulation
  for (obj in names(warping)) {
    assignInMyNamespace(obj, warping[[obj]])
  }
}

##############################################################################

# allfilenames <- c("kmedoids", "distance", "neighborhood", "util", "alignment", "correspondence",
#               "dtw", "embedding", "viz", "warping")
# lapply(allfilenames, nmspaceLoad)
