#!/bin/bash -e

. sdk.sh
export MACOSX_DEPLOYMENT_TARGET=10.15

LUAJIT_VERSION=2.1

if [ ! -d LuaJIT-src ]; then
	wget https://github.com/LuaJIT/LuaJIT/archive/v$LUAJIT_VERSION.zip
	unzip v$LUAJIT_VERSION.zip
	mv LuaJIT-$LUAJIT_VERSION LuaJIT-src
	rm v$LUAJIT_VERSION.zip
fi

cd LuaJIT-src

make amalg -j \
	DEFAULT_CC=clang HOST_CC=clang CROSS="$(dirname $IOS_CC)/" TARGET_SYS=iOS \
	TARGET_FLAGS="$IOS_FLAGS -fno-fast-math"

mkdir -p ../luajit/{lib,include}
cp -v src/*.h ../luajit/include
cp -v src/libluajit.a ../luajit/lib

echo "LuaJIT build successful"
