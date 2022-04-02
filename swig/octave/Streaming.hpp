// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include "Constants.hpp"

#include <SoapySDR/Device.hpp>

#include <octave/CMatrix.h>
#include <octave/fMatrix.h>

#include <cassert>
#include <stdexcept>
#include <vector>

namespace SoapySDR { namespace Octave {

namespace detail
{

template <typename MatrixType>
int readStream(
    SoapySDR::Device *device,
    SoapySDR::Stream *stream,
    const size_t numSamples,
    const size_t numChannels,
    octave_value &samplesOut,
    int &flagsOut,
    long long &timeNsOut,
    const long timeoutUs)
{
    assert(device);
    assert(stream);
    assert(numSamples > 0);
    assert(numChannels > 0);

    MatrixType intermediate(
        static_cast<octave_idx_type>(numChannels),
        static_cast<octave_idx_type>(numSamples));

    auto *samplesBuff = intermediate.fortran_vec();
    std::vector<void *> buffs;
    for(size_t chan = 0; chan < numChannels; ++chan)
    {
        buffs.emplace_back(&samplesBuff[chan * numSamples]);
    }

    const auto readRet = device->readStream(
        stream,
        buffs.data(),
        numSamples,
        flagsOut,
        timeNsOut,
        timeoutUs);

    samplesOut = intermediate;

    return readRet;
}

}

inline int readStreamCF32(
    SoapySDR::Device *device,
    SoapySDR::Stream *stream,
    const size_t numSamples,
    const size_t numChannels,
    octave_value &samplesOut,
    int &flagsOut,
    long long &timeNsOut,
    const long timeoutUs)
{
    return detail::readStream<FloatComplexMatrix>(
        device,
        stream,
        numSamples,
        numChannels,
        samplesOut,
        flagsOut,
        timeNsOut,
        timeoutUs);
}

inline int readStreamCF64(
    SoapySDR::Device *device,
    SoapySDR::Stream *stream,
    const size_t numSamples,
    const size_t numChannels,
    octave_value &samplesOut,
    int &flagsOut,
    long long &timeNsOut,
    const long timeoutUs)
{
    return detail::readStream<ComplexMatrix>(
        device,
        stream,
        numSamples,
        numChannels,
        samplesOut,
        flagsOut,
        timeNsOut,
        timeoutUs);
}

}}
