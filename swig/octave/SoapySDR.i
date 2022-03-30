// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%module SoapySDR

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

%include <SoapySDR/Config.h>
%include <SoapySDR/Version.hpp>
%include <SoapySDR/Types.hpp>
%include <SoapySDR/Device.hpp>
%include <SoapySDR/Time.hpp>
