# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

function test_suite=TestSoapyTypes
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;

function testArgInfo
    SoapySDR;

    argInfo = SoapySDR.getUnitTestArgInfo()
    key = "key"
    name = "name"
    description = "description"
    units = "units"
    type = SoapySDR.ArgType.FLOAT
    range = SoapySDR.Range(0.0, 1.0, 0.1)
    options = cellstr(["opt1"; "opt2"; "opt3"])
    optionNames = cellstr(["Option1"; "Option2"; "Option3"])

    assertEqual(key, argInfo.key)
    assertEqual(name, argInfo.name)
    assertEqual(description, argInfo.description)
    assertEqual(units, argInfo.units)
    assertEqual(type, argInfo.type)
    assertEqual(key, argInfo.key)
    assertEqual(range.minimum, argInfo.range.minimum)
    assertEqual(range.maximum, argInfo.range.maximum)
    assertEqual(range.step, argInfo.range.step)
    assertEqual(options, argInfo.options)
    assertEqual(optionNames, argInfo.optionNames)
