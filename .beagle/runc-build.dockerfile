ARG GO_VERSION=1.17
ARG BATS_VERSION=v1.3.0
ARG LIBSECCOMP_VERSION=2.5.5

FROM registry.cn-qingdao.aliyuncs.com/wod/golang:${GO_VERSION}

RUN dpkg --add-architecture arm64 \
    && dpkg --add-architecture ppc64el \
    && dpkg --add-architecture mips64el \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        crossbuild-essential-arm64 \
        crossbuild-essential-ppc64el \
        crossbuild-essential-mips64el \
        curl \
        gawk \
        gcc \
        gperf \
        iptables \
        jq \
        kmod \
        pkg-config \
        python3-minimal \
        sshfs \
        sudo \
        uidmap \
        autoconf \
        libtool \
    && apt-get clean \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /etc/apt/sources.list.d/*.list

# Add a dummy user for the rootless integration tests. While runC does
# not require an entry in /etc/passwd to operate, one of the tests uses
# `git clone` -- and `git clone` does not allow you to clone a
# repository if the current uid does not have an entry in /etc/passwd.
RUN useradd -u1000 -m -d/home/rootless -s/bin/bash rootless

# install libseccomp
ARG LIBSECCOMP_VERSION
COPY script/* /tmp/script/
RUN mkdir -p /opt/libseccomp \
    && /tmp/script/seccomp.sh "$LIBSECCOMP_VERSION" /opt/libseccomp arm64 ppc64le mips64le loong64
ENV LIBSECCOMP_VERSION=$LIBSECCOMP_VERSION
ENV LD_LIBRARY_PATH=/opt/libseccomp/lib
ENV PKG_CONFIG_PATH=/opt/libseccomp/lib/pkgconfig

WORKDIR /go/src/github.com/opencontainers/runc
