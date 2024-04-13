# git

<https://github.com/opencontainers/runc>

```bash
git remote add upstream git@github.com:opencontainers/runc.git

git fetch upstream

git merge v1.1.12
```

## libseccomp

```bash
rm -rf release && \
docker run -it --rm \
-v $PWD/:/go/src/github.com/opencontainers/runc \
-w /go/src/github.com/opencontainers/runc \
registry-vpc.cn-qingdao.aliyuncs.com/wod/libseccomp:v2.5.5 \
sh -c '
mkdir -p release && \
cp -r /opt/libseccomp ./release/libseccomp
'

docker run -it --rm \
-v $PWD/:/go/src/github.com/opencontainers/runc \
-w /go/src/github.com/opencontainers/runc \
registry-vpc.cn-qingdao.aliyuncs.com/wod/libseccomp:v2.3.3-loong64 \
sh -c '
mkdir -p release && \
rm -rf ./release/libseccomp && \
cp -r /opt/libseccomp ./release/libseccomp
'
```

## build

```bash
# cross
docker run -it --rm \
-v $PWD/:/go/src/github.com/opencontainers/runc \
-w /go/src/github.com/opencontainers/runc \
registry-vpc.cn-qingdao.aliyuncs.com/wod/golang:1.21 \
bash .beagle/build.sh

# loong64
docker run -it --rm \
-v $PWD/:/go/src/github.com/opencontainers/runc \
-w /go/src/github.com/opencontainers/runc \
registry-vpc.cn-qingdao.aliyuncs.com/wod/golang:1.21-loongnix \
bash .beagle/build-loong64.sh
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="runc" \
  -e PLUGIN_MOUNT="./.git" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="runc" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```

## runc:build 已过期

```bash
## debug
docker run -it --rm \
-v $PWD/:/go/src/github.com/opencontainers/runc \
-w /go/src/github.com/opencontainers/runc \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.21 \
bash

## 首先打个补丁，再编译runc-build
git apply .beagle/v1.1-add-mips64el-support.patch
git apply -R .beagle/v1.1-add-mips64el-support.patch

## cross
docker build \
  --no-cache \
  --file ./.beagle/runc-build.dockerfile \
  --build-arg GO_VERSION=1.21 \
  --tag registry-vpc.cn-qingdao.aliyuncs.com/wod/runc:1.1.12-build \
  .

docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/runc:1.1.12-build

## loong64
docker build \
  --no-cache \
  --file .beagle/runc-build-loong64.dockerfile \
  --build-arg GO_VERSION=1.21-loongnix \
  --tag registry-vpc.cn-qingdao.aliyuncs.com/wod/runc:1.1.12-build-loongnix \
  .

docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/runc:1.1.12-build-loongnix
```
