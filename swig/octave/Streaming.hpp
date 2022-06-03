// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include "Constants.hpp"

#include <SoapySDR/Device.hpp>

#include <octave/int8NDArray.h>
#include <octave/int16NDArray.h>
#include <octave/int32NDArray.h>
#include <octave/uint8NDArray.h>
#include <octave/uint16NDArray.h>
#include <octave/uint32NDArray.h>
#include <octave/CMatrix.h>
#include <octave/fMatrix.h>

#include <cassert>
#include <stdexcept>
#include <string>
#include <vector>

namespace SoapySDR { namespace Octave {

struct Stream
{
    int direction{0};
    std::string format;
    std::vector<size_t> channels;
    std::string args;

    SoapySDR::Stream *internal{nullptr};
};

struct RxStreamResult
{
    octave_value samples;
    int errorCode{0};
    int flags{0};
    long long timeNs{0};
};

struct TxStreamResult
{
    int errorCode{0};
    int flags{0};
};

struct StreamStatus
{
    int errorCode{0};
    size_t chanMask{0};
    int flags{0};
    long long timeNs{0};
};

template <typename OutputType>
RxStreamResult readStream(
    SoapySDR::Device *device,
    const Stream &stream,
    const size_t numSamples,
    const long timeoutUs,
    const bool interleaved)
{
    assert(device);
    assert(stream.internal);
    assert(stream.direction == SOAPY_SDR_RX);
    assert(numSamples > 0);

    // Column-major
    const auto numChannels = stream.channels.size();
    const auto internalNumSamples = interleaved ? (numSamples*2) : numSamples;

    OutputType intermediateSamples(dim_vector(
        static_cast<octave_idx_type>(numChannels),
        static_cast<octave_idx_type>(internalNumSamples)));

    auto *samplesBuff = intermediateSamples.fortran_vec();
    std::vector<void *> buffs;
    for(size_t chan = 0; chan < numChannels; ++chan)
    {
        buffs.emplace_back(&samplesBuff[chan * internalNumSamples]);
    }

    // TODO: see if we can resize if we can't read this many elements in one run.
    // I'm not sure if it will remove what's there shrinking a dimension.
    RxStreamResult result;
    result.errorCode = device->readStream(
        stream.internal,
        buffs.data(),
        numSamples,
        result.flags,
        result.timeNs,
        timeoutUs);

    result.samples = intermediateSamples;

    return result;
}

template <typename InputType>
TxStreamResult writeStream(
    SoapySDR::Device *device,
    const Stream &stream,
    const InputType &inputSamples,
    const long long timeNs,
    const long timeoutUs,
    const bool interleaved)
{
    assert(device);
    assert(stream.internal);
    assert(stream.direction == SOAPY_SDR_TX);

    const auto numChannels = stream.channels.size();
    const auto dims = inputSamples.dims();
    size_t internalNumSamples = 0;

    if(dims.length() == 1)
    {
        if(numChannels != 1)
            throw std::invalid_argument("One-dimensional inputs are only valid for single-channel streams.");

        internalNumSamples = dims.elem(0);
    }
    else if(dims.length() == 2)
    {
        if(size_t(dims.elem(0)) != numChannels)
            throw std::invalid_argument("Outer dimension must match number of channels ("+std::to_string(numChannels)+")");
        if(internalNumSamples == 0)
            throw std::invalid_argument("Inner dimension must not be empty");
        if(interleaved and (internalNumSamples % 2) == 1)
            throw std::invalid_argument("Inner dimension must be a multiple of 2");

        internalNumSamples = dims.elem(1);
    }
    else throw std::invalid_argument("Input must be 1D or 2D.");

    const auto numSamples = interleaved ? (internalNumSamples/2) : internalNumSamples;

    const auto *samplesBuff = inputSamples.fortran_vec();
    std::vector<const void *> buffs;
    for(size_t chan = 0; chan < numChannels; ++chan)
    {
        buffs.emplace_back(&samplesBuff[chan * internalNumSamples]);
    }

    TxStreamResult result;
    result.errorCode = device->writeStream(
        stream.internal,
        buffs.data(),
        numSamples,
        result.flags,
        timeNs,
        timeoutUs);

    return result;
}

}}
