// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%module SoapySDR
%feature("autodoc", "1");

%include "soapy_common.i"

%{
#include "Constants.hpp"
#include "Logger.hpp"
#include "Streaming.hpp"
#include "Types.hpp"
#include "Utility.hpp"

#include <SoapySDR/Config.hpp>
#include <SoapySDR/Time.hpp>
#include <SoapySDR/Types.hpp>
#include <SoapySDR/Version.hpp>

#include <algorithm>
#include <iterator>

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
// Note: the "freearg" typemaps here shouldn't be necessary, since
// this recreates the existing behavior, but adding the custom "in"
// typemap by itself results in the generated "freearg" code referencing
// an invalid variable.
//

%include <typemaps.i>

%typemap(in) const std::vector<std::string> & {
    $1 = SoapySDR::Octave::stringVectorOctaveToCpp($input.string_vector_value());
}

%typemap(freearg) const std::vector<std::string> & {
    delete $1;
}

%typemap(out) std::vector<std::string> {
    $result = SoapySDR::Octave::stringVectorCppToOctave($1);
}

%typemap(in) const std::vector<unsigned> & {
    $1 = SoapySDR::Octave::vectorOctaveToCpp<unsigned>($input.array_value());
}

%typemap(freearg) const std::vector<unsigned> & {
    delete $1;
}

%typemap(out) std::vector<unsigned> {
    $result = SoapySDR::Octave::vectorCppToOctave<unsigned>($1);
}

%typemap(in) const std::vector<size_t> & {
    $1 = SoapySDR::Octave::vectorOctaveToCpp<size_t>($input.array_value());
}

%typemap(freearg) const std::vector<size_t> & {
    delete $1;
}

%typemap(out) SoapySDR::ArgInfo {
    $result = new SoapySDR::Octave::ArgInfo($1);
}

%typemap(out) SoapySDR::ArgInfoList {
    auto *outputVec = new std::vector<SoapySDR::Octave::ArgInfo>();
    std::transform(
        $1.begin(),
        $1.end(),
        std::back_inserter(*outputVec),
        [](const SoapySDR::ArgInfo &cppArgInfo)
        {
            return SoapySDR::Octave::ArgInfo(cppArgInfo);
        });

    $result = outputVec;
}

%typemap(in) const SoapySDR::Kwargs & {
    $1 = SoapySDR::Octave::kwargsOctaveToCpp($input);
}

%typemap(freearg) const SoapySDR::Kwargs & {
    delete $1;
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

%template(RangeList) std::vector<SoapySDR::Range>;

%include <SoapySDR/Config.h>
%include <SoapySDR/Version.hpp>

%attribute(SoapySDR::Range, double, minimum, minimum);
%attribute(SoapySDR::Range, double, maximum, maximum);
%attribute(SoapySDR::Range, double, step, step);

%ignore SoapySDR::ArgInfo;
%ignore SoapySDR::ArgInfo(const SoapySDR::ArgInfo &);
%ignore SoapySDR::Octave::argInfoListCppToOctave;
%template(ArgInfoList) std::vector<SoapySDR::Octave::ArgInfo>;

%include "Types.hpp"
%include <SoapySDR/Types.hpp>

%extend SoapySDR::Octave::ArgInfo
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

%nodefaultctor SoapySDR::Octave::ArgType;
%nodefaultctor SoapySDR::Octave::Direction;
%nodefaultctor SoapySDR::Octave::ErrorCode;
%nodefaultctor SoapySDR::Octave::StreamFlag;
%nodefaultctor SoapySDR::Octave::StreamFormat;
%include <Constants.hpp>

%include <SoapySDR/Time.hpp>

%include "Device.i"

%ignore SoapySDR::Octave::detail;
%include "Logger.hpp"
