########################################################################
# Feature setup
########################################################################
find_package(SoapySDR CONFIG REQUIRED)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

########################################################################
# Make sure CMake supports native C#
########################################################################
if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.8.0")
    set(CMAKE_SUPPORTS_NATIVE_CSHARP TRUE)
endif()

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
include(FeatureSummary)
include(CMakeDependentOption)
cmake_dependent_option(ENABLE_CSHARP "Enable C# bindings" ON "MSVC;CMAKE_SUPPORTS_NATIVE_CSHARP;ENABLE_LIBRARY;SWIG_FOUND" OFF)
add_feature_info(CSharp ENABLE_CSHARP "C# bindings")
if (NOT ENABLE_CSHARP)
    return()
endif()

enable_language(CSharp)

# Hardcode target .NET framework version due to:
# * Issues with CMake-generated files with some versions
# * Dependency compatibility
#
# This can be parameterized at some point if needed.
set(CMAKE_DOTNET_TARGET_FRAMEWORK_VERSION "v4.7.2")

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