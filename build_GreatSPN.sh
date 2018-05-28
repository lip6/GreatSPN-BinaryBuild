#! /bin/bash

set -x


# an IDIR = install folder
if [ ! -d usr/local ]; 
then
	mkdir usr
	cd usr
	mkdir local
	cd ..
fi

export IDIR=$(pwd)/usr/local/


if [ ! -d GreatSPN ]; 
then
	mkdir GreatSPN	
fi

cd GreatSPN

if [ ! -f $IDIR/include/meddly.h ];
then
	git clone --depth 1 https://github.com/asminer/meddly.git --branch master --single-branch meddly
	cd meddly
	./autogen.sh
	./configure --prefix=$IDIR  || cat config.log
	make && make install
	cd ..
fi


git clone --depth 1 https://github.com/GreatSPN/SOURCES.git --branch master --single-branch SOURCES/
cd SOURCES
cp -f ../../patches/Makefile .
export CFLAGS="-o2 -Wall -I$IDIR/include"
export CPPFLAGS="-o2 -Wall -I$IDIR/include"
export LDFLAGS="-o2 -L$IDIR/lib"
make



