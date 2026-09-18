#!/bin/bash

if [[ "${OSX_ARCH}" = "x86_64" ]]; then
    # allow newer C++ symbols
    # https://conda-forge.org/docs/maintainer/knowledge_base/#newer-c-features-with-old-sdk
    export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

# Note that CMAKE_ARGS defines: CMAKE_BUILD_TYPE, CMAKE_INSTALL_PREFIX, CMAKE_INSTALL_LIBDIR, etc.
cmake ${CMAKE_ARGS} \
      -G Ninja \
      -D BUILD_SHARED_LIBS=ON \
      -D BUILD_TESTING=ON \
      -S ${SRC_DIR} -B build

cmake --build build

CTEST_EXCLUDE=""
if [[ "${OSX_ARCH}" = "x86_64" ]]; then
    # See https://github.com/libgeos/geos/issues/930
    CTEST_EXCLUDE="--exclude-regex unit-geom-Envelope"
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    (cd build && ctest --output-on-failure ${CTEST_EXCLUDE})
fi

cmake --install build
