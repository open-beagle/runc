#!/usr/bin/env bash

set -ex

git apply .beagle/v1.1-add-mips64el-support.patch

mkdir -p release

export GOARCH=amd64
make static
mv runc release/runc-linux-$GOARCH

export GOARCH=arm64
export CC=aarch64-linux-gnu-gcc
export LD_LIBRARY_PATH=/opt/libseccomp/arm64/lib
export PKG_CONFIG_PATH=/opt/libseccomp/arm64/lib/pkgconfig
make static
mv runc release/runc-linux-$GOARCH

export GOARCH=ppc64le
export CC=powerpc64le-linux-gnu-gcc
export LD_LIBRARY_PATH=/opt/libseccomp/ppc64le/lib
export PKG_CONFIG_PATH=/opt/libseccomp/ppc64le/lib/pkgconfig
make static
mv runc release/runc-linux-$GOARCH

export GOARCH=mips64le
export CC=mips64el-linux-gnuabi64-gcc
export LD_LIBRARY_PATH=/opt/libseccomp/mips64el/lib
export PKG_CONFIG_PATH=/opt/libseccomp/mips64el/lib/pkgconfig
make static
mv runc release/runc-linux-$GOARCH
