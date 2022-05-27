// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#include "Constants.hpp"

#include <SoapySDR/Logger.hpp>

#include <octave/oct.h>
#include <octave/parse.h>

#include <mutex>
#include <stdexcept>

namespace SoapySDR { namespace Octave {

    namespace detail
    {
        static octave_function *LoggerFunction;

        static void OctaveLogHandler(const SoapySDR::LogLevel logLevel, const char *message)
        {
            if (LoggerFunction)
            {
                octave_value_list args;
                args(0) = static_cast<int>(logLevel);
                args(1) = std::string(message);

#if SWIG_OCTAVE_PREREQ(4,4,0)
                octave::feval(LoggerFunction, args, 0);
#else
                feval(LoggerFunction, args, 0);
#endif
            }
            else fprintf(stderr, "We shouldn't be calling GlobalHandler without a function.");
        }

        struct InternalLoggerInit
        {
            ~InternalLoggerInit(void)
            {
                // Restore the default C log handler.
                SoapySDR::registerLogHandler(nullptr);
                LoggerFunction = nullptr;
            }
        };

        static InternalLoggerInit loggerInit;
    }

    static void log(const int logLevel, const std::string& message)
    {
        SoapySDR::log(static_cast<SoapySDR::LogLevel>(logLevel), message.c_str());
    }

    // Even though we don't do anything with the ..., we need it for SWIG to
    // allow variable numbers of arguments.
    static void logf(const octave_value_list& varargs, ...)
    {
        if(varargs.length() < 2)
            throw std::invalid_argument("logf requires at least 2 arguments");

        const auto &logLevel = varargs(0);
        const auto &format = varargs(1);

        octave_value_list sprintfArgs;
        sprintfArgs.append(format);

        for(octave_idx_type i = 2; i < varargs.length(); ++i)
            sprintfArgs.append(varargs(i));

#if SWIG_OCTAVE_PREREQ(4,4,0)
        const auto sprintfResult = octave::feval("sprintf", sprintfArgs, 0);
#else
        const auto sprintfResult = feval("sprintf", sprintfArgs, 0);
#endif
        log(logLevel.int_value(), sprintfResult(0).string_value());
    }

    static void setLogLevel(const int logLevel)
    {
        SoapySDR::setLogLevel(static_cast<SoapySDR::LogLevel>(logLevel));
    }

    static void registerLogger(const octave_value &octaveValue)
    {
        if(octaveValue.is_function_handle() or octaveValue.is_inline_function())
        {
            SoapySDR::registerLogHandler(&detail::OctaveLogHandler);
            detail::LoggerFunction = octaveValue.function_value();
        }
        else if(octaveValue.isnull())
            SoapySDR::registerLogHandler(nullptr);
        else
            throw std::runtime_error("Logger must be a function or null");
    }
}}
