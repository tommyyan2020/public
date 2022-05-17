# Hive表场景评测：Presto VS Trino VS DorisDB

## 基本情况

### 版本

#### 基本信息

| 引擎    | 版本   | server | cli  | java   |
| ------- | ------ | ------ | ---- | ------ |
| presto  | 0.257  | 959M   | 15M  | 1.8    |
| trino   | 359    | 593M   | 9.7M | 11.07+ |
| DorisDB | 1.16.1 |        |      | 1.8    |

#### 外部数据源支持情况

| 数据源                    | trino |       presto       | DorisDB |
| ------------------------- | :---: | :----------------: | :-----: |
| accumulo                  |  ✔  |         ✔         |         |
| atop                      |  ✔  |         ✔         |         |
| bigquery                  |  ✔  |         ✔         |         |
| blackhole                 |  ✔  |         ✔         |         |
| cassandra                 |  ✔  |         ✔         |         |
| clickhouse                |  ✔  |                   |         |
| druid                     |  ✔  |         ✔         |         |
| elasticsearch             |  ✔  |         ✔         |   ✔   |
| example-http              |  ✔  |         ✔         |         |
| geospatial                |  ✔  |         ✔         |         |
| google-sheets             |  ✔  |                   |         |
| hive                      |  ✔  | ✔<br />(包含hudi) |   ✔   |
| iceberg                   |  ✔  |                   |         |
| jmx                       |  ✔  |         ✔         |         |
| kafka                     |  ✔  |         ✔         |         |
| kinesis                   |  ✔  |                   |         |
| kudu                      |  ✔  |         ✔         |         |
| local-file                |  ✔  |         ✔         |         |
| memory                    |  ✔  |         ✔         |         |
| memsql                    |  ✔  |                   |         |
| ml                        |  ✔  |         ✔         |         |
| mongodb                   |  ✔  |         ✔         |         |
| mysql                     |  ✔  |         ✔         |   ✔   |
| oracle                    |  ✔  |         ✔         |         |
| password-authenticators   |  ✔  |         ✔         |         |
| phoenix                   |  ✔  |                   |         |
| phoenix5                  |  ✔  |                   |         |
| pinot                     |  ✔  |         ✔         |         |
| postgresql                |  ✔  |         ✔         |         |
| prometheus                |  ✔  |                   |         |
| raptor-legacy             |  ✔  |         ✔         |         |
| redis                     |  ✔  |         ✔         |         |
| redshift                  |  ✔  |         ✔         |         |
| resource-group-managers   |  ✔  |         ✔         |         |
| session-property-managers |  ✔  |         ✔         |         |
| sqlserver                 |  ✔  |         ✔         |         |
| teradata-functions        |  ✔  |         ✔         |         |
| thrift                    |  ✔  |         ✔         |         |
| tpcds                     |  ✔  |         ✔         |         |
| tpch                      |  ✔  |         ✔         |         |

- prestodb打包时都打入了很多的关联包

### 部署情况

- 7台机器，centos，256G xeron 2650 V4 *2 24核48线程
- presto/trino：一个coordinator，7个worker
- DorisDB：3个fe，7个be ，7个 broker
