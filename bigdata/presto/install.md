# Presto集群安装

## 参考文档

### 官方文档

- prestodb：https://prestodb.io/docs/current/installation/deployment.html
- trino：https://trino.io/docs/current/installation/deployment.html

### 第三方文档

- 大数据实时查询-Presto集群部署搭建：https://blog.csdn.net/beyond59241/article/details/84848358
- Presto 安装部署 https://blog.csdn.net/shangdi1988/article/details/46118971
- [Presto]presto REST API https://blog.csdn.net/Mrerlou/article/details/116756992
- Presto 无active worker的一次定位过程 https://blog.csdn.net/xianzhen376/article/details/101716724
- presto内存配置以及调优(防止OOM等操作) https://blog.csdn.net/zeng6325998/article/details/107087521/

## 下载

- 仓库maven官方：https://repo1.maven.org/maven2/ ，阿里云的maven仓库没有找到
- 下载server和客户端到本地（master、coordinator节点，101节点），/data/tools/bd/presto

  ```bash
  ## prestodb
  ## server
  wget https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.257/presto-server-0.257.tar.gz
  tar -zxvf presto-server-0.257.tar.gz
  ln -s /data/tools/bd/presto/presto-server-0.257 /usr/bd/presto
  mkdir -p /usr/bd/presto/etc/
  mkdir -p /usr/bd/presto/data
  ## client
  wget https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.257/presto-cli-0.257-executable.jar
  ```
- 集群部署

```
在103、104、105、106四个节点安装worker节点，以103为例，在master节点（101）的/data/tools/bd/presto目录下执行：
```

```bash
ssh 192.168.56.103 "mkdir -p /data/tools/bd/presto
scp *.gz 192.168.56.103:/data/tools/bd/presto
ssh 192.168.56.103 "cd /data/tools/bd/presto;tar -zxvf presto-server-0.257.tar.gz;"
ssh 192.168.56.103 "ln -s /data/tools/bd/presto/presto-server-0.257 /usr/bd/presto;"
ssh 192.168.56.103 "mkdir -p /usr/bd/presto/etc/;"
ssh 192.168.56.103 "mkdir -p /usr/bd/presto/data;"


```

## 配置

所有的配置位于etc目录下，前面需要提前建好这个目录。

### 公共配置

- node.properties

  ```
  node.environment=production
  node.id=192-168-56-101
  node.data-dir=/usr/bd/presto/data
  ```
- log.properties

  ```properties
  com.facebook.presto=INFO
  ```

### 配置coordinator

- jvm.config
- ```properties
  -server
  -Xmx4G
  -XX:+UseG1GC
  -XX:G1HeapRegionSize=32M
  -XX:+UseGCOverheadLimit
  -XX:+ExplicitGCInvokesConcurrent
  -XX:+HeapDumpOnOutOfMemoryError
  -XX:+ExitOnOutOfMemoryError
  ```
- config.properties

```properties
coordinator=true
node-scheduler.include-coordinator=false
http-server.http.port=9000
query.max-memory=4GB
query.max-memory-per-node=1GB
query.max-total-memory-per-node=2GB
discovery-server.enabled=true
discovery.uri=http://192.168.56.101:9000
```

- 配置catalog

  - 创建一个子目录

    ```bash
    mkdir catalog
    ```
  - 创建一个jmx的catalog ： jmx.properties

    ```properties
    connector.name=jmx
    ```
  - 创建一个hive的catalog ：hive.properties

    ```properties
    connector.name=hive-hadoop2
    hive.metastore.uri=thrift://192.168.56.103:9083
    hive.config.resources=/etc/hadoop/core-site.xml, /etc/hadoop/hdfs-site.xml
    hive.allow-drop-table=true
    ```
  - 创建一个mysql的catalog：mysql.properties

    ```properties
    connector.name=mysql
    connection-url=jdbc:mysql://192.168.56.101:3306
    connection-user=hive
    # 很重要，默认mysql表名是大小写敏感的，不配置这个大写表查不到
    case-insensitive-name-matching=true
    connection-password=123
    ```

### 配置worker

103/104/105/106四个IP

- jvm.config
  ```
  -server
  -Xmx2G
  -XX:+UseG1GC
  -XX:G1HeapRegionSize=32M
  -XX:+UseGCOverheadLimit
  -XX:+ExplicitGCInvokesConcurrent
  -XX:+HeapDumpOnOutOfMemoryError
  -XX:+ExitOnOutOfMemoryError
  ```
- config.properties

```properties
coordinator=false
http-server.http.port=9000
query.max-memory=4GB
query.max-memory-per-node=1GB
query.max-total-memory-per-node=2GB
discovery.uri=http://192.168.56.101:9000
```

## 启动

```bash
# 后台启动
bin/launcher start
# 同步启动
bin/launcher run
```

## 踩坑记

- mysql catalog增加配置项
  lower_case_table_names=1不能要
  不然hive都跑不起来
- No nodes available to run query
  保持coordinator和worker节点的catalog下文件是同步的
- mysql找不到表（大写的表）
  mysql catalog增加一项，主要是针对mysql、mangodb这一类大小写敏感表名的表述
  ```
  case-insensitive-name-matching=true
  ```
