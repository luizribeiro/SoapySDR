########################################################################
# Feature setup
########################################################################
find_package(SoapySDR CONFIG REQUIRED)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

########################################################################
# Check for native C# support.
########################################################################
include(CheckLanguage)
check_language(CSharp)

########################################################################
# Find SWIG
########################################################################
find_package(SWIG)
message(STATUS "SWIG_FOUND: ${SWIG_FOUND} - ${SWIG_VERSION}")

# SWIG doesn't deal well with (s)size_t and (u)intptr_t
include(CheckCXXSourceCompiles)
CHECK_CXX_SOURCE_COMPILES("
    #include <cstddef>
    int main() {
    size_t *x = (unsigned int *)(NULL);
    return 0; }" SIZE_T_IS_UNSIGNED_INT)

if (SIZE_T_IS_UNSIGNED_INT)
    list(APPEND CMAKE_SWIG_FLAGS -DSIZE_T_IS_UNSIGNED_INT)
endif (SIZE_T_IS_UNSIGNED_INT)

########################################################################
## Feature registration
########################################################################

# Note: anecdotally, only .NET Framework 4.5+ has worked, despite theoretical
# support for .NET Core and .NET Standard. These have resulted in issues with
# the CMake-generated VS project.
#
# Some dependency libraries also don't have support for some versions, which is
# a nonstarter for those.
set(SOAPYSDR_DOTNET_TARGET_VERSION "v4.7.2" CACHE STRING "Target .NET version")

include(FeatureSummary)
include(CMakeDependentOption)
cmake_dependent_option(ENABLE_CSHARP "Enable C# bindings" ON "CMAKE_CSharp_COMPILER;ENABLE_LIBRARY;SWIG_FOUND" OFF)
add_feature_info(CSharp ENABLE_CSHARP "C# bindings ${SOAPYSDR_DOTNET_TARGET_VERSION}")
if (NOT ENABLE_CSHARP)
    return()
endif()

enable_language(CSharp)
set(CMAKE_DOTNET_TARGET_FRAMEWORK_VERSION ${SOAPYSDR_DOTNET_TARGET_VERSION})

########################################################################
# Build Module
########################################################################
add_subdirectory(swig)
add_subdirectory(assembly)

########################################################################
# Documentation
########################################################################
add_subdirectory(docs)

########################################################################
# Apps (TODO: not by default, test standalone)
########################################################################
add_subdirectory(apps)

########################################################################
# Tests
########################################################################
add_subdirectory(tests)