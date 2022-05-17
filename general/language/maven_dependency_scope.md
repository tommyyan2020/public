# Maven配置中Dependency域的scope选项

## 0  参考链接

- https://blog.csdn.net/walykyy/article/details/105910155



## 1 问题回放

- 不到对应的类，在网上找到对应的处理：https://blog.csdn.net/walykyy/article/details/105910155

  ![1640953266666](../../images/1640953266666.png)

  - 最新版本的idea(21.3)处理

  ![1640953904062](../../images/1640953904062.png)

- pom中的配置

```xml
        <!-- This dependency is provided, because it should not be packaged into the JAR file. -->
        <dependency>
            <groupId>org.apache.flink</groupId>
            <artifactId>flink-streaming-java_${scala.binary.version}</artifactId>
            <version>${flink.version}</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.flink</groupId>
            <artifactId>flink-clients_${scala.binary.version}</artifactId>
            <version>${flink.version}</version>
            <scope>provided</scope>
        </dependency>
```

- 将所有用到的”provided“的类放到classpath中后

  ```bash
  "C:\Program Files\Java\jdk1.8.0_191\bin\java.exe" "-javaagent:C:\Program Files\JetBrains\IntelliJ IDEA 2021.3\lib\idea_rt.jar=60093:C:\Program Files\JetBrains\IntelliJ IDEA 2021.3\bin" -Dfile.encoding=UTF-8 -classpath 
  "C:\Program Files\Java\jdk1.8.0_191\jre\lib\charsets.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\deploy.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\access-bridge-64.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\cldrdata.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\dnsns.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\jaccess.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\jfxrt.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\localedata.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\nashorn.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\sunec.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\sunjce_provider.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\sunmscapi.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\sunpkcs11.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\ext\zipfs.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\javaws.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\jce.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\jfr.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\jfxswt.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\jsse.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\management-agent.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\plugin.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\resources.jar;C:\Program Files\Java\jdk1.8.0_191\jre\lib\rt.jar;D:\dev\src\testcase\flink\wordcount\target\classes;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-streaming-java_2.11\1.14.2\flink-streaming-java_2.11-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-core\1.14.2\flink-core-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-annotations\1.14.2\flink-annotations-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-metrics-core\1.14.2\flink-metrics-core-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-shaded-asm-7\7.1-14.0\flink-shaded-asm-7-7.1-14.0.jar;C:\Users\Administrator\.m2\repository\org\apache\commons\commons-lang3\3.3.2\commons-lang3-3.3.2.jar;C:\Users\Administrator\.m2\repository\com\esotericsoftware\kryo\kryo\2.24.0\kryo-2.24.0.jar;C:\Users\Administrator\.m2\repository\com\esotericsoftware\minlog\minlog\1.2\minlog-1.2.jar;C:\Users\Administrator\.m2\repository\org\objenesis\objenesis\2.1\objenesis-2.1.jar;C:\Users\Administrator\.m2\repository\commons-collections\commons-collections\3.2.2\commons-collections-3.2.2.jar;C:\Users\Administrator\.m2\repository\org\apache\commons\commons-compress\1.21\commons-compress-1.21.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-file-sink-common\1.14.2\flink-file-sink-common-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-runtime\1.14.2\flink-runtime-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-rpc-core\1.14.2\flink-rpc-core-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-rpc-akka-loader\1.14.2\flink-rpc-akka-loader-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-queryable-state-client-java\1.14.2\flink-queryable-state-client-java-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-hadoop-fs\1.14.2\flink-hadoop-fs-1.14.2.jar;C:\Users\Administrator\.m2\repository\commons-io\commons-io\2.8.0\commons-io-2.8.0.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-shaded-netty\4.1.65.Final-14.0\flink-shaded-netty-4.1.65.Final-14.0.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-shaded-jackson\2.12.4-14.0\flink-shaded-jackson-2.12.4-14.0.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-shaded-zookeeper-3\3.4.14-14.0\flink-shaded-zookeeper-3-3.4.14-14.0.jar;C:\Users\Administrator\.m2\repository\org\javassist\javassist\3.24.0-GA\javassist-3.24.0-GA.jar;C:\Users\Administrator\.m2\repository\org\xerial\snappy\snappy-java\1.1.8.3\snappy-java-1.1.8.3.jar;C:\Users\Administrator\.m2\repository\org\lz4\lz4-java\1.8.0\lz4-java-1.8.0.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-scala_2.11\1.14.2\flink-scala_2.11-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\scala-lang\scala-reflect\2.11.12\scala-reflect-2.11.12.jar;C:\Users\Administrator\.m2\repository\org\scala-lang\scala-library\2.11.12\scala-library-2.11.12.jar;C:\Users\Administrator\.m2\repository\org\scala-lang\scala-compiler\2.11.12\scala-compiler-2.11.12.jar;C:\Users\Administrator\.m2\repository\org\scala-lang\modules\scala-xml_2.11\1.0.5\scala-xml_2.11-1.0.5.jar;C:\Users\Administrator\.m2\repository\org\scala-lang\modules\scala-parser-combinators_2.11\1.0.4\scala-parser-combinators_2.11-1.0.4.jar;C:\Users\Administrator\.m2\repository\com\twitter\chill_2.11\0.7.6\chill_2.11-0.7.6.jar;C:\Users\Administrator\.m2\repository\com\twitter\chill-java\0.7.6\chill-java-0.7.6.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-java\1.14.2\flink-java-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-shaded-guava\30.1.1-jre-14.0\flink-shaded-guava-30.1.1-jre-14.0.jar;C:\Users\Administrator\.m2\repository\org\apache\commons\commons-math3\3.5\commons-math3-3.5.jar;C:\Users\Administrator\.m2\repository\org\slf4j\slf4j-api\1.7.15\slf4j-api-1.7.15.jar;C:\Users\Administrator\.m2\repository\com\google\code\findbugs\jsr305\1.3.9\jsr305-1.3.9.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-shaded-force-shading\14.0\flink-shaded-force-shading-14.0.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-clients_2.11\1.14.2\flink-clients_2.11-1.14.2.jar;C:\Users\Administrator\.m2\repository\org\apache\flink\flink-optimizer\1.14.2\flink-optimizer-1.14.2.jar;C:\Users\Administrator\.m2\repository\commons-cli\commons-cli\1.3.1\commons-cli-1.3.1.jar;C:\Users\Administrator\.m2\repository\org\apache\logging\log4j\log4j-slf4j-impl\2.17.0\log4j-slf4j-impl-2.17.0.jar;C:\Users\Administrator\.m2\repository\org\apache\logging\log4j\log4j-api\2.17.0\log4j-api-2.17.0.jar;C:\Users\Administrator\.m2\repository\org\apache\logging\log4j\log4j-core\2.17.0\log4j-core-2.17.0.jar" WordCount
  ```

  

  ## 2 各种scope类型的比较

  ### 2.1 provided

  ​	用于在某个容器内部署，并且容器内已经有provided类型制定的jar包

  - 容器如：flink环境、tomcat环境等
  - 在idea运行时，没有提供容器匹配的环境，需要关联上，这一点idea做的不好，不算完美，最好能够提供一些容器环境出来，而不是报错，报错信息也不够明确。