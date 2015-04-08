 #+TITLE: HTML5 - Web Worker

 #+KEYS: html5,web_worker

 #+DATE: <2015-04-05 Sun>

 #+AUTHOR: Jia Feng

Javascript是单线程的。因此，持续时间较长的计算会阻塞UI线程，进而导致用户无法正常使用页面中的功能，并且在大多数浏览器中，除非控制权返回，否则甚至
无法打开新的标签页。HTML5 Web Worker正是这类问题的解决方案，Web Worker可以使得web页面具备后台处理能力，它对多线程的支持非常好，因此，使用了
Web Worker的web应用可以充分利用多核CPU带来的优势。

## 进入正题之前

在决定使用Web Worker之前，你还需要了解一些信息

### 应用场景
如果web应用需要执行一些后台数据处理，但又这些数据处理工作影响web页面本身的交互性，那么可以通过Web Worker去执行数据处理任务，同时添加一个事件监听
器去监听和处理Web Worker发送的消息。

Web Worker的另一个用途是监听由后台服务器广播的新闻信息，收到后台服务器的信息后，将其显示在Web页面上。像这种与后台服务器对话的场景中，Web Worker
可能会使用到Web Socket或Server-Sent Event。

### 限制
尽管Web Worker功能强大，但也不是万能的，有些事情是Web Worker无能为力的。例如，Web Worker中执行的脚本不能访问该页面的 `window` 对象，换句话说，
Web Worker不能直接访问web页面和DOM API。另外，虽然Web Worker不会导致浏览器UI停止响应，但是仍然会消耗CPU周期，导致系统反应速度变慢。

### 浏览器支持
Web Worker目前已被绝大多数主流浏览器所支持，推荐一个网站：[Can I use](http://caniuse.com)，在网站上搜索Web Worker可以查看最新的浏览器支持情况。

## 使用Web Workers API

简而言之，使用Web Workers API需要编写两部分的JS代码：

*  主页面中的JS代码 - 创建Web Worker，接收Web Worker的返回消息和错误信息
*  Web Worker中执行的JS代码 - 处理后台任务，也可以接收主页面发来的消息

### 创建Web Worker
可以用两种方式创建Web Worker，一种是直接传入Web Worker所要运行的JS的URL

```js
worker = new Worker("job.js");
```

如果你的浏览器支持文件系统 `API(Blob, BlobBuilder)`，你还可以加载`<script>`标签中inline的JS代码来创建Web Worker，例如html页面中包含如下标签

```html
<script id="worker" type="javascript/worker">
    ...some job...
</script>
```

可以用下面的JS代码来创建Web Worker

```js
blob = new Blob([document.getElementById('worker').innerText], { type: "text/javascript" });
worker = new Worker(window.URL.createObjectURL(blob));
```

### 发送消息
使用postMessage方法给Worker发送消息，可以是字符串或者任何JS对象

```js
// someData = "some text";
// someData = {};

worker.postMessage(someData);
```

### 监听消息和错误
主页面可以注册Callback来接收Worker返回的消息或者抛出的错误信息

```js
worker.addEventListener("message", messageHandler, true);
worker.addEventListener("error", errorHandler, true);

function messageHandler(e) {
    // do something with e.data
}

function errorHandler(e) {
    console.log(e.message, e);
}
```

### 销毁Web Worker

```js
worker.terminate();
```

### Web Worker导入其他JS文件
如果Web Worker中要执行复杂的处理任务，可能还需要导入其他JS文件

```js
importScripts("someLib.js", "otherLib.js");
```

### 接收主页面消息
Web Worker同样可以监听主页面发来的消息，方式与主页面监听消息是相同的

```js
addEventListener("message", messageHandler, true);

function messageHandler(e) {
    // do something with e.data
}
```

### 向主页面发送消息
Web Worker可以向主页面发送任务运行的结果或中间状态等，其方式与主页面发送消息的方式也是相同的

```js
worker.postMessage(someData);
```

## 举个栗子

一个基于Canvas的图像模糊应用，实现方法是不断对图像中的每个像素点与周围的8个像素点进行线性模糊。由于图像模糊运算任务被分配给一个或多个Web Worker
在后台执行，大家可以看到无论是log打印，还是按钮的交互都没有受到影响。
请查看[源代码](https://github.com/JustinFeng/web-worker-blur)或试试[Live Demo](http://justinfeng.github.io/web-worker-blur/blur.html)。