// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%include <std_pair.i>
%include <std_vector.i>        
%include <stdint.i>
%include <typemaps.i>

%apply double& OUTPUT { double& fullScale };
%apply double& OUTPUT { double& fullScaleOut };

// 
// Use the C# enum for direction
//

%typemap(cstype) const int direction "Direction"
%typemap(csin,
         pre="int temp$csinput = (int)$csinput;")
         const int direction
         "temp$csinput"

%typemap(csimports) SoapySDR::Device "
using System;"
         
%rename(DeviceTemp) SoapySDR::Device;

%csmethodmodifiers SoapySDR::Device::make "private";
%csmethodmodifiers SoapySDR::Device::unmake "private";

// Don't wrap deprecated functions
%ignore SoapySDR::Device::listSampleRates;
%ignore SoapySDR::Device::listBandwidths;

%include <SoapySDR/Device.hpp>

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

%typemap(csclassmodifiers) std::vector<SoapySDR::CSharp::DeviceInternal> "internal class";
%template(DeviceListInternal) std::vector<SoapySDR::CSharp::DeviceInternal>;
