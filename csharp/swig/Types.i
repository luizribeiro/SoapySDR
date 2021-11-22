// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%{
#include "Utility.hpp"

#include <SoapySDR/Types.hpp>
%}

%ignore copyVector;
%ignore toSizeTVector;
%ignore reinterpretCastVector;
%ignore detail::copyVector;
%include "Utility.hpp"

%include <attribute.i>
%include <std_map.i>
%include <std_string.i>
%include <std_vector.i>

//
// ArgInfo
//

%rename(Key) SoapySDR::ArgInfo::key;
%rename(Value) SoapySDR::ArgInfo::value;
%rename(Name) SoapySDR::ArgInfo::name;
%rename(Description) SoapySDR::ArgInfo::description;
%rename(Units) SoapySDR::ArgInfo::units;
%rename(ArgType) SoapySDR::ArgInfo::type;
%rename(Range) SoapySDR::ArgInfo::range;

// Don't expose internal types
%csmethodmodifiers SoapySDR::ArgInfo::options "private";
%csmethodmodifiers SoapySDR::ArgInfo::optionNames "private";

%typemap(cscode) SoapySDR::ArgInfo
%{
    public string[] Options
    {
        get => options.ToArray();
        set => options = new StringListInternal(value);
    }
    
    public string[] OptionNames
    {
        get => optionNames.ToArray();
        set => optionNames = new StringListInternal(value);
    }

    //
    // Object overrides
    //

    public override string ToString()
    {
        return string.Format("{0} ({1})", Name, ArgType);
    }

    public override bool Equals(object obj)
    {
        var objAsArgInfo = obj as ArgInfo;
        if(objAsArgInfo != null) return Key.Equals(objAsArgInfo.Key) && ArgType.Equals(objAsArgInfo.ArgType);
        else                     return false;
    }

    public override int GetHashCode() => GetType().GetHashCode() ^ Key.GetHashCode() ^ ArgType.GetHashCode();
%}

// Hide SWIG-generated STL types, they're ugly and half-done
%typemap(csclassmodifiers) std::vector<SoapySDR::ArgInfo> "internal class";
%template(ArgInfoListInternal) std::vector<SoapySDR::ArgInfo>;

//
// Kwargs
//

// Hide SWIG-generated STL types, they're ugly and half-done

%typemap(csclassmodifiers) std::map<std::string, std::string> "internal class";
%template(KwargsInternal) std::map<std::string, std::string>;

%typemap(csclassmodifiers) std::vector<std::map<std::string, std::string>> "internal class";
%template(KwargsListInternal) std::vector<std::map<std::string, std::string>>;

//
// Range
//

%attribute(SoapySDR::Range, double, Minimum, minimum);
%attribute(SoapySDR::Range, double, Maximum, maximum);
%attribute(SoapySDR::Range, double, Step, step);

%typemap(cscode) SoapySDR::Range
%{
    //
    // Object overrides
    //

    public override string ToString()
    {
        return string.Format("Range: min={0}, max={1}, step={2}", Minimum, Maximum, Step);
    }

    public override bool Equals(object obj)
    {
        var objAsRange = obj as Range;
        if(objAsRange != null) return Minimum.Equals(objAsRange.Minimum) && Maximum.Equals(objAsRange.Maximum) && Step.Equals(objAsRange.Step);
        else                   return false;
    }

    public override int GetHashCode() => GetType().GetHashCode() ^ Minimum.GetHashCode() ^ Maximum.GetHashCode() ^ Step.GetHashCode();
%}

// Hide SWIG-generated STL types, they're ugly and half-done
%typemap(csclassmodifiers) std::vector<SoapySDR::Range> "internal class";
%template(RangeListInternal) std::vector<SoapySDR::Range>;

//
// Type conversion
//

%typemap(csclassmodifiers) TypeConversionInternal "internal class";
%nodefaultctor TypeConversionInternal;

%{
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

//
// Finally, include the header
//

%ignore SoapySDR::KwargsFromString;
%ignore SoapySDR::KwargsToString;
%ignore SoapySDR::SettingToString;
%ignore SoapySDR::StringToSetting;
%ignore SoapySDR::Detail::SettingToString;
%ignore SoapySDR::Detail::StringToSetting;
%include <SoapySDR/Types.hpp>