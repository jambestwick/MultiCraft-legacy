#!/bin/bash -e

. sdk.sh
CURL_VERSION=7.71.1

if [ ! -d libcurl-src ]; then
	wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz
	tar -xzvf curl-$CURL_VERSION.tar.gz
	mv curl-$CURL_VERSION libcurl-src
	rm curl-$CURL_VERSION.tar.gz
fi

cd libcurl-src

# build once for armv7, once for arm64
for x in armv7 arm64; do
	if [ $x = armv7 ]; then
		CURL_CFLAGS="-arch armv7 $IOS_FLAGS_NOARCH"
	else
		CURL_CFLAGS="-arch arm64 -arch arm64e $IOS_FLAGS_NOARCH"
	fi
	CFLAGS="$CURL_CFLAGS" \
	./configure --host=arm-apple-darwin --prefix=/ --disable-shared --enable-static \
		--disable-debug --disable-verbose --disable-versioned-symbols \
		--enable-hidden-symbols --disable-dependency-tracking \
		--disable-ares --disable-cookies --disable-crypto-auth --disable-manual \
		--disable-proxy --disable-unix-sockets --without-libidn --without-librtmp \
		--without-ssl --disable-ftp --disable-ldap --disable-ldaps --disable-rtsp \
		--disable-dict --disable-telnet --disable-tftp --disable-pop3 \
		--disable-imap --disable-smtp --disable-gopher --disable-sspi \
		--disable-libcurl-option
	make -j
	cp -f lib/.libs/libcurl.a templib_$x.a
	make clean >/dev/null || true
done

mkdir -p ../libcurl
cp -rf include ../libcurl/include

# merge libraries
mkdir -p ../libcurl/lib
lipo -create templib_*.a -output ../libcurl/lib/libcurl.a
rm templib_*.a

echo "libcurl build successful"
