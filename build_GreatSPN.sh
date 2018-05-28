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

if [ ! -f $IDIR/lib/libgmp.a ];
then
	wget --progress=dot:mega https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2 ; 
	tar xjf gmp-6.1.2.tar.bz2 ; 
	cd gmp-6.1.2 ; 
	./configure --enable-cxx --prefix=$IDIR ; 
	make -j ; make install ; 
	cd .. ;     
fi

if [ ! -f $IDIR/include/lp_lib.h ];
then
	tar xzf ../lp_solve_5.5.2.5_source.tar.gz 
	cd lp_solve_5.5/lpsolve55
	sh ccc
	mkdir -p $IDIR/bin ; cp bin/ux64/liblpsolve55.* $IDIR/bin/	
	cd ..
	mkdir -p $IDIR/include/ ; cp *.h $IDIR/include/	
	cd ..
fi


git clone --depth 1 https://github.com/GreatSPN/SOURCES.git --branch master --single-branch SOURCES/
cd SOURCES
cp -f ../../patches/Makefile .
export CFLAGS="-O2 -Wall -Wno-unused-variable -Wno-unused-function -I$IDIR/include"
export CPPFLAGS="-O2 -Wall -Wno-unused-variable -Wno-unused-function -I$IDIR/include"
export LDFLAGS="-O2 -L$IDIR/lib"
make




