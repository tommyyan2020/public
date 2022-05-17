# Hive集群安装

## 0、参考文章

- Apache Hive metastore服务使用详解 http://www.itcast.cn/news/20190829/12032894477.shtml

## 1、下载安装包

- 官方站点：https://hive.apache.org/
- 镜像下载站点：https://mirrors.bfsu.edu.cn/apache/hive/ 推荐 https://mirrors.tuna.tsinghua.edu.cn/apache/hive/
- hive版本和hadoop版本之间的对应关系：https://hive.apache.org/downloads.html
- 下载到namenode所在机器

```bash
cd /data/tools/bd/
wget https://mirrors.bfsu.edu.cn/apache/hive/hive-2.3.9/apache-hive-2.3.9-bin.tar.gz
tar -zxvf apache-hive-2.3.9-bin.tar.gz
ln -s /data/tools/bd/apache-hive-2.3.9-bin /usr/bd/hive
```

## 2、配置

配置位于conf目录下，需要根据template文件进行修改，比如：cp hive-env.sh.template hive-env.sh

- hive-env.sh

  ```bash
  # export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64
  # export HADOOP_HOME=/usr/lib/hadoop-2.6.5
  export HIVE_HOME=/usr/bd/hive/
  #export SPARK_HOME=/usr/lib/spark
  ```
- hive-site.xml 常用配置项说明： https://blog.csdn.net/hqwang4/article/details/60141424

  ```xml
  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
  <configuration>
  <!-- 设置 hive仓库的HDFS上的位置 -->
    <property>
      <name>hive.metastore.warehouse.dir</name>
      <value>/hive/warehouse</value>
      <description>location of default database for the warehouse</description>
    </property>

    <!-- 数据库配置 -->
    <property>
      <name>javax.jdo.option.ConnectionURL</name>
      <value>jdbc:mysql://192.168.56.101:3306/hive?createDatabaseIfNotExist=true</value>
    </property>
    <property>
      <name>javax.jdo.option.ConnectionDriverName</name>
      <value>com.mysql.jdbc.Driver</value>
    </property>
    <property>
      <name>javax.jdo.option.ConnectionUserName</name>
      <value>hive</value>
    </property>
    <property>
      <name>javax.jdo.option.ConnectionPassword</name>
      <value>123</value>
    </property>

    <property>
      <name>hive.execution.engine</name>
      <value>mr</value><!-- mapreduce 作为引擎 -->  
      <!-- value>spark</value --><!-- spark 作为引擎 -->
      <description>
        Expects one of [mr, tez, spark].
        Chooses execution engine. Options are: mr (Map reduce, default), tez, spark. While MR
        remains the default engine for historical reasons, it is itself a historical engine
        and is deprecated in Hive 2 line. It may be removed without further warning.
      </description>
    </property>
    <property>
      <name>hive.metastore.schema.verification</name>
      <value>False</value>
      <description>
        Enforce metastore schema version consistency.
        True: Verify that version information stored in is compatible with one from Hive jars.  Also disable automatic
              schema migration attempt. Users are required to manually migrate schema after Hive upgrade which ensures
              proper metastore schema migration. (Default)
        False: Warn if the version information stored in metastore doesn't match with one from in Hive jars.
      </description>
    </property>

    <!-- property>
      <name>datanucleus.autoCreateSchema</name>
      <value>true</value>
    </property>
    <property>
      <name>datanucleus.autoCreateTables</name>
      <value>true</value>
    </property -->

  </configuration>
  ```
- mysql授权

```sql
GRANT ALL ON *.* TO 'hive'@'%' IDENTIFIED BY '123';
```

- 初始化meta库表

```bash
bin/schematool -dbType mysql -initSchema
```

## 3、启动

```bash
nohup bin/hive --service hiveserver2 &
```

## 4、启动metastore服务

前面的已经通过【本地模式】启动了一个hive服务，hive内部已经启动了一个内嵌的metastore服务，跟hive的server在同一个进程，没有暴露端口。生产环境建议采用【远程模式】，单独启动一个metastore服务，具体如下

- 修改conf/hive-site.xml，增加一个配置项

  ```xml
  <property>
      <name>hive.metastore.uris</name>
      <value>thrift://192.168.56.101:9083</value>
  </property>
  ```
- 停掉hiveserver2 ：直接kill掉
- 后台启动metastore

  ```bash
  nohup bin/hive --service metastore &
  ```
- 启动hiveserver2

  ```bash
  nohup bin/hive --service hiveserver2 &
  ```
