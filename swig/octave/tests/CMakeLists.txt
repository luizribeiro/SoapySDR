if (NOT ENABLE_TESTS)
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
#     TestDeviceAPI
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
