########################################################################
# Octave API tests
#
# Normally, Octave tests are included in the .oct libraries and can be
# run from the interpreter, but since we're running the C++ compiler
# ourselves, they're not processed this way.
########################################################################
set(tests
    TestBuildInfo
    TestDeviceAPI
    TestEnumerateDevices
    TestErrorCodes
    TestFormats
    TestLogger
    TestSoapyTypes
    TestTimeConversion)

# TODO: --path not portable
foreach(test ${tests})
    add_test(
        NAME OLD_Octave_${test}
        COMMAND ${OCTAVE_EXECUTABLE} --path ${CMAKE_CURRENT_BINARY_DIR}/../.. --eval "test ${test}"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

    set_tests_properties(OLD_Octave_${test} PROPERTIES
        FAIL_REGULAR_EXPRESSION "test failed")
endforeach()
