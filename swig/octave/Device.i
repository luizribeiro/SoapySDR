// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%{
#include <SoapySDR/Device.hpp>
%}

// Don't wrap deprecated functions
%ignore SoapySDR::Device::listSampleRates;
%ignore SoapySDR::Device::listBandwidths;
%ignore SoapySDR::Device::setCommandTime;
%ignore SoapySDR::Device::writeRegister(const unsigned, const unsigned);
%ignore SoapySDR::Device::readRegister(const unsigned) const;

// Ignore DMA-related functions
%ignore SoapySDR::Device::getNumDirectAccessBuffers;
%ignore SoapySDR::Device::getDirectAccessBufferAddrs;
%ignore SoapySDR::Device::acquireReadBuffer;
%ignore SoapySDR::Device::releaseReadBuffer;
%ignore SoapySDR::Device::acquireWriteBuffer;
%ignore SoapySDR::Device::releaseWriteBuffer;

// Don't wrap development-layer functions
%ignore SoapySDR::Device::getNativeDeviceHandle;

%include <SoapySDR/Device.hpp>
