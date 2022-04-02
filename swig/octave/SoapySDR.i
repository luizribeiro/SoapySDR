// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%module SoapySDR

%include "soapy_common.i"

%{
#include "Constants.hpp"
#include "Streaming.hpp"

#include <SoapySDR/Config.hpp>
#include <SoapySDR/Time.hpp>
#include <SoapySDR/Types.hpp>
#include <SoapySDR/Version.hpp>
%}

%include <exception.i>

%exception
{
    try{$action}
    SWIG_RETHROW_OCTAVE_EXCEPTIONS
    SWIG_CATCH_STDEXCEPT
    catch (...)
    {SWIG_exception(SWIG_RuntimeError, "unknown");}
}

%include <std_complex.i>
%include <std_map.i>
%include <std_string.i>
%include <std_vector.i>

%template(UnsignedVector) std::vector<unsigned>;
%template(StringVector) std::vector<std::string>;
%template(Kwargs) std::map<std::string, std::string>;
%template(KwargsList) std::vector<std::map<std::string, std::string>>;

%include <SoapySDR/Config.h>
%include <SoapySDR/Version.hpp>
%include <SoapySDR/Types.hpp>
%include <SoapySDR/Time.hpp>

// TODO: figure out how to typemap ArgInfo::Type to int and use this instead
%nodefaultctor SoapySDR::Octave::ArgType;
%nodefaultctor SoapySDR::Octave::Direction;
%nodefaultctor SoapySDR::Octave::ErrorCode;
%nodefaultctor SoapySDR::Octave::StreamFlag;
%nodefaultctor SoapySDR::Octave::StreamFormat;
%include <Constants.hpp>

%include "Device.i"
