// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;

// TODO: consistency in non-channel-related getters/setters vs functions
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

        /// <summary>
        /// Get the overall center frequency of the chain.
        /// - For RX, this specifies the down-conversion frequency.
        /// - For TX, this specifies the up-conversion frequency.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>The center frequency in Hz</returns>
        public double GetFrequency(Direction direction, uint channel) => _device.GetFrequency(direction, channel);

        /// <summary>
        /// Get the frequency of a tunable element in the chain.
        /// - For RX, this specifies the down-conversion frequency.
        /// - For TX, this specifies the up-conversion frequency.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="name">The name of a tunable element</param>
        /// <returns>The tunable element's frequency in Hz</returns>
        public double GetFrequency(Direction direction, uint channel, string name) => _device.GetFrequency(direction, channel, name);

        /// <summary>
        /// List tunable elements in the chain, ordered from RF to baseband.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A list of tunable elements</returns>
        public List<string> ListFrequencies(Direction direction, uint channel) => new List<string>(_device.ListFrequencies(direction, channel));

        /// <summary>
        /// Get the range of overall frequency values.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A list of frequency ranges in Hz</returns>
        public List<Range> GetFrequencyRange(Direction direction, uint channel) => Utility.ToRangeList(_device.GetFrequencyRange(direction, channel));

        /// <summary>
        /// Get the range of tunable values for the specified element.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="name">The name of a tunable element</param>
        /// <returns>A list of frequency ranges in Hz</returns>
        public List<Range> GetFrequencyRange(Direction direction, uint channel, string name) => Utility.ToRangeList(_device.GetFrequencyRange(direction, channel, name));

        /// <summary>
        /// Query the argument info descriptions for tune arguments.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A list of argument info structures</returns>
        public List<ArgInfo> GetFrequencyArgsInfo(Direction direction, uint channel) => Utility.ToArgInfoList(_device.GetFrequencyArgsInfo(direction, channel));

        /// <summary>
        /// Set the baseband sample rate of the chain.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="rate">The sample rate in samples/second</param>
        public void SetSampleRate(Direction direction, uint channel, double rate) => _device.SetSampleRate(direction, channel, rate);

        /// <summary>
        /// Get the baseband sample rate of the chain.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>The sample rate in samples/second</returns>
        public double GetSampleRate(Direction direction, uint channel) => _device.GetSampleRate(direction, channel);

        /// <summary>
        /// Get the range of possible baseband sample rates.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A list of sample rate ranges in Hz</returns>
        public List<Range> GetSampleRateRange(Direction direction, uint channel) => Utility.ToRangeList(_device.GetSampleRateRange(direction, channel));

        /// <summary>
        /// Set the baseband filter width of the chain.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="bandwidth">The baseband filter width in Hz</param>
        public void SetBandwidth(Direction direction, uint channel, double bandwidth) => _device.SetBandwidth(direction, channel, bandwidth);

        /// <summary>
        /// Get the baseband filter width of the chain.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>The baseband filter width in Hz</returns>
        public double GetBandwidth(Direction direction, uint channel) => _device.GetBandwidth(direction, channel);

        /// <summary>
        /// Get the range of possible baseband filter widths.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A list of bandwidth ranges in Hz</returns>
        public List<Range> GetBandwidthRange(Direction direction, uint channel) => Utility.ToRangeList(_device.GetBandwidthRange(direction, channel));

        /// <summary>
        /// The master clock rate of the device in Hz
        /// </summary>
        public double MasterClockRate
        {
            get => _device.GetMasterClockRate();
            set => _device.SetMasterClockRate(value);
        }

        /// <summary>
        /// The range of available master clock rates in Hz
        /// </summary>
        public List<Range> MasterClockRates => Utility.ToRangeList(_device.GetMasterClockRates());

        /// <summary>
        /// The reference clock rate of the device in Hz
        /// </summary>
        public double ReferenceClockRate
        {
            get => _device.GetReferenceClockRate();
            set => _device.SetReferenceClockRate(value);
        }

        /// <summary>
        /// The range of available reference clock rates in Hz
        /// </summary>
        public List<Range> ReferenceClockRates => Utility.ToRangeList(_device.GetReferenceClockRates());

        /// <summary>
        /// The clock source on the device
        /// </summary>
        public string ClockSource
        {
            get => _device.GetClockSource();
            set => _device.SetClockSource(value);
        }

        /// <summary>
        /// The list of available clock sources on the device
        /// </summary>
        public List<string> ClockSources => new List<string>(_device.ListClockSources());

        /// <summary>
        /// The list of available time sources on the device
        /// </summary>
        public List<string> TimeSources => new List<string>(_device.ListTimeSources());

        /// <summary>
        /// The time source on the device
        /// </summary>
        public string TimeSource
        {
            get => _device.GetTimeSource();
            set => _device.SetTimeSource(value);
        }

        /// <summary>
        /// Does this device have a hardware clock?
        /// </summary>
        /// <param name="what">Optional hardware time counter</param>
        /// <returns>True if the device has the given hardware clock</returns>
        public bool HasHardwareTime(string what = "") => _device.HasHardwareTime(what);

        /// <summary>
        /// Read the time from the device's hardware clock.
        /// </summary>
        /// <param name="what">Optional hardware time counter</param>
        /// <returns>The hardware time in nanoseconds</returns>
        public long GetHardwareTime(string what = "") => _device.GetHardwareTime(what);

        /// <summary>
        /// Write the time to the device's hardware clock.
        /// </summary>
        /// <param name="timeNs">Optional hardware time counter</param>
        /// <param name="what">The hardware time in nanoseconds</param>
        public void SetHardwareTime(long timeNs, string what = "") => _device.SetHardwareTime(timeNs, what);

        /// <summary>
        /// List the available global readback sensors.
        /// A sensor can represent a reference lock, RSSI, temperature, etc...
        /// </summary>
        /// <returns>A list of sensor names</returns>
        public List<string> ListSensors() => new List<string>(_device.ListSensors());

        /// <summary>
        /// Get meta-information about a global readback sensor.
        /// </summary>
        /// <param name="key">The name of an available sensor</param>
        /// <returns>An ArgInfo describing the given sensor</returns>
        public ArgInfo GetSensorInfo(string key) => new ArgInfo(_device.GetSensorInfo(key));

        /// <summary>
        /// Read a global readback sensor, given the name.
        /// The type of the value returned depends on the sensor and can be a long, double, or bool.
        /// </summary>
        /// <param name="key">The name of an available sensor</param>
        /// <returns>The value of the given sensor, casted to its underlying type</returns>
        public object ReadSensor(string key) => new SoapyConvertible(_device.ReadSensor(key)).ToArgType(GetSensorInfo(key).Type);

        /// <summary>
        /// Read a global readback sensor, given the name, and cast it to the given type.
        /// This function can throw if there is no valid conversion from the sensor value's
        /// underlying type to the type parameter.
        /// </summary>
        /// <typeparam name="T">The type to cast the sensor value to</typeparam>
        /// <param name="key">The name of an available sensor</param>
        /// <returns>The value of the given sensor, casted to the given type</returns>
        public T ReadSensor<T>(string key) => (T)(new SoapyConvertible(_device.ReadSensor(key)).ToType(typeof(T), null));

        /// <summary>
        /// List the available channel readback sensors.
        /// A sensor can represent a reference lock, RSSI, temperature, etc...
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A list of sensor names</returns>
        public List<string> ListSensors(Direction direction, uint channel) => new List<string>(_device.ListSensors(direction, channel));

        /// <summary>
        /// Get meta-information about a channel sensor.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="key">The name of an available sensor</param>
        /// <returns>An ArgInfo describing the given sensor</returns>
        public ArgInfo GetSensorInfo(Direction direction, uint channel, string key) => new ArgInfo(_device.GetSensorInfo(direction, channel, key));

        /// <summary>
        /// Read a channel readback sensor, given the name.
        /// The type of the value depends on the sensor and can be a long, double, or bool.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="key">The name of an available sensor</param>
        /// <returns>The value of the given sensor, casted to its underlying type</returns>
        public object ReadSensor(Direction direction, uint channel, string key)
            => new SoapyConvertible(_device.ReadSensor(direction, channel, key)).ToArgType(GetSensorInfo(direction, channel, key).Type);

        /// <summary>
        /// Read a channel readback sensor, given the name, and cast it to the given type.
        /// This function can throw if there is no valid conversion from the sensor value's
        /// underlying type to the type parameter.
        /// </summary>
        /// <typeparam name="T">The type to cast the sensor value to</typeparam>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="key">The name of an available sensor</param>
        /// <returns>The value of the given sensor, casted to the given type</returns>
        public T ReadSensor<T>(Direction direction, uint channel, string key)
            => (T)(new SoapyConvertible(_device.ReadSensor(direction, channel, key)).ToType(typeof(T), null));

        /// <summary>
        /// A list of available register interfaces by name
        /// </summary>
        public List<string> RegisterInterfaces => new List<string>(_device.ListRegisterInterfaces());

        /// <summary>
        /// Write a register on the device, given the interface name.
        /// This can represent a register on a soft CPU, FPGA, IC;
        /// the interpretation is up the implementation to decide.
        /// </summary>
        /// <param name="name">The name of an available register interface</param>
        /// <param name="addr">The register address</param>
        /// <param name="value">The register value</param>
        public void WriteRegister(string name, uint addr, uint value) => _device.WriteRegister(name, addr, value);

        /// <summary>
        /// Read a register from the device, given the interface name.
        /// This can represent a register on a soft CPU, FPGA, IC;
        /// the interpretation is up the implementation to decide.
        /// </summary>
        /// <param name="name">The name of an available register interface</param>
        /// <param name="addr">The register address</param>
        /// <returns>The register value</returns>
        public uint ReadRegister(string name, uint addr) => _device.ReadRegister(name, addr);

        /// <summary>
        /// Write a memory block on the device, given the interface name.
        /// This can represent a register on a soft CPU, FPGA, IC;
        /// the interpretation is up the implementation to decide.
        /// </summary>
        /// <param name="name">The name of an available memory block interface</param>
        /// <param name="addr">The memory block start address</param>
        /// <param name="value">The memory block content</param>
        public void WriteRegisters(string name, uint addr, uint[] value) => _device.WriteRegisters(name, addr, Utility.ToSizeList(value));

        /// <summary>
        /// Read a memory block from the device, given the interface name.
        /// This can represent a register on a soft CPU, FPGA, IC;
        /// the interpretation is up the implementation to decide.
        /// </summary>
        /// <param name="name">The name of an available memory block interface</param>
        /// <param name="addr">The memory block start address</param>
        /// <param name="length">The number of 32-bit words to read</param>
        /// <returns>The memory block content</returns>
        public uint[] ReadRegisters(string name, uint addr, uint length)
            => _device.ReadRegisters(name, addr, length).Select(x => (uint)x).ToArray();

        /// <summary>
        /// Describe the allowed keys and values for global settings.
        /// </summary>
        /// <returns>A list of ArgInfos describing settings</returns>
        public List<ArgInfo> GetSettingInfo() => Utility.ToArgInfoList(_device.GetSettingInfo());

        /// <summary>
        /// Write an arbitrary setting on the device. The interpretation is up to the implementation.
        /// This function can throw if there is no valid conversion from the setting's underlying
        /// type to the type parameter.
        /// </summary>
        /// <param name="key">The setting identifier</param>
        /// <param name="value">The setting value</param>
        public void WriteSetting(string key, object value) => _device.WriteSetting(key, new SoapyConvertible(value).ToString());

        /// <summary>
        /// Read an arbitrary setting on the device. The interpretation is up to the implementation.
        /// The type of the value depends on the setting and can be a long, double, or bool.
        /// </summary>
        /// <param name="key">The setting identifier</param>
        /// <returns>The setting value, casted to the underlying type</returns>
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

        /// <summary>
        /// Read an arbitrary setting on the device, and cast it to the given type.
        /// The interpretation is up to the implementation. This function can throw
        /// if there is no valid conversion from the sensor value's underlying type
        /// to the type parameter.
        /// </summary>
        /// <typeparam name="T">The type to cast the setting value to</typeparam>
        /// <param name="key">The setting identifier</param>
        /// <returns>The setting value, casted to the given type</returns>
        public T ReadSetting<T>(string key)
        {
            if (GetSettingInfo().Any(x => x.Key.Equals(key)))
                return (T)(new SoapyConvertible(_device.ReadSetting(key)).ToType(typeof(T), null));
            else
                return default;
        }

        /// <summary>
        /// Describe the allowed keys and values for channel settings.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <returns>A list of ArgInfos describing channel settings</returns>
        public List<ArgInfo> GetSettingInfo(Direction direction, uint channel) => Utility.ToArgInfoList(_device.GetSettingInfo(direction, channel));

        /// <summary>
        /// Write an arbitrary channel setting on the device. The interpretation is up to the
        /// implementation. This function can throw if there is no valid conversion from the
        /// setting's underlying type to the type parameter.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="key">The setting identifier</param>
        /// <param name="value">The setting value</param>
        public void WriteSetting(Direction direction, uint channel, string key, object value) => _device.WriteSetting(direction, channel, key, new SoapyConvertible(value).ToString());

        /// <summary>
        /// Read an arbitrary channel setting on the device. The interpretation is up to the
        /// implementation. The type of the value depends on the setting and can be a long,
        /// double, or bool.
        /// </summary>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="key">The setting identifier</param>
        /// <returns>The setting value, casted to the underlying type</returns>
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

        /// <summary>
        /// Read an arbitrary channel setting on the device, and cast it to the given type.
        /// The interpretation is up to the implementation. This function can throw
        /// if there is no valid conversion from the sensor value's underlying type
        /// to the type parameter.
        /// </summary>
        /// <typeparam name="T">The type to cast the setting value to</typeparam>
        /// <param name="direction">The channel direction (RX or TX)</param>
        /// <param name="channel">An available channel on the device</param>
        /// <param name="key">The setting identifier</param>
        /// <returns>The setting value, casted to the given type</returns>
        public T ReadSetting<T>(Direction direction, uint channel, string key)
        {
            if (GetSettingInfo(direction, channel).Any(x => x.Key.Equals(key)))
                return (T)(new SoapyConvertible(_device.ReadSetting(direction, channel, key)).ToType(typeof(T), null));
            else
                return default(T);
        }

        /// <summary>
        /// List of available GPIO banks by name
        /// </summary>
        public List<string> GPIOBanks => new List<string>(_device.ListGPIOBanks());

        /// <summary>
        /// Write the value of a GPIO bank.
        /// </summary>
        /// <param name="bank">An available GPIO bank</param>
        /// <param name="value">An integer representing GPIO bits</param>
        public void WriteGPIO(string bank, uint value) => _device.WriteGPIO(bank, value);

        /// <summary>
        /// Write the value of a GPIO bank with a modification mask.
        /// </summary>
        /// <param name="bank">An available GPIO bank</param>
        /// <param name="value">An integer representing GPIO bits</param>
        /// <param name="mask">A modification mask where 1 = modify</param>
        public void WriteGPIO(string bank, uint value, uint mask) => _device.WriteGPIO(bank, value, mask);

        /// <summary>
        /// Read the value of a GPIO bank.
        /// </summary>
        /// <param name="bank">An available GPIO bank</param>
        /// <returns>An integer representing GPIO bits</returns>
        public uint ReadGPIO(string bank) => _device.ReadGPIO(bank);

        /// <summary>
        /// Write the direction of a GPIO bank.
        /// "1" bits represent outputs, "0" bits represent inputs.
        /// </summary>
        /// <param name="bank">An available GPIO bank</param>
        /// <param name="dir">An integer representing data direction bits</param>
        public void WriteGPIODir(string bank, uint dir) => _device.WriteGPIODir(bank, dir);

        /// <summary>
        /// Write the direction of a GPIO bank with a modification mask.
        /// "1" bits represent outputs, "0" bits represent inputs.
        /// </summary>
        /// <param name="bank">An available GPIO bank</param>
        /// <param name="dir">An integer representing data direction bits</param>
        /// <param name="mask">A modification mask where 1 = modify</param>
        public void WriteGPIODir(string bank, uint dir, uint mask) => _device.WriteGPIODir(bank, dir, mask);

        /// <summary>
        /// Read the direction of a GPIO bank.
        /// "1" bits represent outputs, "0" bits represent inputs.
        /// </summary>
        /// <param name="bank">An available GPIO bank</param>
        /// <returns>A modification mask where 1 = modify</returns>
        public uint ReadGPIODir(string bank) => _device.ReadGPIODir(bank);

        /// <summary>
        /// Write to an available I2C slave.
        /// If the device contains multiple I2C masters,
        /// the address bits can encode which master.
        /// </summary>
        /// <param name="addr">The address of the slave</param>
        /// <param name="data">An array of bytes to write</param>
        public void WriteI2C(int addr, string data) => _device.WriteI2C(addr, data);

        /// <summary>
        /// Read from an available I2C slave.
        /// If the device contains multiple I2C masters,
        /// the address bits can encode which master.
        /// </summary>
        /// <param name="addr">The address of the slave</param>
        /// <param name="numBytes">The number of bytes to read</param>
        /// <returns>Array of bytes read from the slave</returns>
        public string ReadI2C(int addr, uint numBytes) => _device.ReadI2C(addr, numBytes);

        /// <summary>
        /// Perform a SPI transaction and return the result.
        /// SPI slaves without a readback pin will return 0.
        ///
        /// If the device contains multiple SPI masters,
        /// the address bits can encode which master.
        /// </summary>
        /// <param name="addr">The address of an available SPI slave</param>
        /// <param name="data">The SPI data, numBits-1 is first out</param>
        /// <param name="numBits">The number of bits to clock out</param>
        /// <returns>The readback data, numBits-1 is first in</returns>
        public uint TransactSPI(int addr, uint data, uint numBits) => _device.TransactSPI(addr, data, numBits);

        /// <summary>
        /// Enumerate the available UART devices.
        /// </summary>
        public List<string> UARTs => new List<string>(_device.ListUARTs());

        /// <summary>
        /// Write data to a UART device.
        /// </summary>
        /// <param name="which">The name of an available UART</param>
        /// <param name="data">An array of bytes to write</param>
        public void WriteUART(string which, string data) => _device.WriteUART(which, data);

        /// <summary>
        /// Read bytes from a UART until timeout or newline.
        /// </summary>
        /// <param name="which">The name of an available UART</param>
        /// <param name="timeoutUs">A timeout in microseconds</param>
        /// <returns>An array of bytes read from the UART</returns>
        public string ReadUART(string which, long timeoutUs = 100000) => _device.ReadUART(which, timeoutUs);

        //
        // Object overrides
        //

        public override string ToString() => _device.__ToString();

        public override bool Equals(object obj) => ((Device)obj)?._device.Equals(_device) ?? false;

        public override int GetHashCode() => GetType().GetHashCode() ^ _device.GetPointer().GetHashCode();
    }
}