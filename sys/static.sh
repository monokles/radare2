#!/bin/sh

MAKE=make
gmake --help >/dev/null 2>&1
[ $? = 0 ] && MAKE=gmake

# find root
cd `dirname $PWD/$0` ; cd ..

ccache --help > /dev/null 2>&1
if [ $? = 0 ]; then
	[ -z "${CC}" ] && CC=gcc
	CC="ccache ${CC}"
	export CC
fi
PREFIX=/usr
if [ -n "$1" ]; then
	PREFIX="$1"
fi
DOBUILD=1
if [ 1 = "${DOBUILD}" ]; then
	# build
	if [ -f config-user.mk ]; then
		${MAKE} mrproper > /dev/null 2>&1
	fi
	export CFLAGS="-fPIC -pie -D__ANDROID__=1"
	./configure-plugins
	./configure --prefix=$PREFIX --with-nonpic --without-pic
fi
${MAKE} -j 8
