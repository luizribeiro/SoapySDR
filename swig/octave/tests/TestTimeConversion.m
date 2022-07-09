# Copyright (c) 2022 Nicholas Corgan
# SPDX-License-Identifier: BSL-1.0

function test_suite=TestTimeConversion
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;

function testLoopbackTimeToTicks
    SoapySDR;
    rates = [1e9, 52e6, 61.44e6, 100e6/3]
    for i = 1:100
        timeNs = int64(rand() * intmax("int64"))
        for rate = rates
            ticks = SoapySDR.timeNsToTicks(timeNs, rate)
            timeNsOut = SoapySDR.ticksToTimeNs(ticks, rate)
            assertLessThan(double(abs(timeNs - timeNsOut)) / 1e9, rate) # We expect an error, timeNs specifies a subtick

            ticks = SoapySDR.timeNsToTicks(-timeNs, rate)
            timeNsOut = SoapySDR.ticksToTimeNs(ticks, rate)
            assertLessThan(double(abs(-timeNs - timeNsOut)) / 1e9, rate) # We expect an error, timeNs specifies a subtick
        endfor
    endfor

function testLoopbackTicksToTime
    SoapySDR;
    rates = [1e9, 52e6, 61.44e6, 100e6/3]
    for i = 1:100
        ticks = int64(rand() * intmax("int32"))
        for rate = rates
            timeNs = SoapySDR.ticksToTimeNs(ticks, rate)
            ticksOut = SoapySDR.timeNsToTicks(timeNs, rate)
            assertEqual(ticks, ticksOut)
        endfor
    endfor
