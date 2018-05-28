#! /bin/bash

set -x


# an IDIR = install folder
if [ ! -d usr/local ]; 
then
	mkdir usr
	cd usr
	mkdir local
	cd local
	export IDIR=$(pwd)
	cd ../..
fi


if [ ! -d GreatSPN ]; 
then
	mkdir GreatSPN
	cd GreatSPN
fi

if [ ! -f usr/local/include/meddly.h ];
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
make



