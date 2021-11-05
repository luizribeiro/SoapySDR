// Copyright (c) 2020-2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include "CSharpExtensions.hpp"

#include <SoapySDR/ConverterRegistry.hpp>

#include <algorithm>
#include <cassert>
#include <iterator>
#include <vector>

namespace SoapySDR { namespace CSharp { 

    enum class ConverterFunctionPriority
    {
        Generic = 0,
        Vectorized = 3,
        Custom = 5
    };
    static_assert(int(ConverterFunctionPriority::Generic) == int(SoapySDR::ConverterRegistry::GENERIC), "Mismatched generic enum");
    static_assert(int(ConverterFunctionPriority::Vectorized) == int(SoapySDR::ConverterRegistry::VECTORIZED), "Mismatched vectorized enum");
    static_assert(int(ConverterFunctionPriority::Custom) == int(SoapySDR::ConverterRegistry::CUSTOM), "Mismatched custom enum");

    struct ConverterInternal
    {
        static inline std::vector<std::string> ListTargetFormats(const std::string& sourceFormat)
        {
            return SoapySDR::ConverterRegistry::listTargetFormats(sourceFormat);
        }

        static inline std::vector<std::string> ListSourceFormats(const std::string& targetFormat)
        {
            return SoapySDR::ConverterRegistry::listSourceFormats(targetFormat);
        }

        static std::vector<ConverterFunctionPriority> ListPriorities(const std::string& sourceFormat, const std::string& targetFormat)
        {
            const auto cppPriorities = SoapySDR::ConverterRegistry::listPriorities(sourceFormat, targetFormat);

            std::vector<ConverterFunctionPriority> priorities;
            std::transform(
                cppPriorities.begin(),
                cppPriorities.end(),
                std::back_inserter(priorities),
                [](const SoapySDR::ConverterRegistry::FunctionPriority priority)
                {
                    return static_cast<ConverterFunctionPriority>(priority);
                });

            return priorities;
        }

        static inline std::vector<std::string> ListAvailableSourceFormats()
        {
            return SoapySDR::ConverterRegistry::listAvailableSourceFormats();
        }

        static void Convert(
            const std::string& sourceFormat,
            const std::string& destFormat,
            const SWIGSize source,
            SWIGSize dest,
            const size_t numElems,
            const double scalar)
        {
            const auto func = SoapySDR::ConverterRegistry::getFunction(
                sourceFormat,
                destFormat);
            assert(func);

            func(
                reinterpret_cast<const void*>(source),
                reinterpret_cast<void*>(dest),
                numElems,
                scalar);
        }

        static void Convert(
            const std::string& sourceFormat,
            const std::string& destFormat,
            const ConverterFunctionPriority priority,
            const SWIGSize source,
            SWIGSize dest,
            const size_t numElems,
            const double scalar)
        {
            const auto func = SoapySDR::ConverterRegistry::getFunction(
                sourceFormat,
                destFormat,
                static_cast<SoapySDR::ConverterRegistry::FunctionPriority>(priority));
            assert(func);

            func(
                reinterpret_cast<const void*>(source),
                reinterpret_cast<void*>(dest),
                numElems,
                scalar);
        }
    };

}}