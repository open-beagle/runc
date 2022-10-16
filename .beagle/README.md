# git

<https://github.com/opencontainers/runc>

```bash
git remote add upstream git@github.com:opencontainers/runc.git

git fetch upstream

git merge v1.1.4
```

## build

```bash
# x86_64
docker run -it --rm \
-v $PWD/:/go/src/github.com/opencontainers/runc \
-w /go/src/github.com/opencontainers/runc \
registry.cn-qingdao.aliyuncs.com/wod/runc-build:1.1.1 \
bash .beagle/build.sh

# x86_64
# /go/src/gitlab.wodcloud.com/cloud/runc/Dockerfile

## 首先打个补丁，再编译runc-build
git apply .beagle/v1.1-add-mips64el-support.patch

docker build \
  --build-arg GO_VERSION=1.19-bullseye \
  --tag registry.cn-qingdao.aliyuncs.com/wod/runc-build:1.1.1 \
  --file ./.beagle/runc-build.dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/runc-build:1.1.1
```
