#!/bin/bash

mkdir -p build && cd build

cmake ${CMAKE_ARGS} \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=${PREFIX} \
      -D CMAKE_INSTALL_LIBDIR=lib \
      -D BUILD_SHARED_LIBS=ON \
      ${SRC_DIR}

make -j${CPU_COUNT} ${VERBOSE_CM}

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    ctest --output-on-failure
fi

make install -j${CPU_COUNT}
