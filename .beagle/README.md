# git

<https://github.com/opencontainers/runc>

```bash
git remote add upstream git@github.com:opencontainers/runc.git

git fetch upstream

git merge v1.1.5
```

## prepare

```bash
## 首先打个补丁，再编译runc-build
git apply .beagle/v1.1-add-mips64el-support.patch

docker build \
  --build-arg GO_VERSION=1.20 \
  --tag registry-vpc.cn-qingdao.aliyuncs.com/wod/runc:1.1.5-build \
  --file ./.beagle/runc-build.dockerfile .

docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/runc:1.1.5-build
```

## build

```bash
# loong64 patch
## golang.org/x/sys/unix
## libcontainer/system/syscall_linux_64.go
git apply .beagle/v1.1-add-loong64-support.patch

# loong64 patch
## github.com/seccomp/libseccomp-golang
git apply .beagle/v1.1-add-loong64-support-seccomp-golang.patch

# loong64 patch
## go.mod
## go 1.17 -> go 1.16
## golang.org/x/sys v0.7.0 > golang.org/x/sys v0.0.0-20211116061358-0a5406a5449c
## go mod tidy
## go mod vendor
git apply .beagle/v1.1-add-loong64-support-plus.patch

# x86_64 cross
docker run -it --rm \
-v $PWD/:/go/src/github.com/opencontainers/runc \
-w /go/src/github.com/opencontainers/runc \
registry-vpc.cn-qingdao.aliyuncs.com/wod/runc:1.1.5-build \
bash .beagle/build.sh
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
