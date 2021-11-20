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
%include <std_vector.i>
%include <std_map.i>

// Hide SWIG-generated STL types, they're ugly and half-done

#ifdef SIZE_T_IS_UNSIGNED_INT
%typemap(csclassmodifiers) std::vector<uint32_t> "internal class"
%template(SizeListInternal) std::vector<uint32_t>;
#else
%typemap(csclassmodifiers) std::vector<uint64_t> "internal class"
%template(SizeListInternal) std::vector<uint64_t>;
#endif

%typemap(csclassmodifiers) std::vector<std::string> "internal class"
%template(StringListInternal) std::vector<std::string>;

%typemap(csclassmodifiers) std::vector<double> "internal class"
%template(DoubleListInternal) std::vector<double>;

////////////////////////////////////////////////////////////////////////
// SoapySDR Types
////////////////////////////////////////////////////////////////////////

%typemap(csclassmodifiers) SoapySDR::ArgInfo "internal class"
%rename(ArgInfoInternal) SoapySDR::ArgInfo;

%typemap(csclassmodifiers) SoapySDR::Range "internal class"
%rename(RangeInternal) SoapySDR::Range;

%ignore SoapySDR::KwargsFromString;
%ignore SoapySDR::KwargsToString;
%ignore SoapySDR::SettingToString;
%ignore SoapySDR::StringToSetting;
%ignore SoapySDR::Detail::SettingToString;
%ignore SoapySDR::Detail::StringToSetting;
%include <SoapySDR/Types.hpp>

// Hide SWIG-generated STL types, they're ugly and half-done

// SoapySDR::Kwargs
%typemap(csclassmodifiers) std::map<std::string, std::string> "internal class"
%template(KwargsInternal) std::map<std::string, std::string>;

%typemap(csclassmodifiers) std::vector<SoapySDR::Kwargs> "internal class"
%template(KwargsListInternal) std::vector<SoapySDR::Kwargs>;

%typemap(csclassmodifiers) std::vector<SoapySDR::ArgInfo> "internal class"
%template(ArgInfoListInternal) std::vector<SoapySDR::ArgInfo>;

%typemap(csclassmodifiers) std::vector<SoapySDR::Range> "internal class"
%template(RangeListInternal) std::vector<SoapySDR::Range>;

////////////////////////////////////////////////////////////////////////
// Build info, enums
////////////////////////////////////////////////////////////////////////
%typemap(csclassmodifiers) SoapySDR::CSharp::BuildInfo "public partial class"
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
%typemap(csclassmodifiers) TypeConversionInternal "internal class"
%nodefaultctor TypeConversionInternal;
%nodefaultctor Time;

%{
#include <SoapySDR/Time.hpp>
#include <SoapySDR/Types.hpp>

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

struct TypeConversionInternal
{
    template <typename T>
    static __forceinline std::string SettingToString(const T& setting)
    {
        return SoapySDR::SettingToString<T>(setting);
    }

    template <typename T>
    static __forceinline T StringToSetting(const std::string& setting)
    {
        return SoapySDR::StringToSetting<T>(setting);
    }

    static __forceinline SoapySDR::Kwargs StringToKwargs(const std::string& args)
    {
        return SoapySDR::KwargsFromString(args);
    }
};
%}

struct Time
{
    static long long TicksToTimeNs(const long long ticks, const double rate);
    static long long TimeNsToTicks(const long long timeNs, const double rate);
};

struct TypeConversionInternal
{
    template <typename T>
    static std::string SettingToString(const T& setting);

    template <typename T>
    static T StringToSetting(const std::string& setting);

    static SoapySDR::Kwargs StringToKwargs(const std::string& args);
};

%template(SByteToString) TypeConversionInternal::SettingToString<int8_t>;
%template(ShortToString) TypeConversionInternal::SettingToString<int16_t>;
%template(IntToString) TypeConversionInternal::SettingToString<int32_t>;
%template(LongToString) TypeConversionInternal::SettingToString<int64_t>;
%template(ByteToString) TypeConversionInternal::SettingToString<uint8_t>;
%template(UShortToString) TypeConversionInternal::SettingToString<uint16_t>;
%template(UIntToString) TypeConversionInternal::SettingToString<uint32_t>;
%template(ULongToString) TypeConversionInternal::SettingToString<uint64_t>;
%template(BoolToString) TypeConversionInternal::SettingToString<bool>;
%template(FloatToString) TypeConversionInternal::SettingToString<float>;
%template(DoubleToString) TypeConversionInternal::SettingToString<double>;

%template(StringToSByte) TypeConversionInternal::StringToSetting<int8_t>;
%template(StringToShort) TypeConversionInternal::StringToSetting<int16_t>;
%template(StringToInt) TypeConversionInternal::StringToSetting<int32_t>;
%template(StringToLong) TypeConversionInternal::StringToSetting<int64_t>;
%template(StringToByte) TypeConversionInternal::StringToSetting<uint8_t>;
%template(StringToUShort) TypeConversionInternal::StringToSetting<uint16_t>;
%template(StringToUInt) TypeConversionInternal::StringToSetting<uint32_t>;
%template(StringToULong) TypeConversionInternal::StringToSetting<uint64_t>;
%template(StringToBool) TypeConversionInternal::StringToSetting<bool>;
%template(StringToFloat) TypeConversionInternal::StringToSetting<float>;
%template(StringToDouble) TypeConversionInternal::StringToSetting<double>;

////////////////////////////////////////////////////////////////////////
// With types established, this is the bulk of it
////////////////////////////////////////////////////////////////////////

%ignore copyVector;
%ignore toSizeTVector;
%ignore reinterpretCastVector;
%ignore detail::copyVector;
%include "Utility.hpp"

%nodefaultctor SoapySDR::CSharp::StreamHandle;

%include "Stream.i"
%include "Device.i"
%include "Logger.i"