 #+TITLE: JS带你飞（1）- Lodash workshop
 
 #+KEYS: lodash,javascript,highchart

 #+DATE: <2015-03-31 Tue>

 #+AUTHOR: Du Juan

JS带你飞迎来了第二次workshop，这次的主题是用 [lodash](https://lodash.com/) 解释数据生成一个饼图。[UnderscoreJS](http://underscorejs.org)
和[lodash](https://lodash.com/)是目前非常流行的两个JS库，提供了一系列的常用函数来对Javascript对象操作。此次workshop选择了lodash来实现JS对象的解析。

## 需求

这次的workshop是实现第一步的功能，查看[结果](http://jsbin.com/yoqudakune/1/)

1. draw a pie chart to represent listing count grouped by city
2. show the price range of each city
3. show only 4 cities, "beijing", "xian", "chengdu" & "others" (no order required)
4. keep the order: "beijing", "xian", "chengdu" & "others"

输入数据

    var listings = [
        {city: "beijing", price: 3000000},
        {city: "xian", price: 600000},
        {city: "shanghai", price: 3500000},
        {city: "xian", price: 200000},
        {city: "beijing", price: 3500000},
        {city: "xian", price: 640000},
        {city: "wuhan", price: 600000},
        {city: "chengdu", price: 750000},
        {city: "xian", price: 800000},
        {city: "chengdu", price: 750000},
        {city: "xian", price: 660000},
        {city: "shenzhen", price: 3500000},
        {city: "shanghai", price: 5000000},
        {city: "wuhan", price: 450000},
        {city: "chengdu", price: 800000},
        {city: "shenzhen", price: 4000000},
        {city: "xian", price: 460000},
        {city: "beijing", price: 5000000},
        {city: "xian", price: 230000},
        {city: "chengdu", price: 800000},
        {city: "wuhan", price: 800000}
    ];

## 实现

首先对需求进行任务划分：

1. 实现饼图
2. 根据city对listings进行分组
3. 通过饼图展示分组结果

### 实现饼图

引用[highchart](http://www.highcharts.com/)库。并将库引入html文件head中。

    <script src="//code.highcharts.com/highcharts.js">

实现基本的一个饼图。

    var groupedData = [
        ['Firefox',   45.0],
        ['IE',       26.8],
        ['Chrome',   12.8],
        ['Safari',    8.5],
        ['Opera',     6.2],
        ['Others',   0.7]
    ];

    $(function () {
        $('#chart').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'Listings in cities'
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        }
                    }
                }
            },
            series: [{
                type: 'pie',
                name: 'Listings by city',
                data: groupedData
            }]
        });
    });

### 根据city对listings进行分组

有两种方法可以实现对JS对象的分组并得到city的数量：

#### groupBy

    _(listings)
    .groupBy("city")
    .map(
        function(value, key) {
            return [key, value.length];
        }
    )
    .value();

这里使用了chain方法，chain返回一个封装的对象. 在封装的对象上调用方法会返回封装的对象本身, 直道value方法调用为止。

#### countBy

    _(listings)
    .countBy(
        function(n) {
            return n['city'];
        }
    )
    .pairs()
    .value();

### 通过饼图展示分组结果

选择groupBy或者countBy任意一种方法，将其赋值给groupedData就可以得到最终效果了。

