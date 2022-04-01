// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include <SoapySDR/Constants.h>
#include <SoapySDR/Errors.hpp>
#include <SoapySDR/Formats.h>
#include <SoapySDR/Types.hpp>

#include <string>

namespace SoapySDR { namespace Octave {

// By default, SWIG wraps enums as top-level constants, so
// making an enum out of the streaming directions would turn
// into SoapySDR.Direction_TX, and so on. This is ugly, so
// this workaround will allow the more desirable syntax of
// SoapySDR.Direction.TX, and so on.
//
// Note that even though declaring static const int values in
// the struct is valid C++, we need to define them outside for
// this workaround to work.

struct ArgType
{
    static const int BOOL;
    static const int INT;
    static const int FLOAT;
    static const int STRING;
};

const int ArgType::BOOL = SoapySDR::ArgInfo::BOOL;
const int ArgType::INT = SoapySDR::ArgInfo::INT;
const int ArgType::FLOAT = SoapySDR::ArgInfo::FLOAT;
const int ArgType::STRING = SoapySDR::ArgInfo::BOOL;

struct Direction
{
    static const int TX;
    static const int RX;
};

const int Direction::TX = SOAPY_SDR_TX;
const int Direction::RX = SOAPY_SDR_RX;

struct ErrorCode
{
    static const int NONE;
    static const int TIMEOUT;
    static const int STREAM_ERROR;
    static const int CORRUPTION;
    static const int OVERFLOW;
    static const int NOT_SUPPORTED;
    static const int TIME_ERROR;
    static const int UNDERFLOW;

    static inline std::string ToString(int errorCode)
    {
        return SoapySDR::errToStr(errorCode);
    }
};

const int ErrorCode::NONE = 0;
const int ErrorCode::TIMEOUT = SOAPY_SDR_TIMEOUT;
const int ErrorCode::STREAM_ERROR = SOAPY_SDR_STREAM_ERROR;
const int ErrorCode::CORRUPTION = SOAPY_SDR_CORRUPTION;
const int ErrorCode::OVERFLOW = SOAPY_SDR_OVERFLOW;
const int ErrorCode::NOT_SUPPORTED = SOAPY_SDR_NOT_SUPPORTED;
const int ErrorCode::TIME_ERROR = SOAPY_SDR_TIME_ERROR;
const int ErrorCode::UNDERFLOW = SOAPY_SDR_UNDERFLOW;

struct StreamFlag
{
    static const int NONE;
    static const int END_BURST;
    static const int HAS_TIME;
    static const int END_ABRUPT;
    static const int ONE_PACKET;
    static const int MORE_FRAGMENTS;
    static const int WAIT_TRIGGER;
};

const int StreamFlag::NONE = 0;
const int StreamFlag::END_BURST = SOAPY_SDR_END_BURST;
const int StreamFlag::HAS_TIME = SOAPY_SDR_HAS_TIME;
const int StreamFlag::END_ABRUPT = SOAPY_SDR_END_ABRUPT;
const int StreamFlag::ONE_PACKET = SOAPY_SDR_ONE_PACKET;
const int StreamFlag::MORE_FRAGMENTS = SOAPY_SDR_MORE_FRAGMENTS;
const int StreamFlag::WAIT_TRIGGER = SOAPY_SDR_WAIT_TRIGGER;

struct StreamFormat
{
    static const std::string S8;
    static const std::string S16;
    static const std::string S32;

    static const std::string U8;
    static const std::string U16;
    static const std::string U32;

    static const std::string F32;
    static const std::string F64;

    static const std::string CS8;
    static const std::string CS12;
    static const std::string CS16;
    static const std::string CS32;

    static const std::string CU8;
    static const std::string CU12;
    static const std::string CU16;
    static const std::string CU32;

    static const std::string CF32;
    static const std::string CF64;
};

const std::string StreamFormat::S8(SOAPY_SDR_S8);
const std::string StreamFormat::S16(SOAPY_SDR_S16);
const std::string StreamFormat::S32(SOAPY_SDR_S32);

const std::string StreamFormat::U8(SOAPY_SDR_U8);
const std::string StreamFormat::U16(SOAPY_SDR_U16);
const std::string StreamFormat::U32(SOAPY_SDR_U32);

const std::string StreamFormat::F32(SOAPY_SDR_F32);
const std::string StreamFormat::F64(SOAPY_SDR_F64);

const std::string StreamFormat::CS8(SOAPY_SDR_CS8);
const std::string StreamFormat::CS12(SOAPY_SDR_CS12);
const std::string StreamFormat::CS16(SOAPY_SDR_CS16);
const std::string StreamFormat::CS32(SOAPY_SDR_CS32);

const std::string StreamFormat::CU8(SOAPY_SDR_CU8);
const std::string StreamFormat::CU12(SOAPY_SDR_CU12);
const std::string StreamFormat::CU16(SOAPY_SDR_CU16);
const std::string StreamFormat::CU32(SOAPY_SDR_CU32);
const std::string StreamFormat::CF32(SOAPY_SDR_CF32);
const std::string StreamFormat::CF64(SOAPY_SDR_CF64);

}}
