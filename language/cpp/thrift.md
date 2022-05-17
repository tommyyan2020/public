# thrift使用

## 参考

- https://blog.csdn.net/weixin_30892763/article/details/97998593

## 安装thrift

```bash
wget https://dlcdn.apache.org/thrift/0.16.0/thrift-0.16.0.tar.gz
tar -zxvf thrift-0.16.0.tar.gz
 cd thrift-0.16.0/
./configure --prefix=/usr/local
make
make check
make install
thrift --version
```

