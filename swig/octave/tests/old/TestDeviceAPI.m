# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

# Not a function file
1;

%!test
%! SoapySDR
%!
%! function fn = testDirection(device, direction)
%!   #
%!   # Channels API
%!   #
%!
%!   device.setFrontendMapping(direction, "0:0")
%!   assert(strcmp(device.getFrontendMapping(direction), "") == 1)
%!   device.getChannelInfo(direction, 0) # TODO: check
%!   assert(device.getFullDuplex(direction, 0))
%!
%!   #
%!   # Stream API
%!   #
%!
%!   device.getStreamFormats(direction, 0) # TODO: check
%!   [format, fullScale] = device.getNativeStreamFormat(direction, 0)
%!   #assert(strcmp(format, SoapySDR.StreamFormat.CS16) == 1) # TODO: odd error
%!   assert(fullScale == bitshift(1, 15))
%!
%!   format = SoapySDR.StreamFormat.CF32
%!   channels = [0, 1]
%!   args = "bufflen=8192,buffers=15"
%!   stream = device.setupStream(direction, format, channels, args)
%! endfunction
%!
%! #######################################################
%!
%! device = SoapySDR.Device("driver=null,type=null")
%!
%! #
%! # Identification API
%! #
%!
%! assert(device.driverKey == "null")
%! assert(device.hardwareKey == "null")
%! device.getHardwareInfo()
%!
%! #
%! # Clocking API
%! #
%!
%! # TODO: make these attributes
%! device.setMasterClockRate(0.0)
%! assert(device.getMasterClockRate() == 0.0)
%! device.getMasterClockRates() # TODO: check is range array
%!
%! # TODO: make these attributes
%! device.setReferenceClockRate(0.0)
%! assert(device.getReferenceClockRate() == 0.0)
%! device.getReferenceClockRates() # TODO: check is range array
%!
%! #TODO: make these attributes, figure out string comparison issue
%! device.setClockSource("")
%! assert(strcmp(device.getClockSource(), "") == 1)
%! device.listClockSources() # TODO: check is array
%!
%! #
%! # Time API
%! #
%!
%! #TODO: make these attributes
%! device.setTimeSource("")
%! assert(strcmp(device.getTimeSource(), "") == 1)
%! device.listTimeSources() # TODO: check is array
%!
%! assert(isa(device.hasHardwareTime(), "logical"))
%! assert(isa(device.hasHardwareTime(""), "logical"))
%! device.setHardwareTime(0)
%! device.setHardwareTime(0, "")
%! assert(device.getHardwareTime() == 0)
%! assert(device.getHardwareTime("") == 0)
%!
%! #
%! # Sensor API (TODO: check types, seem to be "nothing")
%! #
%!
%! device.listSensors()
%! device.getSensorInfo("")
%! device.readSensor("")
%!
%! #
%! # Register API (TODO: check types)
%! #
%!
%! device.listRegisterInterfaces() # TODO: attribute
%!
%! device.writeRegister("", 0, 0)
%! assert(device.readRegister("", 0) == 0)
%!
%! device.writeRegisters("", 0, [])
%! #assert(device.readRegisters("", 0, 0) == []) # TODO: how?
%!
%! #
%! # Settings API (TODO: all writeSetting overloads should work)
%! #
%!
%! device.getSettingInfo()
%! device.getSettingInfo("")
%! device.writeSetting("", "")
%! device.writeSetting("", 0)
%! device.writeSetting("", 0.0)
%!
%! #
%! # GPIO API
%! #
%!
%! device.listGPIOBanks()
%! device.writeGPIO("", 0)
%! device.writeGPIO("", 0, 0)
%! assert(device.readGPIO("") == 0)
%! device.writeGPIODir("", 0)
%! device.writeGPIODir("", 0, 0)
%! assert(device.readGPIODir("") == 0)
%!
%! #
%! # I2C API
%! #
%!
%! device.writeI2C(0, "")
%! assert(strcmp(device.readI2C(0, 0), "") == 1)
%!
%! #
%! # SPI API
%! #
%!
%! assert(device.transactSPI(0, 0, 0) == 0)
%!
%! #
%! # UART API
%! #
%!
%! device.listUARTs() # TODO: attribute, check value
%! device.writeUART("", "")
%! assert(strcmp(device.readUART(""), "") == 1)
%!
%! #
%! # Test functions with direction parameters
%! #
%! 
%! testDirection(device, SoapySDR.Direction.TX)
%! testDirection(device, SoapySDR.Direction.RX)
