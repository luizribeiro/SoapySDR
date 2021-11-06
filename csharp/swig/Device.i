// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%include <std_pair.i>
%include <stdint.i>
%include <typemaps.i>

//
// Wrapper class
//

%typemap(csimports) SoapySDR::CSharp::Device "
using System;"

%apply double& OUTPUT { double& fullScaleOut };

%ignore SoapySDR::CSharp::DeviceDeleter;
%nodefaultctor SoapySDR::CSharp::DeviceInternal;

%typemap(csclassmodifiers) std::pair<SoapySDR::CSharp::ErrorCode, SoapySDR::CSharp::StreamResult> "internal class";
%template(StreamResultPairInternal) std::pair<SoapySDR::CSharp::ErrorCode, SoapySDR::CSharp::StreamResult>;

%{
#include "DeviceInternal.hpp"
%}

%typemap(csclassmodifiers) SoapySDR::CSharp::DeviceInternal "internal class"
%include "DeviceInternal.hpp"

%typemap(csclassmodifiers) std::vector<SoapySDR::CSharp::DeviceInternal> "internal class"
%template(DeviceListInternal) std::vector<SoapySDR::CSharp::DeviceInternal>;
