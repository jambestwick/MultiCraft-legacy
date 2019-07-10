######################################################################################

# compile with GPROF
# GPROF = 1

######################################################################################
# toolchain config for ARMv7 (gcc, NDK r17c)
######################################################################################

#API = 16
#TARGET_HOST = arm-linux
#TARGET_ABI = armeabi-v7a
#TARGET_ARCH = arm
#TARGET_TOOLCHAIN = arm-linux-androideabi
#TARGET_CFLAGS_ADDON = -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb -Ofast -fdata-sections -ffunction-sections -fvisibility=hidden -fexceptions -D__ANDROID_API__=$(API)
#TARGET_CXXFLAGS_ADDON = $(TARGET_CFLAGS_ADDON) -frtti
#CROSS_PREFIX = arm-linux-androideabi
#CROSS_CC = ${CROSS_PREFIX}-gcc
#CROSS_CXX = ${CROSS_PREFIX}-g++
#HOST_CC = "gcc -m32" # required for LuaJIT
#COMPILER_VERSION = 4.9
#APP_STL = gnustl_static
#APP_STL_LIB = gnustl

######################################################################################
# toolchain config for ARMv7 (Clang)
######################################################################################

API = 16
TARGET_HOST = arm-linux
TARGET_ABI = armeabi-v7a
TARGET_ARCH = arm
TARGET_TOOLCHAIN = arm-linux-androideabi
TARGET_CFLAGS_ADDON = -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb -Ofast -fdata-sections -ffunction-sections -fvisibility=hidden -fexceptions -D__ANDROID_API__=$(API) -fpic
TARGET_CXXFLAGS_ADDON = $(TARGET_CFLAGS_ADDON) -frtti
CROSS_PREFIX = arm-linux-androideabi
CROSS_CC = clang
CROSS_CXX = clang++
HOST_CC = "gcc -m32" # required for LuaJIT
COMPILER_VERSION = clang
APP_STL = c++_shared
APP_STL_LIB = libc++

######################################################################################
# toolchain config for ARM64 (gcc, NDK r17c)
######################################################################################

#API = 21
#TARGET_HOST = arm-linux
#TARGET_ABI = arm64-v8a
#TARGET_ARCH = arm64
#TARGET_TOOLCHAIN = aarch64-linux-android
#TARGET_CFLAGS_ADDON = -Ofast -fvisibility=hidden -fexceptions -D__ANDROID_API__=$(API)
#TARGET_CXXFLAGS_ADDON = $(TARGET_CFLAGS_ADDON) -frtti
#CROSS_PREFIX = aarch64-linux-android
#CROSS_CC = ${CROSS_PREFIX}-gcc
#CROSS_CXX = ${CROSS_PREFIX}-g++
#HOST_CC = "gcc -m64" # required for LuaJIT
#COMPILER_VERSION = 4.9
#APP_STL = gnustl_static
#APP_STL_LIB = gnustl

######################################################################################
# toolchain config for ARM64 (Clang)
######################################################################################

#API = 21
#TARGET_HOST = arm-linux
#TARGET_ABI = arm64-v8a
#TARGET_ARCH = arm64
#TARGET_TOOLCHAIN = aarch64-linux-android
#TARGET_CFLAGS_ADDON = -Ofast -fvisibility=hidden -fexceptions -D__ANDROID_API__=$(API)
#TARGET_CXXFLAGS_ADDON = $(TARGET_CFLAGS_ADDON) -frtti
#CROSS_PREFIX = aarch64-linux-android
#CROSS_CC = clang
#CROSS_CXX = clang++
#HOST_CC = "gcc -m64" # required for LuaJIT
#COMPILER_VERSION = clang
#APP_STL = c++_shared
#APP_STL_LIB = libc++

######################################################################################
# toolchain config for x86 (gcc, NDK r17c)
######################################################################################

#API = 16
#TARGET_HOST = x86-linux
#TARGET_ABI = x86
#TARGET_ARCH = x86
#TARGET_TOOLCHAIN = x86
#TARGET_CFLAGS_ADDON = -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32 -Ofast -funroll-loops -fdata-sections -ffunction-sections -fvisibility=hidden -fexceptions -D__ANDROID_API__=$(API)
#TARGET_CXXFLAGS_ADDON = $(TARGET_CFLAGS_ADDON) -frtti
#CROSS_PREFIX = i686-linux-android
#CROSS_CC = ${CROSS_PREFIX}-gcc
#CROSS_CXX = ${CROSS_PREFIX}-g++
#HOST_CC = "gcc -m32" # required for LuaJIT
#COMPILER_VERSION = 4.9
#APP_STL = gnustl_static
#APP_STL_LIB = gnustl

######################################################################################
# toolchain config for x86 (clang)
######################################################################################

#API = 16
#TARGET_HOST = x86-linux
#TARGET_ABI = x86
#TARGET_ARCH = x86
#TARGET_TOOLCHAIN = x86
#TARGET_CFLAGS_ADDON = -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32 -Ofast -funroll-loops -fdata-sections -ffunction-sections -fvisibility=hidden -fexceptions -D__ANDROID_API__=$(API)
#TARGET_CXXFLAGS_ADDON = $(TARGET_CFLAGS_ADDON) -frtti
#CROSS_PREFIX = i686-linux-android
#CROSS_CC = clang
#CROSS_CXX = clang++
#HOST_CC = "gcc -m32" # required for LuaJIT
#COMPILER_VERSION = clang
#APP_STL = c++_shared
#APP_STL_LIB = libc++

######################################################################################

SHELL := /bin/bash
ANDR_ROOT = $(shell pwd)

LEVELDB_VERSION = 1.20
LEVELDB_DIR = $(ANDR_ROOT)/deps/leveldb
LEVELDB_LIB = $(LEVELDB_DIR)/out-static/libleveldb.a
LEVELDB_TIMESTAMP = $(LEVELDB_DIR)/timestamp
LEVELDB_TIMESTAMP_INT = $(ANDR_ROOT)/deps/leveldb_timestamp
LEVELDB_URL = https://github.com/google/leveldb/archive/v$(LEVELDB_VERSION).zip

OPENAL_VERSION = 1.19.1
OPENAL_DIR = $(ANDR_ROOT)/deps/openal-soft
OPENAL_LIB = $(OPENAL_DIR)/libopenal.a
OPENAL_TIMESTAMP = $(OPENAL_DIR)/timestamp
OPENAL_TIMESTAMP_INT = $(ANDR_ROOT)/deps/openal_timestamp
OPENAL_URL = https://github.com/kcat/openal-soft/archive/openal-soft-$(OPENAL_VERSION).zip

VORBIS_DIR = $(ANDR_ROOT)/deps/libvorbis-android
VORBIS_LIB = $(VORBIS_DIR)/obj/local/$(TARGET_ABI)/libvorbis.a
VORBIS_TIMESTAMP = $(VORBIS_DIR)/timestamp
VORBIS_TIMESTAMP_INT = $(ANDR_ROOT)/deps/vorbis_timestamp
VORBIS_URL_GIT = https://github.com/MoNTE48/libvorbis-android

IRRLICHT_COMMIT = 237eb07bf4b6957f2e103adcaf835e6a2afe3486
IRRLICHT_DIR = $(ANDR_ROOT)/deps/irrlicht
IRRLICHT_LIB = $(IRRLICHT_DIR)/lib/Android/libIrrlicht.a
IRRLICHT_TIMESTAMP = $(IRRLICHT_DIR)/timestamp
IRRLICHT_TIMESTAMP_INT = $(ANDR_ROOT)/deps/irrlicht_timestamp
IRRLICHT_URL_HTTP = https://github.com/zaki/irrlicht/archive/$(IRRLICHT_COMMIT).zip

CURL_VERSION = 7.65.1
CURL_DIR = $(ANDR_ROOT)/deps/curl
CURL_LIB = $(CURL_DIR)/lib/.libs/libcurl.a
CURL_TIMESTAMP = $(CURL_DIR)/timestamp
CURL_TIMESTAMP_INT = $(ANDR_ROOT)/deps/curl_timestamp
CURL_URL_HTTP = http://dl.uxnr.de/mirror/curl/curl-${CURL_VERSION}.tar.bz2

FREETYPE_VERSION = 2.10.1
FREETYPE_DIR = $(ANDR_ROOT)/deps/freetype
FREETYPE_LIB = $(FREETYPE_DIR)/objs/.libs/libfreetype.a
FREETYPE_TIMESTAMP = $(FREETYPE_DIR)/timestamp
FREETYPE_TIMESTAMP_INT = $(ANDR_ROOT)/deps/freetype_timestamp
FREETYPE_URL_HTTP = https://sourceforge.net/projects/freetype/files/freetype2/$(FREETYPE_VERSION)/freetype-$(FREETYPE_VERSION).tar.xz

ICONV_VERSION = 1.16
ICONV_DIR = $(ANDR_ROOT)/deps/libiconv
ICONV_URL_HTTP = https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$(ICONV_VERSION).tar.gz

LUAJIT_GIT_BRANCH = v2.1
LUAJIT_DIR = $(ANDR_ROOT)/deps/luajit
LUAJIT_LIB = $(LUAJIT_DIR)src/libluajit.a
LUAJIT_TIMESTAMP = $(LUAJIT_DIR)/timestamp
LUAJIT_TIMESTAMP_INT = $(ANDR_ROOT)/deps/luajit_timestamp
LUAJIT_URL_GIT = https://github.com/LuaJIT/LuaJIT.git

ASSETS_TIMESTAMP = $(ANDR_ROOT)/deps/assets_timestamp

######################################################################################

PROJ_ROOT = $(shell realpath $(ANDR_ROOT)/../..)
APP_ROOT = $(ANDR_ROOT)/src/main

APP_PLATFORM = android-$(API)

ANDROID_SDK = $(shell grep '^sdk\.dir' local.properties | sed 's/^.*=[[:space:]]*//')
ANDROID_NDK = $(shell grep '^ndk\.dir' local.properties | sed 's/^.*=[[:space:]]*//')

debug : local.properties
	export NDEBUG=;                                                                 \
	export BUILD_TYPE=debug;                                                        \
	$(MAKE) apk

all : debug release

release : local.properties
	@export NDEBUG=1;                                                               \
	export BUILD_TYPE=release;                                                      \
	$(MAKE) apk

reconfig: delconfig
	@$(MAKE) local.properties

delconfig:
	$(RM) local.properties

local.properties:
	@echo "Please specify path of ANDROID NDK";                                     \
	echo "e.g. $$HOME/Android/ndk-r17b/";                                           \
	read ANDROID_NDK ;                                                              \
	if [ ! -d $$ANDROID_NDK ] ; then                                                \
		echo "$$ANDROID_NDK is not a valid folder";                                 \
		exit 1;                                                                     \
	fi;                                                                             \
	echo "ndk.dir = $$ANDROID_NDK" > local.properties;                              \
	echo "Please specify path of ANDROID SDK";                                      \
	echo "e.g. $$HOME/Android/sdk/";                                                \
	read SDKFLDR ;                                                                  \
	if [ ! -d $$SDKFLDR ] ; then                                                    \
		echo "$$SDKFLDR is not a valid folder";                                     \
		exit 1;                                                                     \
	fi;                                                                             \
	echo "sdk.dir = $$SDKFLDR" >> local.properties;


$(OPENAL_TIMESTAMP) : openal_download
	@LAST_MODIF=$$(find ${OPENAL_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "); \
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then                          \
		touch ${OPENAL_TIMESTAMP};                                                  \
	fi

openal_download :
	@if [ ! -d ${OPENAL_DIR} ] ; then                                               \
		echo "openal sources missing, downloading...";                              \
		mkdir -p ${ANDR_ROOT}/deps;                                                 \
		cd ${ANDR_ROOT}/deps ;                                                      \
		wget ${OPENAL_URL} || exit 1;                                               \
		unzip openal-soft-${OPENAL_VERSION}.zip || exit 1;                          \
		rm openal-soft-${OPENAL_VERSION}.zip || exit 1;                             \
		mv openal-soft-openal-soft-${OPENAL_VERSION} openal-soft || exit 1;         \
		cd ${OPENAL_DIR};                                                           \
		sed '/CMAKE_FIND_ROOT_PATH / s/^/#/' -i XCompile-Android.txt;               \
		sed '/CMAKE_C_COMPILER/ s/-gcc"/-clang"/' -i XCompile-Android.txt;          \
		sed '/CMAKE_CXX_COMPILER/ s/-g++"/-clang++"/' -i XCompile-Android.txt;      \
	fi

openal : $(OPENAL_LIB)

$(OPENAL_LIB): $(OPENAL_TIMESTAMP)
	+@REFRESH=0;                                                                    \
	if [ ! -e ${OPENAL_TIMESTAMP_INT} ] ; then                                      \
		REFRESH=1;                                                                  \
	fi;                                                                             \
	if [ ${OPENAL_TIMESTAMP} -nt ${OPENAL_TIMESTAMP_INT} ] ; then                   \
		REFRESH=1;                                                                  \
	fi;                                                                             \
	if [ $$REFRESH -ne 0 ] ; then                                                   \
	echo "changed timestamp for openal detected building...";                       \
	cd ${OPENAL_DIR};                                                               \
	export TOOLCHAIN=/tmp/ndk-${TARGET_HOST}-openal;                                \
	${ANDROID_NDK}/build/tools/make_standalone_toolchain.py                         \
		--arch ${TARGET_ARCH}                                                       \
		--api ${API}                                                                \
		--stl=${APP_STL_LIB}                                                        \
		--install-dir=$${TOOLCHAIN};                                                \
	if [[ ${COMPILER_VERSION} == "clang" && ${API} -lt 18 ]] ; then                 \
		cd "$${TOOLCHAIN}/sysroot/usr/local/include";                               \
		sed '/log2f/ s/^/\/\//' -i math.h;                                          \
		cd ${OPENAL_DIR};                                                           \
	fi;                                                                             \
	export PATH="$${TOOLCHAIN}/bin:$${PATH}";                                       \
	cmake .                                                                         \
		-DCMAKE_TOOLCHAIN_FILE=XCompile-Android.txt -DLIBTYPE=STATIC                \
		-DCMAKE_C_FLAGS="${TARGET_CFLAGS_ADDON}"                                    \
		-DHOST=${CROSS_PREFIX} -DCMAKE_FIND_ROOT_PATH=$${TOOLCHAIN}                 \
		-DALSOFT_NO_CONFIG_UTIL=TRUE || exit 1;                                     \
	$(MAKE) || exit 1;                                                              \
	touch ${OPENAL_TIMESTAMP};                                                      \
	touch ${OPENAL_TIMESTAMP_INT};                                                  \
	$(RM) -rf $${TOOLCHAIN};                                                        \
	else                                                                            \
		echo "nothing to be done for openal";                                       \
	fi

clean_openal :
	$(RM) -rf ${OPENAL_DIR}

$(VORBIS_TIMESTAMP) : vorbis_download
	@LAST_MODIF=$$(find ${VORBIS_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "); \
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then                          \
		touch ${VORBIS_TIMESTAMP};                                                  \
	fi

vorbis_download :
	@if [ ! -d ${VORBIS_DIR} ] ; then                                               \
		echo "vorbis sources missing, downloading...";                              \
		mkdir -p ${ANDR_ROOT}/deps;                                                 \
		cd ${ANDR_ROOT}/deps ;                                                      \
		git clone ${VORBIS_URL_GIT} || exit 1;                                      \
	fi

vorbis : $(VORBIS_LIB)

$(VORBIS_LIB): $(VORBIS_TIMESTAMP)
	+@REFRESH=0;                                                                    \
	if [ ! -e ${VORBIS_TIMESTAMP_INT} ] ; then                                      \
		echo "${VORBIS_TIMESTAMP_INT} doesn't exist";                               \
		REFRESH=1;                                                                  \
	fi;                                                                             \
	if [ ${VORBIS_TIMESTAMP} -nt ${VORBIS_TIMESTAMP_INT} ] ; then                   \
		REFRESH=1;                                                                  \
	fi;                                                                             \
	if [ $$REFRESH -ne 0 ] ; then                                                   \
	echo "changed timestamp for vorbis detected building...";                       \
	cd ${VORBIS_DIR};                                                               \
	${ANDROID_NDK}/ndk-build                                                        \
		NDEBUG=${NDEBUG}                                                            \
		APP_PLATFORM=${APP_PLATFORM}                                                \
		TARGET_ABI=${TARGET_ABI}                                                    \
		APP_STL=${APP_STL}                                                          \
		COMPILER_VERSION=${COMPILER_VERSION}                                        \
		NDK_APPLICATION_MK=${ANDR_ROOT}/jni/Deps.mk || exit 1;                      \
	touch ${VORBIS_TIMESTAMP};                                                      \
	touch ${VORBIS_TIMESTAMP_INT};                                                  \
	else                                                                            \
		echo "nothing to be done for libvorbis";                                    \
	fi

clean_vorbis :
	$(RM) -rf ${VORBIS_DIR}

$(LEVELDB_TIMESTAMP) : leveldb_download
	@LAST_MODIF=$$(find ${LEVELDB_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "); \
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then                          \
		touch ${LEVELDB_TIMESTAMP};                                                 \
	fi

leveldb_download :
	@if [ ! -d ${LEVELDB_DIR} ] ; then                                              \
		echo "leveldb sources missing, downloading...";                             \
		mkdir -p ${ANDR_ROOT}/deps;                                                 \
		cd ${ANDR_ROOT}/deps ;                                                      \
		wget ${LEVELDB_URL} || exit 1;                                              \
		unzip v${LEVELDB_VERSION}.zip || exit 1;                                    \
		rm v${LEVELDB_VERSION}.zip || exit 1;                                       \
		mv leveldb-${LEVELDB_VERSION} leveldb || exit 1;                            \
	fi

leveldb : $(LEVELDB_LIB)
$(LEVELDB_LIB): $(LEVELDB_TIMESTAMP)
	@REFRESH=0;                                                                     \
	if [ ! -e ${LEVELDB_TIMESTAMP_INT} ] ; then                                     \
		REFRESH=1;                                                                  \
	fi;                                                                             \
	if [ ${LEVELDB_TIMESTAMP} -nt ${LEVELDB_TIMESTAMP_INT} ] ; then                 \
		REFRESH=1;                                                                  \
	fi;                                                                             \
	if [ $$REFRESH -ne 0 ] ; then                                                   \
	echo "changed timestamp for leveldb detected building...";                      \
	cd deps/leveldb;                                                                \
	export TOOLCHAIN=/tmp/ndk-${TARGET_HOST}-leveldb;                               \
	${ANDROID_NDK}/build/tools/make_standalone_toolchain.py                         \
		--arch ${TARGET_ARCH}                                                       \
		--api ${API}                                                                \
		--stl=${APP_STL_LIB}                                                        \
		--install-dir=$${TOOLCHAIN};                                                \
	export PATH="$${TOOLCHAIN}/bin:$${PATH}";                                       \
	export CC=${CROSS_CC};                                                          \
	export CXX=${CROSS_CXX};                                                        \
	export TARGET_OS=OS_ANDROID_CROSSCOMPILE;                                       \
	export CFLAGS="$${CFLAGS} ${TARGET_CFLAGS_ADDON}";                              \
	export CXXFLAGS="$${CPPFLAGS} ${TARGET_CXXFLAGS_ADDON}";                        \
	$(MAKE) out-static/libleveldb.a || exit 1;                                      \
	touch ${LEVELDB_TIMESTAMP};                                                     \
	touch ${LEVELDB_TIMESTAMP_INT};                                                 \
	$(RM) -rf $${TOOLCHAIN};                                                        \
	else                                                                            \
		echo "nothing to be done for leveldb";                                      \
	fi

clean_leveldb :
	$(RM) -rf deps/leveldb

$(FREETYPE_TIMESTAMP) : freetype_download
	@LAST_MODIF=$$(find ${FREETYPE_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "); \
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then                          \
		touch ${FREETYPE_TIMESTAMP};                                                \
	fi

freetype_download :
	@if [ ! -d ${FREETYPE_DIR} ] ; then                                             \
		echo "freetype sources missing, downloading...";                            \
		mkdir -p ${ANDR_ROOT}/deps;                                                 \
		cd deps;                                                                    \
		mkdir freetype;                                                             \
		wget ${FREETYPE_URL_HTTP} || exit 1;                                        \
		tar -xJf freetype-${FREETYPE_VERSION}.tar.xz -C freetype --strip-components=1 || exit 1; \
		rm freetype-${FREETYPE_VERSION}.tar.xz;                                     \
	fi

freetype : $(FREETYPE_LIB)

$(FREETYPE_LIB) : $(FREETYPE_TIMESTAMP)
	+@REFRESH=0;                                                                    \
	if [ ! -e ${FREETYPE_TIMESTAMP_INT} ] ; then                                    \
		REFRESH=1;                                                                  \
	fi;                                                                             \
	if [ ! -e ${FREETYPE_LIB} ] ; then                                              \
		REFRESH=1;                                                                  \
	fi;                                                                             \
	if [ ${FREETYPE_TIMESTAMP} -nt ${FREETYPE_TIMESTAMP_INT} ] ; then               \
		REFRESH=1;                                                                  \
	fi;                                                                             \
	if [ $$REFRESH -ne 0 ] ; then                                                   \
	mkdir -p ${FREETYPE_DIR};                                                       \
	export PATH=$$PATH:${ANDROID_NDK};                                              \
	echo "changed timestamp for freetype detected building...";                     \
	cd deps/freetype;                                                               \
	export TOOLCHAIN=/tmp/ndk-${TARGET_HOST}-freetype;                              \
	${ANDROID_NDK}/build/tools/make_standalone_toolchain.py                         \
		--arch ${TARGET_ARCH}                                                       \
		--api ${API}                                                                \
		--stl=${APP_STL_LIB}                                                        \
		--install-dir=$${TOOLCHAIN};                                                \
	export PATH="$${TOOLCHAIN}/bin:$${PATH}";                                       \
	export TARGET_OS=OS_ANDROID_CROSSCOMPILE;                                       \
	export CPPFLAGS="$${CPPFLAGS} ${TARGET_CXXFLAGS_ADDON}";                        \
	export CFLAGS="$${CFLAGS} ${TARGET_CFLAGS_ADDON}";                              \
	CC=${CROSS_CC} ./configure --enable-static --disable-shared --host=${TARGET_HOST} \
		--prefix=${TOOLCHAIN} --with-png=no --with-harfbuzz=no  || exit 1;          \
	CC=${CROSS_CC} ANDROID_DEV=/tmp/ndk-${TARGET_HOST}-freetype $(MAKE) || exit 1;  \
	touch ${FREETYPE_TIMESTAMP};                                                    \
	touch ${FREETYPE_TIMESTAMP_INT};                                                \
	$(RM) -rf $${TOOLCHAIN};                                                        \
	else                                                                            \
		echo "nothing to be done for freetype";                                     \
	fi

clean_freetype :
	$(RM) -rf ${FREETYPE_DIR}

iconv_download :
	@if [ ! -d ${ICONV_DIR} ] ; then                                               \
		echo "iconv sources missing, downloading...";                              \
		mkdir -p ${ANDR_ROOT}/deps;                                                \
		cd ${ANDR_ROOT}/deps;                                                      \
		wget ${ICONV_URL_HTTP} || exit 1;                                          \
		tar -xzf libiconv-${ICONV_VERSION}.tar.gz || exit 1;                       \
		rm libiconv-${ICONV_VERSION}.tar.gz;                                       \
		mv libiconv-${ICONV_VERSION} libiconv;                                     \
		cd libiconv;                                                               \
		patch -p1 < ${ANDR_ROOT}/patches/libiconv_android.patch;                   \
		export TOOLCHAIN=/tmp/ndk-${TARGET_HOST}-iconv;                            \
		${ANDROID_NDK}/build/tools/make_standalone_toolchain.py                    \
			--arch ${TARGET_ARCH}                                                  \
			--api ${API}                                                           \
			--stl=${APP_STL_LIB}                                                   \
			--install-dir=$${TOOLCHAIN};                                           \
		./configure || exit 1;                                                     \
	fi

clean_iconv :
	$(RM) -rf ${ICONV_DIR}

irrlicht_download :
	@if [ ! -d "deps/irrlicht" ] ; then                                            \
		echo "irrlicht sources missing, downloading...";                           \
		mkdir -p ${ANDR_ROOT}/deps;                                                \
		cd deps;                                                                   \
		wget ${IRRLICHT_URL_HTTP} || exit 1;                                       \
		unzip ${IRRLICHT_COMMIT}.zip || exit 1;                                    \
		rm ${IRRLICHT_COMMIT}.zip;                                                 \
		mv irrlicht-${IRRLICHT_COMMIT} irrlicht;                                   \
		cd irrlicht;                                                               \
		mkdir -p lib/Android;                                                      \
		patch -p1 < ${ANDR_ROOT}/patches/irrlicht-touchcount.patch      || exit 1; \
		patch -p1 < ${ANDR_ROOT}/patches/irrlicht-back_button.patch     || exit 1; \
		patch -p1 < ${ANDR_ROOT}/patches/irrlicht-native_activity.patch || exit 1; \
		patch -p1 < ${ANDR_ROOT}/patches/irrlicht-roundingerror.patch   || exit 1; \
	fi

$(IRRLICHT_TIMESTAMP) : irrlicht_download
	@LAST_MODIF=$$(find ${IRRLICHT_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "); \
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then                         \
		touch ${IRRLICHT_TIMESTAMP};                                               \
	fi

irrlicht : $(IRRLICHT_LIB)

$(IRRLICHT_LIB): $(IRRLICHT_TIMESTAMP) $(FREETYPE_LIB)
	+@REFRESH=0;                                                                   \
	if [ ! -e ${IRRLICHT_TIMESTAMP_INT} ] ; then                                   \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ ! -e ${IRRLICHT_LIB} ] ; then                                             \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ ${IRRLICHT_TIMESTAMP} -nt ${IRRLICHT_TIMESTAMP_INT} ] ; then              \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ $$REFRESH -ne 0 ] ; then                                                  \
	mkdir -p ${IRRLICHT_DIR};                                                      \
	echo "changed timestamp for irrlicht detected building...";                    \
	cd deps/irrlicht/source/Irrlicht/Android;                                      \
	export APP_PLATFORM=${APP_PLATFORM};                                           \
	export TARGET_ABI=${TARGET_ABI};                                               \
	${ANDROID_NDK}/ndk-build                                                       \
		NDEBUG=${NDEBUG}                                                           \
		APP_PLATFORM=${APP_PLATFORM}                                               \
		TARGET_ABI=${TARGET_ABI}                                                   \
		APP_STL=${APP_STL}                                                         \
		COMPILER_VERSION=${COMPILER_VERSION}                                       \
		TARGET_CPPFLAGS_ADDON="${TARGET_CXXFLAGS_ADDON}"                           \
		TARGET_CFLAGS_ADDON="${TARGET_CFLAGS_ADDON}"                               \
		NDK_APPLICATION_MK=${ANDR_ROOT}/jni/Irrlicht.mk || exit 1;                 \
	touch ${IRRLICHT_TIMESTAMP};                                                   \
	touch ${IRRLICHT_TIMESTAMP_INT};                                               \
	else                                                                           \
		echo "nothing to be done for irrlicht";                                    \
	fi

clean_irrlicht :
	$(RM) -rf deps/irrlicht

$(CURL_TIMESTAMP) : curl_download
	@LAST_MODIF=$$(find ${CURL_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "); \
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then                         \
		touch ${CURL_TIMESTAMP};                                                   \
	fi

curl_download :
	@if [ ! -d "deps/curl" ] ; then                                                \
		echo "curl sources missing, downloading...";                               \
		mkdir -p ${ANDR_ROOT}/deps;                                                \
		cd deps;                                                                   \
		wget ${CURL_URL_HTTP} || exit 1;                                           \
		tar -xjf curl-${CURL_VERSION}.tar.bz2 || exit 1;                           \
		rm curl-${CURL_VERSION}.tar.bz2;                                           \
		mv curl-${CURL_VERSION} curl;                                              \
	fi

curl : $(CURL_LIB)

$(CURL_LIB): $(CURL_TIMESTAMP)
	@REFRESH=0;                                                                    \
	if [ ! -e ${CURL_TIMESTAMP_INT} ] ; then                                       \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ ! -e ${CURL_LIB} ] ; then                                                 \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ ${CURL_TIMESTAMP} -nt ${CURL_TIMESTAMP_INT} ] ; then                      \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ $$REFRESH -ne 0 ] ; then                                                  \
	mkdir -p ${CURL_DIR};                                                          \
	echo "changed timestamp for curl detected building...";                        \
	cd deps/curl;                                                                  \
	export TOOLCHAIN=/tmp/ndk-${TARGET_HOST}-curl;                                 \
	${ANDROID_NDK}/build/tools/make_standalone_toolchain.py                        \
		--arch ${TARGET_ARCH}                                                      \
		--api ${API}                                                               \
		--stl=${APP_STL_LIB}                                                       \
		--install-dir=$${TOOLCHAIN};                                               \
	export PATH="$${TOOLCHAIN}/bin:$${PATH}";                                      \
	export CC=${CROSS_CC};                                                         \
	export CXX=${CROSS_CXX};                                                       \
	export TARGET_OS=OS_ANDROID_CROSSCOMPILE;                                      \
	export CPPFLAGS="$${CPPFLAGS} ${TARGET_CXXFLAGS_ADDON}";                       \
	./configure --host=${TARGET_HOST} --enable-static --disable-shared             \
	--disable-debug --disable-verbose --disable-dependency-tracking --disable-ftp  \
	--disable-ldap --disable-ldaps --disable-rtsp --disable-proxy --disable-dict   \
	--disable-telnet --disable-tftp --disable-pop3 --disable-imap --disable-smtp   \
	--disable-gopher --disable-sspi --disable-manual;                              \
	$(MAKE) -s || exit 1;                                                          \
	touch ${CURL_TIMESTAMP};                                                       \
	touch ${CURL_TIMESTAMP_INT};                                                   \
	$(RM) -rf $${TOOLCHAIN};                                                       \
	else                                                                           \
		echo "nothing to be done for curl";                                        \
	fi

clean_curl :
	$(RM) -R ${CURL_DIR}

$(ASSETS_TIMESTAMP) : $(IRRLICHT_LIB)
	@mkdir -p ${ANDR_ROOT}/deps;                                                   \
	for DIRNAME in {builtin,client,doc,fonts,games,po,textures}; do                \
		LAST_MODIF=$$(find ${PROJ_ROOT}/$$DIRNAME -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "); \
		if [ $$(basename $$LAST_MODIF) != "timestamp" ]; then                      \
			touch ${PROJ_ROOT}/$$DIRNAME/timestamp;                                \
			touch ${ASSETS_TIMESTAMP};                                             \
			echo $$DIRNAME changed $$LAST_MODIF;                                   \
		fi;                                                                        \
	done;                                                                          \
	LAST_MODIF=$$(find ${IRRLICHT_DIR}/media -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "); \
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then                         \
		touch ${IRRLICHT_DIR}/media/timestamp;                                     \
		touch ${ASSETS_TIMESTAMP};                                                 \
	fi;                                                                            \
	if [ ${PROJ_ROOT}/multicraft.conf.example -nt ${ASSETS_TIMESTAMP} ] ; then     \
		echo "conf changed";                                                       \
		touch ${ASSETS_TIMESTAMP};                                                 \
	fi;                                                                            \
	if [ ${PROJ_ROOT}/README.txt -nt ${ASSETS_TIMESTAMP} ] ; then                  \
		touch ${ASSETS_TIMESTAMP};                                                 \
	fi;                                                                            \
	if [ ! -e $(ASSETS_TIMESTAMP) ] ; then                                         \
		touch $(ASSETS_TIMESTAMP);                                                 \
	fi

$(LUAJIT_TIMESTAMP) : luajit_download
	@LAST_MODIF=$$(find ${LUAJIT_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "); \
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then                         \
		touch ${LUAJIT_TIMESTAMP};                                                 \
	fi

luajit_download :
	@if [ ! -d ${LUAJIT_DIR} ] ; then                                              \
		echo "luajit sources missing, downloading...";                             \
		mkdir -p ${ANDR_ROOT}/deps;                                                \
		cd ${ANDR_ROOT}/deps;                                                      \
		git clone --branch ${LUAJIT_GIT_BRANCH} ${LUAJIT_URL_GIT} luajit || exit 1;\
	fi

luajit : $(LUAJIT_LIB)

$(LUAJIT_LIB): $(LUAJIT_TIMESTAMP)
	@REFRESH=0;                                                                    \
	if [ ! -e ${LUAJIT_TIMESTAMP_INT} ] ; then                                     \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ ${LUAJIT_TIMESTAMP} -nt ${LUAJIT_TIMESTAMP_INT} ] ; then                  \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ $$REFRESH -ne 0 ] ; then                                                  \
	mkdir -p ${LUAJIT_DIR};                                                        \
	export PATH=$$PATH:${ANDROID_NDK};                                             \
	echo "changed timestamp for luajit detected building...";                      \
	cd ${LUAJIT_DIR};                                                              \
	export TOOLCHAIN=/tmp/ndk-${TARGET_HOST}-luajit;                               \
	${ANDROID_NDK}/build/tools/make_standalone_toolchain.py                        \
		--arch ${TARGET_ARCH}                                                      \
		--api ${API}                                                               \
		--stl=${APP_STL_LIB}                                                       \
		--install-dir=$${TOOLCHAIN};                                               \
	export PATH="$${TOOLCHAIN}/bin:$${PATH}";                                      \
	export TARGET_FLAGS="${TARGET_CFLAGS_ADDON} -fno-fast-math";                   \
	$(MAKE) CROSS=${CROSS_PREFIX}-  TARGET_CC=${CROSS_PREFIX}-clang                \
	XCFLAGS="-DLUAJIT_DISABLE_FFI" HOST_CC=${HOST_CC} BUILDMODE=static;            \
	touch ${LUAJIT_TIMESTAMP};                                                     \
	touch ${LUAJIT_TIMESTAMP_INT};                                                 \
	$(RM) -rf $${TOOLCHAIN};                                                       \
	else                                                                           \
		echo "nothing to be done for luajit";                                      \
	fi

clean_luajit:
	$(RM) -R deps/luajit

assets : $(ASSETS_TIMESTAMP)
	@REFRESH=0;                                                                    \
	if [ ! -e ${ASSETS_TIMESTAMP}.old ] ; then                                     \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ ${ASSETS_TIMESTAMP} -nt ${ASSETS_TIMESTAMP}.old ] ; then                  \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ ! -e ${APP_ROOT}/assets ] ; then                                          \
		REFRESH=1;                                                                 \
	fi;                                                                            \
	if [ $$REFRESH -ne 0 ] ; then                                                  \
	echo "assets changed, refreshing...";                                          \
	$(MAKE) clean_assets;                                                          \
	mkdir -p ${APP_ROOT}/assets/MultiCraft;                                        \
	cp -r ${PROJ_ROOT}/builtin ${APP_ROOT}/assets/MultiCraft;                      \
	mkdir ${APP_ROOT}/assets/MultiCraft/fonts;                                     \
	cp -r ${PROJ_ROOT}/fonts/retrovillenc.ttf ${APP_ROOT}/assets/MultiCraft/fonts/; \
	cp -r ${PROJ_ROOT}/games ${APP_ROOT}/assets/MultiCraft;                        \
	mkdir -p ${APP_ROOT}/assets/MultiCraft/locale;                                 \
	pushd ${PROJ_ROOT}/po;                                                         \
	for lang in *; do                                                              \
		[ $${#lang} -ne 2 ] && continue;                                           \
		MOPATH=${APP_ROOT}/assets/MultiCraft/locale/$$lang/LC_MESSAGES;            \
		mkdir -p $$MOPATH;                                                         \
		pushd $$lang;                                                              \
		for fn in *.po; do                                                         \
			newfn=$${fn/.po/.mo};                                                  \
			msgfmt -o $$MOPATH/$$newfn $$fn;                                       \
		done;                                                                      \
		popd;                                                                      \
	done;                                                                          \
	popd;                                                                          \
	cp -r ${PROJ_ROOT}/textures ${APP_ROOT}/assets/MultiCraft;                     \
	cp -r ${PROJ_ROOT}/worlds ${APP_ROOT}/assets/MultiCraft;                       \
	cd ${APP_ROOT}/assets ||  exit 1;                                              \
	find . -name "timestamp" -exec rm {} \; ;                                      \
	find . -name "*.blend" -exec rm {} \; ;                                        \
	find . -name "*~" -exec rm {} \; ;                                             \
	find . -type d -path "*.git" -exec rm -rf {} \; ;                              \
	find . -type d -path "*.svn" -exec rm -rf {} \; ;                              \
	find . -type f -path "*.gitignore" -exec rm -rf {} \; ;                        \
	cd MultiCraft;                                                                 \
	ls -R | grep ":$$" | sed -e 's/:$$//' -e 's/\.//' -e 's/^\///' > ../index.txt; \
	find -L . | cut -c 3- > ../filelist.txt;                                       \
	echo "Creating worlds.zip";                                                    \
	zip -r ../worlds.zip worlds;                                                   \
	echo "Creating games.zip";                                                     \
	zip -r ../games.zip games;                                                     \
	rm -r worlds games;                                                            \
	echo "Creating Files.zip";                                                     \
	zip -r ../Files.zip *;                                                         \
	cp ${ASSETS_TIMESTAMP} ${ASSETS_TIMESTAMP}.old;                                \
	else                                                                           \
		echo "nothing to be done for assets";                                      \
	fi

clean_assets :
	@$(RM) -r ${APP_ROOT}/assets

apk: local.properties $(IRRLICHT_LIB) $(CURL_LIB) $(LEVELDB_LIB) $(LUAJIT_LIB)    \
	$(OPENAL_LIB) $(VORBIS_LIB) prep_srcdir iconv_download assets
	+@${ANDROID_NDK}/ndk-build                                                    \
		APP_STL=${APP_STL} COMPILER_VERSION=${COMPILER_VERSION}                   \
		APP_PLATFORM=${APP_PLATFORM} TARGET_ABI=${TARGET_ABI} || exit 1;          \
	if [ ! -e ${APP_ROOT}/jniLibs ]; then                                         \
		ln -s ${ANDR_ROOT}/libs ${APP_ROOT}/jniLibs || exit 1;                    \
	fi;                                                                           \
	export BUILD_TYPE_C=$$(echo "$${BUILD_TYPE}" | sed 's/./\U&/') &&             \
	./gradlew assemble$$BUILD_TYPE_C &&                                           \
	echo "APK stored at: build/outputs/apk/MultiCraft-$$BUILD_TYPE.apk" &&        \
	echo "You can install it with \'make install_$$BUILD_TYPE\'"

install_debug:
	${ANDROID_SDK}/platform-tools/adb install -r build/outputs/apk/MultiCraft-debug.apk

install_release:
	${ANDROID_SDK}/platform-tools/adb install -r build/outputs/apk/MultiCraft-release.apk

prep_srcdir :
	@if [ ! -e ${ANDR_ROOT}/jni/src ]; then                                       \
		ln -s ${PROJ_ROOT}/src ${ANDR_ROOT}/jni/src;                              \
	fi;                                                                           \
	if [ ! -e ${ANDR_ROOT}/jni/lib ]; then                                        \
		ln -s ${PROJ_ROOT}/lib ${ANDR_ROOT}/jni/lib;                              \
	fi

clean_apk :
	./gradlew clean

clean_all :
	@$(MAKE) clean_apk;                                                           \
	$(MAKE) clean_assets;                                                         \
	sleep 1;                                                                      \
	$(RM) -r gen libs obj deps bin Debug and_env jni/src

clean_src :
	$(RM) -r gen libs obj bin Debug and_env jni/src

clean : clean_apk clean_assets
