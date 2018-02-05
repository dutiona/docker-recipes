#!/bin/bash

set -e

BUILD_DIRECTORY="build-in-docker"
CMAKE_GENERATOR="Unix Makefiles"
COMPILER="gcc"
FORCE=""
RELEASE_TYPE="Debug"
SOURCE_DIRECTORY=".."
TARGET="all"
TOOLCHAIN_ARGS=""
VERBOSE=""
USAGE="$(basename "$0") [OPTIONS] -- execute a build toolchain

where:
    -h --help                       show this help text
    -c --compiler gcc|clang         select the compiler to use
                                    default = gcc
    -g --cmake-generator Generator  use provided cmake generator
                                    default = Unix Makefiles
    -b --build-directory Directory  use provided build directory for build artifacts (on host)
                                    default = build-in-docker
    -s --source-directory Directory use provided source directory to compile
                                    default = ..
    -t --target Target              build target passed to the generated toolchain (make target)
                                    default = all
    -r --release-type ReleaseType   build type. Release|Debug|RelWithDebInfo|MinSizeRel
                                    default = Debug

    -v --verbose                    if passed, enable verbose to underlying commands

    -f --force                      empty build directory to force a full rebuild
    
    --                              end of arguments for script, pass the rest to the toolchain via cmake
                                    useful for passing -D arguments
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
    COMPILER="$2"
    shift 2
    ;;
    -g|--cmake-generator)
    CMAKE_GENERATOR="$2"
    shift 2
    ;;
    -b|--build-directory)
    BUILD_DIRECTORY="$2"
    shift 2
    ;;
    -s|--source-directory)
    SOURCE_DIRECTORY="$2"
    shift 2
    ;;
    -t|--target)
    TARGET="$2"
    shift 2
    ;;
    -r|--release-type)
    RELEASE_TYPE="$2"
    shift 2
    ;;
    --)
    shift
    ;;
    *)
    TOOLCHAIN_ARGS="$TOOLCHAIN_ARGS $1"
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
        -c $COMPILER \
        -g $CMAKE_GENERATOR \
        -b $BUILD_DIRECTORY \
        -s $SOURCE_DIRECTORY \
        -t $TARGET \
        -r $RELEASE_TYPE \
        -- $TOOLCHAIN_ARGS
