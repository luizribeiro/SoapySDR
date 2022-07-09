# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

# Not a function file
1;

%!test
%! SoapySDR
%!
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.U8) == 1)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.S8) == 1)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.U16) == 2)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.S16) == 2)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.U32) == 4)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.S32) == 4)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.F32) == 4)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.F64) == 8)

%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CU4) == 1)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CS4) == 1)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CU8) == 2)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CS8) == 2)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CU12) == 3)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CS12) == 3)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CU16) == 4)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CS16) == 4)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CU32) == 8)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CS32) == 8)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CF32) == 8)
%! assert(SoapySDR.StreamFormat.toSize(SoapySDR.StreamFormat.CF64) == 16)
