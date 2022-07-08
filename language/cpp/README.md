# 资源

### C语言 ## __VA_ARGS__ 宏 

- ：https://www.cnblogs.com/alexshi/archive/2012/03/09/2388453.html



- acl库：https://github.com/acl-dev/acl

# 基础

## 宏

# 编译

## 编译选项

### 参考

### 常用

#### -o

 可执行文件重命名（elf格式） 

####  -O1 -O2 -O3 

 编译优化 

```bash
gcc -O1 demo.c -o demo ：一级优化
gcc -O2 demo.c -o demo ：二级优化
gcc -O3 demo.c -o demo ：三级优化
#（time ./demo：可以测算代码运行的时间）
```

####  -w 

 关闭警告 

```bash
gcc -w demo.c -o demo
# (不推荐使用，警告可能不影响程序的执行，但忽视警告运行时可能会造成程序上的一些问题)
```

####  -Wall 

 开启所有警告（实际上只打开大部分，部分要单独开启）

#### -Werror

  将所有的编译告警转化为编译错误，只要有告警就停止编译 

#### -l

- 链接到指定的库，名字去掉前面的lib和后面的.lib/.so
- 可以带路径

#### -L

添加链接库所在的搜索路径

#### -I

添加头文件的搜索路径

#### -D

 定义一个宏

```bash
gcc -DHAVE_CONFIG_H，定义宏HAVE_CONFIG_H 
```

#### -g

 编译过程中保留调试信息，以便gdb能够调试 







### 动态库

#### -fPIC




建议默认加上





### -lpthread 和 -pthread

- 一句话：  -pthread 会附加一个宏定义 -D_REENTRANT，该宏会导致 libc 头文件选择那些thread-safe的实现 ，所以不管用哪个，最好加上这个宏，优先使用-pthread ，虽然有点恶心，坏了链接库-l的规矩

- https://blog.csdn.net/jakejohn/article/details/79825086
- http://blog.chinaunix.net/uid-69906223-id-5817313.html

# 教程

## gdb

- https://blog.csdn.net/daaikuaichuan/article/details/89791255?spm=1001.2014.3001.5502

### 文件后缀名

- 规范：https://www.cnblogs.com/yoyo-sincerely/p/7921704.html

## B站

- 乱七八糟 C++：https://space.bilibili.com/408093637/channel/seriesdetail?sid=777552



## 未分类

- closure（闭包）、仿函数、std::function、bind、lambda  https://blog.csdn.net/daaikuaichuan/article/details/78229315

