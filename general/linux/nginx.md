# Nginx各种常规用法

## 参考文档

- nginx配置访问密码，输入用户名和密码才能访问 ：https://feiutech.blog.csdn.net/article/details/82817874
- nginx正向代理——实现上网功能：https://blog.csdn.net/liuxiao723846/article/details/80326789

## 权限控制（访问验证）

### 方法

在 nginx 下，提供了 ngx_http_auth_basic_module 模块实现让用户只有输入正确的用户名密码才允许访问web内容。默认情况下，nginx 已经安装了该模块。所以整体的一个过程就是先用第三方工具（ htpasswd，或者使用 openssl）设置用户名、密码（其中密码已经加过密），然后保存到文件中，接着在 nginx 配置文件中根据之前事先保存的文件开启访问验证。

### 例子

以**htpasswd**为例

- 安装htpasswd工具，生成nginx的访问密码

  ```bash
  yum install -y httpd-tools
  # 建一个目录用于存放各种password
  mkdir -p /etc/password
  # 生成nginx的访问密码
  htpasswd -c /etc/password/nginx.pwd tommy
  New password: 
  Re-type new password: 
  Adding password for user tommy
  ```
- 配置nginx

  两种方式配置，作用域不一样

  - 端口级别

    ```
    server {
        listen 80;
        server_name  localhost;
        .......
        #新增下面两行
        auth_basic "Please input password"; #这里是验证时的提示信息
        auth_basic_user_file /etc/password/nginx.pwd;
        location /{
        .......

    }
    ```
  - 路径级别

    ```
    server {
        listen 80;
        server_name  localhost;
        .......

        location /{
            #新增下面两行
            auth_basic "Please input password"; #这里是验证时的提示信息
            auth_basic_user_file /etc/password/nginx.pwd;
        } 
        .......

    }
    ```

## 正向代理

内部网络，代理上网，访问外部www服务

### 简单带鉴权

- 配置

  ```
     resolver 8.8.8.8;

      server {
          listen     38080;
          location / {
              # auth_basic "Please input password";
              auth_basic_user_file /etc/password/nginx.pwd;
              proxy_pass http://$http_host$request_uri;
          }
      }

  ```
- 测试

  ```
  # 环境变量方式
  export "http_proxy=http://[user]:[pass]@host:port/" 
  wget www.qq.com
  # 参数方式
  wget -e "http_proxy=http://[user]:[pass]@host:port/" http://www.qq.com
  # 永久方式
  通过/etc/profile或者当前用户的profile、bashrc等

  ```

## 反向代理

对外提供服务：外部访问公司内服务（公网IP/域名），公司内局域网内www服务

### 转发到内部端口

```
    server {
        listen 80;
        server_name _;
        root /data/docs/public;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        access_log logs/tommydev-accesss.log;
        location / {
             proxy_http_version 1.1;
             proxy_set_header Upgrade $http_upgrade;
             proxy_set_header Connection "Upgrade";
             proxy_set_header Host $host;
             proxy_pass http://192.168.56.101:8000;
        }
    }
```

### 指定路径转发到内部端口

这个有局限性，新开发的前端程序不急于绝对路径转发的服务可以用这种，否则各种路径改造工作

```
server {
            location /docs/ {
             proxy_http_version 1.1;
             proxy_set_header Upgrade $http_upgrade;
             proxy_set_header Connection "Upgrade";
             proxy_set_header Host $host;
             proxy_pass http://192.168.56.101:3000/;
        }
    }
```

### 指定端口的转发

指定端口的转发比前面一种指定路径的转发效果好，但是使用麻烦

```
    server {
        listen 3080;
        server_name _;
        access_log logs/namenode-accesss.log;
        location / {
             auth_basic "User Authentication";
             auth_basic_user_file /etc/nginx/default.admin.passwd;
             proxy_http_version 1.1;
             proxy_set_header Upgrade $http_upgrade;
             proxy_set_header Connection "Upgrade";
             proxy_set_header Host $host:3080;
             proxy_pass http://192.168.56.101:50070;
        }
    }
```

### 指定域名的转发

这种效果最好（比指定端口、指定路径），使用更方便

同一个端口可以指定多组不同的配置

```
    server {
        listen 80;
        server_name iotop.xyz;
        access_log logs/docsify-accesss.log;
        location / {
             proxy_http_version 1.1;
             proxy_set_header Upgrade $http_upgrade;
             proxy_set_header Connection "Upgrade";
             proxy_set_header Host $host;
             proxy_pass http://192.168.56.101:3000;
        }

        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Header X-Requested-With;
        add_header Access-Control-Allow-Methods GET,POST,OPTIONS,PUT,DELETE;
    }

```

### 指定路径静态文件的转发

```
        location /testcase/ {
             root /data/docs/public/;
        }
```

### 复杂交互式网页的转发

```
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Header X-Requested-With;
        add_header Access-Control-Allow-Methods GET,POST,OPTIONS,PUT,DELETE;

```

### HTTPS转发

```
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection "upgrade";
```
