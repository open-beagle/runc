#!/usr/bin/env bash

set -ex

mkdir -p release

# version patch 版本号补丁
git apply .beagle/v1-versoin.patch

# # loong64 patch 翟小娟@龙芯
git apply .beagle/v1.1.9-add-seccomp-support-for-loong64.patch

export COMMIT=$(git rev-parse --short HEAD 2> /dev/null || true)

export GOARCH=loong64
export CC=loongarch64-linux-gnu-gcc
export STRIP=loongarch64-linux-gnu-strip
export LD_LIBRARY_PATH=$PWD/release/libseccomp/loong64/lib
export PKG_CONFIG_PATH=$PWD/release/libseccomp/loong64/lib/pkgconfig

sed -i "s/open-beagle\/libseccomp\/.tmp/opencontainers\/runc\/release\/libseccomp/g" $PKG_CONFIG_PATH/libseccomp.pc

make static
$STRIP runc
mv runc release/runc-linux-$GOARCH

# version patch 版本号补丁
git apply -R .beagle/v1-versoin.patch

# # loong64 patch 翟小娟@龙芯
git apply -R .beagle/v1.1.9-add-seccomp-support-for-loong64.patch