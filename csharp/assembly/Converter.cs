// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

using System;
using System.Buffers;
using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace SoapySDR
{
    public class Converter
    {
        public static List<string> ListTargetFormats(string sourceFormat) => new List<string>(ConverterInternal.ListTargetFormats(sourceFormat));

        public static List<string> ListTargetFormats<T>() where T : unmanaged
            => ListTargetFormats(Utility.GetFormatString<T>());

        public static List<string> ListComplexTargetFormats<T>() where T : unmanaged
            => ListTargetFormats(Utility.GetComplexFormatString<T>());

        public static List<string> ListSourceFormats(string targetFormat) => new List<string>(ConverterInternal.ListSourceFormats(targetFormat));

        public static List<string> ListSourceFormats<T>() where T : unmanaged
            => ListSourceFormats(Utility.GetFormatString<T>());

        public static List<string> ListComplexSourceFormats<T>() where T : unmanaged
            => ListSourceFormats(Utility.GetComplexFormatString<T>());

        public static List<ConverterFunctionPriority> ListPriorities(string sourceFormat, string targetFormat)
            => new List<ConverterFunctionPriority>(ConverterInternal.ListPriorities(sourceFormat, targetFormat));

        public static List<ConverterFunctionPriority> ListPriorities<SrcT, DstT>() where SrcT : unmanaged where DstT : unmanaged
            => ListPriorities(Utility.GetFormatString<SrcT>(), Utility.GetFormatString<DstT>());

        public static List<ConverterFunctionPriority> ListComplexPriorities<SrcT, DstT>() where SrcT : unmanaged where DstT : unmanaged
            => ListPriorities(Utility.GetComplexFormatString<SrcT>(), Utility.GetComplexFormatString<DstT>());

        public List<string> AvailableSourceFormats => new List<string>(ConverterInternal.ListAvailableSourceFormats());

        public unsafe static void Convert<SrcT,DstT>(
            ReadOnlySpan<SrcT> source,
            Span<DstT> dest,
            double scalar = 1.0) where SrcT : unmanaged where DstT : unmanaged
        {
            var priorities = ListPriorities<SrcT, DstT>();
            var priority = priorities[priorities.Count - 1];

            Convert(source, dest, priority, scalar);
        }

        public unsafe static void Convert<SrcT, DstT>(
            ReadOnlySpan<SrcT> source,
            Span<DstT> dest,
            ConverterFunctionPriority priority,
            double scalar = 1.0) where SrcT : unmanaged where DstT : unmanaged
        {
            if (source.Length != dest.Length) throw new ArgumentOutOfRangeException("Source and destination must be the same length");

            fixed (SrcT* sourceBuffer = &MemoryMarshal.GetReference(source))
            {
                fixed (DstT* destBuffer = &MemoryMarshal.GetReference(dest))
                {
                    ConverterInternal.Convert(
                        Utility.GetFormatString<SrcT>(),
                        Utility.GetFormatString<DstT>(),
                        priority,
#if _64BIT
                        (ulong)(void*)sourceBuffer,
                        (ulong)(void*)destBuffer,
#else
                        (uint)(void*)sourceBuffer,
                        (uint)(void*)destBuffer,
#endif
                        (uint)source.Length,
                        scalar);
                }
            }
        }

        public unsafe static void ComplexConvert<SrcT, DstT>(
            ReadOnlySpan<SrcT> source,
            Span<DstT> dest,
            double scalar = 1.0) where SrcT : unmanaged where DstT : unmanaged
        {
            var priorities = ListComplexPriorities<SrcT, DstT>();
            var priority = priorities[priorities.Count - 1];

            ComplexConvert(source, dest, priority, scalar);
        }

        public unsafe static void ComplexConvert<SrcT, DstT>(
            ReadOnlySpan<SrcT> source,
            Span<DstT> dest,
            ConverterFunctionPriority priority,
            double scalar = 1.0) where SrcT : unmanaged where DstT : unmanaged
        {
            if (source.Length != dest.Length) throw new ArgumentOutOfRangeException("Source and destination must be the same length");
            if ((source.Length % 2) == 1) throw new ArgumentOutOfRangeException("Complex interleaved buffers must be of even size");

            fixed (SrcT* sourceBuffer = &MemoryMarshal.GetReference(source))
            {
                fixed (DstT* destBuffer = &MemoryMarshal.GetReference(dest))
                {
                    ConverterInternal.Convert(
                        Utility.GetComplexFormatString<SrcT>(),
                        Utility.GetComplexFormatString<DstT>(),
                        priority,
#if _64BIT
                        (ulong)(void*)sourceBuffer,
                        (ulong)(void*)destBuffer,
#else
                        (uint)(void*)sourceBuffer,
                        (uint)(void*)destBuffer,
#endif
                        (uint)(source.Length / 2),
                        scalar);
                }
            }
        }

        public unsafe static void Convert<SrcT, DstT>(
            SrcT[] source,
            ref DstT[] dest,
            double scalar = 1.0) where SrcT : unmanaged where DstT : unmanaged
        {
            Convert(new ReadOnlySpan<SrcT>(source), new Span<DstT>(dest), scalar);
        }

        public unsafe static void Convert<SrcT, DstT>(
            SrcT[] source,
            ref DstT[] dest,
            ConverterFunctionPriority priority,
            double scalar = 1.0) where SrcT : unmanaged where DstT : unmanaged
        {
            Convert(new ReadOnlySpan<SrcT>(source), new Span<DstT>(dest), priority, scalar);
        }

        public unsafe static void ComplexConvert<SrcT, DstT>(
            SrcT[] source,
            ref DstT[] dest,
            double scalar = 1.0) where SrcT : unmanaged where DstT : unmanaged
        {
            ComplexConvert(new ReadOnlySpan<SrcT>(source), new Span<DstT>(dest), scalar);
        }

        public unsafe static void ComplexConvert<SrcT, DstT>(
            SrcT[] source,
            ref DstT[] dest,
            ConverterFunctionPriority priority,
            double scalar = 1.0) where SrcT : unmanaged where DstT : unmanaged
        {
            ComplexConvert(new ReadOnlySpan<SrcT>(source), new Span<DstT>(dest), priority, scalar);
        }

        public unsafe static void Convert(
            string sourceFormat,
            string destFormat,
            IntPtr source,
            IntPtr dest,
            uint numElems,
            double scalar = 1.0)
        {
            var priorities = ListPriorities(sourceFormat, destFormat);
            var priority = priorities[priorities.Count - 1];

            Convert(sourceFormat, destFormat, source, dest, priority, numElems, scalar);
        }

        public unsafe static void Convert(
            string sourceFormat,
            string destFormat,
            IntPtr source,
            IntPtr dest,
            ConverterFunctionPriority priority,
            uint numElems,
            double scalar = 1.0)
        {
            ConverterInternal.Convert(
                sourceFormat,
                destFormat,
                priority,
#if _64BIT
                (ulong)(void*)source,
                (ulong)(void*)dest,
#else
                (uint)(void*)source,
                (uint)(void*)dest,
#endif
                numElems,
                scalar);
        }
    }
}