// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%module SoapySDR

%include "soapy_common.i"

%{
#include "Enums.hpp"
#include "Streaming.hpp"

#include <SoapySDR/Config.hpp>
#include <SoapySDR/Device.hpp>
#include <SoapySDR/Time.hpp>
#include <SoapySDR/Types.hpp>
#include <SoapySDR/Version.hpp>
%}

%include <std_complex.i>
%include <std_map.i>
%include <std_string.i>
%include <std_vector.i>

%template(StringVector) std::vector<std::string>;
%template(Kwargs) std::map<std::string, std::string>;

%include <SoapySDR/Config.h>
%include <SoapySDR/Version.hpp>
%include <SoapySDR/Types.hpp>
%include <SoapySDR/Device.hpp>
%include <SoapySDR/Time.hpp>

%include <Enums.hpp>
