#!/bin/bash
set -e

PWC_CURRENT_DIR=$(pwd)
PWC_WORKSPACE="mpos-ui/mpos-ui.xcworkspace"
PWC_SDK_NAME_IPHONEOS="iphoneos"
PWC_ACTION="clean build"

PWC_CONFIGURATION="Release"
PWC_FRAMEWORK_VERSION="2.4.1"
PWC_PACKAGE_DIR="${PWC_CURRENT_DIR}/packaged"

PWC_SCHEME="mpos-ui-framework"
PWC_FRAMEWORK_NAME="mpos-ui"



if [ "$#" -lt 1 ]; then
	echo "Building the mpos-ui SDK package"
	echo "usage:    build.sh [configuration]"
	echo "example:  build.sh release"
	echo ""
	echo "configuration  -> release | debug                    	    (release strips symbols from lib)"
	echo ""
	exit 1
fi

if [ $1 == "debug" ]; then
	PWC_CONFIGURATION="Debug"
fi

echo ""
echo ""
echo ""


echo ""
echo ""
echo "### Deleting (old) Packaged Files ###"
echo "${PWC_PACKAGE_DIR}"
#delete the old framework
if [ -d "${PWC_PACKAGE_DIR}" ]; then
	rm -rf "${PWC_PACKAGE_DIR}"
fi

#preparing the pods (replace dummy names)
./prepare-pods.sh

echo ""
echo ""
echo "### Building Versions ###"
echo ""
echo "iphoneos build: xcodebuild -workspace ${PWC_WORKSPACE} -scheme ${PWC_SCHEME} -configuration ${PWC_CONFIGURATION} -sdk iphoneos ${PWC_ACTION} FRAMEWORK_EXPORT_DIR=${PWC_PACKAGE_DIR}"
xcodebuild -workspace "${PWC_WORKSPACE}" -scheme "${PWC_SCHEME}" -configuration "${PWC_CONFIGURATION}" -sdk iphoneos clean build FRAMEWORK_EXPORT_DIR="${PWC_PACKAGE_DIR}" OTHER_CFLAGS="-fembed-bitcode -Qunused-arguments"

echo ""
echo ""
if [ "${PWC_CONFIGURATION}" == "Release" ]; then
	echo "### Stripping Symbols ###"
    strip -x -S "${PWC_PACKAGE_DIR}/${PWC_FRAMEWORK_NAME}.framework/Versions/A/${PWC_FRAMEWORK_NAME}"
else
	echo "### NOT Stripping Symbols ###"
fi
echo ""

echo ""
echo ""
echo "Build completed"
