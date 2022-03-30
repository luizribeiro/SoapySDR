########################################################################
# Find SWIG
########################################################################
find_package(SWIG)
message(STATUS "SWIG_FOUND: ${SWIG_FOUND} - ${SWIG_VERSION}")
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

########################################################################
# Find Octave
########################################################################
find_package(Octave)

########################################################################
## Feature registration
########################################################################
include(FeatureSummary)
include(CMakeDependentOption)
cmake_dependent_option(ENABLE_OCTAVE "Enable Octave bindings" ON "ENABLE_LIBRARY;SWIG_FOUND;OCTAVE_FOUND" OFF)
add_feature_info(Octave ENABLE_OCTAVE "Octave bindings v${OCTAVE_VERSION_STRING}")
if (NOT ENABLE_OCTAVE)
    return()
endif()

########################################################################
# Build Module
########################################################################
include(UseSWIG)
