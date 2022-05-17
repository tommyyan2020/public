-- -------------------------
-- DIM层维表数据准备
-- ------------------------- 

-- -------------------------
--   省份
--   kafka Source
-- ------------------------- 
-- DROP TABLE IF EXISTS `ods_base_province`;
CREATE TABLE `ods_base_province` (
  `id` INT,
  `name` STRING,
  `region_id` INT ,
  `area_code`STRING
) WITH(
'connector' = 'kafka',
 'topic' = 'mydw_base_province',
 'canal-json.ignore-parse-errors' = 'true',
 'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',
 'properties.group.id' = 'testGroup',
 'format' = 'canal-json' ,
 'scan.startup.mode' = 'earliest-offset' 
) ; 

-- -------------------------
--   省份
--   MySQL Sink
-- ------------------------- 
DROP TABLE IF EXISTS `base_province`;
CREATE TABLE `base_province` (
    `id` INT,
    `name` STRING,
    `region_id` INT ,
    `area_code`STRING,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://192.168.56.101:3306/dim',
    'table-name' = 'base_province', -- MySQL中的待插入数据的表
    'driver' = 'com.mysql.jdbc.Driver',
    'username' = 'hive',
    'password' = '123',
    'sink.buffer-flush.interval' = '1s'
);

-- -------------------------
--   省份
--   MySQL Sink Load Data
-- ------------------------- 
INSERT INTO base_province
SELECT *
FROM ods_base_province;

-- -------------------------
--   区域
--   kafka Source
-- ------------------------- 
-- DROP TABLE IF EXISTS `ods_base_region`;
CREATE TABLE `ods_base_region` (
  `id` INT,
  `region_name` STRING
) WITH(
'connector' = 'kafka',
 'topic' = 'mydw_base_region',
 'canal-json.ignore-parse-errors' = 'true',
 'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',
 'properties.group.id' = 'testGroup',
 'format' = 'canal-json' ,
 'scan.startup.mode' = 'earliest-offset' 
) ; 

-- -------------------------
--   区域
--   MySQL Sink
-- ------------------------- 
DROP TABLE IF EXISTS `base_region`;
CREATE TABLE `base_region` (
    `id` INT,
    `region_name` STRING,
     PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://192.168.56.101:3306/dim',
    'table-name' = 'base_region', -- MySQL中的待插入数据的表
    'driver' = 'com.mysql.jdbc.Driver',
    'username' = 'hive',
    'password' = '123',
    'sink.buffer-flush.interval' = '1s'
);

-- -------------------------
--   区域
--   MySQL Sink Load Data
-- ------------------------- 
INSERT INTO base_region
SELECT *
FROM ods_base_region;