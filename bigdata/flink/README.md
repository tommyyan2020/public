# 大数据/Flink

## 网站

### 官方

- Apache Flink：https://flink.apache.org/
- Github: https://github.com/apache/flink
- 中文社区：https://flink-learning.org.cn/
- 镜像下载站：有源代码和bin

  https://mirrors.bfsu.edu.cn/apache/flink/ 推荐 https://mirrors.tuna.tsinghua.edu.cn/apache/flink/
- 官方文档

  - 1.13：https://ci.apache.org/projects/flink/flink-docs-release-1.13/
  - master: https://ci.apache.org/projects/flink/flink-docs-master/
- 库下载

  - https://repo1.maven.org/maven2/com/alibaba/ververica/
- 官方渠道：钉钉群

### 专项技术

#### CDC

##### 官方支持

- Canal    https://ci.apache.org/projects/flink/flink-docs-release-1.11/zh/dev/table/connectors/formats/canal.html
- Debezium  https://ci.apache.org/projects/flink/flink-docs-release-1.11/zh/dev/table/connectors/formats/debezium.html

##### 社区

- mysql-cdc  https://github.com/ververica/flink-cdc-connectors/wiki/MySQL-CDC-Connector
- changelog-json  https://github.com/ververica/flink-cdc-connectors/wiki/Changelog-JSON-Format

## 书籍

## 资料

### Meetup

#### 2021.04.17 上海站

- Flink 和 Iceberg 如何解决数据入湖面临的挑战 https://developer.aliyun.com/article/784806?spm=a2c6h.13148508.0.0.51394f0ef6IrUb

#### 2021.08.07 深圳站

- Apache Flink Meetup · 线上（附 PPT 下载） https://mp.weixin.qq.com/s/Ou2W6Vv4GhyYZW162jwFIg

### 专题

- Info专题：Apache Flink零基础入门到进阶：https://www.infoq.cn/theme/28

## 文章

### 原创

### 官方

- 阿里云官方文档
  - 产品介绍页：https://www.aliyun.com/product/bigdata/sc
  - 产品文档：https://help.aliyun.com/product/45029.html

### 论文

- https://www.oreilly.com/radar/the-world-beyond-batch-streaming-101/
- https://static.googleusercontent.com/media/research.google.com/zh-CN//pubs/archive/43864.pdf

### CDC

- canal和FlinkCDC的总结 https://blog.csdn.net/weixin_45150724/article/details/115415755
- flink教程-详解flink 1.11 中的CDC (Change Data Capture) https://blog.csdn.net/zhangjun5965/article/details/107605396
- Flink CDC 原理、实践和优化 https://cloud.tencent.com/developer/article/1801766
- 基于 Flink SQL CDC的实时数据同步方案 http://www.dreamwu.com/post-1594.html
- Flink + Debezium CDC 实现原理及代码实战:https://www.aboutyun.com/thread-30406-1-1.html

### 实践

- 网易云音乐
  - Flink SQL 在网易云音乐的产品化实践

    视频：https://www.bilibili.com/video/BV1164y1o7yc?p=7
    文章：https://blog.csdn.net/weixin_44904816/article/details/114909589
  - 网易云音乐基于 Flink + Kafka 的实时数仓建设实践：https://blog.csdn.net/huzechen/article/details/109831612
  - 进击的 Flink：网易云音乐实时数仓建设实践：https://blog.csdn.net/weixin_44904816/article/details/107478823
