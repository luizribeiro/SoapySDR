// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#include "../Utility.hpp"

#include <cstdlib>
#include <cstdio>
#include <memory>

//
// Utility
//

#define TEST_ASSERT(cond) \
{ \
    if(not (cond)) \
    { \
        printf(" * FAILURE: \"%s\" is FALSE\n", #cond); \
        return false; \
    } \
}

static bool testMap(
    const SoapySDR::Kwargs &kwargs,
    const std::string &key,
    const std::string &val)
{
    TEST_ASSERT(kwargs.find(key) != kwargs.end());
    TEST_ASSERT(kwargs.at(key) == val);

    return true;
};

//
// Test functions
//

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
    std::unique_ptr<std::vector<std::string>> cppVector(SoapySDR::Octave::stringVectorOctaveToCpp(octaveVector));

    TEST_ASSERT(cppVector->size() == size_t(octaveVector.numel()));
    for(size_t i = 0; i < cppVector->size(); ++i)
        TEST_ASSERT(cppVector->at(i) == octaveVector.elem(i));

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

    TEST_ASSERT(octaveArray(0) == 418);
    TEST_ASSERT(octaveArray(1) == 1351);
    TEST_ASSERT(octaveArray(2) == 4063);

    puts(" * SUCCESS");
    return true;
}

template <typename T>
static bool testPODVectorOctaveToCpp(void)
{
    printf("%s\n", __PRETTY_FUNCTION__);

    Array<T> octaveArray(dim_vector(3, 1));
    octaveArray(0) = 418;
    octaveArray(1) = 1351;
    octaveArray(2) = 4063;
    std::unique_ptr<std::vector<T>> cppVector(SoapySDR::Octave::vectorOctaveToCpp(octaveArray));

    TEST_ASSERT(cppVector->at(0) == 418);
    TEST_ASSERT(cppVector->at(1) == 1351);
    TEST_ASSERT(cppVector->at(2) == 4063);

    puts(" * SUCCESS");
    return true;
}

static bool testKwargsCppToOctave(void)
{
    printf("%s\n", __PRETTY_FUNCTION__);

    const SoapySDR::Kwargs cppMap
    {
        {"key0", "val0"},
        {"key1", "val1"},
        {"key2", "val2"},
    };
    const auto octaveString = SoapySDR::Octave::kwargsCppToOctave(cppMap);

    TEST_ASSERT(cppMap == SoapySDR::KwargsFromString(octaveString.string_value()));

    puts(" * SUCCESS");
    return true;
}

static bool testKwargsOctaveToCpp(void)
{
    printf("%s\n", __PRETTY_FUNCTION__);

    const octave_value octaveString("key0=val0,key1=val1,key2=val2");
    std::unique_ptr<SoapySDR::Kwargs> cppMap(SoapySDR::Octave::kwargsOctaveToCpp(octaveString));

    TEST_ASSERT(testMap(*cppMap, "key0", "val0"));
    TEST_ASSERT(testMap(*cppMap, "key1", "val1"));
    TEST_ASSERT(testMap(*cppMap, "key2", "val2"));

    puts(" * SUCCESS");
    return true;
}

static bool testKwargsListCppToOctave(void)
{
    printf("%s\n", __PRETTY_FUNCTION__);

    const SoapySDR::KwargsList cppMapList
    {
        {
            {"key0", "val0"},
            {"key1", "val1"},
            {"key2", "val2"},
        },
        {
            {"key3", "val3"},
            {"key4", "val4"},
            {"key5", "val5"},
        },
        {
            {"key6", "val6"},
            {"key7", "val7"},
            {"key8", "val8"},
        },
    };
    const auto stringVector = SoapySDR::Octave::kwargsListCppToOctave(cppMapList);
    TEST_ASSERT(stringVector.numel() == 3);

    TEST_ASSERT(stringVector(0) == "key0=val0, key1=val1, key2=val2");
    TEST_ASSERT(stringVector(1) == "key3=val3, key4=val4, key5=val5");
    TEST_ASSERT(stringVector(2) == "key6=val6, key7=val7, key8=val8");

    puts(" * SUCCESS");
    return true;
}

static bool testKwargsListOctaveToCpp(void)
{
    printf("%s\n", __PRETTY_FUNCTION__);

    string_vector octaveVector(3);
    octaveVector.elem(0) = "key0=val0,key1=val1,key2=val2";
    octaveVector.elem(1) = "key3=val3,key4=val4,key5=val5";
    octaveVector.elem(2) = "key6=val6,key7=val7,key8=val8";
    std::unique_ptr<SoapySDR::KwargsList> cppMapList(SoapySDR::Octave::kwargsListOctaveToCpp(octaveVector));

    TEST_ASSERT(cppMapList->size() == size_t(octaveVector.numel()));
    TEST_ASSERT(testMap(cppMapList->at(0), "key0", "val0"));
    TEST_ASSERT(testMap(cppMapList->at(0), "key1", "val1"));
    TEST_ASSERT(testMap(cppMapList->at(0), "key2", "val2"));
    TEST_ASSERT(testMap(cppMapList->at(1), "key3", "val3"));
    TEST_ASSERT(testMap(cppMapList->at(1), "key4", "val4"));
    TEST_ASSERT(testMap(cppMapList->at(1), "key5", "val5"));
    TEST_ASSERT(testMap(cppMapList->at(2), "key6", "val6"));
    TEST_ASSERT(testMap(cppMapList->at(2), "key7", "val7"));
    TEST_ASSERT(testMap(cppMapList->at(2), "key8", "val8"));

    puts(" * SUCCESS");
    return true;
}

//
// Main
//

int main(int,char**)
{
    bool success = true;

    success &= testStringVectorCppToOctave();
    success &= testStringVectorOctaveToCpp();
    success &= testPODVectorCppToOctave<octave_idx_type>();
    success &= testPODVectorOctaveToCpp<octave_idx_type>();
    success &= testKwargsCppToOctave();
    success &= testKwargsOctaveToCpp();
    success &= testKwargsListCppToOctave();
    success &= testKwargsListOctaveToCpp();

    puts("");
    puts(success ? "SUCCESS" : "FAILURE");

    return success ? EXIT_SUCCESS : EXIT_FAILURE;
}
