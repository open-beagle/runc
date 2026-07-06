# runc

<https://github.com/opencontainers/runc>

```bash
git -C ansible-docker-runc remote add upstream git@github.com:opencontainers/runc.git

git -C ansible-docker-runc fetch upstream

git -C ansible-docker-runc merge v1.2.9
```

## git

```bash
# ./.github/workflows/build-1.2.yml
git -C ansible-docker-runc checkout release-v1.2 && \
git -C ansible-docker-runc merge main && \
git -C ansible-docker-runc push origin release-v1.2 && \
git -C ansible-docker-runc checkout main
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
docker pull \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.24-bookworm && \
docker run -it --rm \
  -v $PWD/:/go/src/github.com/opencontainers/ \
  -v $PWD/ansible-docker-runc:/go/src/github.com/opencontainers/runc \
  -w /go/src/github.com/opencontainers/runc \
  -e BUILD_VERSION=1.2.9-beagle \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.24-bookworm \
  bash .beagle/build-cross.sh
```
