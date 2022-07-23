execute_process(
    COMMAND ${OCTAVE_EXECUTABLE} --eval "moxunit_set_path()"
    RESULT_VARIABLE MOXUNIT_FOUND
    OUTPUT_QUIET
    ERROR_QUIET
    )
if(MOXUNIT_FOUND EQUAL 0)
    message(STATUS "Checking for MOxUnit - found")
    set(MOXUNIT_FOUND TRUE)
else()
    message(STATUS "Checking for MOxUnit - failed")
    set(MOXUNIT_FOUND FALSE)
endif()

########################################################################
## Feature registration
########################################################################
include(FeatureSummary)
include(CMakeDependentOption)
cmake_dependent_option(ENABLE_OCTAVE_TESTING "Enable Octave unit tests" ON "ENABLE_TESTS;ENABLE_OCTAVE;MOXUNIT_FOUND" OFF)
add_feature_info("Octave tests" ENABLE_OCTAVE_TESTING "Octave unit tests")

if (NOT ENABLE_OCTAVE_TESTING)
    return()
endif()

########################################################################
# Manual C++ tests
########################################################################
include_directories(
    ${OCTAVE_INCLUDE_DIRS}
    ${SoapySDR_INCLUDE_DIRS})

add_executable(TestManualCppOctaveConversions TestManualCppOctaveConversions.cpp)

target_link_libraries(TestManualCppOctaveConversions
    ${OCTAVE_LIBRARIES}
    SoapySDR)

add_test(Octave_TestManualCppOctaveConversions TestManualCppOctaveConversions)

########################################################################
# Octave API tests
########################################################################
set(tests
    TestBuildInfo
    TestDeviceAPI
    TestEnumerateDevices
    TestErrorCodes
    TestFormats
    TestLogger
    TestSoapyTypes
    TestTimeConversion
)

# TODO: --path not portable
foreach(test ${tests})
    add_test(
        NAME Octave_${test}
        COMMAND ${OCTAVE_EXECUTABLE} --path ${CMAKE_CURRENT_BINARY_DIR}/.. --eval "moxunit_set_path(); moxunit_runtests(filename='${test}.m')"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

    set_tests_properties(Octave_${test} PROPERTIES
        FAIL_REGULAR_EXPRESSION "FAILED")
endforeach()
