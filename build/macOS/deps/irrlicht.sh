#!/bin/bash -e

. sdk.sh

[ ! -d irrlicht-src ] && \
	git clone --depth 1 https://github.com/MoNTE48/Irrlicht-1.8 irrlicht-src

cd irrlicht-src/source/Irrlicht/MacOSX
xcodebuild build \
	 ARCHS="$OSX_ARCHES" \
	-project MacOSX.xcodeproj \
	-configuration Release \
	-scheme libIrrlicht.a

BUILD_FOLDER=$(xcodebuild -project MacOSX.xcodeproj -scheme \
		libIrrlicht.a -showBuildSettings | \
		grep TARGET_BUILD_DIR | sed -n -e 's/^.*TARGET_BUILD_DIR = //p')

cd ../../..

[ -d ../irrlicht ] && rm -r ../irrlicht
mkdir -p ../irrlicht
cp "${BUILD_FOLDER}/libIrrlicht.a" ../irrlicht
cp -r include ../irrlicht/include

echo "Irrlicht build successful"
