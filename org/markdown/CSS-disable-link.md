 #+TITLE: Disable html link的不同实现方式

 #+KEYS: css
 
 #+AUTHOR: Li Min
 
# Disable html link的不同实现方式

一直觉得disable html的link是个比较容易实现的，可实际却是踩了一些坑坑的，所以下面讲给大家介绍几种不同的实现方法，并对各种方法的浏览器支持性进行分析。

## 方法一

### 例子
#### enabled

 <a href="http://www.baidu.com">my click is enabled in non-ie</a>

	<a href="http://www.baidu.com">my click is enabled in non-ie</a>
	
#### disabled

 <a href="http://www.baidu.com" style="pointer-events: none;">my click is disabled in non-ie</a>

	<a href="http://www.baidu.com" style="pointer-events: none;">my click is disabled in non-ie</a>

	
### 原理
pointer-events属性是用来控制浏览器对mouse/touch事件的响应，包括hover/active， click/tap，以及cursor是不是visible。

设置pointer-events: none之后，将会prevent `<a>`  的click,state以及cursor的option


### 浏览器支持
目前pointer－events只能支持主流的浏览器如chrome、firefox、safari

Chrome | Firefox | Safari   | IE
------ | ------  | -------  | -------
Yes    | 3.6     | 4.0		 | 11+




## 方法二

### 例子
#### enabled

 <a href="http://www.baidu.com" enabled>my click is enabled in ie</a>

	<a href="http://www.baidu.com" enabled>my click is enabled in ie</a>

 <button enabled>My Button is enabled</button>

	<button enabled>My Button is enabled</button>
	
#### disabled

 <a href="http://www.baidu.com" disabled>my click is disabled in ie</a>

	<a href="http://www.baidu.com" style="pointer-events: none;">my click is disabled in ie</a>

 <button disabled>My Button is disabled</button>

	<button disabled>My Button is disabled</button>

	
### 原理
enabled和disabled属性一般用于`<input>`或者是`<button>` tag上，但是将它用于`<a>`标签上在non-ie浏览器上时是不会work的，但在ie上却可以work，所以可以采用将方式1和方式2进行结合来实现对link行为的控制。


### 浏览器支持
对于`<a>`标签，enabled和disabled只在IE上支持，所以如果你使用非IE浏览器打开该博客并点击上面的例子，是不会work的.

### 其他
即使结合使用方式一和方式二，link的behavior在non-ie和ie上是不会有差异的，但是在UI上还是有一点点小的差异：

* 方式一：在non-ie上，不管link是否可点击，两个link的style是一样的，只是可点击的hover时会有一个pointer的cursor
* 方式二：在ie上，被disable掉的link字体会变成灰色，并且不能再通过CSS更改颜色.

## 方法三
在某些情况下我们希望disable link是因为链接不存在或者链接不正确。如之前我们工作的某一项目上时，需求为：当链接存在时显示一个可点的link，当链接不存在时只显示文字信息，同时文字的颜色不应该改变。

这个时候采用方式一盒方式二可以实现behavior，但是UI部分就不能简单的通过css进行修正，在IE上被disable的link文字总是灰色的。同时由于需要支持responsive，所以我们并不希望改变html的DOM结构，那样会增加复杂性，所以最后我们采用的方式如下:

### 例子
#### enabled

 <a href="http://www.baidu.com">my click is enabled in all browsers</a>

	<a href="http://www.baidu.com">my click is enabled in all browsers</a>
	
#### disabled

 <a>my click is disabled in all browsers</a>

	<a>my click is disabled in all browsers</a>

	
### 原理
可以看到这里当链接不存在时，我们直接将`<a>`标签的`href`属性删掉了，这个时候对浏览器来说`<a>`就只是一个一般的inline的元素

### 浏览器支持
支持所有浏览器