// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%{
#include "Stream.hpp"
#include "Utility.hpp"
%}

%include <std_pair.i>
%include <std_vector.i>        
%include <stdint.i>
%include <typemaps.i>

%apply double& OUTPUT { double& fullScale };

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
using System.Collections.Generic;"
         
%rename(DeviceTemp) SoapySDR::Device;

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

%ignore SoapySDR::Device::getNativeDeviceHandle;

%typemap(cscode) SoapySDR::Device
%{
    public string DriverKey => GetDriverKey();

    public string HardwareKey => GetHardwareKey();

    public Dictionary<string, string> HardwareInfo => GetHardwareInfo();
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

// Internal stream-related bridge functions to make the C# part easier
%extend SoapySDR::Device
{
    SoapySDR::CSharp::StreamHandle SetupStreamInternal(
        int direction,
        const std::string& format,
        const SWIGSizeVector& channels,
        const SoapySDR::Kwargs& kwargs)
    {
        SoapySDR::CSharp::StreamHandle streamHandle;
        streamHandle.stream = self->setupStream(direction, format, copyVector<size_t>(channels), kwargs);
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

    StreamResultPairInternal ReadStreamInternal(
        const SoapySDR::CSharp::StreamHandle& streamHandle,
        const SWIGSizeVector& buffs,
        const size_t numElems,
        const SoapySDR::CSharp::StreamFlags flags,
        const long long timeNs,
        const long timeoutUs)
    {
        StreamResultPairInternal resultPair;
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

    StreamResultPairInternal WriteStreamInternal(
        const SoapySDR::CSharp::StreamHandle& streamHandle,
        const SWIGSizeVector& buffs,
        const size_t numElems,
        const long long timeNs,
        const long timeoutUs)
    {
        StreamResultPairInternal resultPair;
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

    StreamResultPairInternal ReadStreamStatusInternal(
        const SoapySDR::CSharp::StreamHandle& streamHandle,
        const long timeoutUs)
    {
        StreamResultPairInternal resultPair;
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
};

//
// Wrapper class
//

%typemap(csimports) SoapySDR::CSharp::Device "
using System;"

%ignore SoapySDR::CSharp::DeviceDeleter;
%nodefaultctor SoapySDR::CSharp::DeviceInternal;

%typemap(csclassmodifiers) std::pair<SoapySDR::CSharp::ErrorCode, SoapySDR::CSharp::StreamResult> "internal class";
%template(StreamResultPairInternal) std::pair<SoapySDR::CSharp::ErrorCode, SoapySDR::CSharp::StreamResult>;

%{
#include "DeviceInternal.hpp"
%}

%typemap(csclassmodifiers) SoapySDR::CSharp::DeviceInternal "internal class";
%include "DeviceInternal.hpp"