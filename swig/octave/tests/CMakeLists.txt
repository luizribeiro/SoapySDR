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
