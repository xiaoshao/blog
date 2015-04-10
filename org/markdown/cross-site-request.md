 #+TITLE: Cross Site Request

 #+KEYS: cors,cross_domain

 #+DATE: <2015-04-09 Thur>

 #+AUTHOR: Juan Du

 #+description: 浏览器端跨域请求问题是Web开发经常遇到的问题，理解跨域访问的机制，对处理网站跨域请求非常有必要

浏览器端跨域请求问题并不陌生。网站A http://www.A.com 去请求网站B http://www.B.com 的资源，比如图片，如果网站A和B不在同一个域，
便出现了跨域请求的问题。换句话说，web应用通过XMLHttpRequest发出的web请求默认只能访问相同域名下的资源。

### 怎样进行跨域访问

W3C提供了CORS（跨域资源共享）机制来支持跨域资源访问。目前主流浏览器支持的请求包括：

* XMLHttpRequest API
* Web Fonts（CSS中通过@font-face引用某种字体）
* [WebGL textures](http://blog.chromium.org/2011/07/using-cross-domain-images-in-webgl-and.html)
* [canvas images](https://developer.mozilla.org/en-US/docs/Web/HTML/CORS_enabled_image)

### 简单跨域请求

* 简单的跨域请求支持GET，HEAD，特定MIME类型的POST（application/x-www-form-urlencoded，multipart/form-data和text/plain）
* 未做修改的标准Http请求header（例如X-Modified）
* Response中Access-Control-Allow-Origin包含请求域

看一个简单的跨域请求的[例子](http://jsbin.com/hojulinefe/1/edit?html,js,console)

```js
var xdr = new XMLHttpRequest();
var url = "http://services.realestate.com.au/suburb/ownership/melbourne/vic/3000/buy";
xdr.open("get", url);
xdr.onload = function() {
    console.log(xdr.responseText);
};
setTimeout(function () {
    xdr.send();
}, 0);
```

对于这样一个请求，我们来看一下浏览器发出的请求和响应

Request Headers

```sh
Accept:*/*
Host:services.realestate.com.au
Origin:http://null.jsbin.com
Referer:http://null.jsbin.com/runner
...
```

Response Headers

```sh
Access-Control-Allow-Credentials:true
Access-Control-Allow-Origin:*
Content-Type:application/json;charset=UTF-8
...
```

这里是一个GET请求，并没有去修改Request Header，而且由于服务器响应中设置了`Access-Control-Allow-Origin:*`，所以允许任何跨域资源访问。
这里也可以设置部分域名开放，比如`Access-Control-Allow-Origin:http://null.jsbin.com`

### Preflight跨域请求

CORS还通过一种叫做Preflighted Requests的透明服务器验证机制支持自定义头部、特殊方法请求等特殊跨域访问。之所以称为“Preflight Requests”，是因为
浏览器先会发出一个OPTIONS方法的“Preflight”请求，服务器会对header进行检测，如果允许这种请求，那么浏览器会再次发出一个完整的http请求。

满足下面条件的就是一个Preflight请求：

* 除了GET，HEAD，特定MIME类型POST（application/x-www-form-urlencoded，multipart/form-data和text/plain）以外的请求
* 设置标准Header

例如一个PUT请求，浏览器会发出两个请求。

```html
OPTIONS /services.realestate.com.au HTTP/1.1
```

```html
PUT /services.realestate.com.au HTTP/1.1
```

### 浏览器兼容性

|    Feature    |   Chrome  |   Firefox (Gecko) |   Internet Explorer  |   Opera   |   Safari  |
| ------------- | --------- | ----------------- | -------------------- | --------- | --------- |
| Basic support	|     4  	|       3.5	        |           10         |    12     |     4     |

IE8不支持XMLHttpRequest，可用[XDomainRequest](https://developer.mozilla.org/en-US/docs/Web/API/XDomainRequest)替代。

### 引用
[MDN -- HTTP access control (CORS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS)
