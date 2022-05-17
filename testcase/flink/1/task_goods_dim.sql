-- -------------------------
--  一级类目表
--   kafka Source
-- ------------------------- 
DROP TABLE IF EXISTS `ods_base_category1`;
CREATE TABLE `ods_base_category1` (
  `id` BIGINT,
  `name` STRING
)WITH(
 'connector' = 'kafka',
 'topic' = 'mydw_base_category1',
 'canal-json.ignore-parse-errors' = 'true',
 'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',
 'properties.group.id' = 'testGroup',
 'format' = 'canal-json' ,
 'scan.startup.mode' = 'earliest-offset' 
) ;

-- -------------------------
--  一级类目表
--   MySQL Sink
-- ------------------------- 
DROP TABLE IF EXISTS `base_category1`;
CREATE TABLE `base_category1` (
    `id` BIGINT,
    `name` STRING,
     PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://192.168.56.101:3306/dim',
    'table-name' = 'base_category1', -- MySQL中的待插入数据的表
    'driver' = 'com.mysql.jdbc.Driver',
    'username' = 'hive',
    'password' = '123',
    'sink.buffer-flush.interval' = '1s'
);

-- -------------------------
--  一级类目表
--   MySQL Sink Load Data
-- ------------------------- 

INSERT INTO base_category1
SELECT *
FROM ods_base_category1;

-- -------------------------
--  二级类目表
--   kafka Source
-- ------------------------- 
DROP TABLE IF EXISTS `ods_base_category2`;
CREATE TABLE `ods_base_category2` (
  `id` BIGINT,
  `name` STRING,
  `category1_id` BIGINT
)WITH(
'connector' = 'kafka',
 'topic' = 'mydw_base_category2',
 'canal-json.ignore-parse-errors' = 'true',
 'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',
 'properties.group.id' = 'testGroup',
 'format' = 'canal-json' ,
 'scan.startup.mode' = 'earliest-offset' 
) ;

-- -------------------------
--  二级类目表
--   MySQL Sink
-- ------------------------- 
DROP TABLE IF EXISTS `base_category2`;
CREATE TABLE `base_category2` (
    `id` BIGINT,
    `name` STRING,
    `category1_id` BIGINT,
     PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://192.168.56.101:3306/dim',
    'table-name' = 'base_category2', -- MySQL中的待插入数据的表
    'driver' = 'com.mysql.jdbc.Driver',
    'username' = 'hive',
    'password' = '123',
    'sink.buffer-flush.interval' = '1s'
);

-- -------------------------
--  二级类目表
--   MySQL Sink Load Data
-- ------------------------- 
INSERT INTO base_category2
SELECT *
FROM ods_base_category2;

-- -------------------------
-- 三级类目表
--   kafka Source
-- ------------------------- 
DROP TABLE IF EXISTS `ods_base_category3`;
CREATE TABLE `ods_base_category3` (
  `id` BIGINT,
  `name` STRING,
  `category2_id` BIGINT
)WITH(
'connector' = 'kafka',
 'topic' = 'mydw_base_category3',
 'canal-json.ignore-parse-errors' = 'true',
 'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',
 'properties.group.id' = 'testGroup',
 'format' = 'canal-json' ,
 'scan.startup.mode' = 'earliest-offset' 
) ; 

-- -------------------------
--  三级类目表
--   MySQL Sink
-- ------------------------- 
DROP TABLE IF EXISTS `base_category3`;
CREATE TABLE `base_category3` (
    `id` BIGINT,
    `name` STRING,
    `category2_id` BIGINT,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://192.168.56.101:3306/dim',
    'table-name' = 'base_category3', -- MySQL中的待插入数据的表
    'driver' = 'com.mysql.jdbc.Driver',
    'username' = 'hive',
    'password' = '123',
    'sink.buffer-flush.interval' = '1s'
);

-- -------------------------
--  三级类目表
--   MySQL Sink Load Data
-- ------------------------- 
INSERT INTO base_category3
SELECT *
FROM ods_base_category3;

-- -------------------------
--   商品表
--   Kafka Source
-- ------------------------- 

DROP TABLE IF EXISTS `ods_sku_info`;
CREATE TABLE `ods_sku_info` (
  `id` BIGINT,
  `spu_id` BIGINT,
  `price` DECIMAL(10,0),
  `sku_name` STRING,
  `sku_desc` STRING,
  `weight` DECIMAL(10,2),
  `tm_id` BIGINT,
  `category3_id` BIGINT,
  `sku_default_img` STRING,
  `create_time` TIMESTAMP(0)
) WITH(
 'connector' = 'kafka',
 'topic' = 'mydw_sku_info',
 'canal-json.ignore-parse-errors' = 'true',
 'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',
 'properties.group.id' = 'testGroup',
 'format' = 'canal-json' ,
 'scan.startup.mode' = 'earliest-offset' 
) ; 

-- -------------------------
--   商品表
--   MySQL Sink
-- ------------------------- 
DROP TABLE IF EXISTS `sku_info`;
CREATE TABLE `sku_info` (
  `id` BIGINT,
  `spu_id` BIGINT,
  `price` DECIMAL(10,0),
  `sku_name` STRING,
  `sku_desc` STRING,
  `weight` DECIMAL(10,2),
  `tm_id` BIGINT,
  `category3_id` BIGINT,
  `sku_default_img` STRING,
  `create_time` TIMESTAMP(0),
   PRIMARY KEY (tm_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://192.168.56.101:3306/dim',
    'table-name' = 'sku_info', -- MySQL中的待插入数据的表
    'driver' = 'com.mysql.jdbc.Driver',
    'username' = 'hive',
    'password' = '123',
    'sink.buffer-flush.interval' = '1s'
);

-- -------------------------
--   商品
--   MySQL Sink Load Data
-- ------------------------- 
INSERT INTO sku_info
SELECT *
FROM ods_sku_info;