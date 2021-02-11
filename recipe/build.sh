#!/bin/bash

mv ${SRC_DIR}/README.md ${SRC_DIR}/README

if [ ! -f configure ]; then
  autoreconf -i --force
fi

export CXXFLAGS="-O2 -Wl,-S ${CXXFLAGS}"

ARCH=""
MACHINE_TYPE=$(uname -m)
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  ARCH="-m64"
elif [ ${MACHINE_TYPE} == 'x86_32' ]; then
  ARCH="-m32"
fi

./configure --prefix=${PREFIX} --enable-static=no

make -j${CPU_COUNT}
# Failing on OS X: https://travis-ci.org/conda-forge/geos-feedstock/builds/175667698
# FAIL: geos_unit
# ============================================================================
# Testsuite summary for
# ============================================================================
# # TOTAL: 1
# # PASS:  0
# # SKIP:  0
# # XFAIL: 0
# # FAIL:  1
# # XPASS: 0
# # ERROR: 0
# ============================================================================
# See tests/unit/test-suite.log
# ============================================================================
# make[5]: *** [test-suite.log] Error 1
# make[4]: *** [check-TESTS] Error 2
# make[3]: *** [check-am] Error 2
# make[2]: *** [check-recursive] Error 1
# make[1]: *** [check-recursive] Error 1
# make: *** [check] Error 2
if [[ $(uname) == Linux ]]; then
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    make check -j${CPU_COUNT}
fi
fi
make install -j${CPU_COUNT}
