# kafka web工具CMAK安装

## 1、下载依赖包并解压

```bash
#JDK 11,CMAK需要jdk11以上版本，从华为云的镜像仓库捞一个，https://repo.huaweicloud.com/java/jdk/
wget https://repo.huaweicloud.com/java/jdk/11.0.1+13/jdk-11.0.1_linux-x64_bin.tar.gz
tar -zxvf jdk-11.0.1_linux-x64_bin.tar.gz
# CMAK, 从github上拉一个：https://github.com/yahoo/CMAK
wget https://github.com/yahoo/CMAK/releases/download/3.0.0.5/cmak-3.0.0.5.zip
unzip cmak-3.0.0.5.zip
ln -s /data/tools/bd/cmak-3.0.0.5 /usr/bd/cmak
```

## 2、配置

```bash
vi conf/application.conf
```

- 配置项
  ```properties
  cmak.zkhosts="192.168.56.103:2181,192.168.56.104:2181,192.168.56.105:2181"
  basicAuthentication.enabled=true
  ```

## 3、启动

```bash
 nohup bin/cmak -Dconfig.file=conf/application.conf -Dhttp.port=38080 -java-home /data/tools/jdk-11.0.1 > logs/cmak.log &
```
