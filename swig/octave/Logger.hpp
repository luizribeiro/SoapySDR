// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

#include "Constants.hpp"

#include <SoapySDR/Logger.hpp>

#include <octave/oct.h>
#include <octave/parse.h>

namespace SoapySDR { namespace Octave {

    class Logger
    {
    public:
        Logger()
        {
            SoapySDR::registerLogHandler(&GlobalHandler);
        }
        virtual ~Logger()
        {
            LoggerFunction = nullptr;
            // Restore the default, C coded, log handler.
            SoapySDR::registerLogHandler(nullptr);
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
                LoggerFunction = octaveValue.function_value();
            else if(octaveValue.isnull())
                SoapySDR::registerLogHandler(nullptr);
            else
                throw std::runtime_error("Logger must be a function or null");
        }

    private:
        static void GlobalHandler(const SoapySDR::LogLevel logLevel, const char *message)
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
        }

        static octave_function *LoggerFunction;
    };

    octave_function *Logger::LoggerFunction = nullptr;
}}
