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

if [ ! -d $IDIR/include/lpsolve ];
then
	tar xzf ../lp_solve_5.5.2.5_source.tar.gz 
	cd lp_solve_5.5/lpsolve55
	sh ccc
	mkdir -p $IDIR/bin ; cp bin/ux64/liblpsolve55.* $IDIR/bin/	
	cd ..
	mkdir -p $IDIR/include/lpsolve ; cp *.h $IDIR/include/lpsolve/	
	cd ..
fi


git clone --depth 1 https://github.com/GreatSPN/SOURCES.git --branch master --single-branch SOURCES/
cd SOURCES
cp -f ../../patches/Makefile .
export CFLAGS="-O2 -Wall -Wno-unused-variable -I$IDIR/include"
export CPPFLAGS="-O2 -Wall -Wno-unused-variable -I$IDIR/include"
export LDFLAGS="-O2 -L$IDIR/lib"
make




