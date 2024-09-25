#!/usr/bin/env bash

set -ex

git config --global --add safe.directory $PWD

mkdir -p release

export LIBSECCOMP_VERSION=2.5.5

# version patch 版本号补丁
if $(git diff --quiet VERSION); then
  git apply .beagle/v1-versoin.patch
fi

export COMMIT=$(git rev-parse --short HEAD 2>/dev/null || true)

export GOARCH=amd64
export LD_LIBRARY_PATH=$PWD/release/libseccomp/amd64/lib
export PKG_CONFIG_PATH=$PWD/release/libseccomp/amd64/lib/pkgconfig

sed -i "s/open-beagle\/libseccomp\/.tmp/opencontainers\/runc\/release\/libseccomp/g" $PKG_CONFIG_PATH/libseccomp.pc

make static
strip runc
mv runc release/runc-linux-$GOARCH

export GOARCH=arm64
export CC=aarch64-linux-gnu-gcc
export STRIP=aarch64-linux-gnu-strip
export LD_LIBRARY_PATH=$PWD/release/libseccomp/arm64/lib
export PKG_CONFIG_PATH=$PWD/release/libseccomp/arm64/lib/pkgconfig

sed -i "s/open-beagle\/libseccomp\/.tmp/opencontainers\/runc\/release\/libseccomp/g" $PKG_CONFIG_PATH/libseccomp.pc

make static
$STRIP runc
mv runc release/runc-linux-$GOARCH

# version patch 版本号补丁
git apply -R .beagle/v1-versoin.patch
