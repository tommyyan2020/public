# 常用工具安装情况

## 1 linux环境（master节点）

| 名称        | 版本        | 路径                                                         | 自启动 | 启动命令                                         | 部署情况                                                     |
| ----------- | ----------- | ------------------------------------------------------------ | ------ | ------------------------------------------------ | ------------------------------------------------------------ |
| Calibre-web | 0.6.13 Beta | /data/docs/calibre-web-master                                | 否     | start.sh<br />nohup python3 ./cps.py > cps.log & | IP：101<br />端口：<br />- 内网：8083<br />- 外网: [4500](http://182.87.223.144:4500/) |
| Nginx       | 1.14.1      | /usr/sbin<br />log：/usr/share/nginx/logs/                   | 是     | systemctrl start nginx                           | IP：101，103<br />端口：80及各个服务暴露的端口               |
| vscode-web  | 1.54.2      | /data/run/code-server-3.9.2-linux-amd64<br />配置：~/.config/code-server/config.yaml | 是     | nohup code-server &                              | IP：101<br />端口：<br />- 内部端口：8000<br />- 外部端口：[80](http://182.87.223.144/) |
| docsify     | 4.4.3       | /usr/local/bin/<br />配置：                                  |        | nohup docsify serve /data/docs/public &          | IP：101<br />-内部端口：3000<br />- 外部端口：[80/docs](http://182.87.223.144/docs) |
| scala       | 2.11.12     | rpm安装                                                      |        | scala                                            |                                                              |
| graphviz    | 2.4.0       | https://blog.51cto.com/doublelinux/2092107                   |        | dot                                              |                                                              |
| arthas      | 3.5.5       |                                                              |        | arthas                                           |                                                              |
| protobuf    | 3.20.1      | /usr/local                                                   |        |                                                  |                                                              |
| thrift      | 0.16.0      | /usr/local/bin                                               |        |                                                  |                                                              |
| cmake       | 3.20        |                                                              |        |                                                  |                                                              |
| gperftools  | 2.10        |                                                              |        |                                                  |                                                              |
| gtest       | 1.11.0      |                                                              |        |                                                  |                                                              |
|             |             |                                                              |        |                                                  |                                                              |

## 2 windows环境

| 名称           | 版本    | 路径                                                         | 服务化 | 相关命令                                  | 部署情况                              |
| -------------- | ------- | ------------------------------------------------------------ | ------ | ----------------------------------------- | ------------------------------------- |
| nginx          | 1.20.2  | C:\app\nginx-1.20.2                                          | 是     | 启动：winsw start  <br />停止：winsw stop | 端口：80                              |
| filebrowerser  | 2.20.1  | C:\app\filebrowser                                           | 是     | 启动：winsw start  <br />停止：winsw stop | 外网：file.iotop.xyz <br />内网：8080 |
| docsify        |         | C:\data\public                                               | 否     | 直接在nginx配置                           | 外网：iotop.xyz                       |
| offsetexplorer | 2.2     | https://www.kafkatool.com/download2/offsetexplorer_64bit.exe |        |                                           |                                       |
| PrettyZoo      | 1.96    | https://github.com/vran-dev/PrettyZoo/releases/download/v1.9.6/prettyZoo-win.msi |        |                                           |                                       |
| HDFS Explorer  | 1.1.236 | https://blog.csdn.net/Cypher_Studio/article/details/108605917 |        |                                           |                                       |



