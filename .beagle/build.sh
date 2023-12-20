#!/usr/bin/env bash

set -ex

mkdir -p release

# version patch 版本号补丁
git apply .beagle/v1-versoin.patch

# # loong64 patch 翟小娟@龙芯
# git apply .beagle/v1.1.9-add-seccomp-support-for-loong64.patch

export COMMIT=$(git rev-parse --short HEAD 2> /dev/null || true)

export GOARCH=amd64
make static
strip runc
mv runc release/runc-linux-$GOARCH

export GOARCH=arm64
export CC=aarch64-linux-gnu-gcc
export STRIP=aarch64-linux-gnu-strip
export LD_LIBRARY_PATH=/opt/libseccomp/arm64/lib
export PKG_CONFIG_PATH=/opt/libseccomp/arm64/lib/pkgconfig
make static
$STRIP runc
mv runc release/runc-linux-$GOARCH

export GOARCH=ppc64le
export CC=powerpc64le-linux-gnu-gcc
export STRIP=powerpc64le-linux-gnu-strip
export LD_LIBRARY_PATH=/opt/libseccomp/ppc64le/lib
export PKG_CONFIG_PATH=/opt/libseccomp/ppc64le/lib/pkgconfig
make static
$STRIP runc
mv runc release/runc-linux-$GOARCH

export GOARCH=mips64le
export CC=mips64el-linux-gnuabi64-gcc
export STRIP=mips64el-linux-gnuabi64-strip
export LD_LIBRARY_PATH=/opt/libseccomp/mips64le/lib
export PKG_CONFIG_PATH=/opt/libseccomp/mips64le/lib/pkgconfig
make static
$STRIP runc
mv runc release/runc-linux-$GOARCH

# export GOARCH=loong64
# export CC=loongarch64-linux-gnu-gcc
# export STRIP=loongarch64-linux-gnu-strip
# export LD_LIBRARY_PATH=/opt/libseccomp/loong64/lib
# export PKG_CONFIG_PATH=/opt/libseccomp/loong64/lib/pkgconfig
# make static
# $STRIP runc
# mv runc release/runc-linux-$GOARCH

# version patch 版本号补丁
git apply -R .beagle/v1-versoin.patch

# # loong64 patch 翟小娟@龙芯
# git apply -R .beagle/v1.1.9-add-seccomp-support-for-loong64.patch