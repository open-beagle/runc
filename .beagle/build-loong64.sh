#!/usr/bin/env bash

set -ex

export BUILD_VERSION=${BUILD_VERSION:-"1.2.3-beagle"}
export BUILD_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || true)

export GOARCH=loong64
export CC=loongarch64-linux-gnu-gcc
export STRIP=loongarch64-linux-gnu-strip
export LD_LIBRARY_PATH=$PWD/release/libseccomp/loong64/lib
export PKG_CONFIG_PATH=$PWD/release/libseccomp/loong64/lib/pkgconfig
export TARGETPLATFORM=linux/$GOARCH

git config --global --add safe.directory $PWD

mkdir -p release
sed -i "s/open-beagle\/libseccomp\/.tmp/opencontainers\/runc\/release\/libseccomp/g" $PKG_CONFIG_PATH/libseccomp.pc

## loong64 patch 翟小娟@龙芯
if $(git diff --quiet libcontainer/seccomp/config.go); then
  git apply .beagle/v1.2.3-add-seccomp-support-for-loong64.patch
fi

mkdir -p release/linux/$GOARCH
make COMMIT="$BUILD_COMMIT" VERSION="$BUILD_VERSION" static
$STRIP runc
mv runc release/linux/$GOARCH/runc 

## loong64 patch 翟小娟@龙芯
git apply -R .beagle/v1.2.3-add-seccomp-support-for-loong64.patch
