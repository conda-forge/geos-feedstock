#!/bin/bash

# FIXME: This is a hack to make sure the environment is activated.
# The reason this is required is due to the conda-build issue
# mentioned below.
#
# https://github.com/conda/conda-build/issues/910
#
source activate "${CONDA_DEFAULT_ENV}"

# Problems with cartopy if the -m{32,64} flag is not defined.
# See https://taskman.eionet.europa.eu/issues/14817.
# - toolchain now defines this so we don't need to do anything

if [ "$(uname)" == "Darwin" ]
then
  export CXX="${CXX} -stdlib=libc++"
fi

./configure --prefix=$PREFIX

make

# Failing on OS X: https://travis-ci.org/conda-forge/geos-feedstock/builds/119038524
if [[ $(uname) == Linux ]]; then
    make check
fi

make install
