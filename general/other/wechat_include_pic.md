# 微信图片禁止外链的解决方案

试了一下网上介绍的方案，基本不可行

参考网站

- https://www.cnblogs.com/bornfish/p/5387923.html
- https://blog.csdn.net/qq_38122518/article/details/78538121


最后在第一个网站得到了启发，方法很简单，
- 域名改一下：`mmbiz.qpic.cn` ->`mmbiz.qlogo.cn`
- 页面上增加一条
```html
<meta name="referrer" content="never">
``` 
效果如下：

# mmbiz.qpic.cn
![全局图](https://mmbiz.qpic.cn/mmbiz_png/PL10rfzHicsialGia5ujEy03WX7icsibyiahkLxxFFJKzeQ0ibB4w1jh9oC0obCL0zicsn3AUW8DanwAkWgUwzcRWLvEjQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)
# mmbiz.qlogo.cn
![全局图](https://mmbiz.qlogo.cn/mmbiz_png/PL10rfzHicsialGia5ujEy03WX7icsibyiahkLxxFFJKzeQ0ibB4w1jh9oC0obCL0zicsn3AUW8DanwAkWgUwzcRWLvEjQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)
![全局图](https://mmbiz.qlogo.cn/mmbiz/Mo21APPFBgXibzXsuzdVibpQhicmBBW5sVvJficN7NulwGW2gibbsMEoOHUL4eEjRvVicPiaLia28FTVG8Atdx2mDFhCGw/0?wx_fmt=jpeg)
