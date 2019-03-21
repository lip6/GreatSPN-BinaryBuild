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

export IDIR=$(pwd)/usr/local
export PATH=$IDIR/bin:$PATH


if [ ! -d GreatSPN ]; 
then
	mkdir GreatSPN	
fi

cd GreatSPN

if [ ! -f $IDIR/lib/libgmp.a ];
then
	wget --progress=dot:mega ftp://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2 ; 
	tar xjf gmp-6.1.2.tar.bz2 ; 
	cd gmp-6.1.2 ; 
	./configure --enable-cxx --prefix=$IDIR/ ; 
	make -j ; make install ; 
	cd .. ;     
fi

if [ ! -f $IDIR/include/meddly.h ];
then
	git clone --depth 1 https://github.com/yanntm/meddly.git --branch master --single-branch meddly
	cd meddly
	./autogen.sh
	./configure --prefix=$IDIR/  || cat config.log
	make && make install
	cd ..
fi


if [ ! -f $IDIR/include/lp_lib.h ];
then
	tar xzf ../lp_solve_5.5.2.5_source.tar.gz 
	cd lp_solve_5.5/lpsolve55
	autoreconf -vfi
	cat ccc | sed 's/c=cc/c=$CC/g' > ccc2
	sh ccc2
	mkdir -p $IDIR/lib ; cp bin/ux64/liblpsolve55.* $IDIR/lib/	
	cd ..
	mkdir -p $IDIR/include/ ; cp *.h $IDIR/include/	
	cd ..
fi

if [ ! -f $IDIR/bin/byacc ];
then
    wget --progress=dot:mega https://invisible-island.net/datafiles/release/byacc.tar.gz
    tar xzf byacc.tar.gz
    rm -f byacc.tar.gz
    cd byacc*
    ./configure --prefix=$IDIR/
    make
    make install
    cp $IDIR/bin/yacc $IDIR/bin/byacc
    cd ..
fi

if [ ! -f $IDIR/include/FlexLexer.h ];
then
    wget --progress=dot:mega https://github.com/westes/flex/files/981163/flex-2.6.4.tar.gz
    tar xzf flex*.tar.gz
    rm -f flex*.tar.gz
    cd flex*
    ./configure --prefix=$IDIR/
    make
    make install
    cd ..
fi


git clone --depth 1 https://github.com/yanntm/SOURCES.git --branch master --single-branch SOURCES/
cd SOURCES
# cp -f ../../patches/Makefile .
export CFLAGS="-O2 -Wall -Wno-unused-variable -Wno-unused-function -I$IDIR/include"
export CPPFLAGS="-O2 -Wall -Wno-unused-variable -Wno-unused-function -I$IDIR/include"
export LDFLAGS="-O2 -L$IDIR/lib"
export BYACCDIR=$IDIR/bin/
make 

for i in bin/* ; do strip -s $i ; done ;
tar czf ../../website/greatspn_linux.tar.gz bin/

ls -lah ../../website

cd ../..
 


