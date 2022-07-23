// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include "Utility.hpp"

#include <SoapySDR/Types.hpp>

#include <octave/str-vec.h>

#include <algorithm>
#include <iterator>
#include <vector>

// TODO: should we use string_vector? Doesn't look right in Octave

// This copy+paste is far from ideal, but dealing with typemaps
// with struct members is too ugly.

namespace SoapySDR { namespace Octave {

/*!
 * Argument info describes a key/value argument.
 */
struct ArgInfo
{
    ArgInfo(void) = default;
    ArgInfo(const SoapySDR::ArgInfo &cppArgInfo):
        key(cppArgInfo.key),
        value(cppArgInfo.value),
        name(cppArgInfo.name),
        description(cppArgInfo.description),
        units(cppArgInfo.units),
        type(int(cppArgInfo.type)),
        range(cppArgInfo.range),
        options(stringVectorCppToOctave(cppArgInfo.options)),
        optionNames(stringVectorCppToOctave(cppArgInfo.optionNames))
    {}

    //! The key used to identify the argument (required)
    std::string key;

    /*!
     * The default value of the argument when not specified (required)
     * Numbers should use standard floating point and integer formats.
     * Boolean values should be represented as "true" and  "false".
     */
    std::string value;

    //! The displayable name of the argument (optional, use key if empty)
    std::string name;

    //! A brief description about the argument (optional)
    std::string description;

    //! The units of the argument: dB, Hz, etc (optional)
    std::string units;

    //! The data type of the argument (required)
    int type;

    /*!
     * The range of possible numeric values (optional)
     * When specified, the argument should be restricted to this range.
     * The range is only applicable to numeric argument types.
     */
    SoapySDR::Range range;

    /*!
     * A discrete list of possible values (optional)
     * When specified, the argument should be restricted to this options set.
     */
    string_vector options;

    /*!
     * A discrete list of displayable names for the enumerated options (optional)
     * When not specified, the option value itself can be used as a display name.
     */
    string_vector optionNames;
};

std::vector<SoapySDR::Octave::ArgInfo> argInfoListCppToOctave(const SoapySDR::ArgInfoList &listCpp)
{
    std::vector<SoapySDR::Octave::ArgInfo> listOctave;
    std::transform(
        listCpp.begin(),
        listCpp.end(),
        std::back_inserter(listOctave),
        [](const SoapySDR::ArgInfo &argInfoCpp)
        {
            return SoapySDR::Octave::ArgInfo(argInfoCpp);
        });

    return listOctave;
}

//
// Test functions
//

inline SoapySDR::Range getUnitTestRange(void)
{
    return {0.0, 1.0, 0.1};
}

SoapySDR::RangeList getUnitTestRangeList(void)
{
    auto range = getUnitTestRange();

    SoapySDR::RangeList rangeList;
    for(size_t i = 0; i < 3; ++i)
        rangeList.emplace_back(range.minimum() * i, range.maximum() * i, range.step() * i);

    return rangeList;
}

SoapySDR::Octave::ArgInfo getUnitTestArgInfo(void)
{
    SoapySDR::Octave::ArgInfo argInfo;
    argInfo.key = "key";
    argInfo.value = "value";
    argInfo.name = "name";
    argInfo.description = "description";
    argInfo.units = "units";
    argInfo.type = int(SoapySDR::ArgInfo::FLOAT);
    argInfo.range = getUnitTestRange();
    argInfo.options = std::vector<std::string>{"opt1", "opt2", "opt3"};
    argInfo.optionNames = std::vector<std::string>{"Option1", "Option2", "Option3"};

    return argInfo;
}

std::vector<SoapySDR::Octave::ArgInfo> getUnitTestArgInfoList(void)
{
    std::vector<SoapySDR::Octave::ArgInfo> argInfoList;
    for(size_t i = 0; i < 3; ++i)
    {
        auto argInfo = getUnitTestArgInfo();
        argInfo.key += std::to_string(i);
        argInfo.value += std::to_string(i);
        argInfo.name += std::to_string(i);
        argInfo.description += std::to_string(i);
        argInfo.units += std::to_string(i);
        argInfo.range = {argInfo.range.minimum() * i, argInfo.range.maximum() * i, argInfo.range.step() * i};
        for(size_t j = 0; j < 3; ++j)
        {
            argInfo.options(j) += ("_"+std::to_string(i));
            argInfo.optionNames(j) += ("_"+std::to_string(i));
        }

        argInfoList.emplace_back(std::move(argInfo));
    }

    return argInfoList;
}

}}
