# Starrocks源代码解析
# 基本信息

## 目录结构
```bash
tree -d -L 3
├── be #backend 所有内容的目录
│   ├── build_Release  # cmake执行的目录
│   │   ├── CMakeFiles
│   │   ├── src
│   │   └── test
│   ├── output       	# be编译结果输出目录	
│   │   ├── bin
│   │   ├── conf
│   │   ├── lib
│   │   ├── tmp
│   │   ├── udf
│   │   └── www
│   ├── src				# 源代码目录
│   │   ├── agent
│   │   ├── codegen
│   │   ├── column
│   │   ├── common
│   │   ├── env
│   │   ├── exec
│   │   ├── exprs
│   │   ├── formats
│   │   ├── gen_cpp
│   │   ├── geo
│   │   ├── gutil
│   │   ├── http
│   │   ├── plugin
│   │   ├── runtime
│   │   ├── service
│   │   ├── simd
│   │   ├── storage
│   │   ├── testutil
│   │   ├── tools
│   │   ├── udf
│   │   └── util
│   └── test			# 测试用例目录
│       ├── agent
│       ├── build
│       ├── column
│       ├── common
│       ├── env
│       ├── exec
│       ├── exprs
│       ├── formats
│       ├── geo
│       ├── http
│       ├── plugin
│       ├── runtime
│       ├── simd
│       ├── storage
│       └── util
├── bin
├── build-support
├── conf
├── fe
│   ├── fe-common
│   │   ├── src
│   │   └── target
│   ├── fe-core
│   │   ├── src
│   │   └── target
│   └── spark-dpp
│       ├── src
│       └── target
├── fs_brokers
│   └── apache_hdfs_broker
│       ├── bin
│       ├── conf
│       └── src
├── gensrc
│   ├── build
│   │   ├── common
│   │   ├── gen_cpp
│   │   ├── geo
│   │   └── python
│   ├── proto
│   ├── script
│   │   └── vectorized
│   └── thrift
├── licenses
├── licenses-binary
├── output
│   ├── be
│   │   ├── bin
│   │   ├── conf
│   │   ├── lib
│   │   └── www
│   ├── fe
│   │   ├── bin
│   │   ├── conf
│   │   ├── lib
│   │   ├── spark-dpp
│   │   └── webroot
│   └── udf
│       ├── include
│       └── lib
├── thirdparty
│   ├── minidump
│   └── patches
├── tools
│   └── show_segment_status
└── webroot
    ├── be
    │   └── bootstrap
    └── static
```

# FE

## 启动/停止脚本

### 调试信息

- 显示当前版本：bin/show_fe_version.sh

- 其他调试功能：参考show_fe_version.sh和参数说明改

  - 参数说明

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

  

  - 修改show_fe_version.sh的-v参数

  ```java
      /*
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
       *
       */
  ```

  

  

  - 

    