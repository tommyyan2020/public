# 通过Canal实现mysql的binlog到kafka的同步

## 配置MYSQL

### 配置mysql（mariadb 10.x）

/etc/my.cnf.d/mariadb-server.cnf

```ini
[mysqld]
log-bin=mysql-bin # 开启 binlog
binlog-format=ROW # 选择 ROW 模式
server_id=1 # 配置 MySQL replaction 需要定义，不要和 canal 的 slaveId 重复
```

### 查看mysql binlog信息

```sql
# 是否启用binlog日志
show variables like 'log_bin';
# 查看binlog类型
show global variables like 'binlog_format';
# 查看详细的日志配置信息
show global variables like '%log%';
# mysql数据存储目录
show variables like '%dir%';
# 查看binlog的目录
show global variables like "%log_bin%";
# 查看当前服务器使用的biglog文件及大小
show binary logs;
# 查看最新一个binlog日志文件名称和Position
show master status;
```

### mysql给canal授权

```sql
CREATE USER canal IDENTIFIED BY 'canal';  
GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'canal'@'%';
-- GRANT ALL PRIVILEGES ON *.* TO 'canal'@'%' ;
FLUSH PRIVILEGES;
```

## 安装canal

### 下载

```bash
wget https://github.com/alibaba/canal/releases/download/canal-1.1.5/canal.deployer-1.1.5.tar.gz
mkdir canal
tar -zxvf ./canal.deployer-1.1.5.tar.gz -C canal/
```

注意：canal包太不讲究了，不带目录压缩，需要先建立一个canal目录，将压缩包解压缩到指定的目录下

### 配置修改

- 修改conf/example/instance.properties

  ```properties
  canal.instance.mysql.slaveId = 1234
  #position info，需要改成自己的数据库信息,如果同机安装不需要改
  canal.instance.master.address = 127.0.0.1:3306
  canal.mq.topic=test
  ```
- 修改span conf/canal.properties

```properties
# 配置zookeeper地址
canal.zkServers =192.168.56.103:2181,192.168.56.104:2181,192.168.56.105:2181
# 可选项: tcp(默认), kafka, RocketMQ，
canal.serverMode = kafka
# 配置kafka地址
kafka.bootstrap.servers = 192.168.56.103:9020,192.168.56.104:9020,192.168.56.105:9020
```

### 启动

```bash
sh bin/start.sh
```

### 验证

端口监听：11110（admin.port）， 11111（port）， 11112（metrics.pull.port）

如果不安装canal-admin，这里就结束了。

### 特别说明

如果安装canal-admin，canal需要以local模式启动，配置依赖于**canal_local.properties** ，其他的配置失效（conf/example/instance.properties，conf/canal.properties）

## 安装canal-admin

### 下载

```bash
wget https://github.com/alibaba/canal/releases/download/canal-1.1.5/canal.admin-1.1.5.tar.gz
mkdir canal-admin
tar -zxvf ./canal.admin-1.1.5.tar.gz -C canal-admin/
```

### 配置

- 创建canal_manager库

  ```bash
  mysql < conf/canal_manager.sql
  ```

![管理表](https://img-blog.csdnimg.cn/20200120114740802.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3l1MTM4NDMyNzE4NTc=,size_16,color_FFFFFF,t_70)

- 修改conf/application.yml

```yaml
server:
  port: 8089
spring:
  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8

spring.datasource:
  address: 127.0.0.1:3306
  database: canal_manager
  username: canal
  password: canal
  driver-class-name: com.mysql.jdbc.Driver
  url: jdbc:mysql://${spring.datasource.address}/${spring.datasource.database}?useUnicode=true&characterEncoding=UTF-8&useSSL=false
  hikari:
    maximum-pool-size: 30
    minimum-idle: 1

canal:
  adminUser: admin
  adminPasswd: admin
```

这个默认配置挺好的，可以根据需要更改

- 修改canal的conf/canal_local.properties

  ```properties
  # register ip
  canal.register.ip =

  # canal admin config
  canal.admin.manager = 127.0.0.1:8089
  canal.admin.port = 11110
  canal.admin.user = admin
  canal.admin.passwd = 4ACFE3202A5FF5CF467898FC58AAB1D615029441
  # admin auto register
  canal.admin.register.auto = true
  canal.admin.register.cluster =
  canal.admin.register.name = 
  ```

  如果有需要修改一下这个配置，我这里默认配置挺好，就不改了

### 踩坑记

- 如果机器上有多个ip，一定要配置：canal.register.ip为你想要的IP
- 系统有两套账号体系：用户名都是admin
  - web页面登录：默认是密码是123456，需要改一下，对应mysql表为cannal_user
  - 后台验证：默认密码为admin，加密后为4ACFE3202A5FF5CF467898FC58AAB1D615029441，千万不要改，很坑爹，原因
    - canal的conf/canal_local.properties：配置项为canal.admin.passwd，用的是密文：4ACFE3202A5FF5CF467898FC58AAB1D615029441
    - admin的conf/application.yml，对应的是canal: adminPasswd:，用的是明文：admin，
    - 从密文到名为很难的，所以你懂的，可以通过【web账号体系】密码查db字段来找到对应关系，麻烦
- 集群模式
  - 需要再admin的web页面先创建好集群，用英文，不要用中文，不然不好在canal配置文件里面弄
  - 然后修改canal的conf/canal_local.properties 配置项：canal.admin.register.cluster配上前面设置的集群名
  - 先创建好集群统一的配置，主要是zk、kafka之类的，跟canal 里面的canal.properties一样
  - instance名字不能有空格

### 启动

- 停掉canal，以local模式启动canal
  ```bash
  cd canal
  sh bin/stop.sh
  sh bin/startup.sh local
  ```
- 启动canal-admin

```bash
sh bin/startup.sh
```

## 参考文章

- [基于Canal与Flink实现数据实时增量同步(一)](https://mp.weixin.qq.com/s?__biz=MzU2ODQ3NjYyMA==&mid=2247483676&idx=1&sn=c2dafd2dc5cf092d3d74993bb51be45c&scene=21#wechat_redirect)
- [Canal详细入门实战(使用总结)](https://www.cnblogs.com/CZQ-Darren/p/14717521.html)
- [canal.admin、adapter和deployer的区别](https://blog.csdn.net/qq_25275061/article/details/108888780)
