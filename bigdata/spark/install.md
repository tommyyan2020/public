# spark集群安装

## 1、下载安装包

- 官方站点：https://spark.apache.org/
- 镜像下载站点：https://mirrors.bfsu.edu.cn/apache/spark/ 推荐  https://mirrors.tuna.tsinghua.edu.cn/apache/spark/
- 版本选择：官方对应页面已经提供hadoop版本和spark版本对应关系的选择，http://spark.apache.org/downloads.html
- 下载安装

```bash
wget https://mirrors.bfsu.edu.cn/apache/spark/spark-3.1.2/spark-3.1.2-bin-hadoop2.7.tgz
tar -zxvf spark-3.1.2-bin-hadoop2.7.tgz 
ln -s /data/tools/bd/spark-3.1.2-bin-hadoop2.7 /usr/bd/spark
# 4个datanode节点上安装spark，下面以其中一个节点（103）为例
scp ./spark-3.1.2-bin-hadoop2.7.tgz   192.168.56.103:/data/tools/bd
ssh 192.168.56.103 "cd /data/tools/bd;tar -zxvf spark-3.1.2-bin-hadoop2.7.tgz;ln -s /data/tools/bd/spark-3.1.2-bin-hadoop2.7  /usr/bd/spark"
```

## 2、配置

- spark-env.sh: cp spark-env.sh.template spark-env.sh

```bash
export SPARK_HOME=/usr/bd/spark/
```

- workers: cp workers.template workers

```
192.168.56.103
192.168.56.104
192.168.56.105
192.168.56.106
```

- 同步配置到4个datanode节点

```bash
scp /usr/bd/spark/conf/* 192.168.56.103:/usr/bd/spark/conf/
scp /usr/bd/spark/conf/* 192.168.56.104:/usr/bd/spark/conf/
scp /usr/bd/spark/conf/* 192.168.56.105:/usr/bd/spark/conf/
scp /usr/bd/spark/conf/* 192.168.56.106:/usr/bd/spark/conf/
```

## 3、启动

```bash
sh sbin/start-all.sh
```
