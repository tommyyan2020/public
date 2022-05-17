# Window下搭建web环境

## 0 准备

### 0.1 迁移目的

从目前的linux虚拟机下将日常的web相关的服务移到windows下

- 方便管理
- 系统更稳定，不会因为
- 虚拟机下更轻量，可以搭建多套不同用途（大数据相关、开发环境等）、不同虚拟机方案（VB、VM）的环境

### 0.2 准备

- 所有数据目前暂定放c盘
- 需要的系统程序放在c:\app下
- 数据按照原有组织方式放在c:\data下，保持跟linux环境一致

### 0.3 相关命令

#### 0.3.1 查看端口占用情况

```bash
netstat -ano
#查看某个具体的端口被谁占用
netstat -ano| findstr "8088"
```

#### 0.3.2 查看某个程序对应的进程信息

```bash
tasklist /fi "IMAGENAME eq nginx.exe"
```

#### 

#### 0.3.3 查看进程对应的信息

- 命令行

```bash
tasklist /FI "PID eq 2112"
```

- 图形操作

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201223142545261.png) 

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201223142552791.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDMyNTQ0NA==,size_16,color_FFFFFF,t_70) 

#### 0.3.4 杀死进程

```bash
taskkill /F /PID 4356：
```

#### 0.3.5 建立软链接

```bash
mklink /d C:\data\master \\192.168.56.101\
mklink /d c:\data\diskd d:\
mklink /d c:\data\diske e:\
mklink /d C:\data\diskf f:\
mklink /d c:\data\diskg g:\
#删除
rmdir c:\data\master
```

#### 0.3.6 删除无用windows文件夹

- 参考链接：https://blog.csdn.net/jacke121/article/details/88578792

```bash
regedit
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
- 图片：24ad3ad4-a569-4530-98e1-ab02f9417aa8
- 音乐：3dfdf296-dbec-4fb4-81d1-6a3438bcf4de
- 视频：f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a
```

### 0.4 windows环境下运行linux命令

#### 0.4.1 找命令对应的windows版本

整到windows的system32目录下，目前正找合适相关的合集包，以前见过

注意干掉window defender，容易被搞到隔离区

#### 0.4.2 powershell

windows自带的

#### 0.4.3 cygwin





## 1 安装winsw

### 5.1 参考链接

- 官方地址： https://github.com/winsw/winsw/releases
- 教程：https://www.jianshu.com/p/fc9e4ea61e13

### 1.2 安装要点

- 每个目录放一个可执行程序
- 针对每个服务需要配置各自的名字、启动、停止命令、日志等

## 2 Nginx windows版本安装

### 2.1 参考链接

- 官方网站：http://nginx.org/en/download.html
- 部署教程：https://www.cnblogs.com/taiyonghai/p/9402734.html
- nginx服务化：https://blog.csdn.net/qq_43054982/article/details/108105100

### 2.2 安装要点

#### 2.2.1 启动nginx

```bash
# 测试配置文件是否有效
nginx -t -c conf/nginx.conf
start nginx


```

#### 2.2.2 查看实例

```bash
tasklist /fi "imagename eq nginx.exe"
```

#### 2.2.3 服务化配置

winsw.xml

```xml
<service>
 <id>nginx</id>
 <name>nginx</name>
 <description>nginx</description>

 <logpath>D:\log\nginx</logpath>

 <log mode='roll-by-time'>
    <pattern>yyyyMMdd</pattern>
 </log>

 <depend></depend>

  <executable>C:\app\nginx-1.20.2\nginx.exe</executable>
  <stopexecutable>C:\app\nginx-1.20.2\nginx.exe -s stop</stopexecutable>

</service>
```



## 3 NodeJs环境安装

### 3.1 参考链接

- 官方下载链接：https://nodejs.org/en/download/
- 教程：https://blog.csdn.net/zjh_746140129/article/details/80460965

## 4 安装docsify

### 4.1 参考链接

- 教程：https://blog.csdn.net/qq_31848763/article/details/112368252

## 5 安装filebrowser

### 5.1 参考链接

- 官方链接：
  - https://github.com/filebrowser/filebrowser/releases
- windows下安装教程
  - https://www.jianshu.com/p/73abbd4b03eb
  -  https://blog.csdn.net/qq135595696/article/details/121258260

### 5.2 安装要点

- 设置日志路径

```bash
filebrowser.exe  config set d:/log
```



- 设置根目录

``` bash
filebrowser.exe -d filebrowser.db config set --root  c:/data
```

- 查看配置

```bash
filebrowser.exe  config cat
```



- 设置开机启动 

  winsw.xml

``` xml
<service>
    <id>filebrowser</id>
    <name>filebrowser</name>
    <description>个人网盘</description>
    <executable>filebrowser</executable>
    <onfailure action="restart" delay="60 sec"/>
    <logmode>reset</logmode>
</service>
```



- 