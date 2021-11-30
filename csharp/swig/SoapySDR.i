// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%module(directors="1") SoapySDR

%include <typemaps.i>
%include <std_vector.i>

////////////////////////////////////////////////////////////////////////
// Include all major headers to compile against
////////////////////////////////////////////////////////////////////////
%{
#include <SoapySDR/Version.hpp>
#include <SoapySDR/Modules.hpp>
#include <SoapySDR/Device.hpp>
#include <SoapySDR/Errors.hpp>
#include <SoapySDR/Formats.hpp>
#include <SoapySDR/Time.hpp>
#include <SoapySDR/Logger.hpp>

#include "Constants.hpp"
#include "Utility.hpp"
%}

%ignore copyVector;
%ignore toSizeTVector;
%ignore reinterpretCastVector;
%ignore detail::copyVector;
%include "Utility.hpp"

////////////////////////////////////////////////////////////////////////
// Enforce C# naming conventions
////////////////////////////////////////////////////////////////////////

%rename("%(camelcase)s", match$kind="function", regexmatch$name="^SoapySDR::") "";
%rename("%(camelcase)s", match$kind="class", regexmatch$name="^SoapySDR::") "";
%rename("%(camelcase)s", match$kind="variable", regexmatch$name="^SoapySDR::") "";

////////////////////////////////////////////////////////////////////////
// http://www.swig.org/Doc2.0/Library.html#Library_stl_exceptions
////////////////////////////////////////////////////////////////////////
%include <exception.i>

// We only expect to throw DirectorExceptions from within
// the C# logger class. This will allow us to propagate the
// C# error back to C#.
%exception
{
    try{$action}
    catch (const Swig::DirectorException &e)
    {SWIG_exception(SWIG_RuntimeError, e.what());}
    SWIG_CATCH_STDEXCEPT
    catch (...)
    {SWIG_exception(SWIG_RuntimeError, "unknown");}
}

////////////////////////////////////////////////////////////////////////
// Config header defines API export
////////////////////////////////////////////////////////////////////////
%include <SoapySDR/Config.h>

////////////////////////////////////////////////////////////////////////
// Commonly used data types
////////////////////////////////////////////////////////////////////////
%include <stdint.i>
%include <std_complex.i>
%include <std_string.i>
%include <std_map.i>

// Hide SWIG-generated STL types, they're ugly and half-done

//
// size_t
//

#ifdef SIZE_T_IS_UNSIGNED_INT
typedef unsigned int size_t;
#else
typedef unsigned long long size_t;
#endif

%typemap(csclassmodifiers) std::vector<size_t> "internal class";
%template(SizeListInternal) std::vector<size_t>;

%typemap(cstype) const std::vector<size_t> & "uint[]"
%typemap(csin,
    pre="
        var temp$csinput = new SizeListInternal();
        foreach(var x in $csinput) temp$csinput.Add(x);
    ") const std::vector<size_t> & "$csclassname.getCPtr(temp$csinput)"

//
// std::string
//

%typemap(csclassmodifiers) std::vector<std::string> "internal class";
%template(StringListInternal) std::vector<std::string>;

%typemap(cstype) std::vector<std::string> "System.Collections.Generic.List<string>"
%typemap(csout, excode=SWIGEXCODE) std::vector<std::string> {
    var stringListPtr = $imcall;$excode;

    return new System.Collections.Generic.List<string>(new StringListInternal(stringListPtr, false));
}

////////////////////////////////////////////////////////////////////////
// SoapySDR Types
////////////////////////////////////////////////////////////////////////
%include "Types.i"

////////////////////////////////////////////////////////////////////////
// Build info, enums
////////////////////////////////////////////////////////////////////////
%nodefaultctor SoapySDR::CSharp::BuildInfo;

// TODO: make SWIGABIVersion internal
%typemap(cscode) SoapySDR::CSharp::BuildInfo %{
    internal static readonly string AssemblyABIVersion = "@SOAPY_SDR_ABI_VERSION@";
%}

%include "Constants.hpp"

////////////////////////////////////////////////////////////////////////
// C# needs everything in classes, so add some simple structs for
// global functions
////////////////////////////////////////////////////////////////////////
%nodefaultctor Time;

%{
#include <SoapySDR/Time.hpp>

struct Time
{
    static __forceinline long long TicksToTimeNs(const long long ticks, const double rate)
    {
        return SoapySDR::ticksToTimeNs(ticks, rate);
    }

    static __forceinline long long TimeNsToTicks(const long long timeNs, const double rate)
    {
        return SoapySDR::timeNsToTicks(timeNs, rate);
    }
};
%}

struct Time
{
    static long long TicksToTimeNs(const long long ticks, const double rate);
    static long long TimeNsToTicks(const long long timeNs, const double rate);
};

////////////////////////////////////////////////////////////////////////
// With types established, this is the bulk of it
////////////////////////////////////////////////////////////////////////

%nodefaultctor SoapySDR::CSharp::StreamHandle;

%include "Stream.i"
%include "Device.i"
%include "Logger.i"