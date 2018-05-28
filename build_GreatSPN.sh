#! /bin/bash

set -x


# an IDIR = install folder
mkdir usr
cd usr
mkdir local
cd local
export IDIR=$(pwd)
cd ../..


mkdir GreatSPN
cd GreatSPN

git clone --depth 1 https://github.com/asminer/meddly.git --branch master --single-branch meddly
cd meddly
./autogen.sh
./configure --prefix=$IDIR  || cat config.log
make && make install
cd ..


git clone --depth 1 https://github.com/GreatSPN/SOURCES.git --branch master --single-branch SOURCES/
cd SOURCES
make



