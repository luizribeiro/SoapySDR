########################################################################
# Project setup
########################################################################
cmake_minimum_required(VERSION 3.3)
project(SoapySDROctave CXX)
enable_testing()

find_package(SoapySDR CONFIG REQUIRED)

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
# TODO: https://stackoverflow.com/questions/39355672/cmake-and-mkoctfile, put tests in here
########################################################################
include(UseSWIG)
set(CMAKE_SWIG_FLAGS
    -I${SoapySDR_INCLUDE_DIRS}
    -I${CMAKE_CURRENT_SOURCE_DIR}
    -I${CMAKE_CURRENT_SOURCE_DIR}/..
    -I${CMAKE_CURRENT_BINARY_DIR})

set_source_files_properties(SoapySDR.i PROPERTIES CPLUSPLUS ON)

# TODO: output name SoapySDR
if(${CMAKE_VERSION} VERSION_LESS "3.8")
SWIG_ADD_MODULE(SoapySDROctave octave SoapySDR.i)
else()
SWIG_ADD_LIBRARY(SoapySDROctave LANGUAGE octave SOURCES SoapySDR.i)
endif()

target_include_directories(${SWIG_MODULE_SoapySDROctave_REAL_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${SoapySDR_INCLUDE_DIRS}
    ${OCTAVE_INCLUDE_DIRS})
SWIG_LINK_LIBRARIES(SoapySDROctave SoapySDR ${OCTAVE_LIBRARIES})

set_target_properties(SoapySDROctave PROPERTIES OUTPUT_NAME SoapySDR)
