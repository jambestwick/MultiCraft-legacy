#!/bin/bash -e

. sdk.sh
CURL_VERSION=7.65.3

if [ ! -d libcurl-src ]; then
	wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz
	tar -xzvf curl-$CURL_VERSION.tar.gz
	mv curl-$CURL_VERSION libcurl-src
	rm curl-$CURL_VERSION.tar.gz
fi

cd libcurl-src

# build once for armv7, once for arm64
for x in arm64 armv7; do
	make distclean >/dev/null || true
	CC=$IOS_CC CFLAGS=${IOS_FLAGS_LUA/-arch $x/} \
	./configure --host=arm-apple-darwin --prefix=/ --disable-shared --enable-static \
		--disable-debug --disable-verbose --disable-versioned-symbols \
		--enable-hidden-symbols --disable-dependency-tracking \
		--disable-ares --disable-cookies --disable-crypto-auth --disable-manual \
		--disable-proxy --disable-unix-sockets --without-libidn --without-librtmp \
		--without-ssl --disable-ftp --disable-ldap --disable-ldaps --disable-rtsp \
		--disable-dict --disable-telnet --disable-tftp --disable-pop3 \
		--disable-imap --disable-smtp --disable-gopher --disable-sspi
	make -j$(sysctl -n hw.ncpu)
	cp -f lib/.libs/libcurl.a templib_$x.a
done

mkdir -p ../libcurl
make DESTDIR=$PWD/../libcurl install
# merge libraries
rm ../libcurl/lib/libcurl.a
lipo templib_*.a -create -output ../libcurl/lib/libcurl.a

echo "libcurl build successful"
