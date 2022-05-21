// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include <SoapySDR/Types.hpp>
#include <SoapySDR/Version.hpp>

#include <octave/Array.h>
#include <octave/oct-map.h>
#include <octave/str-vec.h>

#include <algorithm>
#include <iterator>
#include <map>
#include <sstream>
#include <string>
#include <type_traits>
#include <vector>

namespace SoapySDR { namespace Octave {

void validateABI(void)
{
    static const std::string COMPILETIME_ABI = SOAPY_SDR_ABI_VERSION;
    const auto RUNTIME_ABI = SoapySDR::getABIVersion();

    if(COMPILETIME_ABI != RUNTIME_ABI)
    {
        std::ostringstream errMsgStream;
        errMsgStream << "Failed ABI check." << std::endl
                     << " * SoapySDR library: " << RUNTIME_ABI << std::endl
                     << " * Octave module: " << COMPILETIME_ABI;

        throw std::runtime_error(errMsgStream.str());
    }
}

//
// Unlike with some other languages, SWIG's Octave wrappers for maps and vectors
// are not compatible with native list and map types, so we can't use them as
// parameters. This is a subpar developer experience, and Octave copies everything
// anyway, so this is fine.
//
// Returning pointers here is safe because the SWIG wrapper will delete them.
//

string_vector stringVectorCppToOctave(const std::vector<std::string> &cppVector)
{
    string_vector octaveVector;
    for(const auto &str: cppVector) octaveVector.append(str);

    return octaveVector;
}

std::vector<std::string> *stringVectorOctaveToCpp(const string_vector &octaveVector)
{
    auto *cppVector = new std::vector<std::string>();
    for(long i = 0; i < octaveVector.numel(); ++i)
        cppVector->emplace_back(octaveVector(i));

    return cppVector;
}

template <typename T>
Array<octave_idx_type> vectorCppToOctave(const std::vector<T> &cppVector)
{
    static_assert(std::is_pod<T>::value, "Not POD");

    Array<octave_idx_type> octaveArray(dim_vector(cppVector.size(), 1));
    for(size_t i = 0; i < cppVector.size(); ++i)
        octaveArray(i) = static_cast<octave_idx_type>(cppVector[i]);

    return octaveArray;
}

template <typename T>
std::vector<T> *vectorOctaveToCpp(const Array<octave_idx_type> &octaveArray)
{
    static_assert(std::is_pod<T>::value, "Not POD");

    auto *cppVector = new std::vector<T>();
    for(ssize_t i = 0; i < octaveArray.numel(); ++i)
        cppVector->emplace_back(static_cast<T>(octaveArray(i)));

    return cppVector;
}

inline octave_value kwargsCppToOctave(const SoapySDR::Kwargs &cppMap)
{
    return SoapySDR::KwargsToString(cppMap);
}

inline SoapySDR::Kwargs *kwargsOctaveToCpp(const octave_value &octaveValue)
{
    return new SoapySDR::Kwargs(SoapySDR::KwargsFromString(octaveValue.string_value()));
}

string_vector kwargsListCppToOctave(const SoapySDR::KwargsList &cppMapList)
{
    string_vector octaveVector;
    for(const auto &cppMap: cppMapList)
        octaveVector.append(SoapySDR::KwargsToString(cppMap));

    return octaveVector;
}

SoapySDR::KwargsList *kwargsListOctaveToCpp(const string_vector &octaveVector)
{
    auto *cppMapList = new SoapySDR::KwargsList;

    for(long i = 0; i < octaveVector.numel(); ++i)
        cppMapList->emplace_back(SoapySDR::KwargsFromString(octaveVector(i)));

    return cppMapList;
}

}}
