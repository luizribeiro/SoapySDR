// Copyright (c) 2020-2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

using System;
using System.Collections.Generic;

namespace SoapySDR
{
    /// <summary>
    /// The base class for representing transmit or receive streams. This class will never be used
    /// itself. See SoapySDR.TxStream and SoapySDR.RxStream.
    /// </summary>
    public class Stream
    {
        internal Device _device = null;
        internal StreamHandle _streamHandle = null;
        protected bool _active = false;

        /// <summary>
        /// The underlying stream format. See SoapySDR.StreamFormat.
        /// </summary>
        public string Format { get; }

        /// <summary>
        /// The device channels used in this stream.
        /// </summary>
        public uint[] Channels { get; }

        /// <summary>
        /// The arguments used in creating this stream.
        /// </summary>
        public Kwargs StreamArgs { get; }

        /// <summary>
        /// Whether or not the stream is active.
        /// </summary>
        public bool Active { get { return _active; } }

        // We already used these parameters to create the stream,
        // this is just for the sake of getters.
        internal Stream(
            Device device,
            string format,
            uint[] channels,
            Kwargs kwargs)
        {
            _device = device;

            Format = format;
            Channels = channels;
            StreamArgs = kwargs;
        }

        /*
        ~Stream()
        {
            if(_active)               Deactivate();
            if(_streamHandle != null) Close();
        }
        */

        /// <summary>
        /// The number of elements per channel this stream can handle in a single read/write call.
        /// </summary>
        public ulong MTU => _device.GetStreamMTUInternal(_streamHandle);

        /// <summary>
        /// Activate the stream to prepare it for read/write operations.
        /// </summary>
        /// <param name="flags">Optional stream flags.</param>
        /// <param name="timeNs">Optional activation time in nanoseconds. Only valid when flags includes SoapySDR.StreamFlags.HasTime.</param>
        /// <param name="numElems">Optional element count for burst control.</param>
        /// <returns>An error code for the stream activation.</returns>
        public ErrorCode Activate(
            StreamFlags flags = StreamFlags.None,
            long timeNs = 0,
            uint numElems = 0)
        {
            ErrorCode ret;
            if(_streamHandle != null)
            {
                if(!_active)
                {
                    ret = _device.ActivateStreamInternal(
                        _streamHandle,
                        flags,
                        timeNs,
                        numElems);

                    if (ret == ErrorCode.None) _active = true;
                }
                else throw new InvalidOperationException("Stream is already active");
            }
            else throw new InvalidOperationException("Stream is closed");

            return ret;
        }

        /// <summary>
        /// Deactivate the stream to end read/write operations.
        /// </summary>
        /// <param name="flags">Optional stream flags.</param>
        /// <param name="timeNs">Optional activation time in nanoseconds. Only valid when flags includes SoapySDR.StreamFlags.HasTime.</param>
        /// <param name="numElems">Optional element count for burst control.</param>
        /// <returns>An error code for the stream deactivation.</returns>
        public ErrorCode Deactivate(
            StreamFlags flags = StreamFlags.None,
            long timeNs = 0)
        {
            ErrorCode ret;
            if(_streamHandle != null)
            {
                if(!_active)
                {
                    ret = _device.DeactivateStreamInternal(
                        _streamHandle,
                        flags,
                        timeNs);

                    if(ret == ErrorCode.None) _active = true;
                }
                else throw new InvalidOperationException("Stream is already inactive");
            }
            else throw new InvalidOperationException("Stream is closed");

            return ret;
        }

        /// <summary>
        /// Close the underlying stream.
        /// </summary>
        public void Close()
        {
            if(_streamHandle != null) _device.CloseStreamInternal(_streamHandle);
            else throw new InvalidOperationException("Stream is already closed");
        }

        //
        // Utility
        //

        protected void ValidateIntPtrArray(IntPtr[] intPtrs)
        {
            var numChannels = _streamHandle.GetChannels().Length;
            if(intPtrs.Length != numChannels)
            {
                throw new ArgumentException(string.Format("Expected {0} channels. Found {1} buffers.", numChannels, intPtrs.Length));
            }
        }

        //
        // Object overrides
        //

        // For completeness, but a stream is only ever equal to itself
        public override bool Equals(object other) => ReferenceEquals(this, other);

        public override int GetHashCode() => GetType().GetHashCode() ^ (_streamHandle?.GetHashCode() ?? 0);
    }
}
