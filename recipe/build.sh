#!/bin/bash

mkdir -p build && cd build

cmake ${CMAKE_ARGS} \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=${PREFIX} \
      -D CMAKE_INSTALL_LIBDIR=lib \
      -D BUILD_SHARED_LIBS=ON \
      ${SRC_DIR}

make -j${CPU_COUNT} ${VERBOSE_CM}

CTEST_EXCLUDE=""
if [[ "${OSX_ARCH}" = "x86_64" ]]; then
    # See https://github.com/libgeos/geos/issues/930
    CTEST_EXCLUDE="--exclude-regex unit-geom-Envelope"
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    ctest --output-on-failure ${CTEST_EXCLUDE}
fi

make install -j${CPU_COUNT}
