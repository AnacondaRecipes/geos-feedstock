#!/bin/bash

export CMAKE_POLICY_VERSION_MINIMUM=3.5

mkdir -p build && cd build

cmake ${CMAKE_ARGS} \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=${PREFIX} \
      -D CMAKE_INSTALL_LIBDIR=lib \
      -D BUILD_SHARED_LIBS=ON \
      ${SRC_DIR}

make -j${CPU_COUNT} ${VERBOSE_CM}

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    export DYLD_FALLBACK_LIBRARY_PATH="$BUILD_PREFIX/lib:$PREFIX/lib${DYLD_FALLBACK_LIBRARY_PATH:+:$DYLD_FALLBACK_LIBRARY_PATH}"
    ctest --output-on-failure
fi

make install -j${CPU_COUNT}
