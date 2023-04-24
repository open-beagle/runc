#!/usr/bin/env bash

set -ex

mkdir -p release

export GOARCH=amd64
export BUILDTAGS=""
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
export LD_LIBRARY_PATH=/opt/libseccomp/mips64le/lib
export PKG_CONFIG_PATH=/opt/libseccomp/mips64le/lib/pkgconfig
make static
mv runc release/runc-linux-$GOARCH

export GOARCH=loong64
export CC=loongarch64-linux-gnu-gcc
export LD_LIBRARY_PATH=/opt/libseccomp/loong64/lib
export PKG_CONFIG_PATH=/opt/libseccomp/loong64/lib/pkgconfig
make static
mv runc release/runc-linux-$GOARCH