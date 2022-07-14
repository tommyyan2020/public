# docker

# 常用命令

## 容器(container)相关

### 查看

 ![img](https://img-blog.csdnimg.cn/33fe11343a604da5b05c912adca7f1f0.png) 

```bash
docker ps [OPTIONS] 其他参数
-a :显示所有的容器，包括未运行的。
-f :根据条件过滤显示的内容。
–format :指定返回值的模板文件。
-l :显示最近创建的容器。
-n :列出最近创建的n个容器。
–no-trunc :不截断输出。
-q :静默模式，只显示容器编号。
-s :显示总的文件大小。
```

### 启动

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/0ea83c850a2a487aa037fea89f7037cf.png)

- 格式 

```bash
docker start xxxxx
```

- 步骤

```bash
首先是查看所有容器
docker ps -a
然后根据ID 启动容器
docker start 5c0ef059466d
docker start 容器名称
```

### 重启

```bash
docker restart mysql
```

### 停止

```bash
docker stop msyql
```

### 删除

```bash
docker rm name
```

## 镜像(image)

### 删除

```bash
docker rmi xxxx
```





