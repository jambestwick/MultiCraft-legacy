#!/bin/bash -e

. sdk.sh

[ ! -d irrlicht-src ] && \
	git clone -b ogl-es --depth 1 https://github.com/MoNTE48/Irrlicht irrlicht-src

cd irrlicht-src/source/Irrlicht
xcodebuild build \
	-project Irrlicht.xcodeproj \
	-configuration Release \
	-scheme Irrlicht_iOS \
	-destination generic/platform=iOS
cd ../..

[ -d ../irrlicht ] && rm -r ../irrlicht
mkdir -p ../irrlicht
cp lib/iOS/libIrrlicht.a ../irrlicht/
cp -r include ../irrlicht/include
cp -r media/Shaders ../irrlicht/shaders

echo "Irrlicht build successful"
