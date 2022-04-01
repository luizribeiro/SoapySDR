// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include <SoapySDR/Constants.h>
#include <SoapySDR/Errors.h>

namespace SoapySDR { namespace Octave {

// SoapySDR.Direction_TX, etc
enum class Direction
{
    TX = SOAPY_SDR_TX,
    RX = SOAPY_SDR_RX
};

// SoapySDR.ErrorCode_TIMEOUT, etc
enum class ErrorCode
{
    NONE = 0,
    TIMEOUT = SOAPY_SDR_TIMEOUT,
    STREAM_ERROR = SOAPY_SDR_STREAM_ERROR,
    CORRUPTION = SOAPY_SDR_CORRUPTION,
    OVERFLOW = SOAPY_SDR_OVERFLOW,
    NOT_SUPPORTED = SOAPY_SDR_NOT_SUPPORTED,
    TIME_ERROR = SOAPY_SDR_TIME_ERROR,
    UNDERFLOW = SOAPY_SDR_UNDERFLOW,
};

// SoapySDR.StreamFlag_END_BURST, etc
enum class StreamFlag
{
    NONE = 0,
    END_BURST = SOAPY_SDR_END_BURST,
    HAS_TIME = SOAPY_SDR_HAS_TIME,
    END_ABRUPT = SOAPY_SDR_END_ABRUPT,
    ONE_PACKET = SOAPY_SDR_ONE_PACKET,
    MORE_FRAGMENTS = SOAPY_SDR_MORE_FRAGMENTS,
    WAIT_TRIGGER = SOAPY_SDR_WAIT_TRIGGER,
};

}}
