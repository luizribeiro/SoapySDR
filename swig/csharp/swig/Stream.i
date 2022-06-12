// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%typemap(csclassmodifiers) SoapySDR::CSharp::StreamHandle "internal class";
%nodefaultctor SoapySDR::CSharp::StreamHandle;
%ignore SoapySDR::CSharp::StreamHandle::stream;
%ignore SoapySDR::CSharp::StreamHandle::channels;
%ignore SoapySDR::CSharp::StreamHandle::format;

%nodefaultctor SoapySDR::CSharp::StreamFormat;

%{
#include "Stream.hpp"
%}

// Allows bitwise operations
%typemap(csimports) SoapySDR::CSharp::StreamFlags "
using System;"
%typemap(csclassmodifiers) SoapySDR::CSharp::StreamFlags "
/// <summary>
/// Bitwise flags to be passed into or returned from streaming functions.
/// </summary>
[Flags]
public enum";

%csattributes SoapySDR::CSharp::StreamFlags::None "/// <summary>No flags.</summary>";
%csattributes SoapySDR::CSharp::StreamFlags::EndBurst "///
/// <summary>
/// Indicate end of burst for transmit or receive. For write, end of burst if set by the caller. For read, end of burst is set by the driver.
/// </summary>";
%csattributes SoapySDR::CSharp::StreamFlags::HasTime "///
/// <summary>
/// Indicates that the time stamp is valid. For write, the caller must set has time when <b>timeNs</b> is provided. For read, the driver sets has time when <b>timeNs</b> is provided.
/// </summary>";
%csattributes SoapySDR::CSharp::StreamFlags::EndAbrupt "///
/// <summary>
/// Indicates that the stream terminated prematurely. This is the flag version of an overflow error that indicates an overflow with the end samples.
/// </summary>";
%csattributes SoapySDR::CSharp::StreamFlags::OnePacket "///
/// <summary>
/// Indicates transmit or receive only a single packet.
/// Applicable when the driver fragments samples into packets.
///
/// For write, the user sets this flag to only send a single packet.
/// For read, the user sets this flag to only receive a single packet.
/// </summary>";
%csattributes SoapySDR::CSharp::StreamFlags::MoreFragments "///
/// <summary>
/// Indicate that this read call and the next results in a fragment.
/// Used when the implementation has an underlying packet interface.
///
/// The caller can use this indicator and the OnePacket flag
/// on subsequent read stream calls to re-align with packet boundaries.
/// </summary>";
%csattributes SoapySDR::CSharp::StreamFlags::WaitTrigger "///
/// <summary>
/// Indicate that the stream should wait for an external trigger event.
/// This flag might be used with the <b>flags</b> argument in any of the
/// stream API calls. The trigger implementation is hardware-specific.
/// </summary>";
%csattributes SoapySDR::CSharp::StreamFlags::UserFlag0 "/// <summary>A flag that can be used for SDR specific data.</summary>";
%csattributes SoapySDR::CSharp::StreamFlags::UserFlag1 "/// <summary>A flag that can be used for SDR specific data.</summary>";
%csattributes SoapySDR::CSharp::StreamFlags::UserFlag2 "/// <summary>A flag that can be used for SDR specific data.</summary>";
%csattributes SoapySDR::CSharp::StreamFlags::UserFlag3 "/// <summary>A flag that can be used for SDR specific data.</summary>";
%csattributes SoapySDR::CSharp::StreamFlags::UserFlag4 "/// <summary>A flag that can be used for SDR specific data.</summary>";

%typemap(csimports) SoapySDR::CSharp::StreamHandle "
using System;
using System.Linq;"

%include "Stream.hpp"