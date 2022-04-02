// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%include <attribute.i>

// TODO: naming convention?

%{
#include <SoapySDR/Device.hpp>
%}

// Ignore normal factory stuff
%nodefaultctor SoapySDR::Device;
%ignore SoapySDR::Device::make;
%ignore SoapySDR::Device::unmake(const std::vector<Device *> &);

// Don't wrap deprecated functions
%ignore SoapySDR::Device::listSampleRates;
%ignore SoapySDR::Device::listBandwidths;
%ignore SoapySDR::Device::setCommandTime;
%ignore SoapySDR::Device::writeRegister(const unsigned, const unsigned);
%ignore SoapySDR::Device::readRegister(const unsigned) const;

// Ignore stream-related functions, we're rewriting
%ignore SoapySDR::Device::setupStream;
%ignore SoapySDR::Device::closeStream;
%ignore SoapySDR::Device::getStreamMTU;
%ignore SoapySDR::Device::activateStream;
%ignore SoapySDR::Device::deactivateStream;
%ignore SoapySDR::Device::readStream;
%ignore SoapySDR::Device::writeStream;
%ignore SoapySDR::Device::readStreamStatus;

// Ignore DMA-related functions
%ignore SoapySDR::Device::getNumDirectAccessBuffers;
%ignore SoapySDR::Device::getDirectAccessBufferAddrs;
%ignore SoapySDR::Device::acquireReadBuffer;
%ignore SoapySDR::Device::releaseReadBuffer;
%ignore SoapySDR::Device::acquireWriteBuffer;
%ignore SoapySDR::Device::releaseWriteBuffer;

// Don't wrap development-layer functions
%ignore SoapySDR::Device::getNativeDeviceHandle;

%attributestring(SoapySDR::Device, std::string, driverKey, getDriverKey);
%attributestring(SoapySDR::Device, std::string, hardwareKey, getHardwareKey);

%include <SoapySDR/Device.hpp>

%extend SoapySDR::Device
{
    Device()
    {
        return SoapySDR::Device::make("");
    }

    Device(const SoapySDR::Kwargs &kwargs)
    {
        return SoapySDR::Device::make(kwargs);
    }

    Device(const std::string &args)
    {
        return SoapySDR::Device::make(args);
    }

    std::string __str__()
    {
        return self->getDriverKey() + ":" + self->getHardwareKey();
    }

    // TODO: struct that stores stream stuff like C# wrapper
    int readStream2(
        SoapySDR::Stream *stream,
        octave_value &output,
        const size_t numSamples,
        const size_t numChannels,
        int &flagsOut,
        long &timeNsOut,
        const long timeoutUs)
    {
        // SWIG+Octave does not support long long
        long long intermediateTimeNs = 0;

        auto ret = SoapySDR::Octave::readStreamCF32(
            self,
            stream,
            numSamples,
            numChannels,
            output,
            flagsOut,
            intermediateTimeNs,
            timeoutUs);

        timeNsOut = static_cast<long long>(intermediateTimeNs);
        return ret;
    }
}
