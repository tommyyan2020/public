CREATE DATABASE dim;
USE dim;
CREATE TABLE `order_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `consignee` varchar(100) DEFAULT NULL COMMENT '收货人',
  `consignee_tel` varchar(20) DEFAULT NULL COMMENT '收件人电话',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '总金额',
  `order_status` varchar(20) DEFAULT NULL COMMENT '订单状态',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `payment_way` varchar(20) DEFAULT NULL COMMENT '付款方式',
  `delivery_address` varchar(1000) DEFAULT NULL COMMENT '送货地址',
  `order_comment` varchar(200) DEFAULT NULL COMMENT '订单备注',
  `out_trade_no` varchar(50) DEFAULT NULL COMMENT '订单交易编号（第三方支付用)',
  `trade_body` varchar(200) DEFAULT NULL COMMENT '订单描述(第三方支付用)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `operate_time` datetime DEFAULT NULL COMMENT '操作时间',
  `expire_time` datetime DEFAULT NULL COMMENT '失效时间',
  `tracking_no` varchar(100) DEFAULT NULL COMMENT '物流单编号',
  `parent_order_id` bigint(20) DEFAULT NULL COMMENT '父订单编号',
  `img_url` varchar(200) DEFAULT NULL COMMENT '图片路径',
  `province_id` int(20) DEFAULT NULL COMMENT '地区',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='订单表';

CREATE TABLE `order_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint(20) DEFAULT NULL COMMENT '订单编号',
  `sku_id` bigint(20) DEFAULT NULL COMMENT 'sku_id',
  `sku_name` varchar(200) DEFAULT NULL COMMENT 'sku名称（冗余)',
  `img_url` varchar(200) DEFAULT NULL COMMENT '图片名称（冗余)',
  `order_price` decimal(10,2) DEFAULT NULL COMMENT '购买价格(下单时sku价格）',
  `sku_num` varchar(200) DEFAULT NULL COMMENT '购买个数',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='订单详情表';

CREATE TABLE `sku_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'skuid(itemID)',
  `spu_id` bigint(20) DEFAULT NULL COMMENT 'spuid',
  `price` decimal(10,0) DEFAULT NULL COMMENT '价格',
  `sku_name` varchar(200) DEFAULT NULL COMMENT 'sku名称',
  `sku_desc` varchar(2000) DEFAULT NULL COMMENT '商品规格描述',
  `weight` decimal(10,2) DEFAULT NULL COMMENT '重量',
  `tm_id` bigint(20) DEFAULT NULL COMMENT '品牌(冗余)',
  `category3_id` bigint(20) DEFAULT NULL COMMENT '三级分类id（冗余)',
  `sku_default_img` varchar(200) DEFAULT NULL COMMENT '默认显示图片(冗余)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='商品表';

CREATE TABLE `base_category1` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(10) NOT NULL COMMENT '分类名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='一级分类表';

CREATE TABLE `base_category2` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) NOT NULL COMMENT '二级分类名称',
  `category1_id` bigint(20) DEFAULT NULL COMMENT '一级分类编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='二级分类表';


CREATE TABLE `base_category3` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) NOT NULL COMMENT '三级分类名称',
  `category2_id` bigint(20) DEFAULT NULL COMMENT '二级分类编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='三级分类表';


CREATE TABLE `base_province` (
  `id` int(20) DEFAULT NULL COMMENT 'id',
  `name` varchar(20) DEFAULT NULL COMMENT '省名称',
  `region_id` int(20) DEFAULT NULL COMMENT '大区id',
  `area_code` varchar(20) DEFAULT NULL COMMENT '行政区位码'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `base_region` (
  `id` int(20) NOT NULL COMMENT '大区id',
  `region_name` varchar(20) DEFAULT NULL COMMENT '大区名称',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP VIEW IF EXISTS dim_province;
CREATE VIEW dim_province AS
SELECT
  bp.id AS province_id,
  bp.name AS province_name,
  br.id AS region_id,
  br.region_name AS region_name,
  bp.area_code AS area_code
FROM base_region br 
     JOIN base_province bp ON br.id= bp.region_id
;

CREATE DATABASE ads;

CREATE TABLE ads.ads_province_index(
  province_id INT(10),
  area_code VARCHAR(100),
  province_name VARCHAR(100),
  region_id INT(10),
  region_name VARCHAR(100),
  order_amount DECIMAL(10,2),
  order_count BIGINT(10),
  dt VARCHAR(100),
  PRIMARY KEY (province_id, dt) 
);

CREATE TABLE ads.ads_sku_index
(
  sku_id BIGINT(10),
  sku_name VARCHAR(100),
  weight DOUBLE,
  tm_id BIGINT(10),
  price DOUBLE,
  spu_id BIGINT(10),
  c3_id BIGINT(10),
  c3_name VARCHAR(100) ,
  c2_id BIGINT(10),
  c2_name VARCHAR(100),
  c1_id BIGINT(10),
  c1_name VARCHAR(100),
  order_amount DOUBLE,
  order_count BIGINT(10),
  sku_count BIGINT(10),
  dt varchar(100),
  PRIMARY KEY (sku_id,dt)
);



