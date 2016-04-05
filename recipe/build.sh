#!/bin/bash

if [[ `uname` == 'Darwin' ]]; then
    export MACOSX_VERSION_MIN="10.7"
    export CXXFLAGS="-mmacosx-version-min=${MACOSX_VERSION_MIN}"
    export CXXFLAGS="${CXXFLAGS} -stdlib=libc++ -std=c++11"
    export LINKFLAGS="-mmacosx-version-min=${MACOSX_VERSION_MIN}"
    export LINKFLAGS="${LINKFLAGS} -stdlib=libc++ -std=c++11 -L${LIBRARY_PATH}"
else
    export CXXFLAGS="-pthread -std=c++11 ${CXXFLAGS}"
fi

if [[ $(uname) == 'Darwin' ]]; then
  export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
elif [[ $(uname) == 'Linux' ]]; then
  export LIBRARY_SEARCH_VAR=LD_LIBRARY_PATH
fi

# See https://taskman.eionet.europa.eu/issues/14817.
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  ARCH="-m64"
elif [ ${MACHINE_TYPE} == 'x86_32' ]; then
  ARCH="-m32"
else
  ARCH=""
fi

CFLAGS=${ARCH} CPPFLAGS=${ARCH} CXXFLAGS=${ARCH} LDFLAGS=${ARCH} FFLAGS=${ARCH} \
    ./configure --prefix=$PREFIX --without-jni

make
eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make check
make install
