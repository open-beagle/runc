# git

<https://github.com/opencontainers/runc>

```bash
git remote add upstream git@github.com:opencontainers/runc.git

git fetch upstream

git merge v1.2.6
```

## libseccomp

```bash
# amd64与arm64场景下安装libseccomp-dev
# rm -rf release && \
# docker run -it --rm \
#   -v $PWD/:/go/src/github.com/opencontainers/runc \
#   -w /go/src/github.com/opencontainers/runc \
#   registry.cn-qingdao.aliyuncs.com/wod/libseccomp:v2.5.5 \
#   sh -c '
#   mkdir -p release && \
#   cp -r /opt/libseccomp ./release/libseccomp
#   '
```

## build

```bash
# cross
docker pull \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.24-bookworm && \
docker run -it --rm \
  -v $PWD/:/go/src/github.com/opencontainers/runc \
  -w /go/src/github.com/opencontainers/runc \
  -e BUILD_VERSION=1.2.6-beagle \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.24-bookworm \
  bash .beagle/build-cross.sh
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$S3_ENDPOINT_ALIYUN \
  -e PLUGIN_ACCESS_KEY=$S3_ACCESS_KEY_ALIYUN \
  -e PLUGIN_SECRET_KEY=$S3_SECRET_KEY_ALIYUN \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="runc" \
  -e PLUGIN_MOUNT="./.git" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$S3_ENDPOINT_ALIYUN \
  -e PLUGIN_ACCESS_KEY=$S3_ACCESS_KEY_ALIYUN \
  -e PLUGIN_SECRET_KEY=$S3_SECRET_KEY_ALIYUN \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="runc" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
