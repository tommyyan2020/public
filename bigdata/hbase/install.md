# HBase集群安装

## 1、下载安装包

- 官方站点：https://hbase.apache.org/
- 镜像下载站点：https://mirrors.bfsu.edu.cn/apache/hbase/ 推荐 https://mirrors.tuna.tsinghua.edu.cn/apache/hbase/
- HBase版本与hadoop版本关系：http://hbase.apache.org/book.html#hadoop https://www.cnblogs.com/modou/p/12403463.html
- 由于目前hadoop安装的是2.7.5版本，hbase版本可以安装1.4.x版本或者2.1.x版本，目前镜像站合适的只有1.4.13版本
- 下载到NameNode节点并分发到4个datanode节点

  ```bash
  # namenode 节点安装HMaster
  wget https://mirrors.bfsu.edu.cn/apache/hbase/1.4.13/hbase-1.4.13-bin.tar.gz
  tar -zxvf hbase-1.4.13-bin.tar.gz
  ln -s /data/tools/bd/hbase-1.4.13  /usr/bd/hbase
  # 4个datanode节点上安装RegionServer，下面以其中一个节点（103）为例
  scp ./hbase-1.4.13-bin.tar.gz  192.168.56.103:/data/tools/bd
  ssh 192.168.56.103 "cd /data/tools/bd;tar -zxvf hbase-1.4.13-bin.tar.gz;ln -s /data/tools/bd/hbase-1.4.13  /usr/bd/hbase"
  ```

## 2、配置

配置文件在起始目录下的conf目录

- 配置hbase-env.sh
  ```bash
  #Java安装路径，如果系统环境变量没有可以配置这个
  # export JAVA_HOME=/usr/java/default
  #HBase类路径
  export HBASE_CLASSPATH=/usr/bd/hbase/conf
  #由HBase负责启动和关闭Zookeeper
  export HBASE_MANAGES_ZK=false
  ```
- 配置hbase-site.xml
  ```xml
  <configuration>

  <!-- 指定hbase在HDFS上存储的路径, hbase.rootdir：这个属性配置要依据hadoop中core-site.xml中：fs.defaultFs属性的配置-->
    <property>
        <name>hbase.rootdir</name>
        <value>hdfs://192.168.56.101:8020/hbase</value>  
     </property>

  <!-- 指定hbase是分布式的 -->
    <property>
       <name>hbase.cluster.distributed</name>
       <value>true</value>
   </property>

  <!-- 指定zk的地址，多个用“,”分割 -->
    <property>
       <name>hbase.zookeeper.quorum</name>
       <value>192.168.56.103:2181,192.168.56.104:2181,192.168.56.105:2181</value>
   </property>

  </configuration>
  ```
- 配置regionservers

```
192.168.56.103
192.168.56.104
192.168.56.105
192.168.56.106
```

- 同步一下配置到其他4台机器，以103为例
  ```bash
  scp /usr/bd/hbase/conf/* 192.168.56.103:/usr/bd/hbase/conf/

  ```

## 3、启动/停止

```bash
#启动
sh bin/start-hbase.sh
#停止
sh bin/stop-hbase.sh
```

## 4、参考

- HBASE的集群搭建 https://blog.csdn.net/u011066470/article/details/106305238
- HBase简介、搭建环境及安装部署 https://blog.csdn.net/oschina_41140683/article/details/82752115
