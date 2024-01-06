#!/usr/bin/env bash

set -ex

mkdir -p release

export LIBSECCOMP_VERSION=2.5.5

# version patch 版本号补丁
git apply .beagle/v1-versoin.patch

export COMMIT=$(git rev-parse --short HEAD 2> /dev/null || true)

export GOARCH=amd64
export LD_LIBRARY_PATH=$PWD/release/libseccomp/amd64/lib
export PKG_CONFIG_PATH=$PWD/release/libseccomp/amd64/lib/pkgconfig

sed -i "s/.tmp/release\/libseccomp/g" $PKG_CONFIG_PATH/libseccomp.pc

make static
strip runc
mv runc release/runc-linux-$GOARCH

export GOARCH=arm64
export CC=aarch64-linux-gnu-gcc
export STRIP=aarch64-linux-gnu-strip
export LD_LIBRARY_PATH=$PWD/release/libseccomp/arm64/lib
export PKG_CONFIG_PATH=$PWD/release/libseccomp/arm64/lib/pkgconfig

sed -i "s/.tmp/release\/libseccomp/g" $PKG_CONFIG_PATH/libseccomp.pc

make static
$STRIP runc
mv runc release/runc-linux-$GOARCH

export GOARCH=ppc64le
export CC=powerpc64le-linux-gnu-gcc
export STRIP=powerpc64le-linux-gnu-strip
export LD_LIBRARY_PATH=$PWD/release/libseccomp/ppc64le/lib
export PKG_CONFIG_PATH=$PWD/release/libseccomp/ppc64le/lib/pkgconfig

sed -i "s/.tmp/release\/libseccomp/g" $PKG_CONFIG_PATH/libseccomp.pc

make static
$STRIP runc
mv runc release/runc-linux-$GOARCH

export GOARCH=mips64le
export CC=mips64el-linux-gnuabi64-gcc
export STRIP=mips64el-linux-gnuabi64-strip
export LD_LIBRARY_PATH=$PWD/release/libseccomp/mips64le/lib
export PKG_CONFIG_PATH=$PWD/release/libseccomp/mips64le/lib/pkgconfig

sed -i "s/.tmp/release\/libseccomp/g" $PKG_CONFIG_PATH/libseccomp.pc

make static
$STRIP runc
mv runc release/runc-linux-$GOARCH

# version patch 版本号补丁
git apply -R .beagle/v1-versoin.patch
