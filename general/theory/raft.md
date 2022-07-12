# raft算法

# 参考

- b站：TDengine研发工程师 李创 Raft算法简介 https://www.bilibili.com/video/BV15Q4y1C7du
- 算法原理的动画演示：https://thesecretlivesofdata.com/raft/
- MIt6.824-Lab3基于Raft实现KV存储 https://zhuanlan.zhihu.com/p/524566276
- Raft 论文研读： https://www.cnblogs.com/brianleelxt/p/13251540.html
- etcd raft
  - etcd raft 源码阅读 https://www.bilibili.com/video/BV1Eb411B7RM
  - 代码：https://github.com/etcd-io/etcd/tree/main/raft wal 两个目录
  - etcd中Raft协议 https://blog.csdn.net/qq_43949280/article/details/122669244
- 小论文：
  - 论文精读笔记：https://zhuanlan.zhihu.com/p/514512060
  - 
- eraft
  - github:https://github.com/eraft-io/eraft
  - 官网：https://eraft.cn/
  - b站：https://www.bilibili.com/video/BV1Fr4y1b7o6

![1657606648467](images/1657606648467.png)

![1657606805735](images/1657606805735.png)

![1657606913945](images/1657606913945.png)

![1657607228411](images/1657607228411.png)

![1657607398774](images/1657607398774.png)

![1657607445717](images/1657607445717.png)

![1657607459122](images/1657607459122.png)

![1657607820962](images/1657607820962.png)

![1657607897624](images/1657607897624.png)

![1657608029344](images/1657608029344.png)

![1657608067863](images/1657608067863.png)

![1657608178756](images/1657608178756.png)

![1657608289749](images/1657608289749.png)

![1657608702948](images/1657608702948.png)

![1657613036592](images/1657613036592.png)

- 最上面的连续数字是索引号
- 方框里面上面的数字是任期号
- 一行是一个节点
- 先比任期号，然后比索引号

![1657613401997](images/1657613401997.png)

![1657613519064](images/1657613519064.png)

![1657613809656](images/1657613809656.png)

![1657613914636](images/1657613914636.png)

![1657614511379](images/1657614511379.png)

![1657614531748](images/1657614531748.png)

![1657614704484](images/1657614704484.png)

- 当选leader首先写一个空日志，清除以前已达成一致未提交的日志，让整个系统先一致

![1657615462528](images/1657615462528.png)

![1657615524413](images/1657615524413.png)

![1657622685408](images/1657622685408.png)

![1657622719785](images/1657622719785.png)

![1657623969447](images/1657623969447.png)

![1657623988861](images/1657623988861.png)