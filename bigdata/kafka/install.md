# kafka集群安装

## 1、下载安装包

- 官网地址：https://kafka.apache.org/downloads
- 本次安装包：kafka_2.12-2.4.0
- 命令
  ```bash
  wget https://archive.apache.org/dist/kafka/2.4.0/kafka_2.12-2.4.0.tgz
  ```

## 2、安装环境

- IP：103、104、105
- 命令，以103为例、各个机器之间已经开通免密登录

  ```bash
  scp ./kafka_2.12-2.4.0.tgz 192.168.56.103:/data/tools/bd
  cd /data/tools/bd
  tar -zxvf ./kafka_2.12-2.4.0.tgz
  # 所有大数据组件放在/usr/bd下面，软链接方便管理
  ln -s /data/tools/bd/kafka_2.12-2.4.0 /usr/bd/kafka
  ```

## 3、配置/启动zookeeper

- 采用kafka自带的zk
- 启动配置，以103为例，其他两个目录一样的，起始路径为kafka安装路径：/data/tools/bd/kafka_2.12-2.4.0，三个节点分别echo 1、2、3到myid

  ```bash
  #创建zk数据的本地目录
  mkdir zkdata
  echo "1" > /data/tools/bd/kafka_2.12-2.4.0/zkdata/myid
  vi config/zookeeper.properties
  ```
- zk配置项

  ```properties
  tickTime=2000
  initLimit=10
  syncLimit=5
  dataDir=/data/tools/bd/kafka_2.12-2.4.0/zkdata
  server.1=192.168.56.103:2888:3888
  server.2=192.168.56.104:2888:3888
  server.3=192.168.56.105:2888:3888
  ```
- 启动、停止zk

```bash
#启动
sh bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
#停止
sh bin/zookeeper-server-stop.sh
```

## 4、配置、启动kafka

- 启动配置

```bash
vi config/server.propertie
```

- kafka配置项，以103为例，三台机器broker.id分别为0、1、2

```properties

broker.id=0
listeners=PLAINTEXT://kafka-1.local:9092
log.dirs=logs/
zookeeper.connect=192.168.56.103:2181,192.168.56.104:2181,192.168.56.105:2181
```

- 启动、停止kafka

```bash
#启动
nohup bin/kafka-server-start.sh ./config/server.properties > logs/kafka.log &
# 停止
sh bin/kafka-server-stop.sh
```

## 5、测试kafka

```bash
# 创建topic,--replication-factor指定副本个数,--partitions指定分区个数
kafka-topics.sh --create --zookeeper 192.168.56.103:2181,192.168.56.104:2181,192.168.56.105:2181 --replication-factor 1 --partitions 1 --topic test
 
//查看所有的topic信息
kafka-topics.sh --list --zookeeper 192.168.56.103:2181
 
//启动生产者
kafka-console-producer.sh --broker-list 192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092 --topic test
> hello world 1
> hello world 2
> hello world 3
 
//启动消费者
kafka-console-consumer.sh --bootstrap-server 192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092 --topic test --from-beginning
 
//删除topic
kafka-topics.sh --delete --zookeeper 192.168.56.103:2181 --topic test

```
