# runc

<https://github.com/opencontainers/runc>

```bash
git -C ansible-docker-runc remote add upstream git@github.com:opencontainers/runc.git

git -C ansible-docker-runc fetch upstream

git -C ansible-docker-runc merge v1.3.6
```

## git

```bash
# ./.github/workflows/build-1.3.yml
git -C ansible-docker-runc checkout release-v1.3 && \
git -C ansible-docker-runc merge dev && \
git -C ansible-docker-runc push origin release-v1.3 && \
git -C ansible-docker-runc checkout dev

# 合并至主分支
git -C ansible-docker-runc checkout main && \
git -C ansible-docker-runc merge dev && \
git -C ansible-docker-runc push origin main && \
git -C ansible-docker-runc checkout dev
```

## libseccomp

```bash
# amd64与arm64场景下安装libseccomp-dev
# rm -rf release && \
# docker run -it --rm \
#   -v $PWD/:/go/src/github.com/opencontainers/ \
#   -v $PWD/ansible-docker-runc:/go/src/github.com/opencontainers/runc \
#   -w /go/src/github.com/opencontainers/runc \
#   registry.cn-qingdao.aliyuncs.com/wod/libseccomp:v2.5.5 \
#   sh -c '
#   mkdir -p release && \
#   cp -r /opt/libseccomp ./release/libseccomp
#   '
```

## debug

```bash
# cross
docker run -it --rm \
  -v $PWD/:/go/src/github.com/opencontainers/ \
  -v $PWD/ansible-docker-runc:/go/src/github.com/opencontainers/runc \
  -w /go/src/github.com/opencontainers/runc \
  -e BUILD_VERSION=1.3.6-beagle \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.24-bookworm \
  bash .beagle/build-cross.sh
```
