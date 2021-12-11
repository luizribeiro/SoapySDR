/*
 * This file was generated: 2021-12-10 20:39:39.971609
 */




%csmethodmodifiers SoapySDR::F32toS32 "

/// <summary>
/// Conversion Primitives for converting real values between Soapy formats.
/// </summary>
/// <param name=\"from\">the value to convert from</param>
/// <returns>the converted value</returns>
public";

%typemap(csimports) SoapySDR::ConverterRegistry "
using System;
using System.Runtime.InteropServices;

/// <summary>
/// ConverterRegistry class. The ConverterRegistry maintains a list of
/// ConverterFunctions that can be queried and retrieved by markup strings for
/// converting buffers between formats.
/// While Soapy standard format markup strings are declared in the formats include file,
/// custom formats can be created and ConverterFunctions registered to be used as needed.
/// Additionally, different functions can be registered for the same source/target pair
/// with FunctionPriority serving as a selector to allow specialization.
/// </summary>"

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::ConverterRegistry::ConverterRegistry(const std::string & sourceFormat, const std::string & targetFormat, const FunctionPriority & priority, ConverterFunction converter) "

/// <summary>
/// Class constructor. Registers a ConverterFunction with a
/// given source format, target format, and priority.
/// refuses to register converter and logs error if a source/target/priority entry already exists
/// </summary>
/// <param name=\"sourceFormat\">the source format markup string</param>
/// <param name=\"targetFormat\">the target format markup string</param>
/// <param name=\"priority\">the FunctionPriority of the converter to register</param>
/// <param name=\"converter\">function to register</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::ConverterRegistry::listTargetFormats(const std::string & sourceFormat) "

/// <summary>
/// Get a list of existing target formats to which we can convert the specified source from.
/// There is a source format converter function registered for each target format
/// returned in the result vector.
/// </summary>
/// <param name=\"sourceFormat\">the source format markup string</param>
/// <returns>a vector of target formats or an empty vector if none found</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::ConverterRegistry::listSourceFormats(const std::string & targetFormat) "

/// <summary>
/// Get a list of existing source formats from which we can convert to the specified target.
/// There is a target format converter function registered for each source format
/// returned in the result vector.
/// </summary>
/// <param name=\"targetFormat\">the target format markup string</param>
/// <returns>a vector of source formats or an empty vector if none found</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::ConverterRegistry::listPriorities(const std::string & sourceFormat, const std::string & targetFormat) "

/// <summary>
/// Get a list of available converter priorities for a given source and target format.
/// </summary>
/// <param name=\"sourceFormat\">the source format markup string</param>
/// <param name=\"targetFormat\">the target format markup string</param>
/// <returns>a vector of priorities or an empty vector if none found</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::ConverterRegistry::getFunction(const std::string & sourceFormat, const std::string & targetFormat) "

/// <summary>
/// Get a converter between a source and target format with the highest available priority.
/// </summary>
/// <exception cref=\"System.ApplicationException\">when the conversion does not exist and logs error</exception>
/// <param name=\"sourceFormat\">the source format markup string</param>
/// <param name=\"targetFormat\">the target format markup string</param>
/// <returns>a conversion function pointer</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::ConverterRegistry::getFunction(const std::string & sourceFormat, const std::string & targetFormat, const FunctionPriority & priority) "

/// <summary>
/// Get a converter between a source and target format with a given priority.
/// </summary>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::ConverterRegistry::listAvailableSourceFormats() "

/// <summary>
/// Get a list of known source formats in the registry.
/// </summary>
public";

////////////////////////////////////////////////////

%typemap(csimports) SoapySDR::Device "
using System;
using System.Runtime.InteropServices;

/// <summary>
/// Abstraction for an SDR transceiver device - configuration and streaming.
/// </summary>"

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::enumerate(const Kwargs & args) "

/// <summary>
/// Enumerate a list of available devices on the system.
/// </summary>
/// <param name=\"args\">device construction key/value argument filters</param>
/// <returns>a list of argument maps, each unique to a device</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::enumerate(const std::string & args) "

/// <summary>
/// Enumerate a list of available devices on the system.
/// Markup format for args: \"keyA=valA, keyB=valB\".
/// </summary>
/// <param name=\"args\">a markup string of key/value argument filters</param>
/// <returns>a list of argument maps, each unique to a device</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getDriverKey() const "

/// <summary>
/// Identification API
/// A key that uniquely identifies the device driver.
/// This key identifies the underlying implementation.
/// Several variants of a product may share a driver.
/// </summary>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getHardwareKey() const "

/// <summary>
/// A key that uniquely identifies the hardware.
/// This key should be meaningful to the user
/// to optimize for the underlying hardware.
/// </summary>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getHardwareInfo() const "

/// <summary>
/// Query a dictionary of available device information.
/// This dictionary can any number of values like
/// vendor name, product name, revisions, serials...
/// This information can be displayed to the user
/// to help identify the instantiated device.
/// </summary>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setFrontendMapping(const int direction, const std::string & mapping) "

/// <summary>
/// Channels API
/// Set the frontend mapping of available DSP units to RF frontends.
/// This mapping controls channel mapping and channel availability.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"mapping\">a vendor-specific mapping string</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getFrontendMapping(const int direction) const "

/// <summary>
/// Get the mapping configuration string.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <returns>the vendor-specific mapping string</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getNumChannels(const int direction) const "

/// <summary>
/// Get a number of channels given the streaming direction
/// </summary>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getChannelInfo(const int direction, const size_t channel) const "

/// <summary>
/// Query a dictionary of available channel information.
/// This dictionary can any number of values like
/// decoder type, version, available functions...
/// This information can be displayed to the user
/// to help identify the instantiated channel.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>channel information</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getFullDuplex(const int direction, const size_t channel) const "

/// <summary>
/// Find out if the specified channel is full or half duplex.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>true for full duplex, false for half duplex</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getStreamFormats(const int direction, const size_t channel) const "

/// <summary>
/// Stream API
/// Query a list of the available stream formats.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of allowed format strings. See setupStream() for the format syntax.</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getNativeStreamFormat(const int direction, const size_t channel, double & fullScale) const "

/// <summary>
/// Get the hardware's native stream format for this channel.
/// This is the format used by the underlying transport layer,
/// and the direct buffer access API calls (when available).
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"[out]\">fullScale the maximum possible value</param>
/// <returns>the native stream buffer format string</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getStreamArgsInfo(const int direction, const size_t channel) const "

/// <summary>
/// Query the argument info description for stream args.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of argument info structures</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setupStream(const int direction, const std::string & format, const std::vector<size_t> & channels, const Kwargs & args) "

/// <summary>
/// Initialize a stream given a list of channels and stream arguments.
/// The implementation may change switches or power-up components.
/// All stream API calls should be usable with the new stream object
/// after setupStream() is complete, regardless of the activity state.
/// The API allows any number of simultaneous TX and RX streams, but many dual-channel
/// devices are limited to one stream in each direction, using either one or both channels.
/// This call will throw an exception if an unsupported combination is requested,
/// or if a requested channel in this direction is already in use by another stream.
/// When multiple channels are added to a stream, they are typically expected to have
/// the same sample rate. See setSampleRate().
/// \parblock
/// The first character selects the number type:
///   - \"C\" means complex
///   - \"F\" means floating point
///   - \"S\" means signed integer
///   - \"U\" means unsigned integer
/// The type character is followed by the number of bits per number (complex is 2x this size per sample)
///  Example format strings:
///   - \"CF32\" -  complex float32 (8 bytes per element)
///   - \"CS16\" -  complex int16 (4 bytes per element)
///   - \"CS12\" -  complex int12 (3 bytes per element)
///   - \"CS4\" -  complex int4 (1 byte per element)
///   - \"S32\" -  int32 (4 bytes per element)
///   - \"U8\" -  uint8 (1 byte per element)
/// \endparblock
/// \parblock
///   Recommended keys to use in the args dictionary:
///    - \"WIRE\" - format of the samples between device and host
/// \endparblock
/// \parblock
/// The returned stream is not required to have internal locking, and may not be used
/// concurrently from multiple threads.
/// \endparblock
/// </summary>
/// <param name=\"direction\">the channel direction (`SOAPY_SDR_RX` or `SOAPY_SDR_TX`)</param>
/// <param name=\"format\">A string representing the desired buffer format in read/writeStream()</param>
/// <param name=\"channels\">a list of channels or empty for automatic.</param>
/// <param name=\"args\">stream args or empty for defaults.</param>
/// <returns>an opaque pointer to a stream handle.</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::closeStream(Stream * stream) "

/// <summary>
/// Close an open stream created by setupStream
/// The implementation may change switches or power-down components.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getStreamMTU(Stream * stream) const "

/// <summary>
/// Get the stream's maximum transmission unit (MTU) in number of elements.
/// The MTU specifies the maximum payload transfer in a stream operation.
/// This value can be used as a stream buffer allocation size that can
/// best optimize throughput given the underlying stream implementation.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <returns>the MTU in number of stream elements (never zero)</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::activateStream(Stream * stream, const int flags, const long long timeNs, const size_t numElems) "

/// <summary>
/// Activate a stream.
/// Call activate to prepare a stream before using read/write().
/// The implementation control switches or stimulate data flow.
/// The timeNs is only valid when the flags have SOAPY_SDR_HAS_TIME.
/// The numElems count can be used to request a finite burst size.
/// The SOAPY_SDR_END_BURST flag can signal end on the finite burst.
/// Not all implementations will support the full range of options.
/// In this case, the implementation returns SOAPY_SDR_NOT_SUPPORTED.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <param name=\"flags\">optional flag indicators about the stream</param>
/// <param name=\"timeNs\">optional activation time in nanoseconds</param>
/// <param name=\"numElems\">optional element count for burst control</param>
/// <returns>0 for success or error code on failure</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::deactivateStream(Stream * stream, const int flags, const long long timeNs) "

/// <summary>
/// Deactivate a stream.
/// Call deactivate when not using using read/write().
/// The implementation control switches or halt data flow.
/// The timeNs is only valid when the flags have SOAPY_SDR_HAS_TIME.
/// Not all implementations will support the full range of options.
/// In this case, the implementation returns SOAPY_SDR_NOT_SUPPORTED.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <param name=\"flags\">optional flag indicators about the stream</param>
/// <param name=\"timeNs\">optional deactivation time in nanoseconds</param>
/// <returns>0 for success or error code on failure</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readStream(Stream * stream, void * const * buffs, const size_t numElems, int & flags, long long & timeNs, const long timeoutUs) "

/// <summary>
/// Read elements from a stream for reception.
/// This is a multi-channel call, and buffs should be an array of void *,
/// where each pointer will be filled with data from a different channel.
/// **Client code compatibility:**
/// The readStream() call should be well defined at all times,
/// including prior to activation and after deactivation.
/// When inactive, readStream() should implement the timeout
/// specified by the caller and return SOAPY_SDR_TIMEOUT.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <param name=\"buffs\">an array of void* buffers num chans in size</param>
/// <param name=\"numElems\">the number of elements in each buffer</param>
/// <param name=\"flags\">optional flag indicators about the result</param>
/// <param name=\"timeNs\">the buffer's timestamp in nanoseconds</param>
/// <param name=\"timeoutUs\">the timeout in microseconds</param>
/// <returns>the number of elements read per buffer or error code</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeStream(Stream * stream, const void * const * buffs, const size_t numElems, int & flags, const long long timeNs, const long timeoutUs) "

/// <summary>
/// Write elements to a stream for transmission.
/// This is a multi-channel call, and buffs should be an array of void *,
/// where each pointer will be filled with data for a different channel.
/// **Client code compatibility:**
/// Client code relies on writeStream() for proper back-pressure.
/// The writeStream() implementation must enforce the timeout
/// such that the call blocks until space becomes available
/// or timeout expiration.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <param name=\"buffs\">an array of void* buffers num chans in size</param>
/// <param name=\"numElems\">the number of elements in each buffer</param>
/// <param name=\"flags\">optional input flags and output flags</param>
/// <param name=\"timeNs\">the buffer's timestamp in nanoseconds</param>
/// <param name=\"timeoutUs\">the timeout in microseconds</param>
/// <returns>the number of elements written per buffer or error</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readStreamStatus(Stream * stream, size_t & chanMask, int & flags, long long & timeNs, const long timeoutUs) "

/// <summary>
/// Readback status information about a stream.
/// This call is typically used on a transmit stream
/// to report time errors, underflows, and burst completion.
/// **Client code compatibility:**
/// Client code may continually poll readStreamStatus() in a loop.
/// Implementations of readStreamStatus() should wait in the call
/// for a status change event or until the timeout expiration.
/// When stream status is not implemented on a particular stream,
/// readStreamStatus() should return SOAPY_SDR_NOT_SUPPORTED.
/// Client code may use this indication to disable a polling loop.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <param name=\"chanMask\">to which channels this status applies</param>
/// <param name=\"flags\">optional input flags and output flags</param>
/// <param name=\"timeNs\">the buffer's timestamp in nanoseconds</param>
/// <param name=\"timeoutUs\">the timeout in microseconds</param>
/// <returns>0 for success or error code like timeout</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getNumDirectAccessBuffers(Stream * stream) "

/// <summary>
/// Direct buffer access API
/// How many direct access buffers can the stream provide?
/// This is the number of times the user can call acquire()
/// on a stream without making subsequent calls to release().
/// A return value of 0 means that direct access is not supported.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <returns>the number of direct access buffers or 0</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getDirectAccessBufferAddrs(Stream * stream, const size_t handle, void * * buffs) "

/// <summary>
/// Get the buffer addresses for a scatter/gather table entry.
/// When the underlying DMA implementation uses scatter/gather
/// then this call provides the user addresses for that table.
/// Example: The caller may query the DMA memory addresses once
/// after stream creation to pre-allocate a re-usable ring-buffer.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <param name=\"handle\">an index value between 0 and num direct buffers - 1</param>
/// <param name=\"buffs\">an array of void* buffers num chans in size</param>
/// <returns>0 for success or error code when not supported</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::acquireReadBuffer(Stream * stream, size_t & handle, const void * * buffs, int & flags, long long & timeNs, const long timeoutUs) "

/// <summary>
/// Acquire direct buffers from a receive stream.
/// This call is part of the direct buffer access API.
/// The buffs array will be filled with a stream pointer for each channel.
/// Each pointer can be read up to the number of return value elements.
/// The handle will be set by the implementation so that the caller
/// may later release access to the buffers with releaseReadBuffer().
/// Handle represents an index into the internal scatter/gather table
/// such that handle is between 0 and num direct buffers - 1.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <param name=\"handle\">an index value used in the release() call</param>
/// <param name=\"buffs\">an array of void* buffers num chans in size</param>
/// <param name=\"flags\">optional flag indicators about the result</param>
/// <param name=\"timeNs\">the buffer's timestamp in nanoseconds</param>
/// <param name=\"timeoutUs\">the timeout in microseconds</param>
/// <returns>the number of elements read per buffer or error code</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::releaseReadBuffer(Stream * stream, const size_t handle) "

/// <summary>
/// Release an acquired buffer back to the receive stream.
/// This call is part of the direct buffer access API.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <param name=\"handle\">the opaque handle from the acquire() call</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::acquireWriteBuffer(Stream * stream, size_t & handle, void * * buffs, const long timeoutUs) "

/// <summary>
/// Acquire direct buffers from a transmit stream.
/// This call is part of the direct buffer access API.
/// The buffs array will be filled with a stream pointer for each channel.
/// Each pointer can be written up to the number of return value elements.
/// The handle will be set by the implementation so that the caller
/// may later release access to the buffers with releaseWriteBuffer().
/// Handle represents an index into the internal scatter/gather table
/// such that handle is between 0 and num direct buffers - 1.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <param name=\"handle\">an index value used in the release() call</param>
/// <param name=\"buffs\">an array of void* buffers num chans in size</param>
/// <param name=\"timeoutUs\">the timeout in microseconds</param>
/// <returns>the number of available elements per buffer or error</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::releaseWriteBuffer(Stream * stream, const size_t handle, const size_t numElems, int & flags, const long long timeNs) "

/// <summary>
/// Release an acquired buffer back to the transmit stream.
/// This call is part of the direct buffer access API.
/// Stream meta-data is provided as part of the release call,
/// and not the acquire call so that the caller may acquire
/// buffers without committing to the contents of the meta-data,
/// which can be determined by the user as the buffers are filled.
/// </summary>
/// <param name=\"stream\">the opaque pointer to a stream handle</param>
/// <param name=\"handle\">the opaque handle from the acquire() call</param>
/// <param name=\"numElems\">the number of elements written to each buffer</param>
/// <param name=\"flags\">optional input flags and output flags</param>
/// <param name=\"timeNs\">the buffer's timestamp in nanoseconds</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listAntennas(const int direction, const size_t channel) const "

/// <summary>
/// Antenna API
/// Get a list of available antennas to select on a given chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of available antenna names</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setAntenna(const int direction, const size_t channel, const std::string & name) "

/// <summary>
/// Set the selected antenna on a chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"name\">the name of an available antenna</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getAntenna(const int direction, const size_t channel) const "

/// <summary>
/// Get the selected antenna on a chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>the name of an available antenna</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::hasDCOffsetMode(const int direction, const size_t channel) const "

/// <summary>
/// Frontend corrections API
/// Does the device support automatic DC offset corrections?
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>true if automatic corrections are supported</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setDCOffsetMode(const int direction, const size_t channel, const bool automatic) "

/// <summary>
/// Set the automatic DC offset corrections mode.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"automatic\">true for automatic offset correction</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getDCOffsetMode(const int direction, const size_t channel) const "

/// <summary>
/// Get the automatic DC offset corrections mode.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>true for automatic offset correction</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::hasDCOffset(const int direction, const size_t channel) const "

/// <summary>
/// Does the device support frontend DC offset correction?
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>true if DC offset corrections are supported</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setDCOffset(const int direction, const size_t channel, const std::complex<double> & offset) "

/// <summary>
/// Set the frontend DC offset correction.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"offset\">the relative correction (1.0 max)</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getDCOffset(const int direction, const size_t channel) const "

/// <summary>
/// Get the frontend DC offset correction.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>the relative correction (1.0 max)</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::hasIQBalance(const int direction, const size_t channel) const "

/// <summary>
/// Does the device support frontend IQ balance correction?
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>true if IQ balance corrections are supported</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setIQBalance(const int direction, const size_t channel, const std::complex<double> & balance) "

/// <summary>
/// Set the frontend IQ balance correction.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"balance\">the relative correction (1.0 max)</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getIQBalance(const int direction, const size_t channel) const "

/// <summary>
/// Get the frontend IQ balance correction.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>the relative correction (1.0 max)</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::hasIQBalanceMode(const int direction, const size_t channel) const "

/// <summary>
/// Does the device support automatic frontend IQ balance correction?
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>true if IQ balance corrections are supported</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setIQBalanceMode(const int direction, const size_t channel, const bool automatic) "

/// <summary>
/// Set the automatic frontend IQ balance correction.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"automatic\">true for automatic correction</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getIQBalanceMode(const int direction, const size_t channel) const "

/// <summary>
/// Set the automatic IQ balance corrections mode.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>true for automatic correction</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::hasFrequencyCorrection(const int direction, const size_t channel) const "

/// <summary>
/// Does the device support frontend frequency correction?
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>true if frequency corrections are supported</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setFrequencyCorrection(const int direction, const size_t channel, const double value) "

/// <summary>
/// Fine tune the frontend frequency correction.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"value\">the correction in PPM</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getFrequencyCorrection(const int direction, const size_t channel) const "

/// <summary>
/// Get the frontend frequency correction value.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>the correction value in PPM</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listGains(const int direction, const size_t channel) const "

/// <summary>
/// Gain API
/// List available amplification elements.
/// Elements should be in order RF to baseband.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel</param>
/// <returns>a list of gain string names</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::hasGainMode(const int direction, const size_t channel) const "

/// <summary>
/// Does the device support automatic gain control?
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>true for automatic gain control</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setGainMode(const int direction, const size_t channel, const bool automatic) "

/// <summary>
/// Set the automatic gain mode on the chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"automatic\">true for automatic gain setting</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getGainMode(const int direction, const size_t channel) const "

/// <summary>
/// Get the automatic gain mode on the chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>true for automatic gain setting</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setGain(const int direction, const size_t channel, const double value) "

/// <summary>
/// Set the overall amplification in a chain.
/// The gain will be distributed automatically across available element.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"value\">the new amplification value in dB</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setGain(const int direction, const size_t channel, const std::string & name, const double value) "

/// <summary>
/// Set the value of a amplification element in a chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"name\">the name of an amplification element</param>
/// <param name=\"value\">the new amplification value in dB</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getGain(const int direction, const size_t channel) const "

/// <summary>
/// Get the overall value of the gain elements in a chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>the value of the gain in dB</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getGain(const int direction, const size_t channel, const std::string & name) const "

/// <summary>
/// Get the value of an individual amplification element in a chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"name\">the name of an amplification element</param>
/// <returns>the value of the gain in dB</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getGainRange(const int direction, const size_t channel) const "

/// <summary>
/// Get the overall range of possible gain values.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of gain ranges in dB</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getGainRange(const int direction, const size_t channel, const std::string & name) const "

/// <summary>
/// Get the range of possible gain values for a specific element.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"name\">the name of an amplification element</param>
/// <returns>a list of gain ranges in dB</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setFrequency(const int direction, const size_t channel, const double frequency, const Kwargs & args) "

/// <summary>
/// Frequency API
/// Set the center frequency of the chain.
///  - For RX, this specifies the down-conversion frequency.
///  - For TX, this specifies the up-conversion frequency.
/// The default implementation of setFrequency() will tune the \"RF\"
/// component as close as possible to the requested center frequency.
/// Tuning inaccuracies will be compensated for with the \"BB\" component.
/// The args can be used to augment the tuning algorithm.
///  - Use \"OFFSET\" to specify an \"RF\" tuning offset,
///    usually with the intention of moving the LO out of the passband.
///    The offset will be compensated for using the \"BB\" component.
///  - Use the name of a component for the key and a frequency in Hz
///    as the value (any format) to enforce a specific frequency.
///    The other components will be tuned with compensation
///    to achieve the specified overall frequency.
///  - Use the name of a component for the key and the value \"IGNORE\"
///    so that the tuning algorithm will avoid altering the component.
///  - Vendor specific implementations can also use the same args to augment
///    tuning in other ways such as specifying fractional vs integer N tuning.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"frequency\">the center frequency in Hz</param>
/// <param name=\"args\">optional tuner arguments</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setFrequency(const int direction, const size_t channel, const std::string & name, const double frequency, const Kwargs & args) "

/// <summary>
/// Tune the center frequency of the specified element.
///  - For RX, this specifies the down-conversion frequency.
///  - For TX, this specifies the up-conversion frequency.
/// Recommended names used to represent tunable components:
///  - \"CORR\" - freq error correction in PPM
///  - \"RF\" - frequency of the RF frontend
///  - \"BB\" - frequency of the baseband DSP
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"name\">the name of a tunable element</param>
/// <param name=\"frequency\">the center frequency in Hz</param>
/// <param name=\"args\">optional tuner arguments</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getFrequency(const int direction, const size_t channel) const "

/// <summary>
/// Get the overall center frequency of the chain.
///  - For RX, this specifies the down-conversion frequency.
///  - For TX, this specifies the up-conversion frequency.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>the center frequency in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getFrequency(const int direction, const size_t channel, const std::string & name) const "

/// <summary>
/// Get the frequency of a tunable element in the chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"name\">the name of a tunable element</param>
/// <returns>the tunable element's frequency in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listFrequencies(const int direction, const size_t channel) const "

/// <summary>
/// List available tunable elements in the chain.
/// Elements should be in order RF to baseband.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel</param>
/// <returns>a list of tunable elements by name</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getFrequencyRange(const int direction, const size_t channel) const "

/// <summary>
/// Get the range of overall frequency values.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of frequency ranges in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getFrequencyRange(const int direction, const size_t channel, const std::string & name) const "

/// <summary>
/// Get the range of tunable values for the specified element.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"name\">the name of a tunable element</param>
/// <returns>a list of frequency ranges in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getFrequencyArgsInfo(const int direction, const size_t channel) const "

/// <summary>
/// Query the argument info description for tune args.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of argument info structures</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setSampleRate(const int direction, const size_t channel, const double rate) "

/// <summary>
/// Sample Rate API
/// Set the baseband sample rate of the chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"rate\">the sample rate in samples per second</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getSampleRate(const int direction, const size_t channel) const "

/// <summary>
/// Get the baseband sample rate of the chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>the sample rate in samples per second</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listSampleRates(const int direction, const size_t channel) const "

/// <summary>
/// Get the range of possible baseband sample rates.
/// \deprecated replaced by getSampleRateRange()
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of possible rates in samples per second</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getSampleRateRange(const int direction, const size_t channel) const "

/// <summary>
/// Get the range of possible baseband sample rates.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of sample rate ranges in samples per second</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setBandwidth(const int direction, const size_t channel, const double bw) "

/// <summary>
/// Bandwidth API
/// Set the baseband filter width of the chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"bw\">the baseband filter width in Hz</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getBandwidth(const int direction, const size_t channel) const "

/// <summary>
/// Get the baseband filter width of the chain.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>the baseband filter width in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listBandwidths(const int direction, const size_t channel) const "

/// <summary>
/// Get the range of possible baseband filter widths.
/// \deprecated replaced by getBandwidthRange()
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of possible bandwidths in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getBandwidthRange(const int direction, const size_t channel) const "

/// <summary>
/// Get the range of possible baseband filter widths.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of bandwidth ranges in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setMasterClockRate(const double rate) "

/// <summary>
/// Clocking API
/// Set the master clock rate of the device.
/// </summary>
/// <param name=\"rate\">the clock rate in Hz</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getMasterClockRate() const "

/// <summary>
/// Get the master clock rate of the device.
/// </summary>
/// <returns>the clock rate in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getMasterClockRates() const "

/// <summary>
/// Get the range of available master clock rates.
/// </summary>
/// <returns>a list of clock rate ranges in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setReferenceClockRate(const double rate) "

/// <summary>
/// Set the reference clock rate of the device.
/// </summary>
/// <param name=\"rate\">the clock rate in Hz</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getReferenceClockRate() const "

/// <summary>
/// Get the reference clock rate of the device.
/// </summary>
/// <returns>the clock rate in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getReferenceClockRates() const "

/// <summary>
/// Get the range of available reference clock rates.
/// </summary>
/// <returns>a list of clock rate ranges in Hz</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listClockSources() const "

/// <summary>
/// Get the list of available clock sources.
/// </summary>
/// <returns>a list of clock source names</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setClockSource(const std::string & source) "

/// <summary>
/// Set the clock source on the device
/// </summary>
/// <param name=\"source\">the name of a clock source</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getClockSource() const "

/// <summary>
/// Get the clock source of the device
/// </summary>
/// <returns>the name of a clock source</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listTimeSources() const "

/// <summary>
/// Time API
/// Get the list of available time sources.
/// </summary>
/// <returns>a list of time source names</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setTimeSource(const std::string & source) "

/// <summary>
/// Set the time source on the device
/// </summary>
/// <param name=\"source\">the name of a time source</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getTimeSource() const "

/// <summary>
/// Get the time source of the device
/// </summary>
/// <returns>the name of a time source</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::hasHardwareTime(const std::string & what) const "

/// <summary>
/// Does this device have a hardware clock?
/// </summary>
/// <param name=\"what\">optional argument</param>
/// <returns>true if the hardware clock exists</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getHardwareTime(const std::string & what) const "

/// <summary>
/// Read the time from the hardware clock on the device.
/// The what argument can refer to a specific time counter.
/// </summary>
/// <param name=\"what\">optional argument</param>
/// <returns>the time in nanoseconds</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setHardwareTime(const long long timeNs, const std::string & what) "

/// <summary>
/// Write the time to the hardware clock on the device.
/// The what argument can refer to a specific time counter.
/// </summary>
/// <param name=\"timeNs\">time in nanoseconds</param>
/// <param name=\"what\">optional argument</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::setCommandTime(const long long timeNs, const std::string & what) "

/// <summary>
/// Set the time of subsequent configuration calls.
/// The what argument can refer to a specific command queue.
/// Implementations may use a time of 0 to clear.
/// \deprecated replaced by setHardwareTime()
/// </summary>
/// <param name=\"timeNs\">time in nanoseconds</param>
/// <param name=\"what\">optional argument</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listSensors() const "

/// <summary>
/// Sensor API
/// List the available global readback sensors.
/// A sensor can represent a reference lock, RSSI, temperature.
/// </summary>
/// <returns>a list of available sensor string names</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getSensorInfo(const std::string & key) const "

/// <summary>
/// Get meta-information about a sensor.
/// Example: displayable name, type, range.
/// </summary>
/// <param name=\"key\">the ID name of an available sensor</param>
/// <returns>meta-information about a sensor</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readSensor(const std::string & key) const "

/// <summary>
/// Readback a global sensor given the name.
/// The value returned is a string which can represent
/// a boolean (\"true\"/\"false\"), an integer, or float.
/// </summary>
/// <param name=\"key\">the ID name of an available sensor</param>
/// <returns>the current value of the sensor</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readSensor(const std::string & key) const "

/// <summary>
/// Readback a global sensor given the name.
/// \tparam Type the return type for the sensor value
/// </summary>
/// <param name=\"key\">the ID name of an available sensor</param>
/// <returns>the current value of the sensor as the specified type</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listSensors(const int direction, const size_t channel) const "

/// <summary>
/// List the available channel readback sensors.
/// A sensor can represent a reference lock, RSSI, temperature.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of available sensor string names</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getSensorInfo(const int direction, const size_t channel, const std::string & key) const "

/// <summary>
/// Get meta-information about a channel sensor.
/// Example: displayable name, type, range.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"key\">the ID name of an available sensor</param>
/// <returns>meta-information about a sensor</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readSensor(const int direction, const size_t channel, const std::string & key) const "

/// <summary>
/// Readback a channel sensor given the name.
/// The value returned is a string which can represent
/// a boolean (\"true\"/\"false\"), an integer, or float.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"key\">the ID name of an available sensor</param>
/// <returns>the current value of the sensor</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readSensor(const int direction, const size_t channel, const std::string & key) const "

/// <summary>
/// Readback a channel sensor given the name.
/// \tparam Type the return type for the sensor value
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"key\">the ID name of an available sensor</param>
/// <returns>the current value of the sensor as the specified type</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listRegisterInterfaces() const "

/// <summary>
/// Register API
/// Get a list of available register interfaces by name.
/// </summary>
/// <returns>a list of available register interfaces</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeRegister(const std::string & name, const unsigned addr, const unsigned value) "

/// <summary>
/// Write a register on the device given the interface name.
/// This can represent a register on a soft CPU, FPGA, IC;
/// the interpretation is up the implementation to decide.
/// </summary>
/// <param name=\"name\">the name of a available register interface</param>
/// <param name=\"addr\">the register address</param>
/// <param name=\"value\">the register value</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readRegister(const std::string & name, const unsigned addr) const "

/// <summary>
/// Read a register on the device given the interface name.
/// </summary>
/// <param name=\"name\">the name of a available register interface</param>
/// <param name=\"addr\">the register address</param>
/// <returns>the register value</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeRegister(const unsigned addr, const unsigned value) "

/// <summary>
/// Write a register on the device.
/// This can represent a register on a soft CPU, FPGA, IC;
/// the interpretation is up the implementation to decide.
/// \deprecated replaced by writeRegister(name)
/// </summary>
/// <param name=\"addr\">the register address</param>
/// <param name=\"value\">the register value</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readRegister(const unsigned addr) const "

/// <summary>
/// Read a register on the device.
/// \deprecated replaced by readRegister(name)
/// </summary>
/// <param name=\"addr\">the register address</param>
/// <returns>the register value</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeRegisters(const std::string & name, const unsigned addr, const std::vector<unsigned> & value) "

/// <summary>
/// Write a memory block on the device given the interface name.
/// This can represent a memory block on a soft CPU, FPGA, IC;
/// the interpretation is up the implementation to decide.
/// </summary>
/// <param name=\"name\">the name of a available memory block interface</param>
/// <param name=\"addr\">the memory block start address</param>
/// <param name=\"value\">the memory block content</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readRegisters(const std::string & name, const unsigned addr, const size_t length) const "

/// <summary>
/// Read a memory block on the device given the interface name.
/// </summary>
/// <param name=\"name\">the name of a available memory block interface</param>
/// <param name=\"addr\">the memory block start address</param>
/// <param name=\"length\">number of words to be read from memory block</param>
/// <returns>the memory block content</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getSettingInfo() const "

/// <summary>
/// Settings API
/// Describe the allowed keys and values used for settings.
/// </summary>
/// <returns>a list of argument info structures</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeSetting(const std::string & key, const std::string & value) "

/// <summary>
/// Write an arbitrary setting on the device.
/// The interpretation is up the implementation.
/// </summary>
/// <param name=\"key\">the setting identifier</param>
/// <param name=\"value\">the setting value</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeSetting(const std::string & key, const Type & value) "

/// <summary>
/// Write a setting with an arbitrary value type.
/// \tparam Type the data type of the value
/// </summary>
/// <param name=\"key\">the setting identifier</param>
/// <param name=\"value\">the setting value</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readSetting(const std::string & key) const "

/// <summary>
/// Read an arbitrary setting on the device.
/// </summary>
/// <param name=\"key\">the setting identifier</param>
/// <returns>the setting value</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readSetting(const std::string & key) "

/// <summary>
/// Read an arbitrary setting on the device.
/// \tparam Type the return type for the sensor value
/// </summary>
/// <param name=\"key\">the setting identifier</param>
/// <returns>the setting value</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getSettingInfo(const int direction, const size_t channel) const "

/// <summary>
/// Describe the allowed keys and values used for channel settings.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <returns>a list of argument info structures</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeSetting(const int direction, const size_t channel, const std::string & key, const std::string & value) "

/// <summary>
/// Write an arbitrary channel setting on the device.
/// The interpretation is up the implementation.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"key\">the setting identifier</param>
/// <param name=\"value\">the setting value</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeSetting(const int direction, const size_t channel, const std::string & key, const Type & value) "

/// <summary>
/// Write an arbitrary channel setting on the device.
/// \tparam Type the data type of the value
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"key\">the setting identifier</param>
/// <param name=\"value\">the setting value</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readSetting(const int direction, const size_t channel, const std::string & key) const "

/// <summary>
/// Read an arbitrary channel setting on the device.
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"key\">the setting identifier</param>
/// <returns>the setting value</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readSetting(const int direction, const size_t channel, const std::string & key) "

/// <summary>
/// Read an arbitrary channel setting on the device.
/// \tparam Type the return type for the sensor value
/// </summary>
/// <param name=\"direction\">the channel direction RX or TX</param>
/// <param name=\"channel\">an available channel on the device</param>
/// <param name=\"key\">the setting identifier</param>
/// <returns>the setting value</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listGPIOBanks() const "

/// <summary>
/// GPIO API
/// Get a list of available GPIO banks by name.
/// </summary>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeGPIO(const std::string & bank, const unsigned value) "

/// <summary>
/// Write the value of a GPIO bank.
/// </summary>
/// <param name=\"bank\">the name of an available bank</param>
/// <param name=\"value\">an integer representing GPIO bits</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeGPIO(const std::string & bank, const unsigned value, const unsigned mask) "

/// <summary>
/// Write the value of a GPIO bank with modification mask.
/// </summary>
/// <param name=\"bank\">the name of an available bank</param>
/// <param name=\"value\">an integer representing GPIO bits</param>
/// <param name=\"mask\">a modification mask where 1 = modify</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readGPIO(const std::string & bank) const "

/// <summary>
/// Readback the value of a GPIO bank.
/// </summary>
/// <param name=\"bank\">the name of an available bank</param>
/// <returns>an integer representing GPIO bits</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeGPIODir(const std::string & bank, const unsigned dir) "

/// <summary>
/// Write the data direction of a GPIO bank.
/// 1 bits represent outputs, 0 bits represent inputs.
/// </summary>
/// <param name=\"bank\">the name of an available bank</param>
/// <param name=\"dir\">an integer representing data direction bits</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeGPIODir(const std::string & bank, const unsigned dir, const unsigned mask) "

/// <summary>
/// Write the data direction of a GPIO bank with modification mask.
/// 1 bits represent outputs, 0 bits represent inputs.
/// </summary>
/// <param name=\"bank\">the name of an available bank</param>
/// <param name=\"dir\">an integer representing data direction bits</param>
/// <param name=\"mask\">a modification mask where 1 = modify</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readGPIODir(const std::string & bank) const "

/// <summary>
/// Read the data direction of a GPIO bank.
/// 1 bits represent outputs, 0 bits represent inputs.
/// </summary>
/// <param name=\"bank\">the name of an available bank</param>
/// <returns>an integer representing data direction bits</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeI2C(const int addr, const std::string & data) "

/// <summary>
/// I2C API
/// Write to an available I2C slave.
/// If the device contains multiple I2C masters,
/// the address bits can encode which master.
/// </summary>
/// <param name=\"addr\">the address of the slave</param>
/// <param name=\"data\">an array of bytes write out</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readI2C(const int addr, const size_t numBytes) "

/// <summary>
/// Read from an available I2C slave.
/// If the device contains multiple I2C masters,
/// the address bits can encode which master.
/// </summary>
/// <param name=\"addr\">the address of the slave</param>
/// <param name=\"numBytes\">the number of bytes to read</param>
/// <returns>an array of bytes read from the slave</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::transactSPI(const int addr, const unsigned data, const size_t numBits) "

/// <summary>
/// SPI API
/// Perform a SPI transaction and return the result.
/// Its up to the implementation to set the clock rate,
/// and read edge, and the write edge of the SPI core.
/// SPI slaves without a readback pin will return 0.
/// If the device contains multiple SPI masters,
/// the address bits can encode which master.
/// </summary>
/// <param name=\"addr\">an address of an available SPI slave</param>
/// <param name=\"data\">the SPI data, numBits-1 is first out</param>
/// <param name=\"numBits\">the number of bits to clock out</param>
/// <returns>the readback data, numBits-1 is first in</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::listUARTs() const "

/// <summary>
/// UART API
/// Enumerate the available UART devices.
/// </summary>
/// <returns>a list of names of available UARTs</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::writeUART(const std::string & which, const std::string & data) "

/// <summary>
/// Write data to a UART device.
/// Its up to the implementation to set the baud rate,
/// carriage return settings, flushing on newline.
/// </summary>
/// <param name=\"which\">the name of an available UART</param>
/// <param name=\"data\">an array of bytes to write out</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::readUART(const std::string & which, const long timeoutUs) const "

/// <summary>
/// Read bytes from a UART until timeout or newline.
/// Its up to the implementation to set the baud rate,
/// carriage return settings, flushing on newline.
/// </summary>
/// <param name=\"which\">the name of an available UART</param>
/// <param name=\"timeoutUs\">a timeout in microseconds</param>
/// <returns>an array of bytes read from the UART</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Device::getNativeDeviceHandle() const "

/// <summary>
/// Native Access API
/// A handle to the native device used by the driver.
/// The implementation may return a null value if it does not support
/// or does not wish to provide access to the native handle.
/// </summary>
/// <returns>a handle to the native device or null</returns>
public";

////////////////////////////////////////////////////



%csmethodmodifiers SoapySDR::errToStr "

/// <summary>
/// Convert a error code to a string for printing purposes.
/// If the error code is unrecognized, errToStr returns \"UNKNOWN\".
/// </summary>
/// <param name=\"errorCode\">a negative integer return code</param>
/// <returns>a pointer to a string representing the error</returns>
public";



%csmethodmodifiers SoapySDR::formatToSize "

/// <summary>
/// Get the size of a single element in the specified format.
/// </summary>
/// <param name=\"format\">a supported format string</param>
/// <returns>the size of an element in bytes</returns>
public";



%csmethodmodifiers SoapySDR::log "

/// <summary>
/// Send a message to the registered logger.
/// </summary>
/// <param name=\"logLevel\">a possible logging level</param>
/// <param name=\"message\">a logger message string</param>
public";


%csmethodmodifiers SoapySDR::vlogf "

/// <summary>
/// Send a message to the registered logger.
/// </summary>
/// <param name=\"logLevel\">a possible logging level</param>
/// <param name=\"format\">a printf style format string</param>
/// <param name=\"argList\">an argument list for the formatter</param>
public";


%csmethodmodifiers SoapySDR::logf "

/// <summary>
/// Send a message to the registered logger.
/// </summary>
/// <param name=\"logLevel\">a possible logging level</param>
/// <param name=\"format\">a printf style format string</param>
public";


%csmethodmodifiers SoapySDR::registerLogHandler "

/// <summary>
/// Typedef for the registered log handler function.
/// Register a new system log handler.
/// Platforms should call this to replace the default stdio handler.
/// Passing `nullptr` restores the default.
/// </summary>
public";


%csmethodmodifiers SoapySDR::setLogLevel "

/// <summary>
/// Set the log level threshold.
/// Log messages with lower priority are dropped.
/// </summary>
public";



%csmethodmodifiers SoapySDR::getRootPath "

public";


%csmethodmodifiers SoapySDR::listSearchPaths "

/// <summary>
/// The list of paths automatically searched by loadModules().
/// </summary>
/// <returns>a list of automatically searched file paths</returns>
public";


%csmethodmodifiers SoapySDR::listModules "

/// <summary>
/// List all modules found in default path.
/// </summary>
/// <returns>a list of file paths to loadable modules</returns>
public";


%csmethodmodifiers SoapySDR::listModules "

/// <summary>
/// List all modules found in the given path.
/// </summary>
/// <param name=\"path\">a directory on the system</param>
/// <returns>a list of file paths to loadable modules</returns>
public";


%csmethodmodifiers SoapySDR::loadModule "

/// <summary>
/// Load a single module given its file system path.
/// </summary>
/// <param name=\"path\">the path to a specific module file</param>
/// <returns>an error message, empty on success</returns>
public";


%csmethodmodifiers SoapySDR::getLoaderResult "

/// <summary>
/// List all registration loader errors for a given module path.
/// The resulting dictionary contains all registry entry names
/// provided by the specified module. The value of each entry
/// is an error message string or empty on successful load.
/// </summary>
/// <param name=\"path\">the path to a specific module file</param>
/// <returns>a dictionary of registry names to error messages</returns>
public";


%csmethodmodifiers SoapySDR::getModuleVersion "

/// <summary>
/// Get a version string for the specified module.
/// Modules may optionally provide version strings.
/// </summary>
/// <param name=\"path\">the path to a specific module file</param>
/// <returns>a version string or empty if no version provided</returns>
public";


%csmethodmodifiers SoapySDR::unloadModule "

/// <summary>
/// Unload a module that was loaded with loadModule().
/// </summary>
/// <param name=\"path\">the path to a specific module file</param>
/// <returns>an error message, empty on success</returns>
public";


%csmethodmodifiers SoapySDR::loadModules "

/// <summary>
/// Load the support modules installed on this system.
/// This call will only actually perform the load once.
/// Subsequent calls are a NOP.
/// </summary>
public";


%csmethodmodifiers SoapySDR::unloadModules "

/// <summary>
/// Unload all currently loaded support modules.
/// </summary>
public";
%typemap(csimports) SoapySDR::ModuleManager "
using System;
using System.Runtime.InteropServices;

/// <summary>
/// Manage the lifetime of loadable modules
/// by unloading modules on scope exit.
/// </summary>"

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::ModuleManager::ModuleManager(const bool load) "

/// <summary>
/// Create an instance of the module manager.
/// Loading modules on creation can be disabled.
/// </summary>
/// <param name=\"load\">false to skip loading modules</param>
public";

////////////////////////////////////////////////////
%typemap(csimports) SoapySDR::ModuleVersion "
using System;
using System.Runtime.InteropServices;
"

////////////////////////////////////////////////////

%typemap(csimports) SoapySDR::Registry "
using System;
using System.Runtime.InteropServices;

/// <summary>
/// A registry object loads device functions into the global registry.
/// </summary>"

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Registry::Registry(const std::string & name, const FindFunction & find, const MakeFunction & make, const std::string & abi) "

/// <summary>
/// Register a SDR device find and make function.
/// </summary>
/// <param name=\"name\">a unique name to identify the entry</param>
/// <param name=\"find\">the find function returns an arg list</param>
/// <param name=\"make\">the make function returns a device sptr</param>
/// <param name=\"abi\">this value must be SOAPY_SDR_ABI_VERSION</param>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Registry::listFindFunctions() "

/// <summary>
/// List all loaded find functions.
/// </summary>
/// <returns>a dictionary of registry entry names to find functions</returns>
public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Registry::listMakeFunctions() "

/// <summary>
/// List all loaded make functions.
/// </summary>
/// <returns>a dictionary of registry entry names to make functions</returns>
public";

////////////////////////////////////////////////////



%csmethodmodifiers SoapySDR::ticksToTimeNs "

/// <summary>
/// Convert a tick count into a time in nanoseconds using the tick rate.
/// </summary>
/// <param name=\"ticks\">a integer tick count</param>
/// <param name=\"rate\">the ticks per second</param>
/// <returns>the time in nanoseconds</returns>
public";


%csmethodmodifiers SoapySDR::timeNsToTicks "

/// <summary>
/// Convert a time in nanoseconds into a tick count using the tick rate.
/// </summary>
/// <param name=\"timeNs\">time in nanoseconds</param>
/// <param name=\"rate\">the ticks per second</param>
/// <returns>the integer tick count</returns>
public";



%csmethodmodifiers SoapySDR::KwargsFromString "

/// <summary>
/// Convert a markup string to a key-value map.
/// The markup format is: \"key0=value0, key1=value1\"
/// </summary>
public";


%csmethodmodifiers SoapySDR::KwargsToString "

/// <summary>
/// Convert a key-value map to a markup string.
/// The markup format is: \"key0=value0, key1=value1\"
/// </summary>
public";


%csmethodmodifiers SoapySDR::StringToSetting "

/// <summary>
/// Convert a string to the specified type.
/// Supports bools, integers, floats, and strings
/// \tparam Type the specified output type
/// </summary>
/// <param name=\"s\">the setting value as a string</param>
/// <returns>the value converted to Type</returns>
public";


%csmethodmodifiers SoapySDR::SettingToString "

/// <summary>
/// Convert an arbitrary type to a string.
/// Supports bools, integers, floats, and strings
/// \tparam Type the type of the input argument
/// </summary>
/// <param name=\"s\">the setting value as the specified type</param>
/// <returns>the value converted to a string</returns>
public";


%csmethodmodifiers minimum "

/// <summary>
/// Typedef for a list of Argument infos.
/// </summary>
public";
%typemap(csimports) SoapySDR::Range "
using System;
using System.Runtime.InteropServices;

/// <summary>
/// A simple min/max numeric range pair
/// </summary>"

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Range::Range() "

public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Range::Range(const double minimum, const double maximum, const double step) "

public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Range::minimum() const "

public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Range::maximum() const "

public";

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::Range::step() const "

public";

////////////////////////////////////////////////////
%typemap(csimports) SoapySDR::ArgInfo "
using System;
using System.Runtime.InteropServices;

/// <summary>
/// Typedef for a list of min/max range pairs.
/// Overall minimum: rl.front().minimum();
/// Overall maximum: rl.back().maximum();
/// Argument info describes a key/value argument.
/// </summary>"

////////////////////////////////////////////////////


%csmethodmodifiers SoapySDR::ArgInfo::ArgInfo() "

public";

////////////////////////////////////////////////////



%csmethodmodifiers SoapySDR::getAPIVersion "

/// <summary>
/// Get the SoapySDR library API version as a string.
/// The format of the version string is major.minor.increment,
/// where the digits are taken directly from SOAPY_SDR_API_VERSION.
/// </summary>
public";


%csmethodmodifiers SoapySDR::getABIVersion "

/// <summary>
/// Get the ABI version string that the library was built against.
/// A client can compare SOAPY_SDR_ABI_VERSION to getABIVersion()
/// to check for ABI incompatibility before using the library.
/// If the values are not equal then the client code was
/// compiled against a different ABI than the library.
/// </summary>
public";


%csmethodmodifiers SoapySDR::getLibVersion "

/// <summary>
/// Get the library version and build information string.
/// The format of the version string is major.minor.patch-buildInfo.
/// This function is commonly used to identify the software back-end
/// to the user for command-line utilities and graphical applications.
/// </summary>
public";

