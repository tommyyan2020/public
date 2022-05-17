# VI/VIM中使用鼠标

## 好处

- 滚动看日志：鼠标滚轮
- 光标快速定位：鼠标点击即可

## 坏处

- 鼠标复制/黏贴的功能可能没有了
- vim模式下竟然不能复制了。。



## 用法

centos 8上亲测

### vscode terminal + vi/vim（推荐）

- vi：可以滚动，不能定位
- vim：均可

### 命令set mouse =a（不推荐）

- vi 不支持
- vim 可以，xshell上可以，secure crt（6.7）不行

#### 设置方式

命令：set mouse =a

- 永久：vim：~/.vimrc
- 当前有效：":"切换到命令模式，输入命令即可

## 更多

顺便把常用的两个设置上了，vi（~/.virc）/vim(~/.vset ts=4
set expandtab
set autoindentimrc)

- set ts=4
- set expandtab
- set autoindent

## 参考

- https://www.cnblogs.com/litifeng/p/5683935.html
- https://blog.csdn.net/geekqian/article/details/84325139
- https://www.linuxdiyf.com/linux/30470.html

