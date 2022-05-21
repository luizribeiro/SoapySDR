// Copyright (c) 2022 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

%include <attribute.i>

// TODO: naming convention?

%{
#include <SoapySDR/Device.hpp>

#include <algorithm>
%}

// Ignore normal factory stuff
%nodefaultctor SoapySDR::Device;
%ignore SoapySDR::Device::make;
%ignore SoapySDR::Device::unmake(const std::vector<Device *> &);

// Don't wrap deprecated functions
%ignore SoapySDR::Device::listSampleRates;
%ignore SoapySDR::Device::listBandwidths;
%ignore SoapySDR::Device::setCommandTime;
%ignore SoapySDR::Device::writeRegister(const unsigned, const unsigned);
%ignore SoapySDR::Device::readRegister(const unsigned) const;

// Ignore stream-related functions, we're rewriting
// TODO: how?
//%ignore SoapySDR::Device::setupStream;
//%ignore SoapySDR::Device::closeStream;
//%ignore SoapySDR::Device::getStreamMTU;
//%ignore SoapySDR::Device::activateStream;
//%ignore SoapySDR::Device::deactivateStream;
//%ignore SoapySDR::Device::readStream;
//%ignore SoapySDR::Device::writeStream;
//%ignore SoapySDR::Device::readStreamStatus;

%ignore SoapySDR::Octave::readStream;
%ignore SoapySDR::Octave::writeStream;
%ignore SoapySDR::Octave::Stream::internal;

// Ignore DMA-related functions
%ignore SoapySDR::Device::getNumDirectAccessBuffers;
%ignore SoapySDR::Device::getDirectAccessBufferAddrs;
%ignore SoapySDR::Device::acquireReadBuffer;
%ignore SoapySDR::Device::releaseReadBuffer;
%ignore SoapySDR::Device::acquireWriteBuffer;
%ignore SoapySDR::Device::releaseWriteBuffer;

// Ignore setting+sensor functions, we're rewriting
// TODO: how?

// Don't wrap development-layer functions
%ignore SoapySDR::Device::getNativeDeviceHandle;

%attributestring(SoapySDR::Device, std::string, driverKey, getDriverKey);
%attributestring(SoapySDR::Device, std::string, hardwareKey, getHardwareKey);

%include <SoapySDR/Device.hpp>
%include <Streaming.hpp>

%define DEVICE_WRITE_STREAM(expectedFormat,type,interleaved)
    SoapySDR::Octave::TxStreamResult writeStream(
        const SoapySDR::Octave::Stream &stream,
        const type &samples,
        const long timeNs,
        const long timeoutUs)
    {
        if(stream.direction != SOAPY_SDR_TX)
            throw std::invalid_argument("Stream must be TX");
        if(stream.format != expectedFormat)
            throw std::invalid_argument(std::string("Input samples are invalid for format ")+expectedFormat);

        return SoapySDR::Octave::writeStream(
            self,
            stream,
            samples,
            timeNs,
            timeoutUs,
            interleaved);
    }
%enddef

%extend SoapySDR::Device
{
    Device()
    {
        SoapySDR::Octave::validateABI();
        return SoapySDR::Device::make("");
    }

    Device(const std::string &args)
    {
        SoapySDR::Octave::validateABI();
        return SoapySDR::Device::make(args);
    }

    static string_vector enumerate2()
    {
        return SoapySDR::Octave::kwargsListCppToOctave(SoapySDR::Device::enumerate(""));
    }

    std::string __str__()
    {
        return self->getDriverKey() + ":" + self->getHardwareKey();
    }

    SoapySDR::Octave::Stream setupStream(
        int direction,
        const std::string &format,
        const std::vector<size_t> &channels,
        const std::string &args)
    {
        static const std::vector<std::string> SupportedFormats
        {
            SOAPY_SDR_CF32,
            SOAPY_SDR_CF64,
            SOAPY_SDR_CS8,
            SOAPY_SDR_CS16,
            SOAPY_SDR_CS32,
            SOAPY_SDR_CU8,
            SOAPY_SDR_CU16,
            SOAPY_SDR_CU32,
        };
        auto formatIter = std::find(std::begin(SupportedFormats), std::end(SupportedFormats), format);
        if(formatIter == SupportedFormats.end())
            throw std::invalid_argument("Format invalid or unsupported by Octave wrapper: "+format);

        SoapySDR::Octave::Stream stream;
        if((stream.internal = self->setupStream(direction, format, channels, SoapySDR::KwargsFromString(args))))
        {
            stream.direction = direction;
            stream.format = format;
            stream.channels = channels;
            stream.args = args;
        }
        else throw std::runtime_error("Failed to initialize stream");

        return stream;
    }

    SoapySDR::Octave::RxStreamResult readStream(
        const SoapySDR::Octave::Stream &stream,
        const size_t numSamples,
        const long timeoutUs)
    {
        if(stream.direction != SOAPY_SDR_RX)
            throw std::invalid_argument("Stream must be RX");

        SoapySDR::Octave::RxStreamResult result;

        if(stream.format == SOAPY_SDR_CF32)
            result = SoapySDR::Octave::readStream<FloatComplexMatrix>(
                self,
                stream,
                numSamples,
                timeoutUs,
                false);
        else if(stream.format == SOAPY_SDR_CF64)
            result = SoapySDR::Octave::readStream<ComplexMatrix>(
                self,
                stream,
                numSamples,
                timeoutUs,
                false);
        else if(stream.format == SOAPY_SDR_CS8)
            result = SoapySDR::Octave::readStream<int8NDArray>(
                self,
                stream,
                numSamples,
                timeoutUs,
                true);
        else if(stream.format == SOAPY_SDR_CS16)
            result = SoapySDR::Octave::readStream<int16NDArray>(
                self,
                stream,
                numSamples,
                timeoutUs,
                true);
        else if(stream.format == SOAPY_SDR_CS32)
            result = SoapySDR::Octave::readStream<int32NDArray>(
                self,
                stream,
                numSamples,
                timeoutUs,
                true);
        else if(stream.format == SOAPY_SDR_CU8)
            result = SoapySDR::Octave::readStream<uint8NDArray>(
                self,
                stream,
                numSamples,
                timeoutUs,
                true);
        else if(stream.format == SOAPY_SDR_CU16)
            result = SoapySDR::Octave::readStream<uint16NDArray>(
                self,
                stream,
                numSamples,
                timeoutUs,
                true);
        else if(stream.format == SOAPY_SDR_CU32)
            result = SoapySDR::Octave::readStream<uint32NDArray>(
                self,
                stream,
                numSamples,
                timeoutUs,
                true);
        else
            throw std::invalid_argument("Input stream has invalid/unsupported format: "+stream.format);

        return result;
    }

    DEVICE_WRITE_STREAM(SOAPY_SDR_CF32, Array<FloatComplex>, false)
    DEVICE_WRITE_STREAM(SOAPY_SDR_CF64, Array<Complex>, false)
    DEVICE_WRITE_STREAM(SOAPY_SDR_CS8, Array<octave_int8>, true)
    DEVICE_WRITE_STREAM(SOAPY_SDR_CS16, Array<octave_int16>, true)
    DEVICE_WRITE_STREAM(SOAPY_SDR_CS32, Array<octave_int32>, true)
    DEVICE_WRITE_STREAM(SOAPY_SDR_CU8, Array<octave_uint8>, true)
    DEVICE_WRITE_STREAM(SOAPY_SDR_CU16, Array<octave_uint16>, true)
    DEVICE_WRITE_STREAM(SOAPY_SDR_CU32, Array<octave_uint32>, true)

    SoapySDR::Octave::StreamStatus readStreamStatus(
        const SoapySDR::Octave::Stream &stream,
        const long timeoutUs)
    {
        assert(stream.internal);

        // Octave+SWIG doesn't support (unsigned) long long
        long long intermediateTimeNs{0};

        SoapySDR::Octave::StreamStatus status;
        status.errorCode = self->readStreamStatus(
            stream.internal,
            status.chanMask,
            status.flags,
            intermediateTimeNs);

        status.timeNs = static_cast<long>(intermediateTimeNs);

        return status;
    }

    octave_value readSensor(const std::string &key)
    {
        const auto sensorInfo = self->getSensorInfo(key);
        switch(sensorInfo.type)
        {
        case SoapySDR::ArgInfo::BOOL:
            return self->readSensor<bool>(key);

        case SoapySDR::ArgInfo::INT:
            return self->readSensor<int>(key);

        case SoapySDR::ArgInfo::FLOAT:
            return self->readSensor<double>(key);

        default:
            return self->readSensor(key);
        }
    }

    octave_value readSensor(const int direction, const size_t channel, const std::string &key)
    {
        const auto sensorInfo = self->getSensorInfo(direction, channel, key);
        switch(sensorInfo.type)
        {
        case SoapySDR::ArgInfo::BOOL:
            return self->readSensor<bool>(direction, channel, key);

        case SoapySDR::ArgInfo::INT:
            return self->readSensor<int>(direction, channel, key);

        case SoapySDR::ArgInfo::FLOAT:
            return self->readSensor<double>(direction, channel, key);

        default:
            return self->readSensor(direction, channel, key);
        }
    }

    octave_value readSetting(const std::string &key)
    {
        const auto allSettingInfo = self->getSettingInfo();
        auto settingIter = std::find_if(
            std::begin(allSettingInfo),
            std::end(allSettingInfo),
            [&key](const SoapySDR::ArgInfo &argInfo)
            {
                return (argInfo.key == key);
            });
        if(settingIter != allSettingInfo.end())
        {
            switch(settingIter->type)
            {
            case SoapySDR::ArgInfo::BOOL:
                return self->readSetting<bool>(key);

            case SoapySDR::ArgInfo::INT:
                return self->readSetting<int>(key);

            case SoapySDR::ArgInfo::FLOAT:
                return self->readSetting<double>(key);

            default:
                return self->readSetting(key);
            }
        }
        else throw std::invalid_argument("Invalid setting: "+key);
    }

    octave_value readSetting(const int direction, const size_t channel, const std::string &key)
    {
        const auto allSettingInfo = self->getSettingInfo(direction, channel);
        auto settingIter = std::find_if(
            std::begin(allSettingInfo),
            std::end(allSettingInfo),
            [&key](const SoapySDR::ArgInfo &argInfo)
            {
                return (argInfo.key == key);
            });
        if(settingIter != allSettingInfo.end())
        {
            switch(settingIter->type)
            {
            case SoapySDR::ArgInfo::BOOL:
                return self->readSetting<bool>(direction, channel, key);

            case SoapySDR::ArgInfo::INT:
                return self->readSetting<int>(direction, channel, key);

            case SoapySDR::ArgInfo::FLOAT:
                return self->readSetting<double>(direction, channel, key);

            default:
                return self->readSetting(direction, channel, key);
            }
        }
        else throw std::invalid_argument("Invalid setting: "+key);
    }

    void writeSetting(const std::string &key, const octave_value &value)
    {
        if(value.is_integer_type())
            self->writeSetting(key, value.int_value());
        else if(value.is_float_type())
            self->writeSetting(key, value.double_value());
        else
            self->writeSetting(key, value.string_value(true));
    }

    void writeSetting(const int direction, const size_t channel, const std::string &key, const octave_value &value)
    {
        if(value.is_integer_type())
            self->writeSetting(direction, channel, key, value.int_value());
        else if(value.is_float_type())
            self->writeSetting(direction, channel, key, value.double_value());
        else
            self->writeSetting(direction, channel, key, value.string_value(true));
    }
}
