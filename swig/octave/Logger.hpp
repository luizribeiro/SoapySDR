// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#include "Constants.hpp"

#include <SoapySDR/Logger.hpp>

#include <octave/oct.h>
#include <octave/parse.h>

#include <mutex>

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
            InternalLoggerInit(void)
            {
                // In theory, since we're only creating a single instance, this
                // should only run once anyway, but just to be sure...
                static std::once_flag once_flag;
                std::call_once(
                    once_flag,
                    []()
                    {
                        constexpr auto name = "evalin"; // Run in this context
                        octave_value_list args;
                        args.append("caller");
                        args.append("function logf(logLevel, format, varargin); "
                                    "  message = sprintf(format, varargin); "
                                    "  SoapySDR.log(logLevel, message); "
                                    "endfunction;");

#if SWIG_OCTAVE_PREREQ(4,4,0)
                        octave::feval(name, args, 0);
#else
                        feval(name, args, 0);
#endif
                    });
            }
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
