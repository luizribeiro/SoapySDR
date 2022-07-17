// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include "Utility.hpp"

#include <SoapySDR/Types.hpp>

#include <octave/str-vec.h>

#include <algorithm>
#include <iterator>

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

}}
