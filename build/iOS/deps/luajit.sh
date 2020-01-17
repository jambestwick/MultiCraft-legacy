#!/bin/bash -e

. sdk.sh
export MACOSX_DEPLOYMENT_TARGET=10.13

# MoonJIT
LUAJIT_VERSION=2.1.2

if [ ! -d moonjit-src ]; then
    wget https://github.com/moonjit/moonjit/archive/$LUAJIT_VERSION.zip
    unzip $LUAJIT_VERSION.zip
    mv moonjit-$LUAJIT_VERSION moonjit-src
    rm $LUAJIT_VERSION.zip
fi

cd moonjit-src

# 32-bit
make -j \
    DEFAULT_CC=clang HOST_CC="clang -m32 -arch i386" CROSS="$(dirname $IOS_CC)/" TARGET_SYS=iOS \
    TARGET_FLAGS="-arch armv7 ${IOS_FLAGS_LUA}" \
    TARGET_CFLAGS+="-Wno-implicit-function-declaration -fno-omit-frame-pointer"
mv src/libluajit.a templib_32.a
make clean

# 64-bit
make -j \
    DEFAULT_CC=clang HOST_CC=clang CROSS="$(dirname $IOS_CC)/" TARGET_SYS=iOS \
    TARGET_FLAGS="-arch arm64 ${IOS_FLAGS_LUA}" \
    TARGET_CFLAGS+="-Wno-implicit-function-declaration"
mv src/libluajit.a templib_64.a
make clean

# 64-bit [arm64e]
make -j \
    DEFAULT_CC=clang HOST_CC=clang CROSS="$(dirname $IOS_CC)/" TARGET_SYS=iOS \
    TARGET_FLAGS="-arch arm64e ${IOS_FLAGS_LUA}" \
    TARGET_CFLAGS+="-Wno-implicit-function-declaration"
mv src/libluajit.a templib_64e.a
make clean

# repack into one .a
lipo -create templib_*.a -output libluajit.a
rm templib_*.a

mkdir -p ../luajit/{lib,include}
cp -v src/*.h ../luajit/include
cp -v libluajit.a ../luajit/lib

echo "LuaJIT build successful"
