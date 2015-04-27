 #+TITLE: CSS 文档流

 #+KEYS: css, positon, float
 
 #+AUTHOR: Fu Ying
 
 #+description: CSS中的position如何工作
 
# CSS 文档流

在实现一个页面的时候，为了满足设计的需要，我们经常使用position和float属性来对页面元素进行布局。那么这两个属性到底是如何工作的呢？要解释这两个属性，就不得不提到文档流的概念。


## 文档流
一个页面由多个html元素所组成，在没有css样式的情况下，浏览器在渲染这些元素的时候，会按照html元素的顺序从左至右，从上至下的渲染这些元素。

html元素根据其渲染时是否占一整行分为两类，一类是块级（block）元素，一类是内联（inline）元素。块级元素，像div，p等，在渲染的时候都需另起一行。内联元素，像span，a等，在渲染的时候就依次在本行内从左至右渲染。

Example:
```html
<div class="rui-school-information">我占了一行</div>
<span>我是span</span> <a herf="#">我是个链接</a>
<p>我是一段话，也占一整行</p>
```
效果：
<pre><code>
<div>我占了一行</div>
<span>我是span</span> <a>我是个链接</a>
<p>我是一段话，也占一整行</p>
</code></pre>

## position属性
CSS的position属性如何影响元素在文档流中的位置呢？

position属性有4个值，static，relative，absolute，fixed和inherit。

* static：将position属性置为static，元素的位置不会发生任何变化，仍然按照他在文档流的位置进行渲染。
* relative：将position属性置为relative，元素在文档流中原来的位置仍然保留，但元素本身在渲染的时候会根据top，right，bottom，left等属性值根据元素原来的位置进行偏移。
* absolute：将position属性置为absolute，元素在文档流中不再进行占位，在渲染元素的时候，根据他的第一个非static的父元素的位置进行偏移。
* fixed：将position属性置为fixed，元素在文档流中不再进行占位，在渲染元素的时候，根据浏览器窗口进行进行偏移。
* inherit：将position属性置为inherit，元素继承父元素的position属性。


## float属性
CSS的float属性如何影响元素在文档流中的位置呢？float会使元素飘离出文档流，根据其值元素会漂至所在行的最左或最右。而其周围的元素会忽略float元素原本在文档流中的位置进行渲染。

float属性有3个值，left，right，none和inherit。

* left：元素漂至所在行的最左侧
* right：元素漂至所在行的最右侧
* none：元素不进行浮动
* inherit：继承父元素的float属性

## 总结
在不进行任何css修改的情况下，html元素会按照其所在位置从左至右，从上至下进行渲染。有三种情况会使元素跳出文档流，让其周围元素忽略其本身在文档流中的位置进行渲染，他们分别是position：absolute，position：fixed，和float。

