# gperftools使用

# 参考

- github： https://github.com/gperftools/gperftools 
- 官网：https://gperftools.github.io/gperftools/
- b站：https://www.bilibili.com/video/av974786474
- Gperftools原理与实践 https://zhuanlan.zhihu.com/p/343231398
-  https://blog.csdn.net/liuzhe910422/article/details/111712880
- https://blog.csdn.net/10km/article/details/83820080
- 性能测试工具 gperftools环境搭建（亲测好用）：https://blog.csdn.net/liuzhe910422/article/details/111712880

# 安装

```bash
wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.10/gperftools-2.10.tar.gz
cd gperftools-2.10
cmake -B build
cd build
make
make install
# 运行时不然找不到so
cp libprofiler.so* /usr/lib64/
yum install -y pprof
```



