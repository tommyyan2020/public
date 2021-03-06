# Starrocks学习笔记

# 查询

## 基础

![1649644817120](images/1649644817120.png)

![1649651391850](images/1649651391850.png)

![1649651535847](images/1649651535847.png)

![1649651545470](images/1649651545470.png)

![1649651722100](images/1649651722100.png)

![1649659654294](images/1649659654294.png)

![1649660093542](images/1649660093542.png)

![1649660520697](images/1649660520697.png)

![1649661015213](images/1649661015213.png)

## JOIN

### 学习资料

- Join查询优化&HashJoin算子优化 | StarRocks Hacker Meetup第四期：https://www.bilibili.com/video/BV1bi4y1r7Td

### 背景

![1649642563779](images/1649642563779.png)



### 优化难点

![1649643812386](images/1649643812386.png)

![1649644469307](images/1649644469307.png)

![1649644532878](images/1649644532878.png)

![1649644628429](images/1649644628429.png)

![1649644783036](images/1649644783036.png)

### 优化原则

![1649644896067](images/1649644896067.png)

### 逻辑优化 

![1649645149009](images/1649645149009.png) 

#### JOIN类型转换 

![1649645400203](images/1649645400203.png)

- Outer Join转InnerJoin条件：有严格谓词，where子句有过滤null的条件，即放ON条件字段的限定（left outer看右表的条件，反之亦然），不能放on条件里面，因为ON条件决定的是连接关系，没有的要补null

![1649646411714](images/1649646411714.png)

![1649647156093](images/1649647156093.png)

- 如何判断是严格谓词还是非严格谓词：用null替换对应字段，看条件是true（非严格谓词）还是false（严格谓词）

![1649647472042](images/1649647472042.png)

![1649648279911](images/1649648279911.png)

#### 谓词下推

![1649648956996](images/1649648956996.png)

![1649649113738](images/1649649113738.png)

![1649649450389](images/1649649450389.png)

- 与运算才能下推
- 或运算通过谓词提取转换为带限定范围的与运算，然后下推范围

![1649649591975](images/1649649591975.png)

#### 等价推导

![1649649879380](images/1649649879380.png) 

![1649650208286](images/1649650208286.png)

![1649650460637](images/1649650460637.png)

### JoinRecorder

![1649650596836](images/1649650596836.png)

![1649650618975](images/1649650618975.png)

![1649650812480](images/1649650812480.png)

![1649650839049](images/1649650839049.png)

![1649650915544](images/1649650915544.png)

![1649650998075](images/1649650998075.png)

![1649651075877](images/1649651075877.png)

![1649651154813](images/1649651154813.png)

![1649651258896](images/1649651258896.png)

### 分布式JOIN规划

![1649651358177](images/1649651358177.png)

![1649651535847](images/1649651535847.png)

![1649651545470](images/1649651545470.png)

![1649651722100](images/1649651722100.png)

![1649659654294](images/1649659654294.png)

![1649660093542](images/1649660093542.png)

![1649660520697](images/1649660520697.png)

![1649661015213](images/1649661015213.png)



![1649661341682](images/1649661341682.png)

### HashJoin

![1649661652201](images/1649661652201.png)

![1649661700624](images/1649661700624.png)

![1649661767665](images/1649661767665.png)

![1649661789197](images/1649661789197.png)

![1649661863342](images/1649661863342.png)

![1649661903281](images/1649661903281.png)

![1649662008096](images/1649662008096.png)

![1649662081221](images/1649662081221.png)

![1649662107208](images/1649662107208.png)

![1649662250452](images/1649662250452.png)

![1649662267919](images/1649662267919.png)

## ![1649662425520](images/1649662425520.png)



![1649662496666](images/1649662496666.png)

![1649662544084](images/1649662544084.png)

![1649663109600](images/1649663109600.png)

![1649663255912](images/1649663255912.png)

 ![1649663735922](images/1649663735922.png)

![1649663859504](images/1649663859504.png)

![1649663874757](images/1649663874757.png)

![1649663913838](images/1649663913838.png)

![1649664026060](images/1649664026060.png)

![1649664110839](images/1649664110839.png)

![1649664206747](images/1649664206747.png)

![1649664227239](images/1649664227239.png)

![1649664354043](images/1649664354043.png)



## PipeLine执行引擎

### 学习资料

- 走近pipeline执行引擎 | StarRocks Hacker Meetup 第三期 https://www.bilibili.com/video/BV1ES4y137fY

### 背景

#### 原有MPP引擎

![1647312237496](images/1647312237496.png)

![1647312293192](images/1647312293192.png)

![1647312353719](images/1647312353719.png)

![1647312393089](images/1647312393089.png)

#### MPP引擎问题

![1647312477983](images/1647312477983.png)

![1647312586078](images/1647312586078.png)

![1647312615882](images/1647312615882.png)

![1647312635839](images/1647312635839.png)

![1647312666494](images/1647312666494.png)

#### PipeLine引擎

![1647312725746](images/1647312725746.png)

- 单机多核的调度问题

#### PipeLine引擎性能

![1647312859728](images/1647312859728.png)

### 基本原理

#### 方法

- 减少线程数（与cpu core数一致， 用户态和内核态上下文切换），用协程（用户态的调度）
- 调度上用pipelilne方式

![1647313152061](images/1647313152061.png)



Pipeline例子 

- 例子：TPCH Q5

![1647313259124](images/1647313259124.png)

![1647313619733](images/1647313619733.png)

![1647313683950](images/1647313683950.png)

![1647313764455](images/1647313764455.png)

![1647313841892](images/1647313841892.png)

![1647313930079](images/1647313930079.png)

![1647313959184](images/1647313959184.png)

![1647314000579](images/1647314000579.png)

![1647314061866](images/1647314061866.png)

![1647314082540](images/1647314082540.png)

![1647314383316](images/1647314383316.png)

![1647314409743](images/1647314409743.png)

![1647314455940](images/1647314455940.png)

![1647314509095](images/1647314509095.png)

### 实现

![1647314645877](images/1647314645877.png)

#### 算子异步化

![1647314694130](images/1647314694130.png)

![1647314753228](images/1647314753228.png)

![1647314823201](images/1647314823201.png)

![1647314863539](images/1647314863539.png)

#### 算子并行化

![1647315026187](images/1647315026187.png)

![1647315099907](images/1647315099907.png)

![1647315150056](images/1647315150056.png)

![1647315205676](images/1647315205676.png)

![1647315275441](images/1647315275441.png)

![1647315305189](images/1647315305189.png)

短路问题

- pull-best，push-best（current）

![1647315366965](images/1647315366965.png)

![1647315431349](images/1647315431349.png)

![1647315451956](images/1647315451956.png)

![1647315475753](images/1647315475753.png)

![1647315510591](images/1647315510591.png)

![1647586785215](images/1647586785215.png)

![1647315587552](images/1647315587552.png)

![1647315662704](images/1647315662704.png)

![1647315777428](images/1647315777428.png)

![1647315796790](images/1647315796790.png)

![1647315894001](images/1647315894001.png)

![1647316156492](images/1647316156492.png)

![1647587031017](images/1647587031017.png)

![1647587145434](images/1647587145434.png)

![1647587191972](images/1647587191972.png)

### 结论

![1647587298200](images/1647587298200.png)

![1647587358042](images/1647587358042.png)

![1647587444502](images/1647587444502.png)

![1647587510232](images/1647587510232.png)



## 数据写入/更新/读取

### 学习资料

- 列式存储中实时更新和查询性能如何兼得 | StarRocks Hacker Meetup 第二期：https://www.bilibili.com/video/BV1NU4y1f7HJ

### 背景

#### OLAP系统现状

![1646707654358](images/1646707654358.png)

![1646707915932](images/1646707915932.png)

![1646708060114](images/1646708060114.png)

#### 4种更新方案

![1646708164632](images/1646708164632.png)

![1646708260219](images/1646708260219.png)

![1646708356497](images/1646708356497.png)

deltastore：每个数据集存储了对应的变化的数据

![1646708552006](images/1646708552006.png)

deltete/inset：

- 标记每个数据集的删除状态/新数据统一在后面存放
- 好处：文件数会少一些，前面那个方案文件数会double/避免小文件更新早正的io性能问题
- 不好：delete状态的存储

![1646709694216](images/1646709694216.png)

### 基本写入逻辑

#### 基本流程

- 启动一个事务以tablet为单位写多个副本
- 写成功以后fe发起commit版本的操作，

![1646715419264](images/1646715419264.png)



#### tablet的存储结构

- 以primarykey模型为例，其他模型没有delvector和 内存区域的primary key
- primarykey对应的信息记录位置信息保存在内存里面
- delete信息存在rocksdb里面，应该也有内存存放，具体看实现细节
- meta元数据信息：内存缓存、存放版本（版本号，包含的rowset列表，版本变化信息，）列表/下一个rowsetid/
- rocksdb和tablet对应关系未明，感觉是一对多的关系
- rocksdb存放位置未明

![1646715740955](images/1646715740955.png)

#### 元数据信息

![1646721245265](images/1646721245265.png)

#### compaction版本

- 针对一组rowset进行合并
- 结束会生成新的rowset
- 增加minor版本
- 清除delta
- 去掉旧的已合并的rowset列表

![1646721805270](images/1646721805270.png)

#### 垃圾回收

- 半个小时以上未被引用的版本/rowset会被回收

![1646722333193](images/1646722333193.png)

#### 写入流水线

- 以primary key模型为例

- 来源：brokerload/streamload/insert into

- 操作类型：upset/delete

- 请求发送到be的buffer：MemTable

- MemTable满/一批结束以后：排序/合并，flush到磁盘文件，upset和delete（delete无需存放数据）分开存放

- fe发起commit操作到be

- be收到commit请求，做以下三件事，后两件在一个事务里

  - 更新primary key index：查找旧的行位置/标记已删除状态/更新新的行位置
  - 生成delvec
  - 更新元数据

  ![1646723928710](images/1646723928710.png)

- 数据的可见性和一致性：后两步更新应该比较快，

- delvec要采用meta那样按照版本保持delvec，才能做到mvcc， RoaringBitmap 保存的，

#### 例子

![1646724484984](images/1646724484984.png)

![1646724541953](images/1646724541953.png)

#### 并发控制

- 第一步任意执行：这一步比较耗时
- 第二部fe提交commit按照版本号来，这一步快

![1646725394781](images/1646725394781.png)

### Primary Index模型

#### 基本情况

![1646725555107](images/1646725555107.png)

![1646725721797](images/1646725721797.png)

#### 使用场景

![1646725991818](images/1646725991818.png)

- 按天分区的数据：最近的数据是热数据，冷数据的主键索引不会被加载

![1646726149327](images/1646726149327.png)

- 大宽表场景：基于用户的key， 用户数没有明显编号

#### compaction

- 合并原因：小文件，删除后的空洞
- 复杂度：合并后所有的primarykey的位置信息发生变化，需要重新生成

![1646727798071](images/1646727798071.png)

![1646728204509](images/1646728204509.png)

![1646728509212](images/1646728509212.png)

![1646728741694](images/1646728741694.png)

![1646728910819](images/1646728910819.png)

- 记录每个记录对应的rowsetid，compaction版本合并时检查是否已经发生变化，发生变化就不合并进来，逻辑有点重

![1646729449567](images/1646729449567.png)

### 多副本容错

- 多数成功则成功
- 失败的需要从别的成功的be里面clone
- 增量克隆：版本差距比较小，直接copy差的rowset，然后执行一遍commit
- 全量克隆：版本差距比较大，恢复最新的版本的rowset列表

![1646729580115](images/1646729580115.png)

![1646729725653](images/1646729725653.png)

![1646729808078](images/1646729808078.png)

### 数据读取

#### 读取的流水线

 ![1646730008039](images/1646730008039.png)

![1646730027248](images/1646730027248.png)

![1646730224487](images/1646730224487.png)

![1646730266440](images/1646730266440.png)

### 规划

#### 部分字段更新

- https://github.com/StarRocks/StarRocks/pulls?q=%22partial+update%22
- 需要读取原来的数据，变相的copy on write

![1646730373072](images/1646730373072.png)

![1646730612976](images/1646730612976.png)

![1646730669370](images/1646730669370.png)

- 多业务流的简化：各个业务之间解耦，不需要前置flink等就可以加工出大宽表

![1646730742598](images/1646730742598.png)

- 条件更新：避免旧数据覆盖新数据

![1646731092171](images/1646731092171.png)

- 数组字段加元素

#### 更复杂的场景

- 通用的读写事务

![1646730948012](images/1646730948012.png)

![1646731265220](images/1646731265220.png)

![1646731522929](images/1646731522929.png)

![1646731553555](images/1646731553555.png)



![1646731632852](images/1646731632852.png)

![1646731677447](images/1646731677447.png)



## 向量化计算

### 学习资料

- 向量化编程的精髓 | StarRocks Hacker Meetup 第一期 https://www.bilibili.com/video/BV1ea41187KK?spm_id_from=333.999.0.0
-  数据库学习资料 https://blog.bcmeng.com/post/database-learning.html
- 如何打造一款极速分析型数据库：https://blog.bcmeng.com/post/fastest_database.html

### 基础知识

#### CPU执行结构

![1646622497979](images/1646622497979.png)

- 数据流和指令流，都有cache，数据层存在多级性能递减的cache
- 优化核心减少cache-miss的次数

![1646622384698](images/1646622384698.png)

#### CPU Time

```b
 CPU TIME = Instruction Number（指令个数） * CPI（每个指令的时钟周期个数） * Clock Cycle Time(时钟周期)
 
```

#### Intel CPU 性能分析方法

CPU Performance Analysis Top-Down Hierarchy

![1646622883188](images/1646622883188.png)

#### CPU优化方向

![1646623496285](images/1646623496285.png)

- 向量化执行：一条cpu指令处理多条数据，目前主要的优化方向   ：减少指令数
- 减少代码的分支预测错误：if/else类判断，需要重新load指令： 减少CPI
- 提高指令cache和数据cache的命中率，减少cache-miss发生的概率：  减少CPI

#### SIMD

![1646624188864](images/1646624188864.png)

SIMD：单指令多数据的计算

- 一条指令加载多个数据
- 一条指令计算多个数据
- 一条指令将计算结果写回内存

#### SIMD寄存器

- xmm（128 bit）
- ymm（256 bit）
- zmm（512bit）

![1646624897720](images/1646624897720.png)



#### 向量化六种优化方法

分为两大类：自动触发编译器优化，手动写

![1646625050002](images/1646625050002.png)

#### 向量化代码翻译网站

-  https://godbolt.org/

### 编译器自动优化

- gcc版本有要求，越高版本优化会更好

- 循环次数是固定不变的

- 函数是可以被内联的，或者简单的数学函数

- 没有数据依赖的

- 循环里面没有复杂条件

  

### hint提示向量化

- 要求：两个数组的内存不能重叠
- 方法：加_restrict关键字

![1646625405108](images/1646625405108.png)

####   查看是否向量化

通过增加编译选项

- 例子第一条：正常向量化
- 例子第二条：possible aliasing：编译器不知道是否内存相交，可以酌情加上_restrict关键字进行向量化

![1646626028697](images/1646626028697.png)

### 手动编写向量化代码

#### 向量化指令

- 官网：https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html

![1646626934025](images/1646626934025.png)

- 命令规则

![1646626622895](images/1646626622895.png)

#### 例子

![1646626968441](images/1646626968441.png)

###  向量化挑战

#### 挑战点

- 数据要基于列存，全生命周期：磁盘、内存、网络
- 所有的算子要进行向量化：聚合、scan、limit，join、sort、union
- 所有的函数需要向量化：数学函数、字符串函数、case/when
- 尽可能多的出发simd指令
- 重新设计内存管理
- 重新设计数据结构
- 5x性能提升意味着所有的算子和表达式都需要提升5X，没有短板，而不是单一



###   数据存储

#### 磁盘存储

- 层次：从segment file -> data region -> data page(indexed)
- index： short key/ zoom map/ ordinal index（bitmap？） / bloom filter/  inverted index



![1646627867203](images/1646627867203.png)

#### 内存存储

![1646628181773](images/1646628181773.png)
#### 数据结构

- chunk：M clonums * N rows，n == 4096（default）
- chunksize受多因素影响，将来变成自动调整大小

![1646628242600](images/1646628242600.png)

![1646637041426](images/1646637041426.png)

### 算子和表达式

#### 基本思路

![1646628496458](images/1646628496458.png)

算子

按照chunk进行计算

![1646628677093](images/1646628677093.png)

####   表达式计算

![1646628727658](images/1646628727658.png)

#### 去分支

核心：算两遍，根据掩码取结果

![1646629098894](images/1646629098894.png)

#### 过滤器Filter

- 加载数据
- 比较获取掩码的数据
- 左移数据去掉不合格数据，存到result
- 存储结果数据（result）到output
- output指针偏移：加当前mask出来的数据个数

![1646629187138](images/1646629187138.png)

![1646629410656](images/1646629410656.png)

#### shuffle by column

- 按列hash，在o(n)排序

![1646630365360](images/1646630365360.png)

#### Hash聚合

查找hash值为某个具体值的列表

- match数组里面的所有值设置为hash（96）：_mm_set1_epi8
- match 与 ctrl 两个数组求交：_mm_cmpeq_epi8
- 把掩码的FF，变成int值：_mm_movemask_epi8

![1646630526798](images/1646630526798.png)

![1646635282367](images/1646635282367.png)

![1646635336333](images/1646635336333.png)

#### Hash Join

- 论文：balancing vectorized query execution with bandwidth-optimized storage https://dare.uva.nl/search?identifier=5ccbb60a-38b8-4eeb-858a-e7735dd37487

![1646636208092](images/1646636208092.png)

### 优化的方法论和例子

#### 方法论

- 0： profile系统的瓶颈
- 1：引入第三方高性能库
- 2：数据结构i和算法
- 3：自适应策略：CBO
- 4：SIMD指令集优化
- 5：c++底层优化
- 6：内存管理
- 7：cpu缓存管理

![1646637197030](images/1646637197030.png)

#### 例子：并行的hashmap

![1646637529755](images/1646637529755.png)

#### 例子：数据结构和算法：数据编码

- #### 字符串转转字典

- #### where条件优化

![1646637629317](images/1646637629317.png)

- 全局字典。starrocks2.0支持
- 支持scan、filter、agg、sort、join、 string function
- 难度：如何维护全局字典，后面讲
- ck两倍以上优势

![1646637795931](images/1646637795931.png)

#### 例子：动态策略：join运行态过滤计算

- cbo：根据过滤效果决定是否需要使用该过滤器
- 过滤效果50%才使用；5%直接使用当前filter，否则最多只使用3个效果最好的filter

![1646638209045](images/1646638209045.png)

#### 例子：SIMD指令优化：字符串函数

- 判断是不是一个合法的ascii编码 （<128）,判断最高位是否为1（位与0x80）

![1646638530215](images/1646638530215.png)

#### 例子：c++代码层优化

![1646638928086](images/1646638928086.png)

- 减少两次内存copy

![1646638988516](images/1646638988516.png)

例子：HLL内存管理

- 内存一次申请大量内存：按照chunk申请，减少内存频繁申请释放压力

![1646639160004](images/1646639160004.png)

#### 例子：cpu cache

![1646639309848](images/1646639309848.png)

- 瓶颈点在变化

![1646639418014](images/1646639418014.png)



- 空间和时间在局部代码的优化
- 对其代码和数据
- 降低内存访问的范围
- 按照block进行计算
- prefetch（预读）

![1646639466398](images/1646639466398.png)

![1646639699065](images/1646639699065.png)

![1646639759166](images/1646639759166.png)

![1646639890518](images/1646639890518.png)

### 深层思考

#### 底层原理都是类似的

  - ：cpu/starrocks，前端/后端，查询计划/执行层

  ![1646640487964](images/1646640487964.png)

#### 高性能数据库需要什么？

  - 杰出的架构和持续的底层优化

  ![1646640576906](images/1646640576906.png)

 #### 向量化 & 查询编译

  ![1646640685657](images/1646640685657.png)

#### 其他硬件

GPU & FPGA

![1646640865859](images/1646640865859.png)







