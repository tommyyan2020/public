# 源代码解读：Flink datastream添加数据源的例子：transaction模块

## 背景

在实验这个例子[datastream api实现欺诈检测](https://ci.apache.org/projects/flink/flink-docs-release-1.13/zh/docs/try-flink/datastream/)时候，系统用到了Transaction数据源作为例子，这个数据源是用户自己在代码里生成数据进行测试。

对于datastream 里面，常规的写法是这样的

```java
        StreamExecutionEnvironment streamEnv = StreamExecutionEnvironment.getExecutionEnvironment();
        DataStreamSource<Tuple2<String, String>> streamSource = streamEnv.addSource(new SourceFunction<Tuple2<String, String>>() {
            @Override
            public void run(SourceContext<Tuple2<String, String>> ctx) throws Exception {
                int i = 1;
                int j = 1;
                while (!Thread.interrupted()) {
                    Tuple2 tuple2 = new Tuple2(i + "", System.currentTimeMillis() + "");

                    j = j + 1;
                    i = i + 1;
                    if (i > 10) {
                        i = j - 9;
                    }
                    Thread.sleep(1000 * 2);
                    if (j >= 15) {
                        continue;
                    } else {
                        System.out.println(tuple2);
                        ctx.collect(tuple2);
                    }
                }
            }

            @Override
            public void cancel() {
            }
        });
```

核心：

- 定义一个数据结构，本例子中是：Tuple2<String, String>
- 定义一个新的类继承自SourceFunction，本例直接采用内嵌的方式实现了一个新的类，这种方式比较适合测试
  - 用新定义的数据结构进行模板的实例化
  - 重载 run方法和cancel方法
- 基于自定义的数据结构实例化一个对象，并添加到env里面： streamEnv.addSource(new SourceFunction<Tuple2<String, String>>)

### Transation模块的实现

#### 文件列表

- FromIteratorFunction.java
- SourceFunction.java
- TransactionIterator.java
- Transaction.java
- TransactionSource.java
- TransactionRowInputFormat.java：An bounded input of transactions，没用到

# 类继承关系

- Transaction：数据流中的数据结构及其上的操作
- TransactionIterator implements Iterator `<Transaction>`, Serializable：基于Transaction，采用迭代器的方式取数、定义了实际的一组数据
- FromIteratorFunction `<T>` implements SourceFunction `<T>`：实现了run/cancel方式，采用迭代器取数据
- TransactionSource extends FromIteratorFunction `<Transaction>`：模板实例化了FromIteratorFunction，封装了一层next方法来实现延时取数
