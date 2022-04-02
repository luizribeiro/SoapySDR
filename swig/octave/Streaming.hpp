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
    SoapySDR::Kwargs args;

    SoapySDR::Stream *internal{nullptr};
};

struct RxStreamResult
{
    octave_value samples;
    int errorCode{0};
    int flags{0};
    long timeNs{0};
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

    // Octave+SWIG doesn't support (unsigned) long long
    long long intermediateTimeNs{0};

    // TODO: see if we can resize if we can't read this many elements in one run.
    // I'm not sure if it will remove what's there shrinking a dimension.
    RxStreamResult result;
    result.errorCode = device->readStream(
        stream.internal,
        buffs.data(),
        numSamples,
        result.flags,
        intermediateTimeNs,
        timeoutUs);

    result.samples = intermediateSamples;
    result.timeNs = static_cast<long>(intermediateTimeNs);

    return result;
}

}}
