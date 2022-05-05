// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#include "../Utility.hpp"

#include <cstdlib>
#include <cstdio>

#define TEST_ASSERT(cond) \
{ \
    if(not (cond)) \
    { \
        printf(" * FAILURE: \"%s\" is FALSE\n", #cond); \
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

    puts(" * SUCCESS");
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

    puts(" * SUCCESS");
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

    TEST_ASSERT(octaveArray(1) == 418);
    TEST_ASSERT(octaveArray(2) == 1351);
    TEST_ASSERT(octaveArray(3) == 4063);

    puts(" * SUCCESS");
    return true;
}

template <typename T>
static bool testPODVectorOctaveToCpp(void)
{
    printf("%s\n", __PRETTY_FUNCTION__);

    Array<T> octaveArray(dim_vector(3, 1));
    octaveArray(1) = 418;
    octaveArray(2) = 1351;
    octaveArray(3) = 4063;
    const auto cppVector = SoapySDR::Octave::vectorOctaveToCpp(octaveArray);

    TEST_ASSERT(cppVector[0] == 418);
    TEST_ASSERT(cppVector[1] == 1351);
    TEST_ASSERT(cppVector[2] == 4063);

    puts(" * SUCCESS");
    return true;
}

static bool testKwargsCppToOctave(void)
{
    printf("%s\n", __PRETTY_FUNCTION__);

    SoapySDR::Kwargs kwargsCpp
    {
        {"key0", "val0"},
        {"key1", "val1"},
        {"key2", "val2"},
    };
    const auto octaveMap = SoapySDR::Octave::kwargsCppToOctave(kwargsCpp);

    puts(" * SUCCESS");
    return true;
}

int main(int,char**)
{
    bool success = true;

    success &= testStringVectorCppToOctave();
    success &= testStringVectorOctaveToCpp();
    success &= testPODVectorCppToOctave<octave_idx_type>();
    success &= testPODVectorOctaveToCpp<octave_idx_type>();
    success &= testKwargsCppToOctave();

    puts("");
    puts(success ? "SUCCESS" : "FAILURE");

    return success ? EXIT_SUCCESS : EXIT_FAILURE;
}
