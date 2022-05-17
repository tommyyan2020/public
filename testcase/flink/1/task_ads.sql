-- 重复定义的表
-- ---------------------------------
-- DWD层,支付订单明细表dwd_paid_order_detail
-- ---------------------------------
CREATE TABLE dwd_paid_order_detail
(
  detail_id BIGINT,
  order_id BIGINT,
  user_id BIGINT,
  province_id INT,
  sku_id BIGINT,
  sku_name STRING,
  sku_num INT,
  order_price DECIMAL(10,0),
  create_time STRING,
  pay_time STRING
 ) WITH (
    'connector' = 'kafka',
    'topic' = 'dwd_paid_order_detail',
    'scan.startup.mode' = 'earliest-offset',
    'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',        
    'format' = 'changelog-json'
);



-- Flink SQL Cli操作
-- ---------------------------------
-- 使用 DDL创建MySQL中的ADS层表
-- 指标：1.每天每个省份的订单数
--      2.每天每个省份的订单金额
-- ---------------------------------
CREATE TABLE ads_province_index(
  province_id INT,
  area_code STRING,
  province_name STRING,
  region_id INT,
  region_name STRING,
  order_amount DECIMAL(10,2),
  order_count BIGINT,
  dt STRING,
  PRIMARY KEY (province_id, dt) NOT ENFORCED  
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://192.168.56.101:3306/ads',
    'table-name' = 'ads_province_index', 
    'driver' = 'com.mysql.jdbc.Driver',
    'username' = 'hive',
    'password' = '123'
);

-- ---------------------------------
-- tmp_province_index
-- 订单汇总临时表
-- ---------------------------------
CREATE TABLE tmp_province_index(
    province_id INT,
    order_count BIGINT,-- 订单数
    order_amount DECIMAL(10,2), -- 订单金额
    pay_date DATE
)WITH (
    'connector' = 'kafka',
    'topic' = 'tmp_province_index',
    'scan.startup.mode' = 'earliest-offset',
    'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',
    'format' = 'changelog-json'
);
-- ---------------------------------
-- tmp_province_index
-- 订单汇总临时表数据装载
-- ---------------------------------
INSERT INTO tmp_province_index
SELECT
      province_id,
      count(distinct order_id) order_count,-- 订单数
      sum(order_price * sku_num) order_amount, -- 订单金额
      TO_DATE(pay_time,'yyyy-MM-dd') pay_date
FROM dwd_paid_order_detail
GROUP BY province_id,TO_DATE(pay_time,'yyyy-MM-dd')
;
-- ---------------------------------
-- tmp_province_index_source
-- 使用该临时汇总表，作为数据源
-- ---------------------------------
CREATE TABLE tmp_province_index_source(
    province_id INT,
    order_count BIGINT,-- 订单数
    order_amount DECIMAL(10,2), -- 订单金额
    pay_date DATE,
    proctime as PROCTIME()   -- 通过计算列产生一个处理时间列
 ) WITH (
    'connector' = 'kafka',
    'topic' = 'tmp_province_index',
    'scan.startup.mode' = 'earliest-offset',
    'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',
    'format' = 'changelog-json'
);

-- ---------------------------------
-- DIM层,区域维表,
-- 创建区域维表数据源
-- ---------------------------------
DROP TABLE IF EXISTS `dim_province`;
CREATE TABLE dim_province (
  province_id INT,
  province_name STRING,
  area_code STRING,
  region_id INT,
  region_name STRING ,
  PRIMARY KEY (province_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://192.168.56.101:3306/dim',
    'table-name' = 'dim_province', 
    'driver' = 'com.mysql.jdbc.Driver',
    'username' = 'hive',
    'password' = '123',
    'scan.fetch-size' = '100'
);


-- ---------------------------------
-- 向ads_province_index装载数据
-- 维表JOIN
-- ---------------------------------

INSERT INTO ads_province_index
SELECT
  pc.province_id,
  dp.area_code,
  dp.province_name,
  dp.region_id,
  dp.region_name,
  pc.order_amount,
  pc.order_count,
  cast(pc.pay_date as VARCHAR)
FROM
tmp_province_index_source pc
  JOIN dim_province FOR SYSTEM_TIME AS OF pc.proctime as dp 
  ON dp.province_id = pc.province_id;

  -- ---------------------------------
-- 使用 DDL创建MySQL中的ADS层表
-- 指标：1.每天每个商品对应的订单个数
--      2.每天每个商品对应的订单金额
--      3.每天每个商品对应的数量
-- ---------------------------------
CREATE TABLE ads_sku_index
(
  sku_id BIGINT,
  sku_name VARCHAR,
  weight DOUBLE,
  tm_id BIGINT,
  price DOUBLE,
  spu_id BIGINT,
  c3_id BIGINT,
  c3_name VARCHAR ,
  c2_id BIGINT,
  c2_name VARCHAR,
  c1_id BIGINT,
  c1_name VARCHAR,
  order_amount DOUBLE,
  order_count BIGINT,
  sku_count BIGINT,
  dt varchar,
  PRIMARY KEY (sku_id,dt) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://192.168.56.101:3306/ads',
    'table-name' = 'ads_sku_index', 
    'driver' = 'com.mysql.jdbc.Driver',
    'username' = 'hive',
    'password' = '123'
);


-- ---------------------------------
-- tmp_sku_index
-- 商品指标统计
-- ---------------------------------
CREATE TABLE tmp_sku_index(
    sku_id BIGINT,
    order_count BIGINT,-- 订单数
    order_amount DECIMAL(10,2), -- 订单金额
 order_sku_num BIGINT,
    pay_date DATE
)WITH (
    'connector' = 'kafka',
    'topic' = 'tmp_sku_index',
    'scan.startup.mode' = 'earliest-offset',
    'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092:9092',
    'format' = 'changelog-json'
);
-- ---------------------------------
-- tmp_sku_index
-- 数据装载
-- ---------------------------------
INSERT INTO tmp_sku_index
SELECT
      sku_id,
      count(distinct order_id) order_count,-- 订单数
      sum(order_price * sku_num) order_amount, -- 订单金额
   sum(sku_num) order_sku_num,
      TO_DATE(pay_time,'yyyy-MM-dd') pay_date
FROM dwd_paid_order_detail
GROUP BY sku_id,TO_DATE(pay_time,'yyyy-MM-dd')
;

-- ---------------------------------
-- tmp_sku_index_source
-- 使用该临时汇总表，作为数据源
-- ---------------------------------
CREATE TABLE tmp_sku_index_source(
    sku_id BIGINT,
    order_count BIGINT,-- 订单数
    order_amount DECIMAL(10,2), -- 订单金额
    order_sku_num BIGINT,
    pay_date DATE,
    proctime as PROCTIME()   -- 通过计算列产生一个处理时间列
 ) WITH (
    'connector' = 'kafka',
    'topic' = 'tmp_sku_index',
    'scan.startup.mode' = 'earliest-offset',
    'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092:9092',
    'format' = 'changelog-json'
);
-- ---------------------------------
-- DIM层,商品维表,
-- 创建商品维表数据源
-- ---------------------------------
DROP TABLE IF EXISTS `dim_sku_info`;
CREATE TABLE dim_sku_info (
  id BIGINT,
  sku_name STRING,
  c3_id BIGINT,
  weight DECIMAL(10,2),
  tm_id BIGINT,
  price DECIMAL(10,2),
  spu_id BIGINT,
  c3_name STRING,
  c2_id BIGINT,
  c2_name STRING,
  c1_id BIGINT,
  c1_name STRING,
  PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://192.168.56.101:3306/dim',
    'table-name' = 'dim_sku_info', 
    'driver' = 'com.mysql.jdbc.Driver',
    'username' = 'hive',
    'password' = '123',
    'scan.fetch-size' = '100'
);
-- ---------------------------------
-- 向ads_sku_index装载数据
-- 维表JOIN
-- ---------------------------------
INSERT INTO ads_sku_index
SELECT
  sku_id ,
  sku_name ,
  weight ,
  tm_id ,
  price ,
  spu_id ,
  c3_id ,
  c3_name,
  c2_id ,
  c2_name ,
  c1_id ,
  c1_name ,
  sc.order_amount,
  sc.order_count ,
  sc.order_sku_num ,
  cast(sc.pay_date as VARCHAR)
FROM
tmp_sku_index_source sc 
  JOIN dim_sku_info FOR SYSTEM_TIME AS OF sc.proctime as ds
  ON ds.id = sc.sku_id
  ;