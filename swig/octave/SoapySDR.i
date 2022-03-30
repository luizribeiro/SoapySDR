// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%module SoapySDROctave

%include "soapy_common.i"

%{
#include <SoapySDR/Config.hpp>
#include <SoapySDR/Device.hpp>
#include <SoapySDR/Time.hpp>
#include <SoapySDR/Types.hpp>
#include <SoapySDR/Version.hpp>
%}

%include <std_map.i>
%include <std_string.i>
%include <std_vector.i>

%template(string_vector) std::vector<std::string>;
%template(string_map) std::map<std::string, std::string>;

%include <SoapySDR/Config.h>
%include <SoapySDR/Version.hpp>
%include <SoapySDR/Types.hpp>
%include <SoapySDR/Device.hpp>
%include <SoapySDR/Time.hpp>
