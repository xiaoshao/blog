 #+TITLE: JS带你飞（1）- Lodash workshop - Part 2

 #+KEYS: lodash,javascript,highchart
 
 #+AUTHOR: Xiang Zhang
 
 #+description: 这一期的JS飞活动主要练习了Lodash相关方法的使用。
 
# JS带你飞（1）- Lodash workshop - Part 2

[上一篇娟姐的博客](http://resiworks.github.io/markdown/JS-lodash-workshop-1.md.html)中，已经详细介绍了这次 Lodash Workshop 的题目要求，并给出了第一问的实现。这里主要是记录一下我对需求2-4的实现。

### 需求2：show the price range of each city
这里要从分组后的结果中取得 price 数据，所以`countBy`方法不再适用，需要采用`groupBy`来分组，然后再使用`min`与`max`方法得到价格区间的上下限，具体代码如下：

```js
var groupedData = _(listings).groupBy("city").map(function(value, key){
    var minPrice = _.min(value, 'price').price;
    var maxPrice = _.max(value, 'price').price;
    return { name: key, y: value.length, minPrice: minPrice, maxPrice: maxPrice };
}).value();
```
执行结果为：

```js
[{
    maxPrice: 5000000,
    minPrice: 3000000,
    name: "beijing",
    y: 3
 },
 {
    maxPrice: 800000,
    minPrice: 200000,
    name: "xian",
    y: 7
 },
            .
            .
            .
 {
    maxPrice: 4000000,
    minPrice: 3500000,
    name: "shenzhen",
    y: 2
 }]
```
其中，data.y 显式指定了 highcharts 在绘图时使用的数据。

数据有了，我们还要让饼图将 price range 显示出来，这需要将 highcharts 中的`dataLabels.format`修改成我们需要的格式：

```js
dataLabels: {
    enabled: true,
    format: '<b>{point.name}</b>: {point.y} $ {point.minPrice} ~ {point.maxPrice}'
}
```
完整代码及结果图[请看这里](http://jsbin.com/noduqitepe/1/edit?js,output)

### 需求3：show only 4 cities, "beijing", "xian", "chengdu" & "others" (no order required)

在没有顺序要求的情况下，需求3与需求2的不同之处仅在于分组规则，需求2是直接按照 City Name 分组，而需求3则是按照一个自定义的分组规则。我们只需要将`_(listings).groupBy("city")`中的`"city"`替换为自定义的`groupedRule`即可，实现如下：

```js
var groupedRule = function(list) {
    return _(["beijing", "xian", "chengdu"]).includes(list.city) ? list.city : "others";
};
```
这时分组后的结果为：

```js
{   
    beijing: [
        {city: "beijing",price: 3000000},
        {city: "beijing",price: 3500000},
        {city: "beijing",price: 5000000}
    ],
    chengdu: Array[4],
    others: Array[7],
    xian: Array[7]
}
```
完整代码及结果图[请看这里](http://jsbin.com/liwohe/1/edit?js,console,output)


### 需求4：show only 4 cities, and keep the order: "beijing", "xian", "chengdu" & "others"

在上一步中，我们已经获得了分组后的数据。但是要让它们按照指定顺序输出，会遇到一个问题：Object中的数据是没有办法排序的。有两种解决方案：一是将`groupBy`后得到的 Object 转变为数组，然后再进行排序、遍历；另一种更简洁的方案是先进行格式化的`map`，然后再对返回的数组排序。
##### 方案一
为了得到需要的有序数据，一共要三个步骤：

1. 用`_.pairs()`方法将分组后的数据变为Array，变换后的数据如下：

    ```js
[
    ["beijing", [
        {city: "beijing",price: 3000000},
        {city: "beijing",price: 3500000},
        {city: "beijing",price: 5000000}
    ]],
    ["xian",    Array[7]],
    ["chengdu", Array[4]],
    ["others",  Array[7]]
]
    ```
2. 用`_.sortBy()`方法对数据排序

```js
var sortedNumList = { "beijing": 1, "chengdu": 2, "xian": 3, "others": 4 };
var groupedList = _(listings).groupBy(groupedRule).pairs().sortBy(function(data) {
        return sortedNumList[data[0]] || sortedNumList.others;
}).value();
```

3. 由于这时的数据结构发生了变化，最后的`map`方法需要做一些改变

    ```js
var groupedData = _.map(groupedList, function(data){
        var minPrice = _.min(data[1], 'price').price;
        var maxPrice = _.max(data[1], 'price').price;
        return { name: data[0], y: data[1].length, minPrice: minPrice/1000, maxPrice: maxPrice/1000 };
});
    ```
完整代码及结果图[请看这里](http://jsbin.com/xugoquxuli/1/edit?js,output)

##### 方案二
这种方案实现起来比较简单，只需要对`map`后得到的`groupedData`多做一步`sortBy`操作，实现如下：

```js
groupedData = _.sortBy(groupedData, function(listing){
    return _.indexOf(['beijing','xian','chengdu','others'], listing.name);
});
```
完整代码及结果图[请看这里](http://jsbin.com/koyuqilesi/1/edit?js,output)
> 疑问：方案二虽然实现简洁，但它将对数据的逻辑操作(sort)加在了 highcharts 所需的格式化操作(map)之后，这样的写法是否不利于代码分块？

> 个人感觉`map`应该与`$('#chart').highcharts`分在一起，这样画饼图的部分可以抽出来独立使用。而`sortBy`应与`groupBy`等操作组合在一起。