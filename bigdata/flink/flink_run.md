# Java程序执行&Flink程序执行

## 

## 0  参考链接

- Java基础之CLASSPATH环境变量： https://zhuanlan.zhihu.com/p/126323702
- Flink的多种提交方式 https://blog.csdn.net/qq_33689414/article/details/90671685

## 1 java代码执行流程

​	java代码的执行实际上就是在一组路径（classpath参数指定）里面、找到一个入口类（带main函数）开始执行

### 1.1 一个例子

源代码

```java
public class Hello {public static void main(String[] args) {
      System.out.println("Hello World!");
}
```

操作

```bash
# 将Hello.java编译到D:\classes目录下, ，编译成功后的文件为Hello.class；
javac -d D:\classes Hello.java
# 运行Hello.class
java -classpath D:\classes Hello
```

### 1.2 总结

具体：

- classpath：可以是一个路径（包含一组class文件）、或者一个jar包（一个路径下的所有class打包在一起，成为以恶文件）
- 所有classpath对应的classname在同一个名字空间，这样造成引用同一个application对应的不同版本的jar包很难搞

## 2 Flink程序执行

​	Flink具有多种提交方式，主要有：

- local模式：本地调试用，如windows/idea
- stantalone模式：集群模式，flink资源对应的JobManager/TaskManager直接部署在物理机、虚拟机上
- yarn模式：flink通过yarn部署，yarn先部署带JobManger功能的Flink的AppManager，根据需要再进行TaskManager资源部署，可以通过yarn提供的webproxy将Flink的web管理工具暴露出来。
- k8s

### 2.0 相同参数

2.0.1 参数说明

- -c： 指定main()所在的类 
- -C： 可用来添加外部依赖jar包，如自己开发的工具jar包，一个个添加，不能是目录 
- -d ：后台启动

2.0.2 例子

```bash
flink run  -d \
  -C "file:///DSJ/flink-1.11.1/ep/xxxx1.jar" \
  -C "file:///DSJ/flink-1.11.1/ep/xxxx2.jar" \
  -C "file:///DSJ/flink-1.11.1/ep/xxxx3.jar" \
  -C "file:///DSJ/flink-1.11.1/ep/xxxx4.jar" \
  -C "file:///DSJ/flink-1.11.1/ep/xxxx5.jar" \
  -c com.xxx.xxxmain /JarPath/xxx.jar
```



### 2.1 Standalone

### 2.2 Yarn

### 2.3 本地模式

### 2.4 K8S



### 