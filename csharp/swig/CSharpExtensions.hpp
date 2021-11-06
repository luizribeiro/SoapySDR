// Copyright (c) 2020-2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include <SoapySDR/Constants.h>
#include <SoapySDR/Device.hpp>
#include <SoapySDR/Formats.hpp>
#include <SoapySDR/Time.hpp>
#include <SoapySDR/Types.hpp>
#include <SoapySDR/Version.hpp>

#include <algorithm>
#include <cstdint>
#include <iterator>
#include <string>
#include <type_traits>
#include <vector>

// SWIG seems to struggle with size_t/uintptr_t, even with custom typemap stuff.
#if defined(SIZE_T_IS_UNSIGNED_INT)
using SWIGSize = uint32_t;
#else
using SWIGSize = uint64_t;
#endif

using SWIGSizeVector = std::vector<SWIGSize>;

static_assert(sizeof(SWIGSize) == sizeof(void*), "Can't reinterpret_cast size type to void*");

namespace detail
{
    template <typename Out, typename In>
    static inline typename std::enable_if<std::is_same<In, Out>::value, std::vector<Out>>::type copyVector(const std::vector<In>& vec)
    {
        return vec;
    }

    template <typename Out, typename In>
    static inline typename std::enable_if<!std::is_same<In, Out>::value, std::vector<Out>>::type copyVector(const std::vector<In>& vec)
    {
        std::vector<Out> ret;
        std::transform(
            vec.begin(),
            vec.end(),
            std::back_inserter(ret),
            [](const In num) {return static_cast<Out>(num); });

        return ret;
    }
}

template <typename Out, typename In>
static inline std::vector<Out> copyVector(const std::vector<In>& vec)
{
    return detail::copyVector<Out, In>(vec);
}

template <typename Out, typename In>
static inline std::vector<Out*> reinterpretCastVector(const std::vector<In>& vec)
{
    static_assert(sizeof(In) == sizeof(Out*), "In must be pointer-sized");

    std::vector<Out*> ret;
    std::transform(
        vec.begin(),
        vec.end(),
        std::back_inserter(ret),
        [](In elem) {return reinterpret_cast<Out*>(elem); });

    return ret;
}

namespace SoapySDR { namespace CSharp {

    struct BuildInfo
    {
        static const std::string APIVersion;
        static const std::string ABIVersion;
        static const std::string LibVersion;

        static const std::string SWIGABIVersion;
    };

    const std::string BuildInfo::APIVersion = SoapySDR::getAPIVersion();
    const std::string BuildInfo::ABIVersion = SoapySDR::getABIVersion();
    const std::string BuildInfo::LibVersion = SoapySDR::getLibVersion();

    const std::string BuildInfo::SWIGABIVersion(SOAPY_SDR_ABI_VERSION);

    enum class Direction
    {
        Tx = 0,
        Rx = 1
    };

    // Note: we need to repeat the literal enum values or
    //       SWIG will copy SOAPY_SDR* into the C# file.
    enum class ErrorCode
    {
        None         = 0,
        Timeout      = -1,
        StreamError  = -2,
        Corruption   = -3,
        Overflow     = -4,
        NotSupported = -5,
        TimeError    = -6,
        Underflow    = -7
    };

    // Note: we need to repeat the literal enum values or
    //       SWIG will copy SOAPY_SDR* into the C# file.
    enum class LogLevel
    {
        Fatal    = 1,
        Critical = 2,
        Error    = 3,
        Warning  = 4,
        Notice   = 5,
        Info     = 6,
        Debug    = 7,
        Trace    = 8,
        SSI      = 9
    };

    struct Time
    {
        static inline long long TicksToTimeNs(const long long ticks, const double rate)
        {
            return SoapySDR::ticksToTimeNs(ticks, rate);
        }

        static inline long long TimeNsToTicks(const long long timeNs, const double rate)
        {
            return SoapySDR::timeNsToTicks(timeNs, rate);
        }
    };
}}

// Note: we can't set these enums to the equivalent #define
// because SWIG will copy the #define directly, so we'll
// enforce equality with these static_asserts.
#define ENUM_CHECK(_enum,_define) \
    static_assert(int(_enum) == _define, #_define)

ENUM_CHECK(SoapySDR::CSharp::Direction::Tx, SOAPY_SDR_TX);
ENUM_CHECK(SoapySDR::CSharp::Direction::Rx, SOAPY_SDR_RX);