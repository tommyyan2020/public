

# Mave仓库使用大全

## 参考内容

- 《Maven官方指南》30分钟入门：http://ifeve.com/m2-getting-started/
- 《Maven官方指南》标准目录结构：http://ifeve.com/maven-standard-directory-layout/
- 总结比较全的maven使用：Maven 初学 https://blog.csdn.net/qq_39088066/article/details/101294451
- 超级详细的Maven使用教程： https://blog.csdn.net/lovequanquqn/article/details/81627807
- 如何把自己的Jar包上传到 maven 官方仓库中，Maven上传图文讲解：https://blog.csdn.net/hupoling/article/details/78511899
- archetype创建

  - 官方：http://maven.apache.org/guides/mini/guide-creating-archetypes.html
  - 中文：https://www.cnblogs.com/zhenghengbin/p/10337829.html

## 常用信息

### 中央仓库

- 官方：https://repo1.maven.org/maven2/，不做任何配置就用这个
- 阿里云仓库：[https://maven.aliyun.com/repository/central](https://maven.aliyun.com/repository/central?spm=a2c40.maven_devops2020_goldlog_.0.0.60013054WdCrVo) ，其他还有一些仓库见这里https://maven.aliyun.com/mvn/guide
- 其他仓库：可以在这里查--> https://mvnrepository.com/repos

### 项目目录结构

```
src
  -main
      –bin 脚本库
      –java java源代码文件
      –resources 资源库，会自动复制到classes目录里
      –filters 资源过滤文件
      –assembly 组件的描述配置（如何打包）
      –config 配置文件
      –webapp web应用的目录。WEB-INF、css、js等
  -test
      –java 单元测试java源代码文件
      –resources 测试需要用的资源库
      –filters 测试资源过滤库
  -site Site（一些文档）
target   存放项目构建后的文件和目录，jar包、war包、编译的class文件等,maven构建的时候生成的
LICENSE.txt Project’s license
README.txt Project’s readme
```

## 配置

### maven全局配置 - settings.xml

#### 路径

- windows：%MAVEN_HOME%\conf\
- linux：/etc/maven/

#### 主要配置内容

- 中央仓库的地址：`repositories`
- 镜像仓库：`mirrors`
- 本地仓库的地址：配置项->localRepository；默认值：{user.home}/.m2/repository

### 项目配置 - pom.xml

#### 路径

- 项目起始目录下

#### 主要配置内容

- 项目信息：`groupId`、`artifactId、version`、`packaging ，就是所谓的“坐标”`
- 依赖库：`dependencies`
- 版本仓库：`repositories`
- 构建信息：build
  - 插件：`plugins`
  - 插件管理：`pluginManagement`

## 常用命令

### 创建一个新的maven项目

```bash
mvn -B archetype:generate \
  -DarchetypeGroupId=org.apache.maven.archetypes \
  -DgroupId=com.mycompany.app \
  -DartifactId=my-app
```


### 查询Maven版本

```
-v: 本命令用于检查maven是否安装成功。
```

```
Maven安装完成之后，在命令行输入mvn -v，若出现maven信息，则说明安装成功。
```

### 编译

```
compile：将java源文件编译成class文件
```

### 测试项目

```
test: 执行test目录下的测试用例
```

### 打包

```
package: 将项目打成jar包
```

### 删除

clean：删除target文件夹

### 安装

install: 将当前项目放到Maven的本地仓库中。供其他项目使用
