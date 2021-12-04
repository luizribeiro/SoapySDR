// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%{
#include "Utility.hpp"

#include <SoapySDR/Types.hpp>
%}

%include <attribute.i>
%include <std_map.i>
%include <std_string.i>

//
// ArgInfo
//

// Needed because the "type" variable would be renamed to Type, which
// conflicts with the enum type name
%rename(ArgType) SoapySDR::ArgInfo::type;

// Don't expose internal types
%csmethodmodifiers SoapySDR::ArgInfo::options "private";
%csmethodmodifiers SoapySDR::ArgInfo::optionNames "private";

%rename(__Options) SoapySDR::ArgInfo::options;
%rename(__OptionNames) SoapySDR::ArgInfo::optionNames;

%typemap(cscode) SoapySDR::ArgInfo
%{
    public string[] Options
    {
        get => __Options.ToArray();
        set => __Options = new StringListInternal(value);
    }
    
    public string[] OptionNames
    {
        get => __OptionNames.ToArray();
        set => __OptionNames = new StringListInternal(value);
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

    public override int GetHashCode() => GetType().GetHashCode() ^ (Key.GetHashCode() << 1) ^ (ArgType.GetHashCode() << 2);
%}

// Hide SWIG-generated STL types, they're ugly and half-done
%typemap(cstype) std::vector<SoapySDR::ArgInfo> "System.Collections.Generic.List<ArgInfo>"
%typemap(csout, excode=SWIGEXCODE) std::vector<SoapySDR::ArgInfo> {
    var argInfoListPtr = $imcall;$excode;

    return new System.Collections.Generic.List<ArgInfo>(new ArgInfoListInternal(argInfoListPtr, false));
}

//
// Kwargs
//

%typemap(cstype) const std::map<std::string, std::string> & "System.Collections.Generic.IDictionary<string, string>"
%typemap(csin,
    pre="
        KwargsInternal temp$csinput = Utility.ToKwargsInternal($csinput);
    ") const std::map<std::string, std::string> & "$csclassname.getCPtr(temp$csinput)"

%typemap(cstype) std::map<std::string, std::string> "System.Collections.Generic.Dictionary<string, string>"
%typemap(csout, excode=SWIGEXCODE) std::map<std::string, std::string> {
    var kwargsPtr = $imcall;$excode;

    return Utility.ToDictionary(new KwargsInternal(kwargsPtr, false));
}

%typemap(cstype) std::vector<std::map<std::string, std::string>> "System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>>"
%typemap(csout, excode=SWIGEXCODE) std::vector<std::map<std::string, std::string>> {
    var kwargsListPtr = $imcall;$excode;

    return Utility.ToDictionaryList(new KwargsListInternal(kwargsListPtr, false));
}

//
// Range
//

// TODO: make private, manually add properties with docs
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

    public override int GetHashCode() => GetType().GetHashCode() ^ (Minimum.GetHashCode() << 1) ^ (Maximum.GetHashCode() << 2) ^ (Step.GetHashCode() << 3);
%}

// Hide SWIG-generated STL types, they're ugly and half-done
%typemap(cstype) std::vector<SoapySDR::Range> "System.Collections.Generic.List<Range>"
%typemap(csout, excode=SWIGEXCODE) std::vector<SoapySDR::Range> {
    var rangeListPtr = $imcall;$excode;

    return new System.Collections.Generic.List<Range>(new RangeListInternal(rangeListPtr, false));
}

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