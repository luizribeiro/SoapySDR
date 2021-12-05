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

%typemap(csdisposing, methodname="Dispose", methodmodifiers="protected", parameters="bool disposing") SoapySDR::Device {
    lock(this) {
      if (swigCPtr.Handle != global::System.IntPtr.Zero) {
        if (swigCMemOwn) {
          swigCMemOwn = false;
          Unmake(this);
        }
        swigCPtr = new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
      }
    }
  }

%typemap(csdisposing_derived, methodname="Dispose", methodmodifiers="protected", parameters="bool disposing") SoapySDR::Device {
    lock(this) {
      if (swigCPtr.Handle != global::System.IntPtr.Zero) {
        if (swigCMemOwn) {
          swigCMemOwn = false;
          Unmake(this);
        }
        swigCPtr = new global::System.Runtime.InteropServices.HandleRef(null, global::System.IntPtr.Zero);
      }
      base.Dispose(disposing);
    }
  }

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

// Per C# convention, convert trivial getters and setters to properties
%attributestring(SoapySDR::Device, std::string, DriverKey, getDriverKey);
%attributestring(SoapySDR::Device, std::string, HardwareKey, getHardwareKey);
%attributeval(SoapySDR::Device, SoapySDR::Kwargs, HardwareInfo, getHardwareInfo);
%attribute(SoapySDR::Device, double, MasterClockRate, getMasterClockRate, setMasterClockRate);
%attributeval(SoapySDR::Device, std::vector<SoapySDR::Range>, MasterClockRates, getMasterClockRates);
%attribute(SoapySDR::Device, double, ReferenceClockRate, getReferenceClockRate, setReferenceClockRate);
%attributeval(SoapySDR::Device, std::vector<SoapySDR::Range>, ReferenceClockRates, getReferenceClockRates);
%attributestring(SoapySDR::Device, std::string, ClockSource, getClockSource, setClockSource);
%attributeval(SoapySDR::Device, std::vector<std::string>, ClockSources, listClockSources);
%attributestring(SoapySDR::Device, std::string, TimeSource, getTimeSource, setTimeSource);
%attributeval(SoapySDR::Device, std::vector<std::string>, TimeSources, listTimeSources);
%attributeval(SoapySDR::Device, std::vector<std::string>, RegisterInterfaces, listRegisterInterfaces);
%attributeval(SoapySDR::Device, std::vector<std::string>, GPIOBanks, listGPIOBanks);
%attributeval(SoapySDR::Device, std::vector<std::string>, UARTs, listUARTs);

%typemap(cscode) SoapySDR::Device
%{
    public static KwargsList Enumerate() => Enumerate("");

    public TxStream SetupTxStream(
        string format,
        uint[] channels,
        IDictionary<string, string> kwargs)
    {
        return new TxStream(this, format, channels, Utility.ToKwargs(kwargs));
    }

    public TxStream SetupTxStream(
        string format,
        uint[] channels,
        string args) => SetupTxStream(format, channels, Utility.ToKwargs(args));

    public RxStream SetupRxStream(
        string format,
        uint[] channels,
        IDictionary<string, string> kwargs)
    {
        return new RxStream(this, format, channels, Utility.ToKwargs(kwargs));
    }

    public RxStream SetupRxStream(
        string format,
        uint[] channels,
        string args) => SetupRxStream(format, channels, Utility.ToKwargs(args));

    public void SetFrequency(Direction direction, uint channel, double frequency, string args = "") =>
        SetFrequency(direction, channel, frequency, Utility.ToKwargs(args));

    public void SetFrequency(Direction direction, uint channel, string name, double frequency, string args = "") =>
        SetFrequency(direction, channel, name, frequency, Utility.ToKwargs(args));

    public T ReadSensor<T>(string key)
    {
        return (T)(new SoapyConvertible(ReadSensor(key)).ToType(typeof(T), null));
    }

    public T ReadSensor<T>(Direction direction, uint channel, string key)
    {
        return (T)(new SoapyConvertible(ReadSensor(direction, channel, key)).ToType(typeof(T), null));
    }

    public T ReadSetting<T>(string key)
    {
        return (T)(new SoapyConvertible(ReadSetting(key)).ToType(typeof(T), null));
    }

    public T ReadSetting<T>(Direction direction, uint channel, string key)
    {
        return (T)(new SoapyConvertible(ReadSetting(direction, channel, key)).ToType(typeof(T), null));
    }

    public void WriteSetting<T>(string key, T value)
    {
        WriteSetting(key, new SoapyConvertible(value).ToString());
    }

    public void WriteSetting<T>(Direction direction, uint channel, string key, T value)
    {
        WriteSetting(direction, channel, key, new SoapyConvertible(value).ToString());
    }
%}

%nodefaultctor SoapySDR::Device;
%ignore SoapySDR::Device::make;
%ignore SoapySDR::Device::unmake(const std::vector<Device *> &);
%csmethodmodifiers SoapySDR::Device::unmake "private";

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