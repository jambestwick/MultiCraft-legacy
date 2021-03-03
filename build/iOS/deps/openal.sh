#!/bin/bash -e

. sdk.sh
OPENAL_VERSION=1.21.1

if [ ! -d openal-src ]; then
	wget https://github.com/kcat/openal-soft/archive/$OPENAL_VERSION.tar.gz
	tar -xzvf $OPENAL_VERSION.tar.gz
	mv openal-soft-$OPENAL_VERSION openal-src
	rm $OPENAL_VERSION.tar.gz
fi

cd openal-src

cmake -S . -GXcode \
	-DCMAKE_SYSTEM_NAME=iOS -DCMAKE_CXX_EXTENSIONS=OFF -DALSOFT_REQUIRE_COREAUDIO=ON \
	-DALSOFT_OSX_FRAMEWORK=ON -DALSOFT_EMBED_HRTF_DATA=YES -DALSOFT_UTILS=OFF \
	-DALSOFT_EXAMPLES=OFF -DALSOFT_INSTALL=OFF -DALSOFT_BACKEND_WAVE=NO \
	-DCMAKE_C_FLAGS_RELEASE="$IOS_FLAGS" -DCMAKE_CXX_FLAGS_RELEASE="$IOS_FLAGS" \
	-DCMAKE_OSX_DEPLOYMENT_TARGET=12.0 \
	-B build_arm
cmake --build build_arm --config Release --target OpenAL

mv build_arm/Release-iphoneos/soft_oal.framework ../soft_oal.framework

echo "OpenAL-Soft build successful"
