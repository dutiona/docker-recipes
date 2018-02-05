#!/bin/bash

set -e

BUILD_GENERATOR="Unix Makefiles"
BUILD_DIR="build-in-docker"
SOURCE_DIR=".."
BUILD_COMPILER="gcc"
BUILD_TARGET="all"
BUILD_TYPE="Debug"
BUILD_CMAKE_ARGUMENTS=""
BUILD_TOOLCHAIN_ARGUMENTS=""
VERBOSE=""
USAGE="$(basename "$0") [OPTIONS] -- execute a build toolchain

where:
    -h --help                       show this help text
    -c --compiler gcc|clang         select the compiler to use
                                    default = gcc
    -g --cmake-generator Gen        use provided cmake generator
                                    default = Unix Makefiles
    -d --build-directory Dir        use provided build directory for build artifacts (on host)
                                    default = build-in-docker
    -s --source-directory Dir       use provided source directory to compile
                                    default = ..
    -t --target                     build target passed to the generated toolchain (make target)
                                    default = all
    -v --verbose                    if passed, enable verbose to underlying commands
    
    --cmake-arguments=(args...)     arguments to pass to cmake (-D...)

    --toolchain-arguments=(args...) argumennts to pass to underlying toolchain (passed after --)
                                    passing -j4 here will result in cmake --build ... -- -j4
    "

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -h|--help)
    echo "$USAGE"
    exit
    ;;
    -c|--compiler)
    BUILD_COMPILER="$2"
    shift
    shift
    ;;
    -g|--cmake-generator)
    BUILD_GENERATOR="$2"
    shift
    shift
    ;;
    -d|--build-directory)
    BUILD_DIR="$2"
    shift
    shift
    ;;
    -s|--source-directory)
    SOURCE_DIR="$2"
    shift
    shift
    ;;
    -t|--target)
    BUILD_TARGET="$2"
    shift
    shift
    ;;
    -r|--release-type)
    BUILD_TYPE="$2"
    shift
    shift
    ;;
    -v|--verbose)
    VERBOSE="VERBOSE=1"
    shift
    ;;
    --cmake-arguments=*)
    BUILD_CMAKE_ARGUMENTS="${i#*=}"
    shift
    shift
    ;;
    --toolchain-arguments=*)
    BUILD_TOOLCHAIN_ARGUMENTS="${i#*=}"
    shift
    shift
    ;;
    *)
    POSITIONAL+=("$1")
    shift
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

docker run --rm \
    -it \
    --name docker-builder \
    --mount type=bind,source="$(pwd)",target=/app \
    mroynard/ubuntu-toolset:latest \
    #build-dispatch \
    #    -c "$BUILD_COMPILER" \
    #    -g "$BUILD_GENERATOR" \
    #    -d "$BUILD_DIR" \
    #    -s "$SOURCE_DIR" \
    #    -t "$BUILD_TARGET" \
    #    -r "$BUILD_TYPE" \
    #    --cmake-arguments="$BUILD_CMAKE_ARGUMENTS" \
    #    --toolchain-arguments="$BUILD_TOOLCHAIN_ARGUMENTS"
    #    #--cmake-arguments=-DWITH_EXAMPLES=ON -DWITH_BENCHMARK=ON
