#!/bin/bash -e

CURR_DIR=$(dirname $(realpath $0))
ROOT_DIR=$(dirname ${CURR_DIR})
unset CURR_DIR

DEPOT_TOOLS_DIR="${ROOT_DIR}/scripts/depot_tools"
V8_DIR="${ROOT_DIR}/v8"
DIST_DIR="${ROOT_DIR}/dist"
PATCHES_DIR="${ROOT_DIR}/patches"

V8_VERSION="9.7.106.13"
NDK_VERSION="r22b"
NDK_MAJOR_VERSION=$(echo $NDK_VERSION | sed 's/[a-zA-Z]//g')
NDK_API_LEVEL="17"
NDK_64_API_LEVEL="21"
IOS_DEPLOYMENT_TARGET="9"
ANDROID_SDK_PLATFORM_VERSION="30"
ANDROID_SDK_BUILD_TOOLS_VERSION="30.0.2"
ANDROID_NDK="${ANDROID_NDK_HOME:-"${V8_DIR}/android-ndk-${NDK_VERSION}"}"

export PATH="$DEPOT_TOOLS_DIR:$PATH"
