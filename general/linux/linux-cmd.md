# 系统

## 文件

### 文件个数统计

-  当前目录下每个子目录的文件数量 

```bash
find . -maxdepth 1 -type d | while read dir; do count=$(find "$dir" -type f | wc -l); echo "$dir : $count"; done
```



- 文件个数

  - 包括子文件夹里的 

  ```bash
  ls -lR|grep "^-"|wc -l
  ```

  - 不包含子文件夹

  ```bash
  ls -l |grep "^-"|wc -l
  ```

  - 某个特定文件的

  ```bash
  find . -name filename | wc -l
  find -name "*.js" | wc -l
  ```

  

-  目录个数

  - 包括子文件夹里的 

  ```bash
  ls -lR|grep "^d"|wc -l
  ```

  

  - 包括子文件夹里的 

  ```bash
  ls -l |grep "^d"|wc -l
  ```

  

## 目录

#### 



### tree

```bash
# 只显示目录，最多显示三层子目录
tree -d -L 3
```



## 日期时间

- timestamp转日期时间

```bash
date -d@1647918518
```



查看目录下文件大小

```bash
du -sh .[!.]*
```

## 服务

### 所有已经启动的服务

```bash
systemctl list-unit-files | grep enabled
```



# 文本

# 系统控制



## 未分类

### 文件打开个数

```bash
# 查看最大文件个数
ulimit -n

#修改最大打开文件个数
echo ulimit -HSn 65536 >> /etc/rc.local
echo ulimit -HSn 65536 >>/root/.bash_profile
ulimit -HSn 65536


```







# 网络

查看TCP链接情况

```bash
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
```





