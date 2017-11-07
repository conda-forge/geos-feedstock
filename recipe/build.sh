#!/bin/bash

mv $SRC_DIR/README.md $SRC_DIR/README

if [ ! -f configure ]; then
  autoreconf -i --force
fi

export CFLAGS="-O2 -Wl,-S $CFLAGS"

ARCH=""
MACHINE_TYPE=$(uname -m)
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  ARCH="-m64"
elif [ ${MACHINE_TYPE} == 'x86_32' ]; then
  ARCH="-m32"
fi

./configure --prefix=$PREFIX

make -j${CPU_COUNT} ${VERBOSE_AT}
make check -j${CPU_COUNT} ${VERBOSE_AT}
make install -j${CPU_COUNT} ${VERBOSE_AT}
