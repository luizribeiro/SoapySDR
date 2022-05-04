// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#include "../Utility.hpp"

#include <cstdlib>
#include <cstdio>

#define TEST_ASSERT(cond) \
{ \
    if(not (cond)) \
    { \
        printf(" * FAILED: \"%s\" is FALSE\n", #cond); \
        return false; \
    } \
}

static bool testStringVectorCppToOctave(void)
{
    printf("%s\n", __FUNCTION__);

    std::vector<std::string> cppVector
    {
        "elem0",
        "elem1",
        "elem2"
    };
    const auto octaveVector = SoapySDR::Octave::stringVectorCppToOctave(cppVector);

    TEST_ASSERT(cppVector.size() == size_t(octaveVector.numel()));
    for(size_t i = 0; i < cppVector.size(); ++i)
        TEST_ASSERT(cppVector[i] == octaveVector.elem(i));

    printf(" * SUCCESS\n");
    return true;
}

static bool testStringVectorOctaveToCpp(void)
{
    printf("%s\n", __FUNCTION__);

    string_vector octaveVector(3);
    octaveVector.elem(0) = "elem0";
    octaveVector.elem(1) = "elem1";
    octaveVector.elem(2) = "elem2";
    const auto cppVector = SoapySDR::Octave::stringVectorOctaveToCpp(octaveVector);

    TEST_ASSERT(cppVector.size() == size_t(octaveVector.numel()));
    for(size_t i = 0; i < cppVector.size(); ++i)
        TEST_ASSERT(cppVector[i] == octaveVector.elem(i));

    printf(" * SUCCESS\n");
    return true;
}

template <typename T>
static bool testPODVectorCppToOctave(void)
{
    printf("%s\n", __PRETTY_FUNCTION__);

    std::vector<T> cppVector
    {
        T(418),
        T(1351),
        T(4063)
    };
    const auto octaveArray = SoapySDR::Octave::vectorCppToOctave(cppVector);

    printf(" * SUCCESS\n");
    return true;
}

int main(int,char**)
{
    bool success = true;

    success &= testStringVectorCppToOctave();
    success &= testStringVectorOctaveToCpp();
    success &= testPODVectorCppToOctave<octave_idx_type>();

    return success ? EXIT_SUCCESS : EXIT_FAILURE;
}
