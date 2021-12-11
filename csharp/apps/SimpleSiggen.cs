// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

using System;
using System.CommandLine;
using System.Linq;
using System.Threading.Tasks;

public class SimpleSiggen
{
    // https://stackoverflow.com/a/67131017
    private static float[] LinSpace(float startval, float endval, int steps)
    {
        float interval = (endval / Math.Abs(endval)) * Math.Abs(endval - startval) / (steps - 1);
        return (from val in Enumerable.Range(0, steps)
                select startval + (val * interval)).ToArray();
    }

    private static float[] MakeSamples(float ampl, float[] phases)
    {
        var samps = new float[phases.Length * 2]; // Complex interleaved
        for(var i = 0; i < phases.Length; ++i)
        {
            var complex = new System.Numerics.Complex(0, 1) * phases[i] * ampl;
            samps[i * 2] = (float)complex.Real;
            samps[(i * 2) + 1] = (float)complex.Imaginary;
        }

        return samps;
    }

    private static void LogFunction(SoapySDR.LogLevel logLevel, string message)
    {
        System.Console.WriteLine("{0}: {1}: {2}", System.DateTime.Now, logLevel, message);
    }

    private static void SiggenApp(
        string args,
        double rate,
        float ampl,
        double freq,
        double txBandwidth,
        uint txChan,
        double txGain,
        string txAntenna,
        double clockRate,
        double waveFreq,
        bool debug)
    {
        SoapySDR.Logger.RegisterLogHandler(LogFunction);
        SoapySDR.Logger.LogLevel = debug ? SoapySDR.LogLevel.Debug : SoapySDR.LogLevel.Warning;

        var sdr = new SoapySDR.Device(args);

        System.Console.WriteLine("Setting master clock rate to {0} MHz", clockRate / 1e6);
        sdr.MasterClockRate = clockRate;
        System.Console.WriteLine("Actual master clock rate: {0} MHz\n", sdr.MasterClockRate / 1e6);

        System.Console.WriteLine("Setting Tx rate to {0} Msps", rate);
        sdr.SetSampleRate(SoapySDR.Direction.Tx, txChan, rate);
        System.Console.WriteLine("Actual Tx Rate {0} Msps\n", sdr.GetSampleRate(SoapySDR.Direction.Tx, txChan) / 1e6);

        System.Console.WriteLine("Setting Tx bandwidth to {0} MHz", txBandwidth / 1e6);
        sdr.SetBandwidth(SoapySDR.Direction.Tx, txChan, txBandwidth);
        System.Console.WriteLine("Actual Tx bandwidth: {0} MHz\n", sdr.GetBandwidth(SoapySDR.Direction.Tx, txChan) / 1e6);

        System.Console.WriteLine("Setting Tx antenna to {0}\n", txAntenna);
        sdr.SetAntenna(SoapySDR.Direction.Tx, txChan, txAntenna);

        System.Console.WriteLine("Setting Tx gain to {0} dB", txGain);
        sdr.SetGain(SoapySDR.Direction.Tx, txChan, txGain);
        System.Console.WriteLine("Actual Tx gain: {0} dB\n", sdr.GetGain(SoapySDR.Direction.Tx, txChan));

        System.Console.WriteLine("Tuning the frontend to {0} MHz", freq);
        sdr.SetFrequency(SoapySDR.Direction.Tx, txChan, freq);
        System.Console.WriteLine("Actual Tx frequency: {0} MHz\n", sdr.GetFrequency(SoapySDR.Direction.Tx, txChan));

        System.Console.WriteLine("Create Tx stream");
        var txStream = sdr.SetupTxStream(SoapySDR.StreamFormat.CF32, new uint[] { txChan }, "");
        System.Console.WriteLine("Activate Tx stream");
        txStream.Activate(SoapySDR.StreamFlags.None);

        var mtu = txStream.MTU;
        System.Console.WriteLine("Stream MTU: {0}", mtu);

        var phaseAcc = 0.0F;
        var phaseInc = 2.0F * Math.PI * waveFreq / rate;

        uint totalSamps = 0;
        bool running = true;

        // Handle Ctrl+C
        System.Console.CancelKeyPress += delegate (object sender, ConsoleCancelEventArgs e)
        {
            e.Cancel = true;
            running = false;
        };

        var lastPrintTime = System.DateTime.Now;

        while(running)
        {
            float phaseAccNext = (float)(phaseAcc + (mtu * phaseInc));
            var phases = LinSpace(phaseAcc, phaseAccNext, (int)mtu);
            var samples = MakeSamples(ampl, phases);

            phaseAcc = phaseAccNext;
            while (phaseAcc > (Math.PI * 2.0F)) phaseAcc -= (float)(Math.PI * 2.0F);

            var streamResult = new SoapySDR.StreamResult();
            var status = txStream.Write(samples, 0, 1000000, out streamResult);
            if (status != SoapySDR.ErrorCode.None)
            {
                throw new ApplicationException(string.Format("Write returned: {0}", status));
            }
            else if (streamResult.NumSamples != mtu)
            {
                throw new ApplicationException(string.Format("Write consumed {0} elements, expected {1}", streamResult.NumSamples, mtu));
            }

            totalSamps += streamResult.NumSamples;

            // Print rate every 5 seconds
            var now = System.DateTime.Now;
            var durationSecs = (System.DateTime.Now - lastPrintTime).TotalSeconds;
            if (durationSecs > 5)
            {
                var currentRate = totalSamps / durationSecs / 1e6;
                System.Console.WriteLine("C# siggen rate: {0} Msps", currentRate);

                totalSamps = 0;
                lastPrintTime = System.DateTime.Now;
            }
        }

        // Executed after Ctrl+C
        System.Console.WriteLine("Clean up stream");
        txStream.Deactivate();
        txStream.Close();
        System.Console.WriteLine("Done!");
    }

    public static async Task<int> Main(string[] args)
    {
        /*
        parser.add_argument("--args", type=str, help="device factor arguments", default="")
        parser.add_argument("--rate", type=float, help="Tx and Rx sample rate", default=1e6)
        parser.add_argument("--ampl", type=float, help="Tx digital amplitude rate", default=0.7)
        parser.add_argument("--tx-ant", type=str, help="Optional Tx antenna")
        parser.add_argument("--tx-gain", type=float, help="Optional Tx gain (dB)")
        parser.add_argument("--tx-chan", type=int, help="Transmitter channel (def=0)", default=0)
        parser.add_argument("--freq", type=float, help="Optional Tx and Rx freq (Hz)")
        parser.add_argument("--tx-bw", type=float, help="Optional Tx filter bw (Hz)", default=5e6)
        parser.add_argument("--wave-freq", type=float, help="Baseband waveform freq (Hz)")
        parser.add_argument("--clock-rate", type=float, help="Optional clock rate (Hz)")
        parser.add_argument("--debug", action='store_true', help="Output debug messages")
        parser.add_argument(
            "--abort-on-error", action='store_true',
            help="Halts operations if the SDR logs an error")
         */

        RootCommand rootCommand = new RootCommand(
            description: "Simple signal generator for testing transmit\n" +
            "Continuously output a carrier with single sideband sinusoid amplitude modulation.");

        return await rootCommand.InvokeAsync(args);
    }
}