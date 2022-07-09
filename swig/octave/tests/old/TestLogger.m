# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

# Not a function file
1;

# TODO: test registering logger, need to figure out passing functions in,
#       Octave has issues with nested function handles

%!test
%! SoapySDR
%!
%! SoapySDR.setLogLevel(SoapySDR.LogLevel.SSI)
%!
%! SoapySDR.log(SoapySDR.LogLevel.FATAL, "FATAL")
%! SoapySDR.log(SoapySDR.LogLevel.CRITICAL, "CRITICAL")
%! SoapySDR.log(SoapySDR.LogLevel.ERROR, "ERROR")
%! SoapySDR.log(SoapySDR.LogLevel.WARNING, "WARNING")
%! SoapySDR.log(SoapySDR.LogLevel.NOTICE, "NOTICE")
%! SoapySDR.log(SoapySDR.LogLevel.INFO, "INFO")
%! SoapySDR.log(SoapySDR.LogLevel.DEBUG, "DEBUG")
%! SoapySDR.log(SoapySDR.LogLevel.TRACE, "TRACE")
%! SoapySDR.log(SoapySDR.LogLevel.SSI, "SSI")
%!
%! SoapySDR.logf(SoapySDR.LogLevel.NOTICE, "Notice: %s %d %f", "str", 1351, 4.18)
