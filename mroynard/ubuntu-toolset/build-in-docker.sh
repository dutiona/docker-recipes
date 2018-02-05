#!/bin/bash

set -e

BUILD_GENERATOR="Unix Makefiles"
BUILD_DIR="build-in-docker"
SOURCE_DIR=".."
BUILD_COMPILER="gcc"
BUILD_TARGET="all"
BUILD_TYPE="Debug"
FORCE=""
VERBOSE=""
UNDERLYING_ARGS=""
USAGE="$(basename "$0") [OPTIONS] -- execute a build toolchain

where:
    -h --help                       show this help text
    -c --compiler gcc|clang         select the compiler to use
                                    default = gcc
    -g --cmake-generator Generator  use provided cmake generator
                                    default = Unix Makefiles
    -d --build-directory Directory  use provided build directory for build artifacts (on host)
                                    default = build-in-docker
    -s --source-directory Directory use provided source directory to compile
                                    default = ..
    -t --target Target              build target passed to the generated toolchain (make target)
                                    default = all
    -r --release-type ReleaseType             build type. Release|Debug|RelWithDebInfo|MinSizeRel
                                    default = Debug

    -v --verbose                    if passed, enable verbose to underlying commands

    -f --force                      empty build directory to force a full rebuild
    
    --                              end of arguments for script, pass the rest to cmake
    "

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -h|--help)
    echo "$USAGE"
    exit
    ;;
    -f|--force)
    FORCE="--force"
    shift
    ;;
    -v|--verbose)
    VERBOSE="--verbose"
    shift
    ;;
    -c|--compiler)
    BUILD_COMPILER="$2"
    shift 2
    ;;
    -g|--cmake-generator)
    BUILD_GENERATOR="$2"
    shift 2
    ;;
    -d|--build-directory)
    BUILD_DIR="$2"
    shift 2
    ;;
    -s|--source-directory)
    SOURCE_DIR="$2"
    shift 2
    ;;
    -t|--target)
    BUILD_TARGET="$2"
    shift 2
    ;;
    -r|--release-type)
    BUILD_TYPE="$2"
    shift 2
    ;;
    --)
    shift
    ;;
    *)
    UNDERLYING_ARGS="$UNDERLYING_ARGS $1"
    shift
    ;;
esac
done

docker run --rm \
    -it \
    --name docker-builder \
    --mount type=bind,source="$(pwd)",target=/workspace \
    mroynard/ubuntu-toolset:latest \
        $VERBOSE \
        $FORCE \
        -c $BUILD_COMPILER \
        -g $BUILD_GENERATOR \
        -d $BUILD_DIR \
        -s $SOURCE_DIR \
        -t $BUILD_TARGET \
        -r $BUILD_TYPE \
        -- $UNDERLYING_ARGS
