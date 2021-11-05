########################################################################
# Build C# assembly
########################################################################

set(csharp_swig_outputs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/ArgInfoInternal.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/ArgInfoInternalList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/BuildInfo.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/ConverterFunctionPriority.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/ConverterInternal.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/ConverterFunctionPriorityList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/DeviceInternal.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/DeviceInternalList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/Direction.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/DoubleList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/ErrorCode.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/Kwargs.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/KwargsList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/LogHandlerBase.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/LogLevel.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/RangeInternal.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/RangeInternalList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/SizeList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/SoapySDR.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/SoapySDRPINVOKE.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StreamFlags.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StreamFormat.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StreamHandle.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StreamResult.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StreamResultPair.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StringList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/Time.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/TypeConversion.cs)

set_source_files_properties(
    FILES ${csharp_swig_outputs}
    PROPERTIES GENERATED TRUE)

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/AssemblyInfo.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/AssemblyInfo.cs)

set(csharp_srcs
    ${CMAKE_CURRENT_SOURCE_DIR}/ArgInfo.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/AssemblyInfo.cs
    ${CMAKE_CURRENT_SOURCE_DIR}/Converter.cs
    ${CMAKE_CURRENT_SOURCE_DIR}/Device.cs
    ${CMAKE_CURRENT_SOURCE_DIR}/Logger.cs
    ${CMAKE_CURRENT_SOURCE_DIR}/Range.cs
    ${CMAKE_CURRENT_SOURCE_DIR}/RxStream.cs
    ${CMAKE_CURRENT_SOURCE_DIR}/SoapyConvertible.cs
    ${CMAKE_CURRENT_SOURCE_DIR}/Stream.cs
    ${CMAKE_CURRENT_SOURCE_DIR}/TxStream.cs
    ${CMAKE_CURRENT_SOURCE_DIR}/Utility.cs
    
    ${csharp_swig_outputs})

add_library(SoapySDR.CSharp SHARED ${csharp_srcs})
set_property(TARGET SoapySDR.CSharp PROPERTY COMPILE_FLAGS /unsafe)
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set_property(TARGET SoapySDR.CSharp PROPERTY COMPILE_DEFINITIONS _64BIT)
endif()

# TODO: Core? Framework? Standard? Parameterize?
set_property(TARGET SoapySDR.CSharp PROPERTY DOTNET_TARGET_FRAMEWORK_VERSION "v4.7.2")
set_property(
    TARGET SoapySDR.CSharp
    PROPERTY VS_DOTNET_REFERENCES
    "System"
    "System.Core"
    "System.Numerics")
set_property(
    TARGET SoapySDR.CSharp
    PROPERTY VS_PACKAGE_REFERENCES
	"System.Memory_4.5.4")

add_dependencies(SoapySDR.CSharp ${SWIG_TARGET_NAME})