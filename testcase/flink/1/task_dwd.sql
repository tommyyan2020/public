-- -------------------------
--   订单详情
--   Kafka Source
-- ------------------------- 

DROP TABLE IF EXISTS `ods_order_detail`;
CREATE TABLE `ods_order_detail`(
  `id` BIGINT,
  `order_id` BIGINT,
  `sku_id` BIGINT,
  `sku_name` STRING,
  `img_url` STRING,
  `order_price` DECIMAL(10,2),
  `sku_num` INT,
  `create_time` TIMESTAMP(0)
) WITH(
 'connector' = 'kafka',
 'topic' = 'mydw_order_detail',
 'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',
 'properties.group.id' = 'testGroup',
 'canal-json.ignore-parse-errors' = 'true',
 'format' = 'canal-json' ,
 'scan.startup.mode' = 'earliest-offset' 
) ; 

-- -------------------------
--   订单信息
--   Kafka Source
-- -------------------------
DROP TABLE IF EXISTS `ods_order_info`;
CREATE TABLE `ods_order_info` (
  `id` BIGINT,
  `consignee` STRING,
  `consignee_tel` STRING,
  `total_amount` DECIMAL(10,2),
  `order_status` STRING,
  `user_id` BIGINT,
  `payment_way` STRING,
  `delivery_address` STRING,
  `order_comment` STRING,
  `out_trade_no` STRING,
  `trade_body` STRING,
  `create_time` TIMESTAMP(0) ,
  `operate_time` TIMESTAMP(0) ,
  `expire_time` TIMESTAMP(0) ,
  `tracking_no` STRING,
  `parent_order_id` BIGINT,
  `img_url` STRING,
  `province_id` INT
) WITH(
'connector' = 'kafka',
 'topic' = 'mydw_order_info',
 'properties.bootstrap.servers' = '192.168.56.103:9092,192.168.56.104:9092,192.168.56.105:9092',
 'properties.group.id' = 'testGroup',
 'canal-json.ignore-parse-errors' = 'true',
 'format' = 'canal-json' ,
 'scan.startup.mode' = 'earliest-offset' 
); 

-- ---------------------------------
-- DWD层,支付订单明细表dwd_paid_order_detail
-- ---------------------------------
DROP TABLE IF EXISTS dwd_paid_order_detail;
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
-- ---------------------------------
-- DWD层,已支付订单明细表
-- 向dwd_paid_order_detail装载数据
-- ---------------------------------
INSERT INTO dwd_paid_order_detail
SELECT
  od.id,
  oi.id order_id,
  oi.user_id,
  oi.province_id,
  od.sku_id,
  od.sku_name,
  od.sku_num,
  od.order_price,
  cast(oi.create_time as varchar),
  cast(oi.operate_time as varchar)
FROM
    (
    SELECT * 
    FROM ods_order_info
    WHERE order_status = '2' -- 已支付
    ) oi JOIN
    (
    SELECT *
    FROM ods_order_detail
    ) od 
    ON oi.id = od.order_id;