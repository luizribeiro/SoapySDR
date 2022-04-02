# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

# Not a function file
1;

%!test
%! SoapySDR
%! rates = [1e9, 52e6, 61.44e6, 100e6/3]
%! timeNs = int64(rand() * 1e16)
%! for rate = rates
%!     ticks = SoapySDR.timeNsToTicks(timeNs, rate)
%!     timeNsOut = SoapySDR.ticksToTimeNs(ticks, rate)
%!     assert(abs(timeNs - timeNsOut) / 1e9 < rate) # We expect an error, timeNs specifies a subtick
%! endfor
%!
%!test
%! SoapySDR
%! rates = [1e9, 52e6, 61.44e6, 100e6/3]
%! ticks = int64(rand() * 1e16)
%! for rate = rates
%!     timeNs = SoapySDR.ticksToTimeNs(ticks, rate)
%!     ticksOut = SoapySDR.timeNsToTicks(timeNs, rate)
%!     assert(ticks == ticksOut)
%! endfor
%!
