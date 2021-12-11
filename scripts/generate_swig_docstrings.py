#!/usr/bin/env python
#
# Copyright (c) 2016,2021 Nicholas Corgan (n.corgan@gmail.com)
#
# Distributed under the MIT License (MIT) (See accompanying file LICENSE.txt
# or copy at http://opensource.org/licenses/MIT)
#

################################################################
# This script is called at build-time to generate SWIG
# docstrings.
################################################################

import CppHeaderParser
import swigdoc_converter
import datetime
from optparse import OptionParser
import os

header_text = """/*
 * This file was generated: %s
 */""" % datetime.datetime.now()

ignored_files = []

CppHeaderParser.ignoreSymbols += ["SOAPY_SDR_API"]

functions_to_ignore = ["make", "unmake"]

def get_csharp_docs(header):
    output = ""

    for fcn in header.functions:
        if fcn["name"] not in functions_to_ignore and "operator" not in fcn["name"].lower() and "anon" not in fcn["name"].lower() and "doxygen" in fcn:
            output += "%s\n" % swigdoc_converter.documentation(fcn).swig_csharp_docs()

    for cls in header.classes:
        if "doxygen" in header.classes[cls]:
            cls_csharp_docs = "%s\n\n////////////////////////////////////////////////////\n" % swigdoc_converter.documentation(header.classes[cls]).swig_csharp_docs()
            output += cls_csharp_docs

        for fcn in header.classes[cls]["methods"]["public"]:
            if fcn["name"] not in functions_to_ignore and "operator" not in fcn["name"].lower() and not fcn["destructor"] and "doxygen" in fcn:
                output += "%s\n\n////////////////////////////////////////////////////\n" % swigdoc_converter.documentation(fcn).swig_csharp_docs()

    return output

def get_javadocs(header):
    output = ""

    for fcn in header.functions:
        if fcn["name"] not in functions_to_ignore and "operator" not in fcn["name"].lower() and "anon" not in fcn["name"].lower() and "doxygen" in fcn:
            output += "%s\n" % swigdoc_converter.documentation(fcn).swig_javadoc()

    for cls in header.classes:
        if "doxygen" in header.classes[cls]:
            cls_javadoc = "%s\n" % swigdoc_converter.documentation(header.classes[cls]).swig_javadoc()
            output += cls_javadoc

        for fcn in header.classes[cls]["methods"]["public"]:
            if fcn["name"] not in functions_to_ignore and "operator" not in fcn["name"].lower() and not fcn["destructor"] and "doxygen" in fcn:
                output += "%s\n" % swigdoc_converter.documentation(fcn).swig_javadoc()

    return output

def get_python_docstrings(header):
    output = ""

    for fcn in header.functions:
        if fcn["name"] not in functions_to_ignore and "operator" not in fcn["name"].lower() and "anon" not in fcn["name"].lower() and "doxygen" in fcn:
            output += "%s\n" % swigdoc_converter.documentation(fcn).swig_python_docstring()

    for cls in header.classes:
        if "doxygen" in header.classes[cls]:
            cls_python_docstring = "%s\n" % swigdoc_converter.documentation(header.classes[cls]).swig_python_docstring()
            output += cls_python_docstring

        for fcn in header.classes[cls]["methods"]["public"]:
            if fcn["name"] not in functions_to_ignore and "operator" not in fcn["name"].lower() and not fcn["destructor"] and "doxygen" in fcn:
                output += "%s\n" % swigdoc_converter.documentation(fcn).swig_python_docstring()

        for var in header.classes[cls]["properties"]["public"]:
            if "doxygen" in var:
                output += "%s\n" % swigdoc_converter.documentation(var).swig_python_docstring()

    return output

SWIG_DOC_FUNCTIONS = dict(csharp = get_csharp_docs,
                          java = get_javadocs,
                          python = get_python_docstrings)

if __name__ == "__main__":

    parser = OptionParser()
    parser.add_option("--include-dir", type="string", help="SoapySDR include directory")
    parser.add_option("--language", type="string", help="Language")
    parser.add_option("--output", type="string", help="Output filepath")
    (options,args) = parser.parse_args()

    output = header_text + "\n\n"

    os.chdir(options.include_dir)
    for root, dirs, files in os.walk(os.getcwd()):
        for file in files:
            if file.endswith(".hpp") and file not in ignored_files:
                new_output = SWIG_DOC_FUNCTIONS[options.language](CppHeaderParser.CppHeader(os.path.join(root, file)))
                if not ("&&" in new_output or "& &" in new_output):
                    output += "{0}\n".format(new_output)

    f = open(options.output, 'w')
    f.write(output)
    f.close()
