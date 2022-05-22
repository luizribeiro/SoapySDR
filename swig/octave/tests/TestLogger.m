# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

# Not a function file
1;

# TODO: test registering logger, need to figure out passing functions in,
#       Octave has issues with nested function handles

%!test
%! SoapySDR
%!
%! SoapySDR.Logger.setLogLevel(SoapySDR.LogLevel.SSI)
%!
%! SoapySDR.Logger.log(SoapySDR.LogLevel.FATAL, "FATAL")
%! SoapySDR.Logger.log(SoapySDR.LogLevel.CRITICAL, "CRITICAL")
%! SoapySDR.Logger.log(SoapySDR.LogLevel.ERROR, "ERROR")
%! SoapySDR.Logger.log(SoapySDR.LogLevel.WARNING, "WARNING")
%! SoapySDR.Logger.log(SoapySDR.LogLevel.NOTICE, "NOTICE")
%! SoapySDR.Logger.log(SoapySDR.LogLevel.INFO, "INFO")
%! SoapySDR.Logger.log(SoapySDR.LogLevel.DEBUG, "DEBUG")
%! SoapySDR.Logger.log(SoapySDR.LogLevel.TRACE, "TRACE")
%! SoapySDR.Logger.log(SoapySDR.LogLevel.SSI, "SSI")
