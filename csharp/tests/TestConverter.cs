// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;

[TestFixture]
public class TestConverter
{
    //
    // Generic test interface
    //

    public interface IGenericConverterTestCase
    {
        void TestScalarConverter();

        void TestComplexConverter();
    }

    //
    // Generic test implementation
    //

    public unsafe class GenericConverterTestCase<SrcT,DstT> : IGenericConverterTestCase where SrcT : unmanaged where DstT : unmanaged
    {
        public GenericConverterTestCase(double scalar = 1.0) => _scalar = scalar;

        public void TestScalarConverter()
        {
            const int numElems = 256;

            var inputArr = new SrcT[numElems];
            var intermediateArr = new DstT[numElems];
            var outputArr = new SrcT[numElems];

            //
            // Test C# arrays
            //

            SoapySDR.Converter.Convert(
                inputArr,
                ref intermediateArr,
                SoapySDR.ConverterFunctionPriority.Generic,
                _scalar);
            SoapySDR.Converter.Convert(
                intermediateArr,
                ref outputArr,
                SoapySDR.ConverterFunctionPriority.Generic,
                (1.0 / _scalar));

            SoapySDR.Converter.Convert(
                inputArr,
                ref intermediateArr,
                SoapySDR.ConverterFunctionPriority.Generic,
                _scalar);
            SoapySDR.Converter.Convert(
                intermediateArr,
                ref outputArr,
                SoapySDR.ConverterFunctionPriority.Generic,
                (1.0 / _scalar));

            //
            // Test spans from C# arrays
            //

            SoapySDR.Converter.Convert(
                new ReadOnlySpan<SrcT>(inputArr),
                new Span<DstT>(intermediateArr),
                _scalar);
            SoapySDR.Converter.Convert(
                new ReadOnlySpan<DstT>(intermediateArr),
                new Span<SrcT>(outputArr),
                (1.0 / _scalar));

            SoapySDR.Converter.Convert(
                new ReadOnlySpan<SrcT>(inputArr),
                new Span<DstT>(intermediateArr),
                SoapySDR.ConverterFunctionPriority.Generic,
                _scalar);
            SoapySDR.Converter.Convert(
                new ReadOnlySpan<DstT>(intermediateArr),
                new Span<SrcT>(outputArr),
                SoapySDR.ConverterFunctionPriority.Generic,
                (1.0 / _scalar));

            //
            // Test raw stackallocs
            //

            SrcT* inputStackAlloc = stackalloc SrcT[numElems];
            DstT* intermediateStackAlloc = stackalloc DstT[numElems];
            SrcT* outputStackAlloc = stackalloc SrcT[numElems];

            SoapySDR.Converter.Convert(
                new ReadOnlySpan<SrcT>(inputStackAlloc, numElems),
                new Span<DstT>(intermediateStackAlloc, numElems),
                _scalar);
            SoapySDR.Converter.Convert(
                new ReadOnlySpan<DstT>(intermediateStackAlloc, numElems),
                new Span<SrcT>(outputStackAlloc, numElems),
                (1.0 / _scalar));

            SoapySDR.Converter.Convert(
                new ReadOnlySpan<SrcT>(inputStackAlloc, numElems),
                new Span<DstT>(intermediateStackAlloc, numElems),
                SoapySDR.ConverterFunctionPriority.Generic,
                _scalar);
            SoapySDR.Converter.Convert(
                new ReadOnlySpan<DstT>(intermediateStackAlloc, numElems),
                new Span<SrcT>(outputStackAlloc, numElems),
                SoapySDR.ConverterFunctionPriority.Generic,
                (1.0 / _scalar));

            //
            // Test unmanaged allocations
            //

            IntPtr inputRawAlloc = Marshal.AllocHGlobal(numElems * sizeof(SrcT));
            IntPtr intermediateRawAlloc = Marshal.AllocHGlobal(numElems * sizeof(DstT));
            IntPtr outputRawAlloc = Marshal.AllocHGlobal(numElems * sizeof(SrcT));

            SoapySDR.Converter.Convert(
                SoapySDR.Utility.GetFormatString<SrcT>(),
                SoapySDR.Utility.GetFormatString<DstT>(),
                inputRawAlloc,
                intermediateRawAlloc,
                numElems,
                _scalar);
            SoapySDR.Converter.Convert(
                SoapySDR.Utility.GetFormatString<DstT>(),
                SoapySDR.Utility.GetFormatString<SrcT>(),
                intermediateRawAlloc,
                outputRawAlloc,
                numElems,
                _scalar);

            SoapySDR.Converter.Convert(
                SoapySDR.Utility.GetFormatString<SrcT>(),
                SoapySDR.Utility.GetFormatString<DstT>(),
                inputRawAlloc,
                intermediateRawAlloc,
                SoapySDR.ConverterFunctionPriority.Generic,
                numElems,
                _scalar);
            SoapySDR.Converter.Convert(
                SoapySDR.Utility.GetFormatString<DstT>(),
                SoapySDR.Utility.GetFormatString<SrcT>(),
                intermediateRawAlloc,
                outputRawAlloc,
                SoapySDR.ConverterFunctionPriority.Generic,
                numElems,
                _scalar);

            Marshal.FreeHGlobal(outputRawAlloc);
            Marshal.FreeHGlobal(intermediateRawAlloc);
            Marshal.FreeHGlobal(inputRawAlloc);
        }

        public void TestComplexConverter()
        {
            const int numElems = 256;

            var inputArr = new SrcT[numElems * 2];
            var intermediateArr = new DstT[numElems * 2];
            var outputArr = new SrcT[numElems * 2];

            //
            // Test C# arrays
            //

            SoapySDR.Converter.ComplexConvert(
                inputArr,
                ref intermediateArr,
                SoapySDR.ConverterFunctionPriority.Generic,
                _scalar);
            SoapySDR.Converter.ComplexConvert(
                intermediateArr,
                ref outputArr,
                SoapySDR.ConverterFunctionPriority.Generic,
                (1.0 / _scalar));

            SoapySDR.Converter.ComplexConvert(
                inputArr,
                ref intermediateArr,
                SoapySDR.ConverterFunctionPriority.Generic,
                _scalar);
            SoapySDR.Converter.ComplexConvert(
                intermediateArr,
                ref outputArr,
                SoapySDR.ConverterFunctionPriority.Generic,
                (1.0 / _scalar));

            //
            // Test spans from C# arrays
            //

            SoapySDR.Converter.ComplexConvert(
                new ReadOnlySpan<SrcT>(inputArr),
                new Span<DstT>(intermediateArr),
                _scalar);
            SoapySDR.Converter.ComplexConvert(
                new ReadOnlySpan<DstT>(intermediateArr),
                new Span<SrcT>(outputArr),
                (1.0 / _scalar));

            SoapySDR.Converter.ComplexConvert(
                new ReadOnlySpan<SrcT>(inputArr),
                new Span<DstT>(intermediateArr),
                SoapySDR.ConverterFunctionPriority.Generic,
                _scalar);
            SoapySDR.Converter.ComplexConvert(
                new ReadOnlySpan<DstT>(intermediateArr),
                new Span<SrcT>(outputArr),
                SoapySDR.ConverterFunctionPriority.Generic,
                (1.0 / _scalar));

            //
            // Test raw stackallocs
            //

            SrcT* inputStackAlloc = stackalloc SrcT[numElems * 2];
            DstT* intermediateStackAlloc = stackalloc DstT[numElems * 2];
            SrcT* outputStackAlloc = stackalloc SrcT[numElems * 2];

            SoapySDR.Converter.ComplexConvert(
                new ReadOnlySpan<SrcT>(inputStackAlloc, numElems),
                new Span<DstT>(intermediateStackAlloc, numElems),
                _scalar);
            SoapySDR.Converter.ComplexConvert(
                new ReadOnlySpan<DstT>(intermediateStackAlloc, numElems),
                new Span<SrcT>(outputStackAlloc, numElems),
                (1.0 / _scalar));

            SoapySDR.Converter.ComplexConvert(
                new ReadOnlySpan<SrcT>(inputStackAlloc, numElems),
                new Span<DstT>(intermediateStackAlloc, numElems),
                SoapySDR.ConverterFunctionPriority.Generic,
                _scalar);
            SoapySDR.Converter.ComplexConvert(
                new ReadOnlySpan<DstT>(intermediateStackAlloc, numElems),
                new Span<SrcT>(outputStackAlloc, numElems),
                SoapySDR.ConverterFunctionPriority.Generic,
                (1.0 / _scalar));

            //
            // Test unmanaged allocations
            //

            IntPtr inputRawAlloc = Marshal.AllocHGlobal(numElems * sizeof(SrcT) * 2);
            IntPtr intermediateRawAlloc = Marshal.AllocHGlobal(numElems * sizeof(DstT) * 2);
            IntPtr outputRawAlloc = Marshal.AllocHGlobal(numElems * sizeof(SrcT) * 2);

            SoapySDR.Converter.Convert(
                SoapySDR.Utility.GetComplexFormatString<SrcT>(),
                SoapySDR.Utility.GetComplexFormatString<DstT>(),
                inputRawAlloc,
                intermediateRawAlloc,
                numElems,
                _scalar);
            SoapySDR.Converter.Convert(
                SoapySDR.Utility.GetComplexFormatString<DstT>(),
                SoapySDR.Utility.GetComplexFormatString<SrcT>(),
                intermediateRawAlloc,
                outputRawAlloc,
                numElems,
                _scalar);

            SoapySDR.Converter.Convert(
                SoapySDR.Utility.GetComplexFormatString<SrcT>(),
                SoapySDR.Utility.GetComplexFormatString<DstT>(),
                inputRawAlloc,
                intermediateRawAlloc,
                SoapySDR.ConverterFunctionPriority.Generic,
                numElems,
                _scalar);
            SoapySDR.Converter.Convert(
                SoapySDR.Utility.GetComplexFormatString<DstT>(),
                SoapySDR.Utility.GetComplexFormatString<SrcT>(),
                intermediateRawAlloc,
                outputRawAlloc,
                SoapySDR.ConverterFunctionPriority.Generic,
                numElems,
                _scalar);

            Marshal.FreeHGlobal(outputRawAlloc);
            Marshal.FreeHGlobal(intermediateRawAlloc);
            Marshal.FreeHGlobal(inputRawAlloc);
        }

        private double _scalar = 1.0;
    }

    //
    // Generic test factories
    //

    public static IEnumerable<IGenericConverterTestCase> TestCases()
    {
        // All covered by generic converters
        yield return new GenericConverterTestCase<float, float>();
        yield return new GenericConverterTestCase<int, int>();
        yield return new GenericConverterTestCase<short, short>();
        yield return new GenericConverterTestCase<sbyte, sbyte>();
        yield return new GenericConverterTestCase<float, short>(1 << 15);
        yield return new GenericConverterTestCase<float, ushort>();
        yield return new GenericConverterTestCase<float, sbyte>(1 << 7);
        yield return new GenericConverterTestCase<float, byte>();
        yield return new GenericConverterTestCase<short, ushort>();
        yield return new GenericConverterTestCase<short, sbyte>();
        yield return new GenericConverterTestCase<short, byte>();
        yield return new GenericConverterTestCase<sbyte, byte>();
    }

    [Test]
    [TestCaseSource("TestCases")]
    public void TestScalarConverter(IGenericConverterTestCase testCase)
    {
        testCase.TestScalarConverter();
    }

    [Test]
    [TestCaseSource("TestCases")]
    public void TestComplexConverter(IGenericConverterTestCase testCase)
    {
        testCase.TestComplexConverter();
    }

    public static int Main(string[] args) => TestRunner.RunNUnitTest("TestConverter");
}