# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

# Not a function file
1;

%!test
%! SoapySDR
%!
%! assert(SoapySDR.Error.toString(SoapySDR.Error.TIMEOUT) == "TIMEOUT")
%! assert(SoapySDR.Error.toString(SoapySDR.Error.STREAM_ERROR), "STREAM_ERROR")
%! assert(SoapySDR.Error.toString(SoapySDR.Error.CORRUPTION), "CORRUPTION")
%! assert(SoapySDR.Error.toString(SoapySDR.Error.OVERFLOW), "OVERFLOW")
%! assert(SoapySDR.Error.toString(SoapySDR.Error.NOT_SUPPORTED), "NOT_SUPPORTED")
%! assert(SoapySDR.Error.toString(SoapySDR.Error.TIME_ERROR), "TIME_ERROR")
%! assert(SoapySDR.Error.toString(SoapySDR.Error.UNDERFLOW), "UNDERFLOW")
%! assert(SoapySDR.Error.toString(0), "UNKNOWN")
