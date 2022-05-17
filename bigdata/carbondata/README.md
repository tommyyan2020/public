

版本演化
版本号	发布日期	特性
2.0 RC2	2020年5月	索引和物化视图能力：
详单查询：二级索引、BloomFilter索引、Lucene索引、空间索引、Segment级别MINMAX索引，实现PB级别秒级详单查询；
复杂查询：物化视图、时序聚合、分桶索引，实现复杂查询秒级响应；
海量索引管理：分布式内存索引缓存、并支持索引内存预加载；
数据湖能力：

历史数据无缝迁移：支持对Parquet、ORC、CarbonData数据进行统一元数据管理，PB级别Parquet、ORC数据秒级迁移CarbonData；
历史数据加速：为Parquet、ORC、CarbonData构建统一物化视图；
异构计算融合：对接Flink、Hive、Presto、PyTorch、TensorFlow，实现“一份数据到处访问”；
ACID能力：
Insert、Update和Delete性能增强，支持Merge语法
		
		




https://www.iteblog.com/archives/2375.html

大数据小视角3：CarbonData，来自华为的中国力量
https://www.cnblogs.com/happenlee/p/9202236.html

Apache CarbonData 2.0 RC2预览版发布，在数据湖+索引+ACID方面大幅增强
https://blog.csdn.net/marchpure_312/article/details/105903080

然而并没什么卵用的Apache CarbonData发布功能强劲的2.0版
https://3g.163.com/news/article/FC79M3MS05315PUD.html?from=history-back-list

Apache CarbonData 1.4.0 正式发布，多项新功能及性能提升(2018-06-05)
https://www.iteblog.com/archives/2375.html
Apache CarbonData里程碑式版本1.3发布，多个重要新特性(2018-02-09)
https://www.sohu.com/a/221807484_315839

Apache CarbonData 1.0.0 发布(第4个稳定版本)(2017-01)
https://www.kejianet.cn/apache-carbondata/
Carbondata源码阅读(1) - Carbondata Presto Connector
https://blog.csdn.net/bhq2010/article/details/72972278
如何评价Apache CarbonData成为Apache基金会顶级项目
https://www.zhihu.com/question/58854775
Carbondata integration-presto查询carbondata
https://blog.csdn.net/hjw199089/article/details/88752798

Delta Lake
大数据：DataBricks新项目Delta Lake的深度分析和解读
http://www.toojiao.com/Index/News/news/id/1230.html
Delta的真正用处和价值，你可知道
https://blog.csdn.net/allwefantasy/article/details/89876869


databricks使用教程
https://blog.csdn.net/RONE321/article/details/90413306

Apache Hudi
Apache Hudi 介绍与应用
https://www.cnblogs.com/zackstang/p/11912994.html
delta-lake 系列— delta对比hudi
https://my.oschina.net/u/2484672/blog/3131156
