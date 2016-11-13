#!/bin/bash

mv $SRC_DIR/README.md $SRC_DIR/README

if [ ! -f configure ]; then
  autoreconf -i --force
fi

ARCH=""
MACHINE_TYPE=$(uname -m)
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  ARCH="-m64"
elif [ ${MACHINE_TYPE} == 'x86_32' ]; then
  ARCH="-m32"
fi

if [ $(uname) == Darwin ]; then
  export CC=clang
  export CXX=clang++
  export MACOSX_DEPLOYMENT_TARGET="10.9"
  export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
  export CXXFLAGS="$CXXFLAGS -stdlib=libc++"
fi


./configure --prefix=$PREFIX

make
make check
make install
