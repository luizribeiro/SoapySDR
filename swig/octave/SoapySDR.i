// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%module SoapySDR
%feature("autodoc", "1");

%include "soapy_common.i"

%{
#include "Constants.hpp"
#include "Streaming.hpp"
#include "Utility.hpp"

#include <SoapySDR/Config.hpp>
#include <SoapySDR/Time.hpp>
#include <SoapySDR/Types.hpp>
#include <SoapySDR/Version.hpp>

%}

//
// Exceptions
//

%include <exception.i>

%exception
{
    try{$action}
    SWIG_RETHROW_OCTAVE_EXCEPTIONS
    SWIG_CATCH_STDEXCEPT
    catch (...)
    {SWIG_exception(SWIG_RuntimeError, "unknown");}
}

//
// Typemaps
//

%include <typemaps.i>

%typemap(out) std::vector<std::string> {
    $result = SoapySDR::Octave::stringVectorCppToOctave($1);
}

%typemap(in) const SoapySDR::Kwargs & {
    $1 = SoapySDR::Octave::kwargsOctaveToCpp($input);
}

%typemap(out) SoapySDR::Kwargs {
    $result = SoapySDR::Octave::kwargsCppToOctave($1);
}

%typemap(out) SoapySDR::KwargsList {
    $result = SoapySDR::Octave::kwargsListCppToOctave($1);
}

//
// Types
//

%include <std_complex.i>
%include <std_map.i>
%include <std_string.i>
%include <std_vector.i>

%template(UnsignedVector) std::vector<unsigned>;
%template(SizeVector) std::vector<size_t>;
//%template(StringVector) std::vector<std::string>;
%template(Kwargs) std::map<std::string, std::string>;
%template(KwargsList) std::vector<std::map<std::string, std::string>>;
%template(ArgInfoList) std::vector<SoapySDR::ArgInfo>;
%template(RangeList) std::vector<SoapySDR::Range>;

%include <SoapySDR/Config.h>
%include <SoapySDR/Version.hpp>

%attribute(SoapySDR::Range, double, minimum, minimum);
%attribute(SoapySDR::Range, double, maximum, maximum);
%attribute(SoapySDR::Range, double, step, step);

%include <SoapySDR/Types.hpp>

%extend SoapySDR::ArgInfo
{
    std::string __str__()
    {
        return std::string("ArgInfo: ")+self->key;
    }
}

%extend SoapySDR::Range
{
    std::string __str__()
    {
        return std::string("Range: (")+std::to_string(self->minimum())+","+std::to_string(self->maximum())+","+std::to_string(self->step())+")";
    }
}

// TODO: figure out how to typemap ArgInfo::Type to int and use this instead
%nodefaultctor SoapySDR::Octave::ArgType;
%nodefaultctor SoapySDR::Octave::Direction;
%nodefaultctor SoapySDR::Octave::ErrorCode;
%nodefaultctor SoapySDR::Octave::StreamFlag;
%nodefaultctor SoapySDR::Octave::StreamFormat;
%include <Constants.hpp>

%include <SoapySDR/Time.hpp>

%include "Device.i"
