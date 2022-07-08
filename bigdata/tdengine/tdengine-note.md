# TDEngine笔记

# 官方内容

## 参考

- TDengine 3.0 的技术演进规划 https://www.bilibili.com/video/BV1SY411s7Vx
- TDengine 技术内幕分享——兼容 OpenTSDB https://www.bilibili.com/video/BV1Qg411A7kP
- 全面超越OpenTSDB——TDengine的迁移方案和更多时序查询支持能力介绍  https://www.bilibili.com/video/BV1r44y1h7gc

## 历史

![1656904016169](images/1656904016169.png)

![1656904125120](images/1656904125120.png)

![1656904237051](images/1656904237051.png)

![1656904299838](images/1656904299838.png)

![1656904355514](images/1656904355514.png)

![1656904379253](images/1656904379253.png)

![1656904387620](images/1656904387620.png)



## 特点

### 技术创新

![1656903674801](images/1656903674801.png)

- 这个方式不太好，逻辑关系有点问题，跟mysql分库/分表策略有点类似，不过还是以动态分区（按照region 和，日期），按照采集点分桶/分文件比较好，或者只分桶，桶内按照采集点分块可能效果会更好，不然文件数有可能太多，后面的超级表应该是类似的思路；也比较容易理解，而且对于一个采集点的查询可以利用多块磁盘的并行读取
- 时序数据库库内是连续存储，
- 数据块内是列是存储，经过二次压缩（列，整体）

![1656904603759](images/1656904603759.png)

- 这里要重点看看超级表的实现细节

![1656904831833](images/1656904831833.png)



![1656904931234](images/1656904931234.png)

- 这里的分片是基于数据采集点进行，比较容易产生数据倾斜，如何提供灵活的基于数据点的类似于分组/hash算法、以及如何处理数据倾斜造成的vnode节点问题（文件太碎、文件太大）；还有就是前面的超级表怎么弄的细节
- 大概了解了：
  - 每个vode （如V2）节点应该是按照采集点hash的连续存多个分区的数据（T0-T1， T1-T2， T2-T3，。。。）
  - 一个vode节点中的一个分区的数据，按照采集点（所谓表）存成不同的blob

![1656906302402](images/1656906302402.png)

### 3.0功能演进

![1656911696003](images/1656911696003.png)

![1656911988304](images/1656911988304.png)

![1656912218779](images/1656912218779.png)

![1656912299393](images/1656912299393.png)

![1656912351511](images/1656912351511.png)

![1656912400302](images/1656912400302.png)

![1656914165520](images/1656914165520.png)

![1656914281021](images/1656914281021.png)

![1656914506069](images/1656914506069.png)

![1656914598531](images/1656914598531.png)

## 实际场景应用

![1657008859967](images/1657008859967.png)

### ![1657009074366](images/1657009074366.png)

![1657009279773](images/1657009279773.png)

![1657009376872](images/1657009376872.png)

![1657009517444](images/1657009517444.png)

![1657009661636](images/1657009661636.png)

![1657009710424](images/1657009710424.png)

![1657009851619](images/1657009851619.png)

![1657010070692](images/1657010070692.png)

# 技术内幕

## 参考

- TDengine如何高效计算千万级数据的百分位数？ https://www.bilibili.com/video/BV16h411n7Mg

## 技术架构

![1657019664740](images/1657019664740.png)

- 超级表

  - 对应于数据的metric字段，有整个表的元数据信息描述

- 子表

  - 超级表（metric字段）+ tags（字段）MD5出来的字符串（前缀t_）
  - 基于tags的检索快，只需要根据元数据检索出表名，然后再查询\
    - 子表不需要存tags字段	值，这样节省存储空间
  - 一个子表按照时间序的连续数据是放一个vnode中的，子表和vnode的关系是多对1
  - 问题：通过tags提高检索效率/降低存储空间（越多key越好）和文件个数膨胀/数据碎片化（越少key越好）这个是矛盾的，另外需要预防数据污染照成的系统质量不可控
  - 子表下又分了文件组（按照时间段区分），每个文件组分三个文件：
    - .head：索引文件，BRIN（BlockRange Index）
    - .data：数据文件，数据块的形式存在，而且是追加方式
    - .last：数据文件，数据块的形式存在，而且是追加方式
    - 数据块
      - 按时间顺序递增排列
      - 列式存储，根据不同的列类型采用不同的压缩算法

- vode

  - 存储多个表的全部数据
  - 备份策略好弄
  - 可以提供多核技术能力在多个vnode上计算
  - 应该是利用到了类似于redis单核无锁机制
  - 感觉这里可以根据磁盘个数情况划分vnode，一个磁盘一个vnode（写节点），读节点可以根据cpu核心情况划分/或者vnode自行按照核心个数规划算力（回头调研一下这个实践情况）


![1656919564197](images/1656919564197.png)

![1656988315526](images/1656988315526.png)

![1656988398491](images/1656988398491.png)

![1656988688026](images/1656988688026.png)

![1656988876189](images/1656988876189.png)

![1656989181509](images/1656989181509.png)

![1656989313233](images/1656989313233.png)

![1656990401802](images/1656990401802.png)

![1656990422356](images/1656990422356.png)

![1656991460090](images/1656991460090.png)

![1656991585311](images/1656991585311.png)

![1656991616942](images/1656991616942.png)

![1657000626839](images/1657000626839.png)

![1657000677637](images/1657000677637.png)

![1657000845348](images/1657000845348.png)

![1657000921678](images/1657000921678.png)

![1657001083708](images/1657001083708.png)

![1657001285911](images/1657001285911.png)



## 兼容 OpenTSDB

### 优势

![1656916999457](images/1656916999457.png)

![1656917203207](images/1656917203207.png)

![1656917297680](images/1656917297680.png)

### 兼容度

![1656917423255](images/1656917423255.png)

![1656917516204](images/1656917516204.png)

- 插值策略

![1656918018997](images/1656918018997.png)

![1656918289951](images/1656918289951.png)

![1656918736712](images/1656918736712.png)

![1656918954319](images/1656918954319.png)

- 这个太简单了，感觉就是事先按照blob预先计算好了各个聚合函数的值

### 切换收益

![1656919473419](images/1656919473419.png)



### 迁移方案

![1657001453502](images/1657001453502.png)

![1657001486423](images/1657001486423.png)

![1657001536973](images/1657001536973.png)

![1657002481796](images/1657002481796.png)

![1657002508017](images/1657002508017.png)

![1657005595225](images/1657005595225.png)

![1657006094792](images/1657006094792.png)

![1657006129321](images/1657006129321.png)

![1657007381343](images/1657007381343.png)

![1657007471590](images/1657007471590.png)

![1657007953556](images/1657007953556.png)

![1657007984695](images/1657007984695.png)

![1657008180084](images/1657008180084.png)

![1657008299130](images/1657008299130.png)

![1657008404430](images/1657008404430.png)

![1657008554703](images/1657008554703.png)

![1657008608332](images/1657008608332.png)

![1657008673116](images/1657008673116.png)

## 缓存技术

![1657019531712](images/1657019531712.png)

## ![1657019852625](images/1657019852625.png)

![1657020054862](images/1657020054862.png)

![1657020117697](images/1657020117697.png)

![1657020461626](images/1657020461626.png)

![1657020630229](images/1657020630229.png)

![1657020845981](images/1657020845981.png)

![1657020976852](images/1657020976852.png)

![1657021138658](images/1657021138658.png)

![1657021201838](images/1657021201838.png)

![1657021367848](images/1657021367848.png)

![1657021405671](images/1657021405671.png)

![1657021433813](images/1657021433813.png)

![1657021448377](images/1657021448377.png)

## 百分位数

![1657073453274](images/1657073453274.png)

![1657073615064](images/1657073615064.png)

![1657073646867](images/1657073646867.png)

![1657073708495](images/1657073708495.png)

![1657073783407](images/1657073783407.png)

![1657073810945](images/1657073810945.png)

![1657073824438](images/1657073824438.png)

![1657073932713](images/1657073932713.png)

![1657075257714](images/1657075257714.png)

![1657075795663](images/1657075795663.png)

![1657075890423](images/1657075890423.png)

![1657076111404](images/1657076111404.png)

![1657076311278](images/1657076311278.png)

![1657076454801](images/1657076454801.png)

![1657076482326](images/1657076482326.png)

![1657076549760](images/1657076549760.png)

![1657077027386](images/1657077027386.png)

![1657077145936](images/1657077145936.png)

![1657079256297](images/1657079256297.png)

![1657079459673](images/1657079459673.png)

![1657079666083](images/1657079666083.png)

![1657079723752](images/1657079723752.png)

![1657079775800](images/1657079775800.png)

![1657080032956](images/1657080032956.png)

- 相同数据质点容纳的数据个数没有上限

## 数据压缩

- 列存

![1657091174890](images/1657091174890.png)

- 两级压缩
  - 按照字段类型
  - 整体压缩

![1657091201703](images/1657091201703.png)

![1657091317311](images/1657091317311.png)

![1657091406296](images/1657091406296.png)

![1657091468348](images/1657091468348.png)

## 乱序数据

![1657091678706](images/1657091678706.png)

![1657091770957](images/1657091770957.png)

- 乱序数据从尾部向前查找，因为基本时有序的
- 

![1657091958087](images/1657091958087.png)

- 追加数据时，如果有相交，则会成为原来block的sub-block，写 到索引里面

## 数据更新

## ![1657092434982](images/1657092434982.png)

![1657092554705](images/1657092554705.png)

## 条件过滤

![1657095308728](images/1657095308728.png)
## 数据写入

![1657095818961](images/1657095818961.png)

![1657095877005](images/1657095877005.png)

- 重客户端

  - 语法解析

  ![1657096383359](images/1657096383359.png)

  - table meta：客户端缓存， schema和dnode信息
  - 客户端对每个table的数据排序并去重
  - 按照表所属的vnode节点分组发送
  - rpc发送：小于14k的包用udp， 大于14k用tcp
  - 异常处理：通过udp发包有重试机制


