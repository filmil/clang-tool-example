#! /bin/bash

# It is 2021 and we're still compiling using bash scripts.

LLVM_BUILD_DIR=${HOME}/code/llvm/build
LLVM_INSTALL_DIR=${HOME}/code/llvm/installation

SOURCE_DIR=${HOME}/code/clang-tool/clang-tool-example
BUILD_DIR=${HOME}/code/clang-tool/build

cd ${BUILD_DIR}

cmake \
  -G Ninja \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_CXX_STANDARD=14 \
  -DCMAKE_CXX_EXTENSIONS=OFF \
  -DCMAKE_CXX_STANDARD_REQUIRED=ON \
  -DLLVM_DIR=${LLVM_INSTALL_DIR}/lib/cmake/llvm \
  ../clang-tool-example

ln -fs ${BUILD_DIR}/compile_commands.json ${SOURCE_DIR}

ninja
