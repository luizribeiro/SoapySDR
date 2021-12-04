// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%{
#include "Stream.hpp"
#include "Utility.hpp"
%}

%include <attribute.i>
%include <std_pair.i>
%include <stdint.i>
%include <typemaps.i>

%apply double& OUTPUT { double& fullScale };

%typemap(csclassmodifiers) std::pair<SoapySDR::CSharp::ErrorCode, SoapySDR::CSharp::StreamResult> "internal class";
%template(StreamResultPairInternal) std::pair<SoapySDR::CSharp::ErrorCode, SoapySDR::CSharp::StreamResult>;

// 
// Use the C# enum for direction
//

%typemap(cstype) const int direction "Direction"
%typemap(csin,
         pre="int temp$csinput = (int)$csinput;")
         const int direction
         "temp$csinput"

%typemap(csimports) SoapySDR::Device "
using System;
using System.Collections.Generic;
using System.Linq;"

%csmethodmodifiers SoapySDR::Device::make "private";
%csmethodmodifiers SoapySDR::Device::unmake "private";

// Don't wrap deprecated functions
%ignore SoapySDR::Device::listSampleRates;
%ignore SoapySDR::Device::listBandwidths;

// Ignore stream-related functions, we're rewriting
%ignore SoapySDR::Device::setupStream;
%ignore SoapySDR::Device::closeStream;
%ignore SoapySDR::Device::getStreamMTU;
%ignore SoapySDR::Device::activateStream;
%ignore SoapySDR::Device::deactivateStream;
%ignore SoapySDR::Device::readStream;
%ignore SoapySDR::Device::writeStream;
%ignore SoapySDR::Device::readStreamStatus;
%ignore SoapySDR::Device::getNumDirectAccessBuffers;
%ignore SoapySDR::Device::getDirectAccessBufferAddrs;
%ignore SoapySDR::Device::acquireReadBuffer;
%ignore SoapySDR::Device::releaseReadBuffer;
%ignore SoapySDR::Device::acquireWriteBuffer;
%ignore SoapySDR::Device::releaseWriteBuffer;

// Ignore functions explicitly using std::vector<unsigned> due to size_t workaround
%ignore SoapySDR::Device::writeRegisters;
%ignore SoapySDR::Device::readRegisters;

// Don't wrap development-layer functions
%ignore SoapySDR::Device::getNativeDeviceHandle;

// csout typemaps don't apply to properties, so this is necessary
%csmethodmodifiers SoapySDR::Device::MasterClockRatesInternal "private";
%csmethodmodifiers SoapySDR::Device::ReferenceClockRatesInternal "private";

// Per C# convention, convert trivial getters and setters to properties
%attributestring(SoapySDR::Device, std::string, DriverKey, getDriverKey);
%attributestring(SoapySDR::Device, std::string, HardwareKey, getHardwareKey);
%attribute(SoapySDR::Device, double, MasterClockRate, getMasterClockRate, setMasterClockRate);
%attributeval(SoapySDR::Device, std::vector<SoapySDR::Range>, MasterClockRatesInternal, getMasterClockRates);
%attribute(SoapySDR::Device, double, ReferenceClockRate, getReferenceClockRate, setReferenceClockRate);
%attributeval(SoapySDR::Device, std::vector<SoapySDR::Range>, ReferenceClockRatesInternal, getReferenceClockRates);

%typemap(cscode) SoapySDR::Device
%{
    public List<Range> MasterClockRates => new List<Range>(MasterClockRatesInternal);

    public List<Range> ReferenceClockRates => new List<Range>(ReferenceClockRatesInternal);
%}

%nodefaultctor SoapySDR::Device;
%include <SoapySDR/Device.hpp>

%csmethodmodifiers SoapySDR::Device::SetupStreamInternal "internal";
%csmethodmodifiers SoapySDR::Device::CloseStreamInternal "internal";
%csmethodmodifiers SoapySDR::Device::GetStreamMTUInternal "internal";
%csmethodmodifiers SoapySDR::Device::ActivateStreamInternal "internal";
%csmethodmodifiers SoapySDR::Device::DeactivateStreamInternal "internal";
%csmethodmodifiers SoapySDR::Device::ReadStreamInternal "internal";
%csmethodmodifiers SoapySDR::Device::WriteStreamInternal "internal";
%csmethodmodifiers SoapySDR::Device::ReadStreamStatusInternal "internal";

// Internal bridge functions to make the C# part easier
%extend SoapySDR::Device
{
    SoapySDR::CSharp::StreamHandle SetupStreamInternal(
        const SoapySDR::CSharp::Direction direction,
        const std::string& format,
        const SWIGSizeVector& channels,
        const SoapySDR::Kwargs& kwargs)
    {
        SoapySDR::CSharp::StreamHandle streamHandle;
        streamHandle.stream = self->setupStream(int(direction), format, copyVector<size_t>(channels), kwargs);
        streamHandle.format = format;
        streamHandle.channels = channels;

        return streamHandle;
    }

    void CloseStreamInternal(const SoapySDR::CSharp::StreamHandle& streamHandle)
    {
        self->closeStream(streamHandle.stream);
    }

    size_t GetStreamMTUInternal(const SoapySDR::CSharp::StreamHandle& streamHandle)
    {
        return self->getStreamMTU(streamHandle.stream);
    }

    SoapySDR::CSharp::ErrorCode ActivateStreamInternal(
        const SoapySDR::CSharp::StreamHandle& streamHandle,
        const SoapySDR::CSharp::StreamFlags flags,
        const long long timeNs,
        const size_t numElems)
    {
        return SoapySDR::CSharp::ErrorCode(self->activateStream(
            streamHandle.stream,
            int(flags),
            timeNs,
            numElems));
    }

    SoapySDR::CSharp::ErrorCode DeactivateStreamInternal(
        const SoapySDR::CSharp::StreamHandle& streamHandle,
        const SoapySDR::CSharp::StreamFlags flags,
        const long long timeNs)
    {
        return SoapySDR::CSharp::ErrorCode(self->deactivateStream(
            streamHandle.stream,
            int(flags),
            timeNs));
    }

    SoapySDR::CSharp::StreamResultPairInternal ReadStreamInternal(
        const SoapySDR::CSharp::StreamHandle& streamHandle,
        const SWIGSizeVector& buffs,
        const size_t numElems,
        const SoapySDR::CSharp::StreamFlags flags,
        const long long timeNs,
        const long timeoutUs)
    {
        SoapySDR::CSharp::StreamResultPairInternal resultPair;
        auto& errorCode = resultPair.first;
        auto& result = resultPair.second;

        const auto buffPtrs = reinterpretCastVector<void>(buffs);
        auto intFlags = int(flags);
        auto cppRet = self->readStream(
            streamHandle.stream,
            buffPtrs.data(),
            numElems,
            intFlags,
            result.TimeNs,
            result.TimeoutUs);
        result.Flags = SoapySDR::CSharp::StreamFlags(intFlags);

        if(cppRet >= 0) result.NumSamples = static_cast<size_t>(cppRet);
        else            errorCode = static_cast<SoapySDR::CSharp::ErrorCode>(cppRet);

        return resultPair;
    }

    SoapySDR::CSharp::StreamResultPairInternal WriteStreamInternal(
        const SoapySDR::CSharp::StreamHandle& streamHandle,
        const SWIGSizeVector& buffs,
        const size_t numElems,
        const long long timeNs,
        const long timeoutUs)
    {
        SoapySDR::CSharp::StreamResultPairInternal resultPair;
        auto& errorCode = resultPair.first;
        auto& result = resultPair.second;

        const auto buffPtrs = reinterpretCastVector<const void>(buffs);
        int intFlags = 0;
        auto cppRet = self->writeStream(
            streamHandle.stream,
            buffPtrs.data(),
            numElems,
            intFlags,
            timeNs,
            timeoutUs);
        result.Flags = SoapySDR::CSharp::StreamFlags(intFlags);

        if(cppRet >= 0) result.NumSamples = static_cast<size_t>(cppRet);
        else            errorCode = static_cast<SoapySDR::CSharp::ErrorCode>(cppRet);

        return resultPair;
    }

    SoapySDR::CSharp::StreamResultPairInternal ReadStreamStatusInternal(
        const SoapySDR::CSharp::StreamHandle& streamHandle,
        const long timeoutUs)
    {
        SoapySDR::CSharp::StreamResultPairInternal resultPair;
        auto& errorCode = resultPair.first;
        auto& result = resultPair.second;

        int intFlags = 0;
        errorCode = SoapySDR::CSharp::ErrorCode(self->readStreamStatus(
            streamHandle.stream,
            result.ChanMask,
            intFlags,
            result.TimeNs,
            result.TimeoutUs));
        result.Flags = SoapySDR::CSharp::StreamFlags(intFlags);

        return resultPair;
    }

    void WriteRegisters(
        const std::string &name,
        const unsigned addr,
        const SWIGSizeVector &value)
    {
        self->writeRegisters(name, addr, copyVector<unsigned>(value));
    }

    SWIGSizeVector ReadRegisters(
        const std::string &name,
        const unsigned addr,
        const size_t length) const
    {
        return copyVector<SWIGSize>(self->readRegisters(name, addr, length));
    }
};