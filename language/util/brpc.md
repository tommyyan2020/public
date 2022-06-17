# baidu rpc(better rpc)

# 基本信息

## 官方

brpc已经入apache门下

- 官网：https://brpc.apache.org/zh/
- github ：https://github.com/apache/incubator-brpc

# 安装



brpc依赖于gflag和leveldb、protobuf，没有库依赖，需要自行安装

最好还是根据版本下载吧。直接用master不太好，：），以后不太好定位问题和解决

这里是我的安装，也可以参考官方的安装方式：https://brpc.apache.org/zh/docs/getting_started/

## 安装gflag

常规安装

```bash
git clone https://github.com/gflags/gflags.git
cd gflags
mkdir build

cd build
cmake .. -DCMAKE_CXX_FLAGS=-fPIC
make
make install
```

## 安装leveldb

常规方式安装，注意有依赖库，需要加上“--recursivecd”

```bash
git clone https://github.com/google/leveldb.git --recursive
cd leveldb
make build
cd build
cmake .. -DCMAKE_CXX_FLAGS=-fPIC
make 
make install
```

## 安装protobuf

参考这个[protobuf安装](/general/other/protobuf.md)

## 安装brpc

