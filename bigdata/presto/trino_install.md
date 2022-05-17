### 官方文档

- trino：https://trino.io/docs/current/installation/deployment.html

### 第三方文档

- Presto（Trino）集群安装 https://blog.csdn.net/zuorichongxian_/article/details/115529459
- CentOS7环境下部署PrestoSQL-345版本三节点集群详细过程 https://blog.csdn.net/Happy_Sunshine_Boy/article/details/109681123

## 下载

- 仓库maven官方：https://repo1.maven.org/maven2/ ，阿里云的maven仓库没有找到
- JDK华为云镜像仓库：https://repo.huaweicloud.com/java/jdk/
- 下载jdk12到/，目前trino至少需要11.07版本的java，在各个机器上初始化好java环境

  ```bash
  wget https://repo.huaweicloud.com/java/jdk/12+33/jdk-12_linux-x64_bin.tar.gz
  tar -zxvf jdk-12_linux-x64_bin.tar.gz
  useradd trino
  ln -s /data/tools/jdk-12 /home/trino/jdk
  # 在/home/trino/.bashrc增加以下内容
  export JAVA_HOME=/home/trino/jdk:
  export JRE_HOME=$JAVA_HOME/jre
  export PATH=$JAVA_HOME/bin:$PATH
  export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib/rt.jar
  ```
- 下载server和客户端到本地（master、coordinator节点，101节点），/data/tools/bd/presto

  ```bash
  ## trino
  ## server
  wget https://repo1.maven.org/maven2/io/trino/trino-server/359/trino-server-359.tar.gz
  tar -zxvf trino-server-359.tar.gz
  ln -s /data/tools/bd/presto/trino-server-359 /usr/bd/trino
  mkdir -p /usr/bd/trino/etc/
  mkdir -p /usr/bd/trino/data/
  ## client
  wget https://repo1.maven.org/maven2/io/trino/trino-cli/359/trino-cli-359-executable.jar
  ```
- 集群部署

```
在103、104、105、106四个节点安装worker节点，以103为例，在master节点（101）的/data/tools/bd/presto目录下执行：
```

```bash
ssh 192.168.56.103 "mkdir -p /data/tools/bd/presto
scp *.gz 192.168.56.103:/data/tools/bd/presto
ssh 192.168.56.103 "cd /data/tools/bd/presto;tar -zxvf trino-server-359.tar.gz"
ssh 192.168.56.103 "ln -s /data/tools/bd/presto/trino-server-359 /usr/bd/trino"
ssh 192.168.56.103 "mkdir -p /usr/bd/trino/etc/"
ssh 192.168.56.103 "mkdir -p /usr/bd/trino/data"
```

## 配置

所有的配置位于etc目录下，前面需要提前建好这个目录。

### 公共配置

- node.properties

  ```
  node.environment=production
  node.id=192-168-56-101
  node.data-dir=/usr/bd/trino/data
  ```
- log.properties

  ```properties
  io.trino=INFO
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
http-server.http.port=9001
query.max-memory=4GB
query.max-memory-per-node=1GB
query.max-total-memory-per-node=2GB
discovery-server.enabled=true
discovery.uri=http://192.168.56.101:9001
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
