// Copyright (c) 2020-2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

using System;
using System.Buffers;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;

namespace SoapySDR
{
    /// <summary>
    /// Utility functions to generate SoapySDR.Device parameters
    /// </summary>
    public class Utility
    {
        //
        // Public
        //

        /// <summary>
        /// Return the SoapySDR format string that corresponds to the given type. This
        /// string will be passed into Device's stream setup functions.
        ///
        /// This function will throw if the type is unsupported.
        /// </summary>
        /// <typeparam name="T">The format type</typeparam>
        /// <returns>The type's format string (see SoapySDR.StreamFormat)</returns>
        public static string GetFormatString<T>() where T : unmanaged
        {
            var type = typeof(T);

            if (typeof(T).Equals(typeof(sbyte))) return StreamFormat.Int8;
            else if (typeof(T).Equals(typeof(short))) return StreamFormat.Int16;
            else if (typeof(T).Equals(typeof(int))) return StreamFormat.Int32;
            else if (typeof(T).Equals(typeof(byte))) return StreamFormat.UInt8;
            else if (typeof(T).Equals(typeof(ushort))) return StreamFormat.UInt16;
            else if (typeof(T).Equals(typeof(uint))) return StreamFormat.UInt32;
            else if (typeof(T).Equals(typeof(float))) return StreamFormat.Float32;
            else if (typeof(T).Equals(typeof(double))) return StreamFormat.Float64;
            else throw new Exception(string.Format("Type {0} not covered by GetFormatString", type));
        }

        /// <summary>
        /// Return the SoapySDR complex format string that corresponds to the given type.
        /// This string will be passed into Device's stream setup functions.
        ///
        /// This function will throw if the type is unsupported.
        /// </summary>
        /// <typeparam name="T">The format type</typeparam>
        /// <returns>The type's complex format string (see SoapySDR.StreamFormat)</returns>
        public static string GetComplexFormatString<T>() where T : unmanaged
        {
            var type = typeof(T);

            if (typeof(T).Equals(typeof(sbyte))) return StreamFormat.ComplexInt8;
            else if (typeof(T).Equals(typeof(short))) return StreamFormat.ComplexInt16;
            else if (typeof(T).Equals(typeof(int))) return StreamFormat.ComplexInt32;
            else if (typeof(T).Equals(typeof(byte))) return StreamFormat.ComplexUInt8;
            else if (typeof(T).Equals(typeof(ushort))) return StreamFormat.ComplexUInt16;
            else if (typeof(T).Equals(typeof(uint))) return StreamFormat.ComplexUInt32;
            else if (typeof(T).Equals(typeof(float))) return StreamFormat.ComplexFloat32;
            else if (typeof(T).Equals(typeof(double))) return StreamFormat.ComplexFloat64;
            else throw new Exception(string.Format("Type {0} not covered by GetComplexFormatString", type));
        }

        /// <summary>
        /// Convert a markup string to a key-value map.
        ///
        /// The markup format is: "key0=value0, key1=value1".
        /// </summary>
        /// <param name="args">The markup string</param>
        /// <returns>An equivalent key-value map</returns>
        public static Kwargs StringToKwargs(string args) => TypeConversionInternal.StringToKwargs(args);

        /// <summary>
        /// Convert a key-value map to a markup string.
        ///
        /// The markup format is: "key0=value0, key1=value1".
        /// </summary>
        /// <param name="kwargs">The key-value map</param>
        /// <returns>An equivalent markup string</returns>
        public static string KwargsToString(IDictionary<string, string> kwargs) => TypeConversionInternal.KwargsToString(ToKwargs(kwargs));

        //
        // Internal
        //

        internal static unsafe void ManagedArraysToSizeListInternal<T>(
            T[][] buffs,
            out GCHandle[] handles,
            out SizeListInternal sizeList)
        {
            handles = new GCHandle[buffs.Length];
            sizeList = new SizeListInternal();

            for(int buffIndex = 0; buffIndex < buffs.Length; ++buffIndex)
            {
                handles[buffIndex] = GCHandle.Alloc(
                    buffs[buffIndex],
                    System.Runtime.InteropServices.GCHandleType.Pinned);

                var uptr = (UIntPtr)(void*)handles[buffIndex].AddrOfPinnedObject();
#if _64BIT
                sizeList.Add((ulong)uptr);
#else
                sizeList.Add((uint)uptr);
#endif
            }
        }

        internal static Kwargs ToKwargs(IDictionary<string, string> input)
        {
            if (input is Kwargs) return (Kwargs)input;

            Kwargs kwargs;

            var output = new Kwargs();
            foreach(var pair in input)
            {
                output.Add(pair.Key, pair.Value);
            }

            return output;
        }

        internal unsafe static SizeListInternal ToSizeListInternal<T>(
            Memory<T>[] memory,
            out MemoryHandle[] memoryHandles)
        {
            memoryHandles = memory.Select(mem => mem.Pin()).ToArray();
            return ToSizeListInternal(memoryHandles.Select(handle => (UIntPtr)handle.Pointer).ToArray());
        }

        internal unsafe static SizeListInternal ToSizeListInternal<T>(
            ReadOnlyMemory<T>[] memory,
            out MemoryHandle[] memoryHandles)
        {
            memoryHandles = memory.Select(mem => mem.Pin()).ToArray();
            return ToSizeListInternal(memoryHandles.Select(handle => (UIntPtr)handle.Pointer).ToArray());
        }

#if _64BIT
        internal static SizeListInternal ToSizeListInternal(UIntPtr[] arr) => new SizeListInternal(arr.Select(x => (ulong)x));

        internal unsafe static SizeListInternal ToSizeListInternal(IntPtr[] arr) => new SizeListInternal(arr.Select(x => (ulong)(UIntPtr)(void*)x));
#else
        internal static SizeListInternal ToSizeListInternal(UIntPtr[] arr) => new SizeListInternal(arr.Select(x => (uint)x));

        internal unsafe static SizeListInternal ToSizeListInternal(IntPtr[] arr) => new SizeListInternal(arr.Select(x => (uint)(UIntPtr)(void*)x));
#endif
    }
}
