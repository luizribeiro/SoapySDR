########################################################################
# Build C# assembly
########################################################################

set(csharp_swig_outputs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/ArgInfo.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/ArgInfoList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/BuildInfo.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/Device.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/Direction.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/ErrorCode.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/Kwargs.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/KwargsList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/LogHandlerBase.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/LogLevel.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/Range.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/RangeList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/SizeListInternal.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/SoapySDR.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/SoapySDRPINVOKE.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StreamFlags.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StreamFormat.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StreamHandle.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StreamResult.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StreamResultPairInternal.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/StringList.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/Time.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/TypeConversionInternal.cs)

set_source_files_properties(
    FILES ${csharp_swig_outputs}
    PROPERTIES GENERATED TRUE)

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/AssemblyInfo.in.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/AssemblyInfo.cs)
    
file(READ "${PROJECT_SOURCE_DIR}/include/SoapySDR/Version.h" version_h_txt)
string(REGEX MATCH "define SOAPY_SDR_API_VERSION (0x[^\\n\\r]+) " version_h_match "${version_h_txt}")
if(NOT version_h_match)
    message(FATAL_ERROR "Failed to extract SOAPY_SDR_API_VERSION from version.h")
endif()
set(SOAPY_SDR_API_VERSION ${CMAKE_MATCH_1})
string(FIND "${SOAPY_SDR_API_VERSION}" "\n" newline_pos)
string(SUBSTRING ${SOAPY_SDR_API_VERSION} 0 ${newline_pos} SOAPY_SDR_API_VERSION)

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/BuildInfo.Assembly.in.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/BuildInfo.Assembly.cs)

# TODO: move all files into binary directory, only point Doxygen at binary directory
set(csharp_srcs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/AssemblyInfo.cs
    ${CSHARP_SWIG_OUTPUT_DIRECTORY}/BuildInfo.Assembly.cs
    ${CMAKE_CURRENT_SOURCE_DIR}/Logger.cs
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

install(TARGETS SoapySDR.CSharp
    EXPORT SoapySDRCSharpExport
    DESTINATION ${CMAKE_INSTALL_BINDIR})

# TODO: cmake dir
install(FILES ${PROJECT_SOURCE_DIR}/swig/csharp/SoapySDRCSharpConfig.cmake
        DESTINATION ${CMAKE_LIB_DEST})

# Export target to SoapySDR project config
install(EXPORT SoapySDRCSharpExport DESTINATION ${CMAKE_LIB_DEST})