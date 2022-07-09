# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

# Not a function file
1;

%!test
%! SoapySDR
%!
%! assert(!isnull(SoapySDR.getABIVersion()))
%! assert(!isnull(SoapySDR.getAPIVersion()))
%! assert(!isnull(SoapySDR.getLibVersion()))
