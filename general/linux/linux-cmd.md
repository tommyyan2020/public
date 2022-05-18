# 系统

## 日期时间

- timestamp转日期时间

```bash
date -d@1647918518
```



查看目录下文件大小

```bash
du -sh .[!.]*
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





