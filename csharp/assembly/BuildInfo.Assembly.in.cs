// Copyright (c) 2021 Nicholas Corgan
// SPDX-License-Identifier: BSL-1.0

using System;

namespace SoapySDR
{
    public partial class BuildInfo
    {
        public class Assembly
        {
            private static uint APIVersionNum = @SOAPY_SDR_API_VERSION@;

            public static string ABIVersion => "@SOAPY_SDR_ABI_VERSION@";
            public static string APIVersion => string.Format("{0}.{1}.{2}", ((APIVersionNum >> 24) & 0xFF), ((APIVersionNum >> 16) & 0xFF), (APIVersionNum & 0xFFFF));
            public static string LibVersion => "@SOAPY_SDR_VERSION@";
        }
    }
}
