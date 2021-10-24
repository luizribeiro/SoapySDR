// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

using System;
using System.Collections.Generic;

using NUnit.Framework;

// For the null device, functions generally don't do anything or return some
// hardcoded value, but we can still make sure functions compile and run as
// expected, especially for the added C# fanciness.

[TestFixture]
public class TestStreamingAPI
{
    //
    // Utility
    //

    private static void TestDeviceKeys(SoapySDR.Device device)
    {
        Assert.AreEqual("null", device.DriverKey);
        Assert.AreEqual("null", device.HardwareKey);
        Assert.AreEqual("null:null", device.ToString());
    }

    private static SoapySDR.Device GetTestDevice()
    {
        // Make sure either method works.
        TestDeviceKeys(new SoapySDR.Device("driver=null,type=null"));

        var args = new Dictionary<string, string>();
        args.Add("driver", "null");
        args.Add("type", "null");

        var device = new SoapySDR.Device(args);
        TestDeviceKeys(device);

        return device;
    }

    private static void GetStreamTestParams(
        out uint[] oneChannel,
        out uint[] twoChannels,
        out Dictionary<string, string> streamArgs,
        out SoapySDR.StreamFlags streamFlags,
        out long timeNs,
        out int timeoutUs,
        out uint numElems)
    {
        oneChannel = new uint[] { 0 };
        twoChannels = new uint[] { 0, 1 };

        streamArgs = new Dictionary<string, string>();
        streamArgs["bufflen"] = "8192";
        streamArgs["buffers"] = "15";

        streamFlags = SoapySDR.StreamFlags.HasTime | SoapySDR.StreamFlags.EndBurst;
        timeNs = 1000;
        timeoutUs = 1000;
        numElems = 1024;
    }

    //
    // Non-generic TX streaming API
    //

    private unsafe void TestTxStreamNonGeneric(string format)
    {
        var device = GetTestDevice();
        var streamResult = new SoapySDR.StreamResult();

        GetStreamTestParams(
            out uint[] channel,
            out uint[] channels,
            out Dictionary<string, string> streamArgs,
            out SoapySDR.StreamFlags streamFlags,
            out long timeNs,
            out int timeoutUs,
            out uint numElems);

        //
        // Test with single channel
        //

        var txStream = device.SetupTxStream(format, channel, streamArgs);
        Assert.AreEqual(format, txStream.Format);
        Assert.AreEqual(channel, txStream.Channels);
        Assert.AreEqual(streamArgs, txStream.StreamArgs);
        Assert.False(txStream.Active);
        Assert.AreEqual(1024, txStream.MTU);

        txStream.Activate(streamFlags, timeNs, numElems);
        Assert.True(txStream.Active);

        byte[] buf = new byte[numElems * SoapySDR.StreamFormats.FormatToSize(format)];
        fixed (void* ptr = &buf[0])
        {
            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Write((IntPtr)ptr, numElems, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Write((UIntPtr)ptr, numElems, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);
        }

        Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Deactivate(streamFlags, timeNs));
        Assert.False(txStream.Active);
        txStream.Close();

        //
        // Test with multiple channels
        //

        txStream = device.SetupTxStream(format, channels, streamArgs);
        Assert.AreEqual(format, txStream.Format);
        Assert.AreEqual(channels, txStream.Channels);
        Assert.AreEqual(streamArgs, txStream.StreamArgs);
        Assert.False(txStream.Active);
        Assert.AreEqual(1024, txStream.MTU);

        byte[][] bufs = new byte[channels.Length][];
        for (var i = 0; i < bufs.Length; ++i) bufs[i] = new byte[numElems * SoapySDR.StreamFormats.FormatToSize(format)];

        fixed (void* ptr0 = &buf[0])
        {
            fixed (void* ptr1 = &buf[1])
            {
                var intPtrs = new IntPtr[] { (IntPtr)ptr0, (IntPtr)ptr1 };
                Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Write(intPtrs, numElems, timeNs, timeoutUs, out streamResult));
                Assert.AreEqual(0, streamResult.NumSamples);
                Assert.AreEqual(streamFlags, streamResult.Flags);

                var uintPtrs = new UIntPtr[] { (UIntPtr)ptr0, (UIntPtr)ptr1 };
                Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Write(uintPtrs, numElems, timeNs, timeoutUs, out streamResult));
                Assert.AreEqual(0, streamResult.NumSamples);
                Assert.AreEqual(streamFlags, streamResult.Flags);
            }
        }

        //
        // Test async read status
        //

        Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.ReadStatus(timeoutUs, out streamResult));
        Assert.AreEqual(0, streamResult.TimeNs);
        Assert.AreEqual(SoapySDR.StreamFlags.None, streamResult.Flags);
        Assert.AreEqual(0, streamResult.ChanMask);

        Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Deactivate(streamFlags, timeNs));
        Assert.False(txStream.Active);
        txStream.Close();
    }

    // TODO: StreamFormats -> StreamFormat
    [Test]
    public void Test_TxStreamNonGeneric()
    {
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.S8);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.S16);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.S32);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.U8);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.U16);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.U32);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.F32);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.F64);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.CS8);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.CS12);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.CS16);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.CS32);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.CU8);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.CU12);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.CU16);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.CU32);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.CF32);
        TestTxStreamNonGeneric(SoapySDR.StreamFormats.CF64);
    }

    //
    // Non-generic RX streaming API
    //

    private unsafe void TestRxStreamNonGeneric(string format)
    {
        var device = GetTestDevice();
        var streamResult = new SoapySDR.StreamResult();

        GetStreamTestParams(
            out uint[] channel,
            out uint[] channels,
            out Dictionary<string, string> streamArgs,
            out SoapySDR.StreamFlags streamFlags,
            out long timeNs,
            out int timeoutUs,
            out uint numElems);

        //
        // Test with single channel
        //

        var rxStream = device.SetupRxStream(format, channel, streamArgs);
        Assert.AreEqual(format, rxStream.Format);
        Assert.AreEqual(channel, rxStream.Channels);
        Assert.AreEqual(streamArgs, rxStream.StreamArgs);
        Assert.False(rxStream.Active);
        Assert.AreEqual(1024, rxStream.MTU);

        rxStream.Activate(streamFlags, timeNs, numElems);
        Assert.True(rxStream.Active);

        byte[] buf = new byte[numElems * SoapySDR.StreamFormats.FormatToSize(format)];
        fixed (void* ptr = &buf[0])
        {
            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Read((IntPtr)ptr, numElems, streamFlags, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Read((UIntPtr)ptr, numElems, streamFlags, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);
        }

        Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Deactivate());
        Assert.False(rxStream.Active);
        rxStream.Close();

        //
        // Test with multiple channels
        //

        rxStream = device.SetupRxStream(format, channels, streamArgs);
        Assert.AreEqual(format, rxStream.Format);
        Assert.AreEqual(channels, rxStream.Channels);
        Assert.AreEqual(streamArgs, rxStream.StreamArgs);
        Assert.False(rxStream.Active);
        Assert.AreEqual(1024, rxStream.MTU);

        byte[][] bufs = new byte[channels.Length][];
        for (var i = 0; i < bufs.Length; ++i) bufs[i] = new byte[numElems * SoapySDR.StreamFormats.FormatToSize(format)];

        fixed (void* ptr0 = &buf[0])
        {
            fixed (void* ptr1 = &buf[1])
            {
                var intPtrs = new IntPtr[] { (IntPtr)ptr0, (IntPtr)ptr1 };
                Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Read(intPtrs, numElems, streamFlags, timeNs, timeoutUs, out streamResult));
                Assert.AreEqual(0, streamResult.NumSamples);
                Assert.AreEqual(streamFlags, streamResult.Flags);

                var uintPtrs = new UIntPtr[] { (UIntPtr)ptr0, (UIntPtr)ptr1 };
                Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Read(uintPtrs, numElems, streamFlags, timeNs, timeoutUs, out streamResult));
                Assert.AreEqual(0, streamResult.NumSamples);
                Assert.AreEqual(streamFlags, streamResult.Flags);
            }
        }

        Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Deactivate());
        Assert.False(rxStream.Active);
        rxStream.Close();
    }

    // TODO: StreamFormats -> StreamFormat
    [Test]
    public void Test_RxStreamNonGeneric()
    {
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.S8);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.S16);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.S32);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.U8);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.U16);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.U32);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.F32);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.F64);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.CS8);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.CS12);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.CS16);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.CS32);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.CU8);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.CU12);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.CU16);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.CU32);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.CF32);
        TestRxStreamNonGeneric(SoapySDR.StreamFormats.CF64);
    }

    //
    // Generic test interface
    //

    public interface IGenericStreamingTestCase
    {
        void TestTxStreaming();

        void TestComplexTxStreaming();

        void TestRxStreaming();

        void TestComplexRxStreaming();
    }

    //
    // Generic test implementation
    //

    public class GenericStreamingTestCase<T>: IGenericStreamingTestCase where T: unmanaged
    {
        public void TestTxStreaming()
        {
            var device = GetTestDevice();
            SoapySDR.StreamResult streamResult;

            GetStreamTestParams(
                out uint[] oneChannel,
                out uint[] twoChannels,
                out Dictionary<string, string> streamArgs,
                out SoapySDR.StreamFlags streamFlags,
                out long timeNs,
                out int timeoutUs,
                out uint numElems);
            
            //
            // Test with single channel
            //

            var txStream = device.SetupTxStream<T>(oneChannel, streamArgs);
            Assert.AreEqual(SoapySDR.Utility.GetFormatString<T>(), txStream.Format);
            Assert.AreEqual(oneChannel, txStream.Channels);
            Assert.AreEqual(streamArgs, txStream.StreamArgs);
            Assert.False(txStream.Active);
            Assert.AreEqual(1024, txStream.MTU);

            txStream.Activate(streamFlags, timeNs, numElems);
            Assert.True(txStream.Active);

            T[] buff = new T[numElems];
            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Write(buff, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Deactivate(streamFlags, timeNs));
            Assert.False(txStream.Active);
            txStream.Close();

            //
            // Test with multiple channels
            //

            txStream = device.SetupTxStream<T>(twoChannels, streamArgs);
            Assert.AreEqual(SoapySDR.Utility.GetFormatString<T>(), txStream.Format);
            Assert.AreEqual(twoChannels, txStream.Channels);
            Assert.AreEqual(streamArgs, txStream.StreamArgs);
            Assert.False(txStream.Active);
            Assert.AreEqual(1024, txStream.MTU);

            txStream.Activate(streamFlags, timeNs, numElems);
            Assert.True(txStream.Active);

            T[][] buffs = new T[twoChannels.Length][];
            buffs[0] = new T[numElems];
            buffs[1] = new T[numElems];

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Write(buffs, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Deactivate(streamFlags, timeNs));
            Assert.False(txStream.Active);
            txStream.Close();
        }

        public void TestComplexTxStreaming()
        {
            var device = GetTestDevice();
            SoapySDR.StreamResult streamResult;

            GetStreamTestParams(
                out uint[] oneChannel,
                out uint[] twoChannels,
                out Dictionary<string, string> streamArgs,
                out SoapySDR.StreamFlags streamFlags,
                out long timeNs,
                out int timeoutUs,
                out uint numElems);

            //
            // Test with single channel
            //

            var txStream = device.SetupComplexTxStream<T>(oneChannel, streamArgs);
            Assert.AreEqual(SoapySDR.Utility.GetComplexFormatString<T>(), txStream.Format);
            Assert.AreEqual(oneChannel, txStream.Channels);
            Assert.AreEqual(streamArgs, txStream.StreamArgs);
            Assert.False(txStream.Active);
            Assert.AreEqual(1024, txStream.MTU);

            txStream.Activate(streamFlags, timeNs, numElems);
            Assert.True(txStream.Active);

            T[] buff = new T[numElems * 2];
            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Write(buff, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Deactivate());
            Assert.False(txStream.Active);
            txStream.Close();

            //
            // Test with multiple channels
            //

            txStream = device.SetupComplexTxStream<T>(twoChannels, streamArgs);
            Assert.AreEqual(SoapySDR.Utility.GetComplexFormatString<T>(), txStream.Format);
            Assert.AreEqual(twoChannels, txStream.Channels);
            Assert.AreEqual(streamArgs, txStream.StreamArgs);
            Assert.False(txStream.Active);
            Assert.AreEqual(1024, txStream.MTU);

            txStream.Activate(streamFlags, timeNs, numElems);
            Assert.True(txStream.Active);

            T[][] buffs = new T[twoChannels.Length][];
            buffs[0] = new T[numElems * 2];
            buffs[1] = new T[numElems * 2];

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Write(buffs, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, txStream.Deactivate());
            Assert.False(txStream.Active);
            txStream.Close();
        }
        public void TestRxStreaming()
        {
            var device = GetTestDevice();
            SoapySDR.StreamResult streamResult;

            GetStreamTestParams(
                out uint[] oneChannel,
                out uint[] twoChannels,
                out Dictionary<string, string> streamArgs,
                out SoapySDR.StreamFlags streamFlags,
                out long timeNs,
                out int timeoutUs,
                out uint numElems);

            //
            // Test with single channel
            //

            var rxStream = device.SetupRxStream<T>(oneChannel, streamArgs);
            Assert.AreEqual(SoapySDR.Utility.GetFormatString<T>(), rxStream.Format);
            Assert.AreEqual(oneChannel, rxStream.Channels);
            Assert.AreEqual(streamArgs, rxStream.StreamArgs);
            Assert.False(rxStream.Active);
            Assert.AreEqual(1024, rxStream.MTU);

            rxStream.Activate(streamFlags, timeNs, numElems);
            Assert.True(rxStream.Active);

            T[] buff = new T[numElems];
            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Read(ref buff, streamFlags, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Deactivate(streamFlags, timeNs));
            Assert.False(rxStream.Active);
            rxStream.Close();

            //
            // Test with multiple channels
            //

            rxStream = device.SetupRxStream<T>(twoChannels, streamArgs);
            Assert.AreEqual(SoapySDR.Utility.GetFormatString<T>(), rxStream.Format);
            Assert.AreEqual(twoChannels, rxStream.Channels);
            Assert.AreEqual(streamArgs, rxStream.StreamArgs);
            Assert.False(rxStream.Active);
            Assert.AreEqual(1024, rxStream.MTU);

            rxStream.Activate(streamFlags, timeNs, numElems);
            Assert.True(rxStream.Active);

            T[][] buffs = new T[twoChannels.Length][];
            buffs[0] = new T[numElems];
            buffs[1] = new T[numElems];

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Read(ref buffs, streamFlags, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Deactivate(streamFlags, timeNs));
            Assert.False(rxStream.Active);
            rxStream.Close();
        }

        public void TestComplexRxStreaming()
        {
            var device = GetTestDevice();
            SoapySDR.StreamResult streamResult;

            GetStreamTestParams(
                out uint[] oneChannel,
                out uint[] twoChannels,
                out Dictionary<string, string> streamArgs,
                out SoapySDR.StreamFlags streamFlags,
                out long timeNs,
                out int timeoutUs,
                out uint numElems);

            //
            // Test with single channel
            //

            var rxStream = device.SetupComplexRxStream<T>(oneChannel, streamArgs);
            Assert.AreEqual(SoapySDR.Utility.GetFormatString<T>(), rxStream.Format);
            Assert.AreEqual(oneChannel, rxStream.Channels);
            Assert.AreEqual(streamArgs, rxStream.StreamArgs);
            Assert.False(rxStream.Active);
            Assert.AreEqual(1024, rxStream.MTU);

            rxStream.Activate(streamFlags, timeNs, numElems);
            Assert.True(rxStream.Active);

            T[] buff = new T[numElems * 2];
            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Read(ref buff, streamFlags, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Deactivate(streamFlags, timeNs));
            Assert.False(rxStream.Active);
            rxStream.Close();

            //
            // Test with multiple channels
            //

            rxStream = device.SetupComplexRxStream<T>(twoChannels, streamArgs);
            Assert.AreEqual(SoapySDR.Utility.GetFormatString<T>(), rxStream.Format);
            Assert.AreEqual(twoChannels, rxStream.Channels);
            Assert.AreEqual(streamArgs, rxStream.StreamArgs);
            Assert.False(rxStream.Active);
            Assert.AreEqual(1024, rxStream.MTU);

            rxStream.Activate(streamFlags, timeNs, numElems);
            Assert.True(rxStream.Active);

            T[][] buffs = new T[twoChannels.Length][];
            buffs[0] = new T[numElems * 2];
            buffs[1] = new T[numElems * 2];

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Read(ref buffs, streamFlags, timeNs, timeoutUs, out streamResult));
            Assert.AreEqual(0, streamResult.NumSamples);
            Assert.AreEqual(streamFlags, streamResult.Flags);

            Assert.AreEqual(SoapySDR.ErrorCode.NotSupported, rxStream.Deactivate(streamFlags, timeNs));
            Assert.False(rxStream.Active);
            rxStream.Close();
        }
    }

    //
    // Generic test factories
    //

    public static IEnumerable<IGenericStreamingTestCase> TestCases()
    {
        yield return new GenericStreamingTestCase<sbyte>();
        yield return new GenericStreamingTestCase<short>();
        yield return new GenericStreamingTestCase<int>();
        yield return new GenericStreamingTestCase<byte>();
        yield return new GenericStreamingTestCase<ushort>();
        yield return new GenericStreamingTestCase<uint>();
        yield return new GenericStreamingTestCase<float>();
        yield return new GenericStreamingTestCase<double>();
    }

    [Test]
    [TestCaseSource("TestCases")]
    public void TestTxStreaming(IGenericStreamingTestCase testCase)
    {
        testCase.TestTxStreaming();
    }

    [Test]
    [TestCaseSource("TestCases")]
    public void TestComplexTxStreaming(IGenericStreamingTestCase testCase)
    {
        testCase.TestComplexTxStreaming();
    }

    [Test]
    [TestCaseSource("TestCases")]
    public void TestRxStreaming(IGenericStreamingTestCase testCase)
    {
        testCase.TestRxStreaming();
    }

    [Test]
    [TestCaseSource("TestCases")]
    public void TestComplexRxStreaming(IGenericStreamingTestCase testCase)
    {
        testCase.TestComplexRxStreaming();
    }
}