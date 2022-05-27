# doris源代码解析

# 参考

- b站系列官方教程：https://space.bilibili.com/362350065/video
- 官方github源代码：[doris-1.0.0-rc03](https://github.com/apache/incubator-doris/archive/refs/tags/1.0.0-rc03.tar.gz)
- 

# 基本信息

## 目录结构

![1653272019116](images/1653272019116.png)

```bash
tree -d -L 2
├── be
│   ├── build_Release
│   ├── output
│   ├── src
│   └── test
├── bin
├── build-support
├── conf
├── contrib
│   └── udf
├── docker
├── docs
│   ├── build
│   ├── contents
│   ├── en
│   └── zh-CN
├── extension
│   ├── DataX
│   └── logstash
├── fe
│   ├── conf
│   ├── fe-common
│   ├── fe-core
│   ├── hive-udf
│   └── spark-dpp
├── fe_plugins
│   ├── auditdemo
│   └── auditloader
├── fs_brokers
│   └── apache_hdfs_broker
├── gensrc
│   ├── build
│   ├── proto
│   ├── script
│   └── thrift
├── output
│   ├── apache_hdfs_broker
│   ├── be
│   ├── fe
│   └── udf
├── regression-test
│   ├── conf
│   ├── data
│   ├── framework
│   └── suites
├── samples
│   ├── connect
│   ├── doris-demo
│   ├── insert
│   ├── mini_load
│   └── stream_load
├── thirdparty
│   └── patches
├── tools
│   ├── row_to_column
│   ├── show_segment_status
│   ├── ssb-tools
│   └── systemd
├── ui   					# 这个目录包含的子目录太多了，就不要tree三层了
│   ├── config
│   ├── dist
│   ├── node_modules
│   ├── public
│   └── src
└── webroot
    ├── be
    └── static
    
tree be/src -d -L 2
be/src
├── agent					# 接收任务，对应fe的task模块
├── common
├── env
├── exec					# 各种算子、节点
│   ├── es
│   └── schema_scanner
├── exprs
│   └── table_function
├── gen_cpp
├── geo
├── glibc-compatibility
│   └── musl
├── gutil
│   ├── hash
│   ├── strings
│   ├── threading
│   └── utf
├── http					# http服务、统计、stream load
│   └── action				# http的cgi服务目录
├── olap
│   ├── fs
│   ├── memory
│   ├── rowset
│   └── task
├── runtime
│   ├── bufferpool
│   ├── cache
│   ├── memory
│   ├── routine_load
│   └── stream_load			# streamload的核心代码
├── service
├── testutil
├── tools
├── udf
├── util
│   ├── arrow
│   ├── debug
│   ├── mustache
│   └── simd
└── vec
    ├── aggregate_functions
    ├── columns
    ├── common
    ├── core
    ├── data_types
    ├── exec
    ├── exprs
    ├── functions
    ├── io
    ├── olap
    ├── runtime
    ├── sink
    └── utils
    

be
├── build_Release
│   ├── CMakeFiles
│   ├── src
│   └── test
├── output
│   ├── bin
│   ├── conf
│   ├── lib
│   └── udf
├── src
│   ├── agent					# 接收任务，对应fe的task模块
│   ├── common
│   ├── env
│   ├── exec
│   ├── exprs
│   ├── gen_cpp
│   ├── geo
│   ├── glibc-compatibility
│   ├── gutil
│   ├── http
│   ├── olap
│   ├── runtime
│   	├── stream_load 
│   ├── service
│   ├── testutil
│   ├── tools
│   ├── udf
│   ├── util
│   └── vec
└── test
    ├── agent
    ├── common
    ├── env
    ├── exec
    ├── exprs
    ├── geo
    ├── gutil
    ├── http				# http服务、统计、stream load，服务在action目录下
    ├── olap
    ├── plugin
    ├── runtime
    ├── test_util
    ├── tools
    ├── udf
    ├── util
    └── vec
    
tree fe -d -L 2
fe
├── conf
├── fe-common
│   ├── src
│   └── target
├── fe-core
│   ├── src
│   └── target
├── hive-udf
│   └── src
└── spark-dpp
    ├── src
    └── target
    
tree fe/fe-core/src -d -L 6

fe/fe-core/src
├── main
│   ├── cup
│   ├── java
│   │   └── org
│   │       └── apache
│   │           └── doris				#核心fe代码目录
│   │               ├── alter
│   │               ├── analysis		# SQL解析相关的逻辑
│   │               ├── backup
│   │               ├── blockrule
│   │               ├── catalog			# 元数据管理
│   │               ├── clone
│   │               ├── cluster
│   │               ├── common
│   │               ├── consistency
│   │               ├── deploy
│   │               ├── external
│   │               ├── ha
│   │               ├── http			# 默认没用，starrocks用的这个
│   │               ├── httpv2			# web服务，查询元数据信息/统计、streamload等，springboot实现
│   │               ├── journal
│   │               ├── ldap
│   │               ├── load			# 各种load任务相关的代码：broker load /stream load
│   │               ├── master			# master节点特有的逻辑
│   │               ├── metric
│   │               ├── monitor
│   │               ├── mysql			# mysql服务（nio模式的server）、协议解析、权限管控
│   │               ├── persist			# 数据持久化，editlog, 数据文件格式（segment V2）、database
│   │               ├── planner			# 查询规划器
│   │               ├── plugin
│   │               ├── qe				# QeService, mysql服务支持，
│   │               ├── resource
│   │               ├── rewrite
│   │               ├── rpc				# rpc服务
│   │               ├── service			# thrift server 封装
│   │               ├── statistics
│   │               ├── system
│   │               ├── task			# 多线程任务执行系统
│   │               └── transaction
│   ├── jflex
│   └── resources
│       └── static
└── test
    ├── java
    │   ├── org
    │   │   └── apache
    │   │       └── doris
    │   │           ├── alter
    │   │           ├── analysis
    │   │           ├── backup
    │   │           ├── bdb
    │   │           ├── blockrule
    │   │           ├── catalog			
    │   │           ├── clone
    │   │           ├── cluster
    │   │           ├── common
    │   │           ├── deploy
    │   │           ├── external
    │   │           ├── http
    │   │           ├── ldap
    │   │           ├── load
    │   │           ├── metric
    │   │           ├── mysql			
    │   │           ├── persist
    │   │           ├── planner
    │   │           ├── plugin
    │   │           ├── qe
    │   │           ├── resource
    │   │           ├── rewrite
    │   │           ├── service
    │   │           ├── system
    │   │           ├── task
    │   │           ├── transaction
    │   │           └── utframe
    │   └── plugin
    └── resources
        ├── data
        │   ├── es
        │   ├── help
        │   │   └── Admin
        │   │       ├── Select
        │   │       └── Show
        │   ├── qe
        │   └── show_help
        │       └── functions
        │           ├── binary function
        │           └── bit function
        └── plugin_test
            ├── source
            └── test_local_plugin
    
```

### 文件统计

```bash
# be\src 目录下
. : 1720
./exprs : 114
./runtime : 195
./gen_cpp : 1
./http : 68
./vec : 346
./gutil : 93
./agent : 18
./exec : 180
./service : 13
./testutil : 5
./env : 9
./glibc-compatibility : 90
./tools : 2
./util : 227
./common : 19
./udf : 6
./geo : 13
./olap : 321

# fe下
. : 10888
./spark-dpp : 308
./build : 0
./fe-common : 4423
./target : 4
./conf : 1
./fe-core : 6139
./hive-udf : 8

# fe/fe-core/src/main/java/org/apache/doris
. : 1381
./cluster : 3
./http : 65
./httpv2 : 68
./task : 38
./backup : 19
./system : 10
./service : 4
./transaction : 23
./qe : 57
./ldap : 3
./mysql : 46
./analysis : 356
./ha : 5
./blockrule : 2
./rpc : 4
./deploy : 4
./persist : 54
./clone : 19
./master : 5
./load : 105
./external : 26
./journal : 12
./common : 198
./metric : 15
./statistics : 18
./catalog : 87
./plugin : 15
./rewrite : 28
./planner : 64
./alter : 13
./monitor : 8
./consistency : 2
./resource : 4

```





# FE与BE的交互

## 任务

### 基本任务流程

![1653295027885](images/1653295027885.png)

### FE任务发送

![1653295306193](images/1653295306193.png)

- 目录：task
- 基于java.util.concurrent.ExecutorService和java.util.concurrent.ThreadPoolExecutor实现的一个任务多线程执行模型
- 参考：https://www.jianshu.com/p/85323b892f8d
- 任务从

![1653294038050](images/1653294038050.png)

![1653294071084](images/1653294071084.png)

- 基于这个等待同步等待返回 java.util.concurrent.CountDownLatch;

![1653294437101](images/1653294437101.png)

![1653294598960](images/1653294598960.png)

### BE任务接收

![1653295465037](images/1653295465037.png)

### FE处理任务汇报

![1653295642633](images/1653295642633.png)

### 错误处理

- be会每10秒汇报当前收到的任务的集合

![1653295978420](images/1653295978420.png)

## RPC（thrit）

### 协议 

- \gensrc ： 按照proto(protobuf协议)、script（python，代码生成脚本）、thrit（thift idl协议）存放协议的源文件

### FE

- thrit实现的服务：service\FeServer.cpp： FeServer类
- thrit的rpc入口的类：service\FrontendServiceImpl.java: FrontendServiceImpl类，重载协议生成的FrontendService.Iface里面的方法
- thrit协议生成的代码的目录：fe\fe-common\target\generated-sources\thrift\org\apache\doris\thrift

![1653542533872](images/1653542533872.png)



### BE

- 协议文件：应该是直接引用了gensrc\build目录
- 服务：benend_service.h/cpp::doris::BackendService::create_service
- 入口类：benend_service.h/cpp::BackendService : public BackendServiceIf



# FE

## 基本信息

- 脚本：发布包顶层的bin目录下：start_fe.sh/stop_fe.sh

## 主流程

![1653209578686](images/1653209578686.png)

### 启动停止脚本

#### 常规

- --daemon ：后台方式启动，加了nohup
- --helper host:port ：第二个节点开始， 新FE节点**首次**启动时，需要指定现有集群中的一个节点作为helper节点, 从该节点获得集群的所有FE节点的配置信息 

#### 调试相关
- bdbje相关的重点看这个：fe/fe-core/src/main/java/com/starrocks/journal/bdbje/BDBTool.java
- 参照这个查看版本的脚本改，原有通过start脚本启动有问题

```bash
#!/usr/bin/env bash

curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

export STARROCKS_HOME=`cd "$curdir/.."; pwd`
export PID_DIR=`cd "$curdir"; pwd`

# java
if [ "$JAVA_HOME" = "" ]; then
  echo "Error: JAVA_HOME is not set."
  exit 1
fi
JAVA=$JAVA_HOME/bin/java

# add libs to CLASSPATH
for f in $STARROCKS_HOME/lib/*.jar; do
  CLASSPATH=$f:${CLASSPATH};
done
export CLASSPATH=${CLASSPATH}:${STARROCKS_HOME}/lib

if [ -f $PID_DIR/fe.pid ]; then 
    mv $PID_DIR/fe.pid $PID_DIR/fe.pid.bak
fi

$JAVA com.starrocks.StarRocksFE -v 2>/dev/null | tail -5

if [ -f $PID_DIR/fe.pid.bak ]; then 
    mv $PID_DIR/fe.pid.bak $PID_DIR/fe.pid 
fi
```


```bash
     * -v --version
     *      Print the version of StarRocks Frontend
     * -h --helper
     *      Specify the helper node when joining a bdb je replication group
     * -b --bdb
     *      Run bdbje debug tools
     *
     *      -l --listdb
     *          List all database names in bdbje
     *      -d --db
     *          Specify a database in bdbje
     *
     *          -s --stat
     *              Print statistic of a database, including count, first key, last key
     *          -f --from
     *              Specify the start scan key
     *          -t --to
     *              Specify the end scan key
     *          -m --metaversion
     *              Specify the meta version to decode log value, separated by ',', first
     *              is community meta version, second is StarRocks meta version
```



### Main函数

- PaloFe.java：跟目录

#### 基本流程

- 根据环境变量获取相关目录的位置（start_fe.sh里面设置的），支持多用户启动多个实例
- 加载4类配置（基础、用户、ldap、log4j）
- 检查是否进入命令行调试模式(checkCommandLineOptions)
- 检查所有的网络配置和端口占用情况
- 如果设置了enable_bdbje_debug_mode，启动bdbje的调试模式
- 元数据初始化（Catalog.getCurrentCatalog().initialize(args)）
- 启动三个服务：rpc服务（thrift server，内部通信用）、http服务（状态信息，stream load）、mysql服务（sql执行）
- 统计数据初始化

```java
ThreadPoolManager.registerAllThreadPoolMetric();
```



![1653209983326](images/1653209983326.png)

#### DORIS_HOME/PID_DIR

来自于启动脚本start_fe.sh，DORIS_HOME默认为脚本目录（bin）的上一级目录（起始目录）, PID_DIR默认为当前目录

这样设计也挺好的，可以多个用户用一份代码一个机器启动多个实例，每个实例的环境变量隔离，感觉可以在k8s里面通过configmap配置

![1653210530538](images/1653210530538.png)

![1653210499786](images/1653210499786.png)



#### 启动参数

- 使用到了
  - 官网：https://commons.apache.org/proper/commons-cli/
  - 例子：https://www.jianshu.com/p/848bde98f7a6

![1653211866605](images/1653211866605.png)




#### 四种配置

配置都在conf目录下

- 基础配置：fe.conf
- 用户自定义配置：fe_custom.conf
- ladp配置：ldap.conf
- log4j配置：log4j2-spring.xml，应该是这个文件吧

![1653211058767](images/1653211058767.png)

配置解析

- ConfigBase::setFields将读取的配置绑定到当前类的同名变量

#### 元数据管理

```java
            // init catalog and wait it be ready
            Catalog.getCurrentCatalog().initialize(args);
            Catalog.getCurrentCatalog().waitForReady();
```

#### 三个基础服务

![1653226407543](images/1653226407543.png)

## QueryEngine

### QeService

- qe 目录下，QeService.java
- 默认端口：9030
- mysql协议支持：引用mysql目录下
  - 这里有一个协议的Java版本：https://github.com/sea-boat/mysql-protocol
  - 官网协议文档：https://dev.mysql.com/doc/internals/en/client-server-protocol.html
  - privilege：有相关权限管控的代码
- mysql目录和qe目录的文件是交叉引用，不太好



### NMysqlServer/MysqlServer

- 目录结构
  - nio：网络层
  - privilege：权限管理
  - 根目录：mysql协议层实现

- mysql目录下，NMysqlServer是nio实现的版本
- 源代码：NMysqlServer.java 和 MysqlServer.java
- nio
  - 引用模块：org.xnio.Xnio
    - github：https://github.com/xnio/xnio
    - 这个貌似是官网：https://xnio.jboss.org/docs
  - 主要代码模块
    - NMysqlServer.java：服务启动
    - AcceptListener.java：新连接建立过程
    - ReadListener.java：数据交互流程

### 整体流程

#### 服务启动

![1653226840194](images/1653226840194.png)

#### 接收新请求

![1653229955375](images/1653229955375.png)

![1653230015001](images/1653230015001.png)

#### 处理请求

![1653228129685](images/1653228129685.png)

![1653229215470](images/1653229215470.png)

调用关系有点乱，来回在qe和mysql模块之间折腾

![1653229282478](images/1653229282478.png)

![1653229459708](images/1653229459708.png)

- 读取连接里面的字符流，字符流转换
- 进行词法和语法解析：analyze，切分独立的sql
- 每个sql单独执行

![1653232215162](images/1653232215162.png)

#### 执行单一sql

- 每个sql执行生成一个唯一的queryId，uuid类型
  - 对于一些需要master执行的queryid，会转发到master
- 生成一个long类型的stmtId
- 支持在sql里面设置环境变量：analyzeVariablesInStmt
- 根据sql类型执行各种类型的sql的执行类：parsedStmt instanceof xxx
- 语义解析：analyze
- isForwardToMaster：这个决定是否是需要master执行的命令

![1653287557055](images/1653287557055.png)

```java
   // query with a random sql
    public void execute() throws Exception {
        UUID uuid = UUID.randomUUID();
        TUniqueId queryId = new TUniqueId(uuid.getMostSignificantBits(), uuid.getLeastSignificantBits());
        execute(queryId);
    }

    // Execute one statement with queryId
    // The queryId will be set in ConnectContext
    // This queryId will also be sent to master FE for exec master only query.
    // query id in ConnectContext will be changed when retry exec a query or master FE return a different one.
    // Exception:
    // IOException: talk with client failed.
    public void execute(TUniqueId queryId) throws Exception {
        context.setStartTime();

        plannerProfile.setQueryBeginTime();
        context.setStmtId(STMT_ID_GENERATOR.incrementAndGet());

        context.setQueryId(queryId);

        try {
            if (context.isTxnModel() && !(parsedStmt instanceof InsertStmt)
                    && !(parsedStmt instanceof TransactionStmt)) {
                throw new TException("This is in a transaction, only insert, commit, rollback is acceptable.");
            }
            // support select hint e.g. select /*+ SET_VAR(query_timeout=1) */ sleep(3);
            analyzeVariablesInStmt();

            if (!context.isTxnModel()) {
                // analyze this query
                analyze(context.getSessionVariable().toThrift());
                if (isForwardToMaster()) {
                    if (isProxy) {
                        // This is already a stmt forwarded from other FE.
                        // If goes here, which means we can't find a valid Master FE(some error happens).
                        // To avoid endless forward, throw exception here.
                        throw new UserException("The statement has been forwarded to master FE("
                                + Catalog.getCurrentCatalog().getSelfNode().first + ") and failed to execute" +
                                " because Master FE is not ready. You may need to check FE's status");
                    }
                    forwardToMaster();
                    if (masterOpExecutor != null && masterOpExecutor.getQueryId() != null) {
                        context.setQueryId(masterOpExecutor.getQueryId());
                    }
                    return;
                } else {
                    LOG.debug("no need to transfer to Master. stmt: {}", context.getStmtId());
                }
            } else {
                analyzer = new Analyzer(context.getCatalog(), context);
                parsedStmt.analyze(analyzer);
            }

            if (parsedStmt instanceof QueryStmt) {
                context.getState().setIsQuery(true);
                if (!((QueryStmt) parsedStmt).isExplain()) {
                    // sql/sqlHash block
                    try {
                        Catalog.getCurrentCatalog().getSqlBlockRuleMgr().matchSql(originStmt.originStmt, context.getSqlHash(), context.getQualifiedUser());
                    } catch (AnalysisException e) {
                        LOG.warn(e.getMessage());
                        context.getState().setError(e.getMysqlErrorCode(), e.getMessage());
                        return;
                    }
                    // limitations: partition_num, tablet_num, cardinality
                    List<ScanNode> scanNodeList = planner.getScanNodes();
                    for (ScanNode scanNode : scanNodeList) {
                        if (scanNode instanceof OlapScanNode) {
                            OlapScanNode olapScanNode = (OlapScanNode) scanNode;
                            Catalog.getCurrentCatalog().getSqlBlockRuleMgr().checkLimitaions(olapScanNode.getSelectedPartitionNum().longValue(),
                                    olapScanNode.getSelectedTabletsNum(), olapScanNode.getCardinality(), analyzer.getQualifiedUser());
                        }
                    }
                }

                MetricRepo.COUNTER_QUERY_BEGIN.increase(1L);
                int retryTime = Config.max_query_retry_time;
                for (int i = 0; i < retryTime; i++) {
                    try {
                        //reset query id for each retry
                        if (i > 0) {
                            UUID uuid = UUID.randomUUID();
                            TUniqueId newQueryId = new TUniqueId(uuid.getMostSignificantBits(), uuid.getLeastSignificantBits());
                            AuditLog.getQueryAudit().log("Query {} {} times with new query id: {}", DebugUtil.printId(queryId), i, DebugUtil.printId(newQueryId));
                            context.setQueryId(newQueryId);
                        }
                        handleQueryStmt();
                        // explain query stmt do not have profile
                        if (!((QueryStmt) parsedStmt).isExplain()) {
                            writeProfile(true);
                        }
                        break;
                    } catch (RpcException e) {
                        if (i == retryTime - 1) {
                            throw e;
                        }
                        if (!context.getMysqlChannel().isSend()) {
                            LOG.warn("retry {} times. stmt: {}", (i + 1), parsedStmt.getOrigStmt().originStmt);
                        } else {
                            throw e;
                        }
                    } finally {
                        QeProcessorImpl.INSTANCE.unregisterQuery(context.queryId());
                    }
                }
            } else if (parsedStmt instanceof SetStmt) {
                handleSetStmt();
            } else if (parsedStmt instanceof EnterStmt) {
                handleEnterStmt();
            } else if (parsedStmt instanceof UseStmt) {
                handleUseStmt();
            } else if (parsedStmt instanceof TransactionStmt) {
                handleTransactionStmt();
            } else if (parsedStmt instanceof InsertStmt) { // Must ahead of DdlStmt because InserStmt is its subclass
                try {
                    handleInsertStmt();
                    if (!((InsertStmt) parsedStmt).getQueryStmt().isExplain()) {
                        queryType = "Insert";
                        writeProfile(true);
                    }
                } catch (Throwable t) {
                    LOG.warn("handle insert stmt fail", t);
                    // the transaction of this insert may already begun, we will abort it at outer finally block.
                    throw t;
                } finally {
                    QeProcessorImpl.INSTANCE.unregisterQuery(context.queryId());
                }
            } else if (parsedStmt instanceof DdlStmt) {
                handleDdlStmt();
            } else if (parsedStmt instanceof ShowStmt) {
                handleShow();
            } else if (parsedStmt instanceof KillStmt) {
                handleKill();
            } else if (parsedStmt instanceof ExportStmt) {
                handleExportStmt();
            } else if (parsedStmt instanceof UnlockTablesStmt) {
                handleUnlockTablesStmt();
            } else if (parsedStmt instanceof LockTablesStmt) {
                handleLockTablesStmt();
            } else if (parsedStmt instanceof UnsupportedStmt) {
                handleUnsupportedStmt();
            } else {
                context.getState().setError(ErrorCode.ERR_NOT_SUPPORTED_YET, "Do not support this query.");
            }
        } catch (IOException e) {
            LOG.warn("execute IOException. {}", context.getQueryIdentifier(), e);
            // the exception happens when interact with client
            // this exception shows the connection is gone
            context.getState().setError(ErrorCode.ERR_UNKNOWN_ERROR, e.getMessage());
            throw e;
        } catch (UserException e) {
            // analysis exception only print message, not print the stack
            LOG.warn("execute Exception. {}, {}", context.getQueryIdentifier(), e.getMessage());
            context.getState().setError(e.getMysqlErrorCode(), e.getMessage());
            context.getState().setErrType(QueryState.ErrType.ANALYSIS_ERR);
        } catch (Exception e) {
            LOG.warn("execute Exception. {}", context.getQueryIdentifier(), e);
            context.getState().setError(ErrorCode.ERR_UNKNOWN_ERROR,
                    e.getClass().getSimpleName() + ", msg: " + e.getMessage());
            if (parsedStmt instanceof KillStmt) {
                // ignore kill stmt execute err(not monitor it)
                context.getState().setErrType(QueryState.ErrType.ANALYSIS_ERR);
            }
        } finally {
            // revert Session Value
            try {
                SessionVariable sessionVariable = context.getSessionVariable();
                VariableMgr.revertSessionValue(sessionVariable);
                // origin value init
                sessionVariable.setIsSingleSetVar(false);
                sessionVariable.clearSessionOriginValue();
            } catch (DdlException e) {
                LOG.warn("failed to revert Session value. {}", context.getQueryIdentifier(), e);
                context.getState().setError(e.getMysqlErrorCode(), e.getMessage());
            }
            if (!context.isTxnModel() && parsedStmt instanceof InsertStmt) {
                InsertStmt insertStmt = (InsertStmt) parsedStmt;
                // The transaction of an insert operation begin at analyze phase.
                // So we should abort the transaction at this finally block if it encounters exception.
                if (insertStmt.isTransactionBegin() && context.getState().getStateType() == MysqlStateType.ERR) {
                    try {
                        String errMsg = Strings.emptyToNull(context.getState().getErrorMessage());
                        Catalog.getCurrentGlobalTransactionMgr().abortTransaction(
                                insertStmt.getDbObj().getId(), insertStmt.getTransactionId(),
                                (errMsg == null ? "unknown reason" : errMsg));
                    } catch (Exception abortTxnException) {
                        LOG.warn("errors when abort txn. {}", context.getQueryIdentifier(), abortTxnException);
                    }
                }
            }
        }
    }
```

#### 上下文

ConnectContext

- stmtId/forwardedStmtId：log
- queryId：uuid
- executor：StmtExecutor
- catalog：元数据

### SQL解析

#### 语法/词法解析

- 词法语法解析：ConnectProcessor::handleQuery -> ConnectProcessor::analyze
- 语法：jcup

![1653286888183](images/1653286888183.png)

![1653287047859](images/1653287047859.png)

#### 生成新的sql

![1653296824776](images/1653296824776.png)

#### ![1653297178201](images/1653297178201.png)

- 语法文件：SqlScanner.java
- 词法文件：SqlParser.java SqlParserSymbols.java

![1653297308502](images/1653297308502.png)

#### 语义解析

- 语义解析：StmtExecutor::execute ->  StmtExecutor::analyze -> 具体smt类的analyze方法，如



![1653288216591](images/1653288216591.png)

![1653288204324](images/1653288204324.png)

### 转发处理

- 补充一点：心跳信息等只有master节点才有
- FORWARD_NO_SYNC：不需要返回，无元数据修改的语句，只有master有的数据
- FORWARD_WITH_SYNC：需要等待返回、元数据修改的语句
- NO_FORWARD：不需要转发master，查询语句

![1653288914161](images/1653288914161.png)

### DDL执行

- ddl的执行基本上就是对catalog类接口的二次封装

![1653274935921](images/1653274935921.png)

![1653275266846](images/1653275266846.png)

#### CreateTableStmt

- 检查库/表是否已存在
- 检查是否是需要资源配额是否足够
- 根据不同的表类型进行相关的建表操作

![1653275553269](images/1653275553269.png)


## 元数据管理

### 基本知识

#### 元数据层级

- catalog目录下
- 基表也有 Materialized index
- 没有分区的表，分区数为固定1

![1653291030757](images/1653291030757.png)

#### 7+表类型

- olap：默认的
- odbc
- mysql
- broker
- es
- hive
- iceberg

### 元数据持久化

![1653296346733](images/1653296346733.png)

![1653296476842](images/1653296476842.png)

### 元数据回放

- 根据元数据信息重新构件table对象

![1653296579570](images/1653296579570.png)



### olap类型创建流程

- 代码：catalog/catalog.java: Catalog::createOlapTable , line 3667

- 步骤

  - 根据分区规则生成分区信息：PartitionInfo partitionInfo

  - 根据数据分布规则（分桶）创建分布信息：DistributionInfo defaultDistributionInfo

  - 生成tableid：tableId

  - 创建表对象：OlapTable olapTable

  - 生成索引ID：baseIndexId

  - 检查properties字段的设置是否符合segment v2（默认存储格式）的要求，并进行相应的设置

  - 生成排序信息：DataSortInfo dataSortInfo

  - 设置布隆过滤器字段： olapTable.setBloomFilterInfo(bfColumns, bfFpp);

  - 设置副本分布信息：ReplicaAllocation replicaAlloc

  - 设置是否需要放内存：olapTable.setIsInMemory(isInMemory);

  - 处理未分区的表

  - 处理colocation的表：olapTable.setColocateGroup(colocateGroup);

  - 检查存储类型设置是否合理：StorageType

  - 设置各种元数据信息：olapTable.setIndexMeta

  - rollup表的元数据设置

  - 支持unique_keys表的SequenceType检查和设置

  - properties字段的版本检查

  - 创建任务，去be创建分区/分桶，有些场景需要处理一下

    - 不分区
    - range或者list类型的

  - 调用database的创建表的方法进行数据持久化  Database::createTableWithLock -> EditLog::logCreateTable

![1653289837821](images/1653289837821.png)

#### database创建表

- 内存中创建表： idToTable.put(table.getId(), table);
- 表信息持久化：Catalog.getCurrentCatalog().getEditLog().logCreateTable(info);
- isReplay：元数据回放时不进行持久化

<img src="images/1653278785969.png" alt="1653278785969" style="zoom:67%;" />

​    ![1653290296968](images/1653290296968.png)

​    



### 创建分区

- Catalog::createOlapTable  -> Catalog::createPartitionWithIndices

![1653291297446](images/1653291297446.png)



## HTTP服务

### HttpServer的版本
enable_http_server_v2：默认值为true，starrocks已经取消这个配置了，
- - 最初版本
  目前默认没用，starrocks还在使用
- V2版本
 SpringBoot实现的版本，目前默认用这个

### 功能

官方文档：https://doris.apache.org/zh-CN/admin-manual/http-actions/fe/manager/cluster-action.html#request

## 权限管控

### http接口

- 基本都在 httpv2\rest\BaseController.java、有一部分封装在httpv2\rest\RestBaseController.java
- 检查用户名/密码是否正确：：RestBaseController::executeCheckPassword ->：BaseController::checkPassword
- 检查库/表权限： httpv2\rest\BaseController.java：BaseController::checkTblAuth checkDbAuth等

### mysql接口



# BE

## 基本信息

- 脚本
  - 

## 主流程



### Main函数

- 入口：service\doris_main.cpp

#### 基本流程

#### 服务启动

服务的启动类均在service目录下



## HTTP服务

### 基本信息

- 目录：http目录
  - http服务框架在根目录下
    - 基于libevent的实现：
      - https://www.bookstack.cn/read/libevent/450ef2232c710e15.md
      - https://www.bookstack.cn/read/libevent/0696851dcbb5e81c.md
  - cgi在action目录下
    - 继承自HttpHandler类，重载on_header和handle方法

# 数据导入

## 基础知识

![1653363049331](images/1653363049331.png)



![1653363199879](images/1653363199879.png)



![1653363143641](images/1653363143641.png)

### 两阶段提交

![1653364804686](images/1653364804686.png)

#### 阶段1

- Prepare Txn：
  - 创建事务
  - 规划导入执行计划
  - 分发子任务给BE
- Execute Txn：
  - 接受查询计划
  - 初始化LoadScanNode
  - 初始化TableSink和tablet writer
  - Extract & Transform & Load
  - 汇报导入结果
  - 

#### 阶段2

- Publish

  - 收集导入任务汇报结果
  - 发送Publish消息
  - 事务状态改为COMMITED
  - 等待BE返回
- Publish 2

  - BE修改BE元数据，数据版本+1 ，返回成功结果给FE
  - BE成功返回后，FE修改FE元数据，数据版本+1（这个地方是多数派？）
  - 事务状态改为VISIBLE

- RollBack
  - BE返回没有成功，事务状态改为abort
  - BE等待回收任务删除已写入数据

![1653364952780](images/1653364952780.png)

## StreamLoad流程

- 主要涉及的代码文件

![1653565789200](images/1653565789200.png)

![1653565616911](images/1653565616911.png)

- 可以连fe也可以连be导数，如果是连接fe，会被http301到be节点

![1653366151464](images/1653366151464.png)

### Restful接口

- java程序：httpv2/rest/LoadAction.java

![1653377785686](images/1653377785686.png)

![1653378066945](images/1653378066945.png)

![1653378122405](images/1653378122405.png)

- LoadAction::executeWithoutPassword

![1653379227588](images/1653379227588.png)

- SystemInfoService::seqChooseBackendIds：研究了一下这个代码，同一机器上的多个实例选择是随机取一个，不同机器应该不随机

### BE相关流程

![1653389533301](images/1653389533301.png)

![1653455651291](images/1653455651291.png)

- onhead阶段开启了一个事务（为啥不在fe里面开启一个事务？应该是与http请求跳转、无法获取事务相关的完整信息有关）
- begin_txn会调用fe里面的一个方法开启一个事务（事务的信息都在fe的元数据里面维护，另外也需要操作其他的元数据）
- 所有rpc的调用类是由协议文件生成，放在/gensrc，按照proto(protobuf协议)、script（python）、thrit（thift idl协议）存放协议的源文件，生成的目标文件放gencpp目录

![1653538917425](images/1653538917425.png)

![1653540189330](images/1653540189330.png)


![1653549554259](images/1653549554259.png)

![1653549991598](images/1653549991598.png)

![1653550044940](images/1653550044940.png)

### FE相关接口
![1653540893066](images/1653540893066.png)

![1653549392092](images/1653549392092.png)

![1653550231896](images/1653550231896.png)

最终调用的是transaction下的GlobalTransactionMgr下的接口

### 执行计划

#### FE RPC处理：streamLoadPut

-  来自 FrontendServiceImpl

- 调用方：BE http\action\stream_load.cpp::StreamLoadAction::_process_put -> FrontendServiceConnection::streamLoadPut

stream_load.cpp_exec:549 client->streamLoadPut(ctx->put_result, request);

![1653550431520](images/1653550431520.png)

#### FE 创建Planner

- 创建tuple descriptor：目标表的结构和数据类型

- 创建两个节点：scan node 和 OlapTableSink node

  ![1653551733183](images/1653551733183.png)

- scan node节点
    - 作用：负责读取元数据、转换成查询框架需要的内存结构、谓词过滤、数据转换，然后发给OlapTableSink节点
    - 只需要一个，因为是从http请求的
    - scanRange：streamnode实现简单，只有一个节点，scanrange就是全部；对于brokerload，存在多个scan node如何瓜分文件列表/或者很大一个文件的问题
    - 初始化列映射
    - 初始化行列分割符

![1653555549215](images/1653555549215.png)

![1653556976893](images/1653556976893.png)

- OlapTableSink节点
    - 负责接受scan node数据，根据schema信息（分区、分桶策略）发送给不同的be
    - 跟scan node同一个节点，不需要exchange node接受多个scan node的数据

![1653557158931](images/1653557158931.png)



### 执行

#### scan node

### ![1653557275863](images/1653557275863.png)

![1653563983496](images/1653563983496.png)

![1653557414279](images/1653557414279.png)

![1653564120885](images/1653564120885.png)

![1653564778538](images/1653564778538.png)

#### OlapTableSink节点

![1653564888125](images/1653564888125.png)

![1653565132537](images/1653565132537.png)

![1653565219411](images/1653565219411.png)

![1653565300447](images/1653565300447.png)

![1653565392037](images/1653565392037.png)

![1653565488462](images/1653565488462.png)

![1653565521242](images/1653565521242.png)

来源：BE http\action\stream_load.cpp::StreamLoadAction::_process_put -> StreamLoadExecutor::execute_plan_fragment

stream_load.cpp_exec:568 _env->stream_load_executor()->execute_plan_fragment(ctx)