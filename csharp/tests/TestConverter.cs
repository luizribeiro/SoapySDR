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
            const uint numElems = 256;

            var input = new SrcT[numElems];
            var intermediate = new DstT[numElems];
            var output = new SrcT[numElems];

            //
            // Test the different overloads (TODO: with priority)
            //

            SoapySDR.Converter.Convert(input, ref intermediate, _scalar);
            SoapySDR.Converter.Convert(intermediate, ref output, (1.0 / _scalar));

            SoapySDR.Converter.Convert(new ReadOnlySpan<SrcT>(input), new Span<DstT>(intermediate), _scalar);
            SoapySDR.Converter.Convert(new ReadOnlySpan<DstT>(intermediate), new Span<SrcT>(output), (1.0 / _scalar));

            // TODO: raw unsafe memory
            fixed (SrcT* inputBuffer = &MemoryMarshal.GetReference(new Span<SrcT>(input)))
            {
                fixed (DstT* intermediateBuffer = &MemoryMarshal.GetReference(new Span<DstT>(intermediate)))
                {
                    fixed (SrcT* outputBuffer = &MemoryMarshal.GetReference(new Span<SrcT>(output)))
                    {
                        SoapySDR.Converter.Convert(
                            SoapySDR.Utility.GetFormatString<SrcT>(),
                            SoapySDR.Utility.GetFormatString<DstT>(),
                            (IntPtr)inputBuffer,
                            (IntPtr)intermediateBuffer,
                            numElems,
                            _scalar);

                        SoapySDR.Converter.Convert(
                            SoapySDR.Utility.GetFormatString<DstT>(),
                            SoapySDR.Utility.GetFormatString<SrcT>(),
                            (IntPtr)intermediateBuffer,
                            (IntPtr)outputBuffer,
                            numElems,
                            _scalar);

                        // TODO: check values
                    }
                }
            }
        }

        public void TestComplexConverter()
        {
            // TODO
        }

        private double _scalar = 1.0;
    }

    //
    // Generic test factories
    //

    public static IEnumerable<IGenericConverterTestCase> TestCases()
    {
        // All covered by generic
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