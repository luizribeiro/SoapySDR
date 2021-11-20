// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;

// TODO: format consistency, especially where => is relative to newline
// TODO: string overloads for all dict params

namespace SoapySDR
{
    /// <summary>
    /// Abstraction for an SDR transceiver device - configuration and streaming.
    /// </summary>
    public class Device
    {
        private static void CheckABI()
        {
            if(!BuildInfo.ABIVersion.Equals(BuildInfo.SWIGABIVersion) || !BuildInfo.ABIVersion.Equals(BuildInfo.AssemblyABIVersion))
            {
                throw new InvalidOperationException(string.Format(
                    "ABI mismatch:\n{0}: {1}\nSoapySDRCSharp.dll: {2}\nSoapySDR.dll: {3}",
                    Path.GetFileName(Assembly.GetExecutingAssembly().Location),
                    BuildInfo.AssemblyABIVersion,
                    BuildInfo.SWIGABIVersion,
                    BuildInfo.ABIVersion));
            }
        }

        private DeviceInternal _device = null;

        internal Device(DeviceInternal deviceInternal)
        {
            CheckABI();
            _device = deviceInternal;
        }

        public Device()
        {
            CheckABI();
            new Device("");
        }

        public Device(string args)
        {
            CheckABI();
            _device = new DeviceInternal(args);
        }

        public Device(IDictionary<string, string> args)
        {
            CheckABI();
            _device = new DeviceInternal(Utility.ToKwargsInternal(args));
        }

        /// <summary>
        /// Enumerate a list of available devices on the system.
        /// </summary>
        /// <returns>A list of argument maps, each unique to a device</returns>
        public static List<Dictionary<string, string>> Enumerate() => Utility.ToDictionaryList(DeviceInternal.Enumerate());

        /// <summary>
        /// Enumerate a list of available devices on the system.
        /// Markup format for args: "keyA=valA, keyB=valB".
        /// </summary>
        /// <param name="args">A markup string of key/value argument filters</param>
        /// <returns>A list of argument maps, each unique to a device</returns>
        public static List<Dictionary<string, string>> Enumerate(string args) => Utility.ToDictionaryList(DeviceInternal.Enumerate(args));

        /// <summary>
        /// Enumerate a list of available devices on the system.
        /// </summary>
        /// <param name="args">Device construction key/value argument filters</param>
        /// <returns>A list of argument maps, each unique to a device</returns>
        public static List<Dictionary<string, string>> Enumerate(IDictionary<string, string> args) => Utility.ToDictionaryList(DeviceInternal.Enumerate(Utility.ToKwargsInternal(args)));

        /// <summary>
        /// A key that uniquely identifies the device driver.
        /// This key identifies the underlying implementation.
        /// Several variants of a product may share a driver.
        /// </summary>
        public string DriverKey => _device.GetDriverKey();

        /// <summary>
        /// A key that uniquely identifies the hardware.
        /// This key should be meaningful to the user
        /// to optimize for the underlying hardware.
        /// </summary>
        public string HardwareKey => _device.GetHardwareKey();

        /// <summary>
        /// Query a dictionary of available device information.
        /// This dictionary can any number of values like
        /// vendor name, product name, revisions, serials...
        /// This information can be displayed to the user
        /// to help identify the instantiated device.
        /// </summary>
        public Dictionary<string, string> HardwareInfo => Utility.ToDictionary(_device.GetHardwareInfo());

        /// <summary>
        /// Set the frontend mapping of available DSP units to RF frontends.
        /// This mapping controls channel mapping and channel availability.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="mapping">A vendor-specific mapping string</param>
        public void SetFrontendMapping(Direction direction, string mapping) => _device.SetFrontendMapping(direction, mapping);

        /// <summary>
        /// Get the mapping configuration string.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <returns>The vendor-specific mapping string</returns>
        public string GetFrontendMapping(Direction direction) => _device.GetFrontendMapping(direction);

        /// <summary>
        /// Get the number of channels, given the streaming direction.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <returns>The number of channels</returns>
        public uint GetNumChannels(Direction direction) => _device.GetNumChannels(direction);

        /// <summary>
        /// Query a dictionary of available channel information.
        /// This dictionary can any number of values like
        /// decoder type, version, available functions...
        /// This information can be displayed to the user
        /// to help identify the instantiated channel.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>Channel information</returns>
        public Dictionary<string, string> GetChannelInfo(Direction direction, uint channel) => Utility.ToDictionary(_device.GetChannelInfo(direction, channel));

        /// <summary>
        /// Find out if the specified channel is full or half duplex.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>True for full duplex, false for half duplex</returns>
        public bool GetFullDuplex(Direction direction, uint channel) => _device.GetFullDuplex(direction, channel);

        /// <summary>
        /// Query a list of the available stream formats.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A list of allowed format strings</returns>
        public List<string> GetStreamFormats(Direction direction, uint channel) => new List<string>(_device.GetStreamFormats(direction, channel));

        /// <summary>
        /// Get the hardware's native stream format for this channel.
        /// This is the format used by the underlying transport layer.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="fullScaleOut">The maximum possible value</param>
        /// <returns>The native stream buffer format string</returns>
        public string GetNativeStreamFormat(Direction direction, uint channel, out double fullScaleOut) => _device.GetNativeStreamFormat(direction, channel, out fullScaleOut);

        /// <summary>
        /// Query the argument info descriptions for stream arguments.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A list of argument info structures</returns>
        public List<ArgInfo> GetStreamArgsInfo(Direction direction, uint channel) => Utility.ToArgInfoList(_device.GetStreamArgsInfo(direction, channel));

        public TxStream SetupTxStream(string format, uint[] channels, IDictionary<string, string> kwargs)
            => new TxStream(_device, format, channels, Utility.ToKwargsInternal(kwargs));

        public TxStream SetupTxStream(string format, uint[] channels, string args)
            => SetupTxStream(format, channels, TypeConversionInternal.StringToKwargs(args));

        public TxStream SetupTxStream<T>(uint[] channels, IDictionary<string, string> kwargs) where T : unmanaged =>
            SetupTxStream(Utility.GetFormatString<T>(), channels, kwargs);

        public TxStream SetupTxStream<T>(uint[] channels, string args) where T : unmanaged
            => SetupTxStream<T>(channels, TypeConversionInternal.StringToKwargs(args));

        public TxStream SetupComplexTxStream<T>(uint[] channels, IDictionary<string, string> kwargs) where T : unmanaged =>
            SetupTxStream(Utility.GetComplexFormatString<T>(), channels, kwargs);

        public TxStream SetupComplexTxStream<T>(uint[] channels, string args) where T : unmanaged
            => SetupComplexTxStream<T>(channels, TypeConversionInternal.StringToKwargs(args));

        public RxStream SetupRxStream(string format, uint[] channels, IDictionary<string, string> kwargs)
            => new RxStream(_device, format, channels, Utility.ToKwargsInternal(kwargs));

        public RxStream SetupRxStream(string format, uint[] channels, string args)
            => SetupRxStream(format, channels, TypeConversionInternal.StringToKwargs(args));

        public RxStream SetupRxStream<T>(uint[] channels, IDictionary<string, string> kwargs) where T : unmanaged =>
            SetupRxStream(Utility.GetFormatString<T>(), channels, kwargs);

        public RxStream SetupRxStream<T>(uint[] channels, string args) where T : unmanaged
            => SetupRxStream<T>(channels, TypeConversionInternal.StringToKwargs(args));

        public RxStream SetupComplexRxStream<T>(uint[] channels, IDictionary<string, string> kwargs) where T : unmanaged =>
            SetupRxStream(Utility.GetComplexFormatString<T>(), channels, kwargs);

        public RxStream SetupComplexRxStream<T>(uint[] channels, string args) where T : unmanaged
            => SetupComplexRxStream<T>(channels, TypeConversionInternal.StringToKwargs(args));

        /// <summary>
        /// Get a list of available antennas to select for a given chain.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A list of available antenna names</returns>
        public List<string> ListAntennas(Direction direction, uint channel) => new List<string>(_device.ListAntennas(direction, channel));

        /// <summary>
        /// Set the selected antenna for a given chain.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="name">The name of an available antenna</param>
        public void SetAntenna(Direction direction, uint channel, string name) => _device.SetAntenna(direction, channel, name);

        /// <summary>
        /// Get the selected antenna for a given chain.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>The name of an available antenna</returns>
        public string GetAntenna(Direction direction, uint channel) => _device.GetAntenna(direction, channel);

        /// <summary>
        /// Does the device support automatic DC offset correction?
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>True if automatic DC offset correction is supported</returns>
        public bool HasDCOffsetMode(Direction direction, uint channel) => _device.HasDCOffsetMode(direction, channel);

        /// <summary>
        /// Enable or disable automatic DC offset correction.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="automatic">True for automatic DC offset corrections</param>
        public void SetDCOffsetMode(Direction direction, uint channel, bool automatic) => _device.SetDCOffsetMode(direction, channel, automatic);

        /// <summary>
        /// Is automatic DC offset correction enabled?
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>Whether automatic DC offset correction is enabled</returns>
        public bool GetDCOffsetMode(Direction direction, uint channel) => _device.GetDCOffsetMode(direction, channel);

        /// <summary>
        /// Does the device support frontend DC offset correction?
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>True if the device supports frontend DC offset correction</returns>
        public bool HasDCOffset(Direction direction, uint channel) => _device.HasDCOffset(direction, channel);

        /// <summary>
        /// Set the frontend DC offset correction.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="dcOffset">The relative correction (1.0 max)</param>
        public void SetDCOffset(Direction direction, uint channel, System.Numerics.Complex dcOffset) => _device.SetDCOffset(direction, channel, dcOffset);

        /// <summary>
        /// Get the frontend DC offset correction.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>The frontend DC offset correction</returns>
        public System.Numerics.Complex GetDCOffset(Direction direction, uint channel) => _device.GetDCOffset(direction, channel);

        /// <summary>
        /// Does the device support frontend IQ balance correction?
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>True if the device supports frontend IQ balance correction</returns>
        public bool HasIQBalance(Direction direction, uint channel) => _device.HasIQBalance(direction, channel);

        /// <summary>
        /// Set the frontend IQ balance correction.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="iqBalance">The frontend IQ balance correction (1.0 max)</param>
        public void SetIQBalance(Direction direction, uint channel, System.Numerics.Complex iqBalance) => _device.SetIQBalance(direction, channel, iqBalance);

        /// <summary>
        /// Get the frontend IQ balance correction.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>The frontend IQ balance correction</returns>
        public System.Numerics.Complex GetIQBalance(Direction direction, uint channel) => _device.GetIQBalance(direction, channel);

        /// <summary>
        /// Does this device support automatic frontend IQ balance correction?
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>True if the device supports frontend IQ balance correction</returns>
        public bool HasIQBalanceMode(Direction direction, uint channel) => _device.HasIQBalanceMode(direction, channel);

        /// <summary>
        /// Enable or disable automatic frontend IQ balance correction.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="automatic">True to enable automatic frontend IQ balance correction</param>
        public void SetIQBalanceMode(Direction direction, uint channel, bool automatic) => _device.SetIQBalanceMode(direction, channel, automatic);

        /// <summary>
        /// Is automatic frontend IQ balance correction enabled?
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>True if automatic frontend IQ balance correction is enabled</returns>
        public bool GetIQBalanceMode(Direction direction, uint channel) => _device.GetIQBalanceMode(direction, channel);

        /// <summary>
        /// Does the device support automatic frontend frequency correction?
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>True if the device supports automatic frontend frequency correction</returns>
        public bool HasFrequencyCorrection(Direction direction, uint channel) => _device.HasFrequencyCorrection(direction, channel);

        /// <summary>
        /// Fine-tune the frontend frequency correction.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="correction">The correction value in PPM</param>
        public void SetFrequencyCorrection(Direction direction, uint channel, double correction) => _device.SetFrequencyCorrection(direction, channel, correction);

        /// <summary>
        /// Get the frontend frequency correction value.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>The correction value in PPM</returns>
        public double GetFrequencyCorrection(Direction direction, uint channel) => _device.GetFrequencyCorrection(direction, channel);

        /// <summary>
        /// List available gain amplification elements.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>Available gain amplification elements</returns>
        public List<string> ListGains(Direction direction, uint channel) => new List<string>(_device.ListGains(direction, channel));

        /// <summary>
        /// Does the device support automatic gain control?
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>True if the device supports automatic gain control</returns>
        public bool HasGainMode(Direction direction, uint channel) => _device.HasGainMode(direction, channel);

        /// <summary>
        /// Enable or disable automatic gain control.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="automatic">True to enable automatic gain control</param>
        public void SetGainMode(Direction direction, uint channel, bool automatic) => _device.SetGainMode(direction, channel, automatic);

        /// <summary>
        /// Is automatic gain control enabled?
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>True if automatic gain control is enabled</returns>
        public bool GetGainMode(Direction direction, uint channel) => _device.GetGainMode(direction, channel);

        /// <summary>
        /// Set the overall gain amplification in a chain.
        /// The gain will be distributed evenly across available gain elements.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="value">The new amplification value in dB</param>
        public void SetGain(Direction direction, uint channel, double value) => _device.SetGain(direction, channel, value);

        /// <summary>
        /// Set the value of a gain amplification element in a chain.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="name">The name of an available gain amplification element</param>
        /// <param name="value">The new amplification value in dB</param>
        public void SetGain(Direction direction, uint channel, string name, double value) => _device.SetGain(direction, channel, name, value);

        /// <summary>
        /// Get the overall value of the gain amplification elements in a chain.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>The amplification value in dB</returns>
        public double GetGain(Direction direction, uint channel) => _device.GetGain(direction, channel);

        /// <summary>
        /// Get the value of an individual gain amplification element in a chain.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="name">The name of an available gain amplification element</param>
        /// <returns>The amplification value in dB</returns>
        public double GetGain(Direction direction, uint channel, string name) => _device.GetGain(direction, channel, name);

        /// <summary>
        /// Get the overall range of possible gain values.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A gain range in dB</returns>
        public Range GetGainRange(Direction direction, uint channel) => new Range(_device.GetGainRange(direction, channel));

        /// <summary>
        /// Get the range of possible gain values for an individual gain amplification element.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="name">The name of an available gain amplification element</param>
        /// <returns>A gain range in dB</returns>
        public Range GetGainRange(Direction direction, uint channel, string name) => new Range(_device.GetGainRange(direction, channel, name));

        /// <summary>
        /// Set the center frequency of the chain.
        /// - For RX, this specifies the down-conversion frequency.
        /// - For TX, this specifies the up-conversion frequency.
        ///
        /// This overload of setFrequency() will tune the "RF" component as close
        /// as possible to the requested center frequency. Tuning inaccuracies
        /// will be compensated for with the "BB" component.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="frequency">The center frequency in Hz</param>
        public void SetFrequency(Direction direction, uint channel, double frequency) => SetFrequency(direction, channel, frequency, new KwargsInternal());

        /// <summary>
        /// Set the center frequency of the chain.
        /// - For RX, this specifies the down-conversion frequency.
        /// - For TX, this specifies the up-conversion frequency.
        ///
        /// The args can be used to augment the tuning algorithm.
        ///  - Use "OFFSET" to specify an "RF" tuning offset,
        ///    usually with the intention of moving the LO out of the passband.
        ///    The offset will be compensated for using the "BB" component.
        ///  - Use the name of a component for the key and a frequency in Hz
        ///    as the value(any format) to enforce a specific frequency.
        ///    The other components will be tuned with compensation
        ///    to achieve the specified overall frequency.
        ///  - Use the name of a component for the key and the value "IGNORE"
        ///    so that the tuning algorithm will avoid altering the component.
        ///  - Vendor specific implementations can also use the same args to augment
        ///    tuning in other ways such as specifying fractional vs integer N tuning.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="frequency">The center frequency in Hz</param>
        /// <param name="args">Tuner arguments</param>
        public void SetFrequency(Direction direction, uint channel, double frequency, IDictionary<string, string> args) => _device.SetFrequency(direction, channel, frequency, Utility.ToKwargsInternal(args));

        public void SetFrequency(Direction direction, uint channel, double frequency, string args) => SetFrequency(direction, channel, frequency, TypeConversionInternal.StringToKwargs(args));

        public void SetFrequency(Direction direction, uint channel, string name, double frequency) => SetFrequency(direction, channel, name, frequency, new KwargsInternal());

        public void SetFrequency(Direction direction, uint channel, string name, double frequency, IDictionary<string, string> args) => _device.SetFrequency(direction, channel, name, frequency, Utility.ToKwargsInternal(args));

        public void SetFrequency(Direction direction, uint channel, string name, double frequency, string args) => SetFrequency(direction, channel, name, frequency, TypeConversionInternal.StringToKwargs(args));

        public double GetFrequency(Direction direction, uint channel) => _device.GetFrequency(direction, channel);

        public double GetFrequency(Direction direction, uint channel, string name) => _device.GetFrequency(direction, channel, name);

        public List<string> ListFrequencies(Direction direction, uint channel) => new List<string>(_device.ListFrequencies(direction, channel));

        public List<Range> GetFrequencyRange(Direction direction, uint channel) => Utility.ToRangeList(_device.GetFrequencyRange(direction, channel));

        public List<Range> GetFrequencyRange(Direction direction, uint channel, string name) => Utility.ToRangeList(_device.GetFrequencyRange(direction, channel, name));

        public List<ArgInfo> GetFrequencyArgsInfo(Direction direction, uint channel) => Utility.ToArgInfoList(_device.GetFrequencyArgsInfo(direction, channel));

        public void SetSampleRate(Direction direction, uint channel, double rate) => _device.SetSampleRate(direction, channel, rate);

        public double GetSampleRate(Direction direction, uint channel) => _device.GetSampleRate(direction, channel);

        public List<Range> GetSampleRateRange(Direction direction, uint channel) => Utility.ToRangeList(_device.GetSampleRateRange(direction, channel));

        public void SetBandwidth(Direction direction, uint channel, double bandwidth) => _device.SetBandwidth(direction, channel, bandwidth);

        public double GetBandwidth(Direction direction, uint channel) => _device.GetBandwidth(direction, channel);

        public List<Range> GetBandwidthRange(Direction direction, uint channel) => Utility.ToRangeList(_device.GetBandwidthRange(direction, channel));

        public double MasterClockRate
        {
            get => _device.GetMasterClockRate();
            set => _device.SetMasterClockRate(value);
        }

        public List<Range> MasterClockRates => Utility.ToRangeList(_device.GetMasterClockRates());

        public double ReferenceClockRate
        {
            get => _device.GetReferenceClockRate();
            set => _device.SetReferenceClockRate(value);
        }

        public List<Range> ReferenceClockRates => Utility.ToRangeList(_device.GetReferenceClockRates());

        public string ClockSource
        {
            get => _device.GetClockSource();
            set => _device.SetClockSource(value);
        }

        public List<string> ClockSources => new List<string>(_device.ListClockSources());

        public List<string> TimeSources => new List<string>(_device.ListTimeSources());

        public string TimeSource
        {
            get => _device.GetTimeSource();
            set => _device.SetTimeSource(value);
        }

        public bool HasHardwareTime(string what) => _device.HasHardwareTime(what);

        public long GetHardwareTime(string what) => _device.GetHardwareTime(what);

        public void SetHardwareTime(long timeNs, string what = "") => _device.SetHardwareTime(timeNs, what);

        public List<string> ListSensors() => new List<string>(_device.ListSensors());

        public ArgInfo GetSensorInfo(string key) => new ArgInfo(_device.GetSensorInfo(key));

        public object ReadSensor(string key) => new SoapyConvertible(_device.ReadSensor(key)).ToArgType(GetSensorInfo(key).Type);

        public T ReadSensor<T>(string key) => (T)(new SoapyConvertible(_device.ReadSensor(key)).ToType(typeof(T), null));

        public List<string> ListSensors(Direction direction, uint channel) => new List<string>(_device.ListSensors(direction, channel));

        public ArgInfo GetSensorInfo(Direction direction, uint channel, string key) => new ArgInfo(_device.GetSensorInfo(direction, channel, key));

        public object ReadSensor(Direction direction, uint channel, string key)
            => new SoapyConvertible(_device.ReadSensor(direction, channel, key)).ToArgType(GetSensorInfo(direction, channel, key).Type);

        public T ReadSensor<T>(Direction direction, uint channel, string key)
            => (T)(new SoapyConvertible(_device.ReadSensor(direction, channel, key)).ToType(typeof(T), null));

        public List<string> RegisterInterfaces => new List<string>(_device.ListRegisterInterfaces());

        public void WriteRegister(string name, uint addr, uint value) => _device.WriteRegister(name, addr, value);

        public uint ReadRegister(string name, uint addr) => _device.ReadRegister(name, addr);

        public void WriteRegisters(string name, uint addr, uint[] value) => _device.WriteRegisters(name, addr, Utility.ToSizeList(value));

        // Note: keeping uint[] return for read registers, implied to be contiguous

        public uint[] ReadRegisters(string name, uint addr, uint length)
            => _device.ReadRegisters(name, addr, length).Select(x => (uint)x).ToArray();

        public List<ArgInfo> GetSettingInfo() => Utility.ToArgInfoList(_device.GetSettingInfo());

        public void WriteSetting(string key, object value) => _device.WriteSetting(key, new SoapyConvertible(value).ToString());

        public object ReadSetting(string key)
        {
            var query = GetSettingInfo().Where(x => x.Key.Equals(key));

            if (query.Any())
            {
                var info = query.First();
                return new SoapyConvertible(_device.ReadSetting(key)).ToArgType(info.Type);
            }
            else return null;
        }

        public T ReadSetting<T>(string key)
        {
            if (GetSettingInfo().Any(x => x.Key.Equals(key)))
                return (T)(new SoapyConvertible(_device.ReadSetting(key)).ToType(typeof(T), null));
            else
                return default(T);
        }

        public List<ArgInfo> GetSettingInfo(Direction direction, uint channel) => Utility.ToArgInfoList(_device.GetSettingInfo(direction, channel));

        public void WriteSetting(Direction direction, uint channel, string key, object value) => _device.WriteSetting(direction, channel, key, new SoapyConvertible(value).ToString());

        public object ReadSetting(Direction direction, uint channel, string key)
        {
            var query = GetSettingInfo(direction, channel).Where(x => x.Key.Equals(key));

            if (query.Any())
            {
                var info = query.First();
                return new SoapyConvertible(_device.ReadSetting(direction, channel, key)).ToArgType(info.Type);
            }
            else return null;
        }

        public T ReadSetting<T>(Direction direction, uint channel, string key)
        {
            if (GetSettingInfo(direction, channel).Any(x => x.Key.Equals(key)))
                return (T)(new SoapyConvertible(_device.ReadSetting(direction, channel, key)).ToType(typeof(T), null));
            else
                return default(T);
        }

        public List<string> GPIOBanks => new List<string>(_device.ListGPIOBanks());

        public void WriteGPIO(string bank, uint value) => _device.WriteGPIO(bank, value);

        public void WriteGPIO(string bank, uint value, uint mask) => _device.WriteGPIO(bank, value, mask);

        public uint ReadGPIO(string bank) => _device.ReadGPIO(bank);

        public void WriteGPIODir(string bank, uint dir) => _device.WriteGPIODir(bank, dir);

        public void WriteGPIODir(string bank, uint dir, uint mask) => _device.WriteGPIODir(bank, dir, mask);

        public uint ReadGPIODir(string bank) => _device.ReadGPIODir(bank);

        public void WriteI2C(int addr, string data) => _device.WriteI2C(addr, data);

        public string ReadI2C(int addr, uint numBytes) => _device.ReadI2C(addr, numBytes);

        public uint TransactSPI(int addr, uint data, uint numBits) => _device.TransactSPI(addr, data, numBits);

        public List<string> UARTs => new List<string>(_device.ListUARTs());

        public void WriteUART(string which, string data) => _device.WriteUART(which, data);

        public string ReadUART(string which, long timeoutUs = 100000) => _device.ReadUART(which, timeoutUs);

        //
        // Object overrides
        //

        public override string ToString() => _device.__ToString();

        public override bool Equals(object obj) => ((Device)obj)?._device.Equals(_device) ?? false;

        public override int GetHashCode() => GetType().GetHashCode() ^ _device.GetPointer().GetHashCode();
    }
}