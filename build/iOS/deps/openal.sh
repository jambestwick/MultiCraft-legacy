#!/bin/bash -e

. sdk.sh
OPENAL_VERSION=1.21.0

if [ ! -d openal-src ]; then
	wget https://github.com/kcat/openal-soft/archive/openal-soft-$OPENAL_VERSION.tar.gz
	tar -xzvf openal-soft-$OPENAL_VERSION.tar.gz
	mv openal-soft-openal-soft-$OPENAL_VERSION openal-src
	rm openal-soft-$OPENAL_VERSION.tar.gz
fi

cd openal-src

cmake -S . -GXcode \
	-DCMAKE_SYSTEM_NAME=iOS -DCMAKE_CXX_EXTENSIONS=OFF -DALSOFT_REQUIRE_COREAUDIO=ON \
	-DALSOFT_OSX_FRAMEWORK=ON -DALSOFT_EMBED_HRTF_DATA=YES -DALSOFT_UTILS=OFF \
	-DALSOFT_EXAMPLES=OFF -DALSOFT_INSTALL=OFF -DALSOFT_BACKEND_WAVE=NO \
	-DCMAKE_C_FLAGS_RELEASE="$IOS_FLAGS" -DCMAKE_CXX_FLAGS_RELEASE="$IOS_FLAGS" \
	-DCMAKE_OSX_DEPLOYMENT_TARGET=9.3 \
	-B build_arm "-DCMAKE_OSX_ARCHITECTURES=armv7;arm64"
cmake --build build_arm --config Release --target OpenAL

mv build_arm/Release-iphoneos/soft_oal.framework ../soft_oal.framework

echo "OpenAL-Soft build successful"
