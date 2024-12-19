#!/usr/bin/env bash

git config --global --add safe.directory $PWD

set -ex

mkdir -p release

export BUILD_VERSION=${BUILD_VERSION:-"1.2.3-beagle"}
export BUILD_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || true)

export TARGETPLATFORM=linux/amd64
xx-apt install -y libseccomp-dev
xx-go build -trimpath -buildmode=pie \
  -tags "seccomp urfave_cli_no_docs netgo osusergo" \
  -ldflags "-s -w -X main.gitCommit=${BUILD_COMMIT} -X main.version=${BUILD_VERSION} -linkmode external -extldflags --static-pie " \
  -o release/$TARGETPLATFORM/runc .

export TARGETPLATFORM=linux/arm64
export CGO_ENABLED=1
xx-apt install -y libseccomp-dev
xx-go build -trimpath -buildmode=pie \
  -tags "seccomp urfave_cli_no_docs netgo osusergo" \
  -ldflags "-s -w -X main.gitCommit=${BUILD_COMMIT} -X main.version=${BUILD_VERSION} -linkmode external -extldflags --static-pie " \
  -o release/$TARGETPLATFORM/runc .
