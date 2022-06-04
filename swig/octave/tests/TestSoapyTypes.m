# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

# Not a function file
1;

%!test
%! SoapySDR
%! key = "key"
%! name = "name"
%! description = "description"
%! units = "units"
%! type = SoapySDR.ArgType.FLOAT
%! range = SoapySDR.Range(0.0, 1.0, 0.1)
%! options = {"opt1", "opt2", "opt3"}
%! optionNames = {"Option1", "Option2", "Option3"}
%!
%! argInfo = SoapySDR.ArgInfo()
%! argInfo.key = key
%! argInfo.name = name
%! argInfo.description = description
%! argInfo.units = units
%! argInfo.type = type
%! argInfo.range = range
%! #argInfo.options = options
%! #argInfo.optionNames = optionNames
%!
%! assert(argInfo.key == key)
%! assert(argInfo.name == name)
%! assert(argInfo.description == description)
%! assert(argInfo.units == units)
%! assert(argInfo.type == type)
%! assert(argInfo.key == key)
%! assert(argInfo.range.minimum == range.minimum)
%! assert(argInfo.range.maximum == range.maximum)
%! assert(argInfo.range.step == range.step)
%! #assert(argInfo.options == options)
%! #assert(argInfo.optionNames == optionNames)
