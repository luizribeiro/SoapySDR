// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include "CSharpExtensions.hpp"

#include <SoapySDR/Types.hpp>

namespace SoapySDR { namespace CSharp { 

    struct TypeConversionInternal
    {
        template <typename T>
        static inline std::string SettingToString(const T& setting)
        {
            return SoapySDR::SettingToString<T>(setting);
        }

        template <typename T>
        static inline T StringToSetting(const std::string& setting)
        {
            return SoapySDR::StringToSetting<T>(setting);
        }

        static inline SoapySDR::Kwargs StringToKwargs(const std::string& args)
        {
            return SoapySDR::KwargsFromString(args);
        }
    };
}}