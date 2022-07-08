# git相关



# 常用操作

- 参考：https://blog.csdn.net/weixin_67585820/article/details/123554416
- 详解git fetch与git pull的区别 https://blog.csdn.net/riddle1981/article/details/74938111

## 新项目

- 先在远程仓库创建项目
- 本地操作

```bash

cd 项目路径
git init
# 配置忽略规则, 可以没有
vi .gitignore
# 添加远程仓库
git remote add origin https://git.code.tencent.com/tommyyan2020/test.git
# 将 本地文件添加到本地仓库
git add .
git commit -m "new"

git push origin master

git branch --set-upstream-to=origin/master

```

## 分支

### branch

```bash
git branch <branchName> //创建一个分支
git branch -d <branchName> //删除一个分支
git branch -v //显示所有分支信息
```

### checkout

```bash
git checkout <branchName> //通过移动HEAD检出版本，可用于切换分支
git checkout -b <branchName> //创件一个分支并切换
git checkout <reference> //将其移动到一个引用
git checkout - //恢复到上一个分支
```

 git checkout 也可以跟一个commitid，这时候HEAD指向这个commitid跟所有分支分离，这个状态为detached 

### reset

```bash
//git reset   将当前分支回退到历史某个版本
git reset --mixed <commit> //(默认)
git reset --soft<commit> 
git reset --hard <commit> 

git reset --hard origin/master 

git reflog
```

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/f90d6a4c25a542ac82bc3372c14d699e.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAQmV0dHlhbmVy,size_20,color_FFFFFF,t_70,g_se,x_16) 

### stash

git stash 用来保存目前的工作目录和暂存区状态，并返回到干净的工作空间。有时候我们要切换分支会有以下提示，是因为当前分支还有内容未提交，现在切换内容会丢失。这时候要用到git stash 命令

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/fa1415118bbd45b892842e5c4c54f949.png) 

```bash
git stash save "push to stash area" // 通过save 后面传入信息标识 放到stash区
git stash list //查看收藏的记录
git stash apply stash@{0} //将保存的内容重新恢复到工作目录
git stash drop stash@{0} //将对应的stash记录删除

git stash pop //= git stash apply + git stash drop
```

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/1442d0f069494e3498499ce8fe260731.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAQmV0dHlhbmVy,size_20,color_FFFFFF,t_70,g_se,x_16) 

### merge

 合并分支
git cat-file -p HEAD //查看某个对象的具体信息
git merge 基本会出现冲突 

```bash
merge fast-forward //默认  不会显示 feature，只保留单条分支记录。git直接把HEAD指针指向合并分支的头，完成合并。属于“快进方式”，不过这种情况如果删除分支，则会丢失分支信息。因为在这个过程中没有创建commit
git merge --no-ff //指的是强行关闭fast-forward方式。可以保存之前的分支历史。能够更好的查看 merge历史，以及branch 状态

git rebase //修剪提交历史基线，俗称“变基”
git rebase --onto master 5755487


git tag //对某个提交设置一个别名
```

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/86c897037e8c40a5beb0057bf56da77f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAQmV0dHlhbmVy,size_20,color_FFFFFF,t_70,g_se,x_16) 



## 设置忽略的文件

- 参考：https://blog.csdn.net/weixin_42428778/article/details/118710622 https://blog.csdn.net/Q1761991696/article/details/123572766

### 忽略范围

- 项目： 本地`.gitignore`文件通常放置在仓库库的根目录中 
- 全局： ~/.gitignore_global 

### 配置规则

- 忽略文件中的空行或以井号（#）开始的行将会被忽略。
- 可以使用Linux通配符。例如：星号（*）代表任意多个字符，问好（？）代表一个字符，方括号（[abc]）代表可选字符范围，大括号（{string1,string2,…}）代表可选的字符串等。
- 如果名称的最前面有一个感叹号（！），表示例外规则，将不忽略。
- 如果名称的最前面有一个路径分隔符（/），表示要忽略的文件在此目录下，而子目录中的文件不忽略。
- 如果名称的最后面有一个路径分隔符（/），表示要忽略的是此目录下该名称的子目录，而非文件（默认文件或目录都忽略）。

### 例子

```bash
#为注释
	
*.txt				#忽略所有 .txt结尾的文件，这样的话上传就不会被选中！
!lib.txt			#但 lib.txt除外。
/temp				#仅忽略项目跟目录下的 TODO文件，不包括其他目录temp。
build/				#忽略 build/ 目录下的所有文件。
doc/*.txt			#会忽略 doc/notes.txt 但不包括 doc/server/arch.txt。
```

常用配置

```bash
# 忽略node_modules目录
node_modules/


# 忽略IDE的配置文件
.idea/
.vscode/
*.sw*

# 忽略cmake的构建目录
build/

# 忽略日志
logs/
log/
*.log

```



## 常用命令

### 帮助

```bash
//查看某个命令文档
git help <command>
git <command> -h
git <command> --help
```



### 添加文件

```bash
# 添加目录下所有文件
git add .
# 提交
git commit -m "xxx"
```

### 删除

```bash
git rm --cached :仅从暂存区删除
git rm :从暂存区与工作目录同时删除
git rm $(git ls-files --deleted):删除所有被跟踪，但是在工作目录被删除的文件
```



### 仓库/远程操作

仓库配置可以在 .git/config 看到

upstream相关参考：https://www.csdn.net/tags/Mtzacg1sMDUwMy1ibG9n.html

```bash
git init ~/git-server --bare  //初始化一个本地的远程服务器
# 或者
cd project_dir
git init

git push //将本地历史推送到远程

git remote add  origin ~/git-server //添加一个远程仓库的别名
git remote -v //查看远程仓库信息

 git branch --set-upstream-to=origin_ssh/master # 设置默认的仓库和分支
 #或者
 git branch -u origin/dev

 
git fetch 
git pull // git pull = git fetch + git merge

git clone //克隆一个远程仓库作为本地仓库
```



### 用户

```bash
git config --global user.name "bettyaner"
git config --global user.email bettyaner@163.com
```

- local（默认，高级优先）：只影响本地仓库
- global(中优先级)：只影响所有当前用户的git仓库
- system（低优先级）：影响到全系统的git仓库

- ~/.git-credentials 

```bash
https://tommyyan2020:password@github.com
https://tommyyan:password@git.code.tencent.com
```



### 其他

```bash
//对状态的跟踪
git status

git log //查看提交历史记录

git log --online
git log --color --graph

git diff //工作区与暂存区的差异
git diff  --cached [<reference>]//暂存区与某次提交的差异，默认为HEAD
git diff  [<reference>]//工作区与某次提交的差异，默认为HEAD

git checkout -- <file> //将文件内容从暂存区复制到工作目录

//撤销暂存区内容
git reset HEAD <file> //将文件内容从上次提交复制到缓存区
git checkout HEAD -- <file> //将内容从上次提交复制到工作目录

```

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/d479dc58dfc04d488f6188a2973686e8.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAQmV0dHlhbmVy,size_20,color_FFFFFF,t_70,g_se,x_16) 



## 添加依赖的项目

- 参考：https://blog.csdn.net/boildoctor/article/details/122784055
- 不过对于一些公共的不易变动的库可以用这种方式，毕竟比较稳定，对于大的项目还是建议以release版本为主

### 下载

```bash
# 下载整个仓库带依赖项目
git clone --recursive 仓库名
# 更新依赖项目
cd 仓库目录
git submodule update --init --recursive
# 或者直接进入子模块项目目录去
git pull
```



### 新增

编辑仓库根目录下的 .gitmodules 文件，例子(levelDB)

```ini
[submodule "third_party/googletest"]
	path = third_party/googletest
	url = https://github.com/google/googletest.git
[submodule "third_party/benchmark"]
	path = third_party/benchmark
	url = https://github.com/google/benchmark
```



# github

## 参考

- github--pr 详细步骤 https://blog.csdn.net/qianfengkui/article/details/110820779
- github提交pr https://blog.csdn.net/gentleman_hua/article/details/123816150
- Github 使用经典问题：如何同步 fork 项目原仓库的更新 https://zhuanlan.zhihu.com/p/291845721
- github 默认的主分支从master 变成了main  https://blog.csdn.net/sanqima/article/details/122201855

## 免密登录

### ssh方式

- 教程：https://www.bilibili.com/video/BV1a34y1s7qV
- 也可以本地配置一个文件，配上用户名密码，参考这个教程：http://www.edbiji.com/doccenter/showdoc/74/nav/3283.html

- 注意这个key 是公钥,pub结尾那个

![1652770232753](images/1652770232753.png)

![1652772145163](images/1652772145163.png)

```bash
 git remote add origin_ssh git@github.com:tommyyan2020/public.git
 git config --global user.name "tommyyan2020"
 git config --global user.email 3965743@qq.com
 git push origin_ssh master
 git branch --set-upstream-to=origin_ssh/master
```

![1652772582790](images/1652772582790.png)

### https方式

- 参考：https://baijiahao.baidu.com/s?id=1717846683433344604&wfr=spider&for=pc

```bash
git config --global credential.helper store

```



![1654920742714](images/1654920742714.png)

![1654934214233](images/1654934214233.png)

## 参与开源项目开发

### 1 Fork项目到自己github账号下

![1652765121860](images/1652765121860.png)

![1652765070986](images/1652765070986.png)

### 2、clone到本地

- windows

![1652765342946](images/1652765342946.png)

![1652765468808](images/1652765468808.png)

​	一般要记得把Recursive选上，不然依赖的项目不会拉下来，编译可能不能通过

- linux

```bash
git clone https://github.com/tommyyan2020/incubator-doris.git --recursive
```



![1652765808818](images/1652765808818.png)

## 例子

### tdengine

- B站教程：https://www.bilibili.com/video/BV1Bq4y1p7Qr

![1657016516240](images/1657016516240.png)

![1657018013203](images/1657018013203.png)

# 腾讯工蜂

- https://git.code.tencent.com/



