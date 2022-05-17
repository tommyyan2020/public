# HUDI学习笔记

# 资料

- 从Apache Hudi基础到项目实战 https://www.bilibili.com/video/BV1sb4y1n7hK
- 阿里云基于Hudi构建Lakehouse实践：https://www.bilibili.com/video/BV19M4y1V7S6

# 湖仓一体基础篇

### 数据湖 VS 数据仓库

![1646645392819](images/1646645392819.png)

![1646645887420](images/1646645887420.png)

![1646645943390](images/1646645943390.png)

### 数据胡框架

![1646646210894](images/1646646210894.png)

#### DeltaLake

![1646646299081](images/1646646299081.png)

![1646646374480](images/1646646374480.png)

#### Iceberg

![1646646441173](images/1646646441173.png)

# Hudi基础篇

## 基本信息 

![1646796733599](images/1646796733599.png)

![1646646552808](images/1646646552808.png)





![1646646640422](images/1646646640422.png)

![1646646766600](images/1646646766600.png)





![1650001530207](images/1650001530207.png)

![1646797367560](images/1646797367560.png)

![1646797113579](images/1646797113579.png)

![1646797264582](images/1646797264582.png)

## 架构

![1646647333554](images/1646647333554.png)



![1646796323530](images/1646796323530.png)

![1646797144479](images/1646797144479.png)

![1646796662230](images/1646796662230.png)

![1649671044501](images/1649671044501.png)

## 快速体验使用

- 

### hudi编译

![1646797428675](images/1646797428675.png)

![1646797461618](images/1646797461618.png)

![1646799227812](images/1646799227812.png)

- 下载地址 https://hudi.apache.org/releases/download
- build源码方式太麻烦，而且基本上都是基于spark的文档，还是直接使用相关的包吧：https://mvnrepository.com/artifact/org.apache.hudi/hudi-flink-bundle

![1646810137015](images/1646810137015.png)

```xml
<!-- https://mvnrepository.com/artifact/org.apache.hudi/hudi-flink-bundle -->
<dependency>
    <groupId>org.apache.hudi</groupId>
    <artifactId>hudi-flink-bundle_2.12</artifactId>
    <version>0.10.1</version>
</dependency>
```



![1646799493794](images/1646799493794.png)

没有用aliyun的仓库，用了官方仓库

```xml
     <mirror>
      <id>maven2</id>
      <mirrorOf>central</mirrorOf>
      <name>maven2 Repository</name>
      <url>https://repo1.maven.org/maven2/</url>
    </mirror>
```



![1646816295710](images/1646816295710.png)

### 安装scala

- 官网下载页面，选择需要安装的版本：https://www.scala-lang.org/download/all.html 
- 下载安装：spark只支持2.12以上版本的scala，

```bash
wget https://downloads.lightbend.com/scala/2.12.15/scala-2.12.15.rpm
rpm -ivh scala-2.12.15.rpm 
```

![1649673867661](images/1649673867661.png)

### 启动spark-cli

- 进入spark的bin目录，执行下面的命令

```bash
// spark-shell for spark 3.1
spark-shell \
  --packages org.apache.hudi:hudi-spark3.1.2-bundle_2.12:0.10.1,org.apache.spark:spark-avro_2.12:3.1.2 \
  --conf 'spark.serializer=org.apache.spark.serializer.KryoSerializer'
```

注意官方推荐的hudi版本和spark版本的对应关系，本机装的是spark3.1.2，需要hudi 0.10以上的版本

- 官方文档：https://hudi.apache.org/cn/docs/quick-start-guide/

![1649994954096](../../images/1649994954096.png)
![1649994889541](../../images/1649994889541.png)

### 官方例子

- https://hudi.apache.org/cn/docs/quick-start-guide/
- 下载：quick_start.scala，路径：/data/test/bd/hudi/quick_start.scala
- spark-shell加载scala文件：https://wenku.baidu.com/view/75a85a9efe0a79563c1ec5da50e2524de518d0c0.html

#### 生成数据

```sc
// spark-shell
import org.apache.hudi.QuickstartUtils._
import scala.collection.JavaConversions._
import org.apache.spark.sql.SaveMode._
import org.apache.hudi.DataSourceReadOptions._
import org.apache.hudi.DataSourceWriteOptions._
import org.apache.hudi.config.HoodieWriteConfig._

val tableName = "hudi_trips_cow"
val basePath =  "hdfs://192.168.56.101:8020/data/hudi-warehouse/hudi_trips_cow"
val dataGen = new DataGenerator
// 生成十条数据
val inserts = convertToStringList(dataGen.generateInserts(10))
// 将list类型的json数据转换成dataframe
val df = spark.read.json(spark.sparkContext.parallelize(inserts, 2))
//查看转换后的DataFrame数据集的Schema信息
df.printSchema()
```

![1650011937647](images/1650011937647.png)

```sc
// 查询dataframe里面的数据
df.select("rider","begin_lat","begin_lon","driver","fare", "uuid", "ts").show(10, truncate=false)
```

![1650013267811](images/1650013267811.png)

- ：preCombinedField ：https://blog.csdn.net/dkl12/article/details/122309954
  - Spark DF建表写数据时（含更新）：
    1、UPSERT，当数据重复时（这里指同一主键对应多条记录），程序在写数据前会根据预合并字段ts进行去重，去重保留ts值最大的那条记录，且无论新记录的ts值是否大于历史记录的ts值，都会覆盖写，直接更新。
    2、INSERT时，没有预合并，程序依次写入，实际更新为最后一条记录，且无论新记录的ts值是否大于历史记录的ts值，都会覆盖写，直接更新。
  - Spark SQL建表，写数据时（含更新）：
    有ts时，预合并时如果数据重复取预合并字段值最大的那条记录，最大值相同的取第一个。写数据时，ts值大于等于历史ts值，才会更新，小于历史值则不更新。
    没有ts时，则默认将主键字段的第一个值作为预合并字段，如果数据重复，去重时会取第一个值，写数据时，直接覆盖历史数据（因为  这里的预合并字段为主键字段，等于历史值，其实原理跟上面有ts时一样）
  
- 消化一下：

  - mysql：
    - insert， 重复key出错，
    - replace：有直接替换，没有insert
    
    hudi
为了处理乱序的语义，其实没必要搞这么复杂
  
- spark dataframe
  
    - upsert：根据时间戳合并数据，然后replace
    - insert：replace
  - spark sql
    - 有时间戳：去重时取时间戳最大的第一个，大于历史数据时间戳才更新
    - 没有时间戳：replace

#### 插入数据


```scala
df.write.
  mode(Overwrite).
  format("hudi").
  options(getQuickstartWriteConfigs).
  option(PRECOMBINE_FIELD_OPT_KEY, "ts").
  option(RECORDKEY_FIELD_OPT_KEY, "uuid").
  option(PARTITIONPATH_FIELD_OPT_KEY, "partitionpath").
  option(TABLE_NAME, tableName).
  mode(Overwrite).
  save(basePath)
```

![1650080703436](images/1650080703436.png)

#### 读取数据

```sca

// spark-shell
val tripsSnapshotDF = spark.
  read.
  format("hudi").
  load(basePath)
tripsSnapshotDF.printSchema  
//load(basePath) use "/partitionKey=partitionValue" folder structure for Spark auto partition discovery
tripsSnapshotDF.createOrReplaceTempView("hudi_trips_snapshot")

spark.sql("select fare, begin_lon, begin_lat, ts from  hudi_trips_snapshot where fare > 20.0").show()
spark.sql("select _hoodie_commit_time, _hoodie_record_key, _hoodie_partition_path, rider, driver, fare from  hudi_trips_snapshot").show()

```

- 与原数据相比，hudi会增加一些内部用的字段

![1650264925299](images/1650264925299.png)

![1650265037564](images/1650265037564.png)

## 总结

![1650265606717](images/1650265606717.png)

- 按照表来管理数据
- 按照字段分区+ parquet格式存放数据
- 唯一主键
- 解决数据乱序的问题

# 数据管理

## 表数据结构

![1650266706693](images/1650266706693.png)

![1650266746005](images/1650266746005.png)

![1650267055878](images/1650267055878.png)

![1650267277255](images/1650267277255.png)

![1650267933467](images/1650267933467.png)

## 元数据

![1650267506430](images/1650267506430.png)

![1650267904948](images/1650267904948.png)

IDEA编程开发

# 核心概念剖析

![1650335569634](images/1650335569634.png)

![1650335718928](images/1650335718928.png)

![1650335793315](images/1650335793315.png)

![1650335926821](images/1650335926821.png)

![1650335948772](images/1650335948772.png)

![1650336031014](images/1650336031014.png)

![1650336079871](images/1650336079871.png)

![1650336148192](images/1650336148192.png)

![1650336681713](images/1650336681713.png)

![1650336711618](images/1650336711618.png)

![1650336855405](images/1650336855405.png)

![1650336930069](images/1650336930069.png)

![1650337006595](images/1650337006595.png)

![1650337080537](images/1650337080537.png)

![1650337115032](images/1650337115032.png)

![1650337169143](images/1650337169143.png)

![1650337427049](images/1650337427049.png)

![1650337528383](images/1650337528383.png)

![1650337654185](images/1650337654185.png)

 ![1650337819452](images/1650337819452.png)

![1650337886875](images/1650337886875.png)

![1650338010206](images/1650338010206.png)

![1650338128512](images/1650338128512.png)



![1650338560534](images/1650338560534.png)

![1650338596369](images/1650338596369.png)

![1650338642743](images/1650338642743.png)

![1650338795930](images/1650338795930.png)

![1650338824938](images/1650338824938.png)

![1650338951854](images/1650338951854.png)

![1650339063682](images/1650339063682.png)



# 应用

## 阿里云

