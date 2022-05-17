# Calibre-Web安装

## 下载对应的安装包
以下几种方式选择一个
- github：https://github.com/janeczku/calibre-web
- pip:pip install calibreweb
   下载完成后解压版本包执行：
  `pip install --target vendor -r requirements.txt`
  
- 也可以通过docker的方式下载启动，参考网页2
- 官网下载：https://calibre-ebook.com/download :
  ```bash
  wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin install_dir=~/calibre-bin isolated=y
  ```

 
## 配置

配置使用参考第一个参考网页

重点是需要有一个文件metadata.db的文件，可以从Calibre的windows版本的安装的书籍路径下找到，这里有一个：[metadata.db](/docs/file/general/metadata.db ":ignore")

## 启动

nohup python ./cps.py > cps.log &

默认用户密码：admin/admin123，可以在页面上修改

## 参考网页

* https://tencentcvm.blog.csdn.net/article/details/116765289
* https://zhuanlan.zhihu.com/p/94534013
