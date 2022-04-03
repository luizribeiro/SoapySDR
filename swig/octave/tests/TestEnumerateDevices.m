# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

# Not a function file
1;

%!test
%! SoapySDR
%! #TODO: figure out SWIG printing error, making test fail
%!
%! # Just make sure this runs, no idea what's actually there
%! deviceNoArgs = SoapySDR.Device.enumerate()
%!
%! #TODO: check output for null device
%! deviceStringArgs = SoapySDR.Device.enumerate("type=null")
%!
%! #TODO: check output for null device
%! argsMap = containers.Map({"type"}, {"null"})
%! deviceMapArgs = SoapySDR.Device.enumerate(argsMap)
