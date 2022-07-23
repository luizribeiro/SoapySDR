########################################################################
# Project setup
########################################################################
cmake_minimum_required(VERSION 3.7)
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

if(OCTAVE_FOUND)
    if("${OCTAVE_VERSION_STRING}" VERSION_GREATER_EQUAL "6.2.0")
        # See: https://github.com/swig/swig/pull/2020
        if("${SWIG_VERSION}" VERSION_GREATER_EQUAL "4.1.0")
            set(SWIG_OCTAVE_COMPATIBLE TRUE)
        else()
            set(SWIG_OCTAVE_COMPATIBLE FALSE)
        endif()
    else()
        set(SWIG_OCTAVE_COMPATIBLE TRUE)
    endif()
endif()

if(APPLE AND CMAKE_COMPILER_IS_GNUCXX)
    message(WARNING "Octave bindings built with GCC on OS X are not officially supported and may not build.")
endif()

########################################################################
## Feature registration
########################################################################
include(FeatureSummary)
include(CMakeDependentOption)
cmake_dependent_option(ENABLE_OCTAVE "Enable Octave bindings" ON "ENABLE_LIBRARY;SWIG_FOUND;OCTAVE_FOUND;SWIG_OCTAVE_COMPATIBLE" OFF)
add_feature_info(Octave ENABLE_OCTAVE "Octave bindings v${OCTAVE_VERSION_STRING}")
if (NOT ENABLE_OCTAVE)
    return()
endif()

########################################################################
# Build Module
# TODO: Octave has a huge number of warnings, figure out suppressing
#       it all.
########################################################################

# Both Octave and the SWIG-generated source have a huge amount of warnings.
# TODO: the virtual dtor one still sneaks past
if(CMAKE_COMPILER_IS_GNUCXX OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
    list(APPEND CMAKE_CXX_FLAGS "-Wno-non-virtual-dtor -Wno-deprecated-copy -Wno-unused-parameter")
endif()

include(UseSWIG)
set(CMAKE_SWIG_FLAGS
    -I${SoapySDR_INCLUDE_DIRS}
    -I${CMAKE_CURRENT_SOURCE_DIR}
    -I${CMAKE_CURRENT_SOURCE_DIR}/..
    -I${CMAKE_CURRENT_BINARY_DIR})

set_source_files_properties(SoapySDR.i PROPERTIES CPLUSPLUS ON)

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

add_subdirectory(tests)
