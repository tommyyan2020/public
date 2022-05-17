# 基于python的文件上传/下载服务

## 主页：index.html

```html
<!DOCTYPE html>
<html>
<meta charset="utf-8">
<head>
    <title>File Server</title>
</head>
<body>
    <form action="/cgi-bin/download.py" method="get">
        要下载的文件: <input type="text" name="filename" />
        <input type="submit" value="download">
    </form>

    <form enctype="multipart/form-data" action="/cgi-bin/upload.py" method="post">
        要上传的文件: <input type="file" name="filename" />
        <input type="submit" value="upload">
    </form>
</body>
</html>
```

## server.py

```python
## !/usr/bin/python3
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer, CGIHTTPRequestHandler

if __name__ == '__main__':
    try:
        handler = CGIHTTPRequestHandler
        handler.cgi_directories = ['/cgi-bin', '/htbin']
        port = int(sys.argv[1])
        print('port is %d' % port)
        server = HTTPServer(('', port), handler)
        print('Welcome to my website !')
        server.serve_forever()

    except KeyboardInterrupt:
        print('^C received, shutting down server')
        server.socket.close()
```

## download.py

```python
##!/usr/bin/python3

import os
import sys
import cgi

form = cgi.FieldStorage()

filename = form.getvalue('filename')

dir_path = "d:/tmp/"
target_path = dir_path + str(filename)
if os.path.exists(target_path) == True:
    print('Content-Type: application/octet-stream')
    print('Content-Disposition: attachment; filename = "%s"' % filename)
    print('\n\n')

    sys.stdout.flush()
    fo = open(target_path, "rb")
    sys.stdout.buffer.write(fo.read())
    fo.close()
else:
    print("""\
        Content-type: text/html\n
        <html>
        <head>
        <meta charset="utf-8">
        <title>File server</title>
        </head>
        <body>
        <h1> %s doesn't exist in the server:
        files in the server list below: </h1>""" % filename)

    for line in os.popen("ls -lh d:/data/"):
        cmd = "cat %s |awk -F \" \" '{print $9}'" % line
        name = os.popen(cmd)
        name = line.strip().split(' ', 8)
        if len(name) == 9:
            print('''<form action="/cgi-bin/download.py" method="get">
                %s <input type="submit" name="filename" value="%s">
                </form>''' % (line, name[8]))

    print('</body> <html>')
```

## upload.py

```python
##!/usr/bin/python3

import cgi, os

form = cgi.FieldStorage()

item = form['filename']

if item.filename:
    fn = os.path.basename(item.filename)
    open('d:/tmp/' + fn, 'wb').write(item.file.read())
    msg = 'File ' + fn + ' upload successfully !'
else:
    msg = 'no file is uploaded '

print("""\
Content-type: text/html\n
<html>
<head>
<meta charset="utf-8">
<title>Hello world</title>
</head>
<body>
<h2>名称: %s</h2>
</body>
<html>
""" % (msg,))
```

