# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

# Not a function file
1;

%!test
%! SoapySDR
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
%! #assert(device.getClockSource() == "")
%! device.listClockSources() # TODO: check is array
%!
%! #
%! # Time API
%! #
%!
%! #TODO: make these attributes, figure out string comparison issue
%! device.setTimeSource("")
%! #assert(device.getTimeSource() == "")
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
%! device.getSettingInfo() # TODO: attribute?
%! device.writeSetting("", "")
%! #device.writeSetting("", 0)
%! #device.writeSetting("", 0.0)
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
%! #assert(device.readI2C(0, 0) == "") # TODO: how?
%!
%! #
%! # SPI API
%! #
%!
%! assert(device.transactSPI(0, 0, 0), 0)
%!
%! #
%! # UART API
%! #
%!
%! device.listUARTs() # TODO: attribute, check value
%! device.writeUART("", "")
%! #assert(device.readUART("") == "") # TODO: how?
%!
%! # TODO: per-direction API
