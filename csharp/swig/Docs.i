// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

//
// TODO: automate this with SWIG doc generator when brought in
//

%csmethodmodifiers SoapySDR::Device::enumerate(const Kwargs&) "
/// <summary>
/// Enumerate a list of devices on the system, given a set of filters.
/// </summary>
/// <param name=\"args\">A map of construction key/value argument filters</param>
/// <returns>A list of argument maps, each unique to a device</returns>
public";

%csmethodmodifiers SoapySDR::Device::enumerate(const std::string&) "
/// <summary>
/// Enumerate a list of devices on the system, given a set of filters.
///
/// Markup format for args: \"keyA=valA, keyB=valB\".
/// </summary>
/// <param name=\"args\">A markup string of device construction key/value argument filters</param>
/// <returns>A list of argument maps, each unique to a device</returns>
public";

%csmethodmodifiers SoapySDR::Device::DriverKey "
/// <summary>
/// A key that uniquely identifies the device driver.
///
/// This key identifies the underlying implementation.
/// Several variants of a product may share a driver.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::HardwareKey "
/// <summary>
/// A key that uniquely identifies the hardware.
///
/// This key should be meaningful to the user
/// to optimize for the underlying hardware.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::HardwareInfo "
/// <summary>
/// A dictionary of available device information.
///
/// This dictionary can any number of values like
/// vendor name, product name, revisions, serials...
/// This information can be displayed to the user
/// to help identify the instantiated device.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::setFrontendMapping "
/// <summary>
/// Set the frontend mapping of available DSP units to RF frontends.
///
/// This mapping controls channel mapping and channel availability.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"mapping\">A vendor-specific mapping string</param>
public";

%csmethodmodifiers SoapySDR::Device::getFrontendMapping "
/// <summary>
/// Get the mapping configuration string.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <returns>A vendor-specific mapping string</returns>
public";

%csmethodmodifiers SoapySDR::Device::getNumChannels "
/// <summary>
/// Get the number of channels given the streaming direction.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
public";

%csmethodmodifiers SoapySDR::Device::getChannelInfo "
/// <summary>
/// Query a dictionary of available channel information.
///
/// This dictionary can any number of values like
/// decoder type, version, available functions...
/// This information can be displayed to the user
/// to help identify the instantiated channel.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
public";

%csmethodmodifiers SoapySDR::Device::getFullDuplex "
/// <summary>
/// Find out if the specified channel is half or full duplex.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>True for full duplex, false for half duplex</returns>
public";

%csmethodmodifiers SoapySDR::Device::getStreamFormats "
/// <summary>
/// Query a list of the available stream formats.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>A list of allowed format strings. See SoapySDR.StreamFormat.</returns>
public";

%csmethodmodifiers SoapySDR::Device::getNativeStreamFormat "
/// <summary>
/// Get the hardware's native stream format for this channel.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <param name=\"fullScale\">The maximum possible value (output)</param>
/// <returns>The native stream format string. See SoapySDR.StreamFormat.</returns>
public";

%csmethodmodifiers SoapySDR::Device::getStreamArgsInfo "
/// <summary>
/// Query the argument info description for stream args.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
public";

%csmethodmodifiers SoapySDR::Device::listAntennas "
/// <summary>
/// Get a list of available antennas to select on a given chain.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>A list of available antenna names</returns>
public";

%csmethodmodifiers SoapySDR::Device::setAntenna "
/// <summary>
/// Set the selected antenna on a chain.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <param name=\"name\">The name of an available antenna</param>
public";

%csmethodmodifiers SoapySDR::Device::getAntenna "
/// <summary>
/// Set the selected antenna on a chain.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>The name of an available antenna</returns>
public";

%csmethodmodifiers SoapySDR::Device::hasDCOffsetMode "
/// <summary>
/// Does the device support automatic frontend DC offset correction?
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>True if automatic correction is supported</returns>
public";

%csmethodmodifiers SoapySDR::Device::setDCOffsetMode "
/// <summary>
/// Enable or disable automatic frontend DC offset correction.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <param name=\"automatic\">True to enable correction, false to disable</param>
public";

%csmethodmodifiers SoapySDR::Device::getDCOffsetMode "
/// <summary>
/// Is automatic frontend DC offset correction enabled?
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>True if correction is enabled, false if disabled</returns>
public";

%csmethodmodifiers SoapySDR::Device::hasDCOffset "
/// <summary>
/// Does the device support frontend DC offset correction?
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>True if correction is supported</returns>
public";

%csmethodmodifiers SoapySDR::Device::setDCOffset "
/// <summary>
/// Set the frontend DC offset correction.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <param name=\"offset\">The relative correction (1.0 max)</param>
public";

%csmethodmodifiers SoapySDR::Device::getDCOffset "
/// <summary>
/// Get the frontend DC offset correction.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>The relative correction (1.0 max)</returns>
public";

%csmethodmodifiers SoapySDR::Device::hasIQBalanceMode "
/// <summary>
/// Does the device support automatic frontend IQ balance correction?
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>True if automatic correction is supported</returns>
public";

%csmethodmodifiers SoapySDR::Device::setIQBalanceMode "
/// <summary>
/// Enable or disable automatic frontend IQ balance correction.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <param name=\"automatic\">True to enable correction, false to disable</param>
public";

%csmethodmodifiers SoapySDR::Device::getIQBalanceMode "
/// <summary>
/// Is automatic frontend IQ balance correction enabled?
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>True if correction is enabled, false if disabled</returns>
public";

%csmethodmodifiers SoapySDR::Device::hasIQBalance "
/// <summary>
/// Does the device support frontend IQ balance correction?
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>True if correction is supported</returns>
public";

%csmethodmodifiers SoapySDR::Device::setIQBalance "
/// <summary>
/// Set the frontend IQ balance correction.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <param name=\"balance\">The relative correction (1.0 max)</param>
public";

%csmethodmodifiers SoapySDR::Device::getIQBalance "
/// <summary>
/// Get the frontend IQ balance correction.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>The relative correction (1.0 max)</returns>
public";

%csmethodmodifiers SoapySDR::Device::hasFrequencyCorrection "
/// <summary>
/// Does the device support frontend frequency correction correction?
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>True if correction is supported</returns>
public";

%csmethodmodifiers SoapySDR::Device::setFrequencyCorrection "
/// <summary>
/// Set the frontend frequency correction correction.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <param name=\"value\">The correction in PPM</param>
public";

%csmethodmodifiers SoapySDR::Device::getFrequencyCorrection "
/// <summary>
/// Get the frontend frequency correction correction.
/// </summary>
/// <param name=\"direction\">The channel direction (RX or TX)</param>
/// <param name=\"channel\">An available channel on the device</param>
/// <returns>The correction in PPM</returns>
public";

%csmethodmodifiers SoapySDR::Device::MasterClockRate "
/// <summary>
/// The device's master clock rate in Hz.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::MasterClockRates "
/// <summary>
/// A list of available master clock rates in Hz.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::ReferenceClockRate "
/// <summary>
/// The device's reference clock rate in Hz.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::ReferenceClockRates "
/// <summary>
/// A list of available reference clock rates in Hz.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::ClockSource "
/// <summary>
/// The name of the device's clock source.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::ClockSources "
/// <summary>
/// A list of the device's available clock sources.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::TimeSource "
/// <summary>
/// The name of the device's time source.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::TimeSources "
/// <summary>
/// A list of the device's available time sources.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::RegisterInterfaces "
/// <summary>
/// A list of the device's available register interfaces by name.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::GPIOBanks "
/// <summary>
/// A list of the device's available GPIO banks by name.
/// </summary>
public";

%csmethodmodifiers SoapySDR::Device::UARTs "
/// <summary>
/// A list of the device's available UART devices by name.
/// </summary>
public";