 #+TITLE: HTML5 Geolocation API in China

 #+KEYS: html5,geolocation

 #+DATE: <2015-05-06 Wed>

 #+AUTHOR: Jia Feng
 
 #+description: HTML5 Geolocation API允许用户在Web应用中共享他们的位置，使其能够享受LBS应用所带来的独特魅力。HTML5 Geolocation API的使用方法相当简单（仅限地球...）。请求共享位置信息，如果用户同意，浏览器就会返回位置信息（主要是十进制的经纬度），该位置信息是通过支持HTML5地理定位功能的底层设备（如笔记本、手机）提供给浏览器的。

## 信息来源

底层设备通常可以通过哪些数据源来获取位置信息呢？

*  IP地址
*  坐标定位
    *  GPS
    *  基站辅助定位
    
IP地址定位随处可以使用，但定位不精确，甚至可能出现非常离谱的定位结果；GPS定位非常精确，但需要额外的硬件设备，耗时长，而且室内效果很差；基站辅助定位精度较为精确，定位快速且可以在室内使用。

## 如何使用HTML5 Geolocation API

HTML5 Geolocation API是通过 `navigator.geolocation` 对象暴露给Web应用的，用户使用时可以有两种方式：单次定位请求，周期定位请求。

### 单次定位

```js
navigator.geolocation.getCurrentPosition(successCallback, errorCallback, options);
```

如果浏览器获取位置信息成功，则会调用 `successCallback` 并传入 `Position` 对象

```js
//Position object

{
    timestamp: "位置信息的获取时间",
    coords: {
        latitude: "维度（十进制）",
        longitude: "精度（十进制）",
        accuracy: "准确度（以m为单位，置信度95%）",
        altitude: "海拔（以m为单位）",
        altitudeAccuracy: "海拔准确度（以m为单位，置信度95%）",
        heading: "行进方向（相对于正北）",
        speed: "速度（m/s）"
    } 
}
```

关于定位请求选项 `options` ，可以以 `map` 的形式传入如下参数的组合

*  enableHighAccuracy，高精度模式，true/false(default);
*  timeout，设置定位超时时间，ms;
*  maximumAge，设置浏览器重新定位的时间间隔，ms;

### 周期定位

如果用户希望随时获得浏览器定位信息的更新，则可以使用周期定位接口，接口的使用方法与单次定位完全一致。

```js
navigator.geolocation.watchPosition(successCallback, errorCallback, options);
```

唯一不同的一点是，该接口提供了取消定位通知的功能

```js
var watchId = navigator.geolocation.watchPosition(successCallback, errorCallback, options);

navigator.geolocation.clearWatch(watchId);
```

## 地球坐标，火星坐标，XX坐标

好简单啊，是么？！

不过在天朝，使用HTML5 Geolocation API就没那么简单了，如果你尝试着将自己当前位置的经纬度绘制在百度地图上，你会发现自己可能正在某个楼顶，马路中间，甚至是湖中间...发生了什么。

这里不得不从地球坐标和火星坐标说起，用户通过HTML5 Geolocation获取的经纬度信息是国际通用的WGS84坐标系统，俗称为地球坐标。而我国国测局出于安全的目的，要求境内所有地图和位置信息数据必须通过加密算法进行非线性偏移，这就是GCJ-02坐标体系，也就是大家常说的火星坐标。再进一步，国内一些地图服务提供商出于响应国家政策以及自身商业目的原因，又在此基础上进行了二次加密，如百度的BD-09坐标系统等。

### 坐标系列表

国内各大LBS都在用什么坐标系统呢

API            坐标系
----------------------
百度地图        百度坐标
腾讯搜搜地图     火星坐标
搜狗地图        搜狗坐标
阿里云地图      火星坐标
图吧MapBar地图  图吧坐标
高德MapABC地图  火星坐标


### 坐标转换

网上有大量关于在各个坐标系之间进行转换的文章甚至代码，这里就不再重复了。但如果你恰好在使用百度地图的服务，建议直接使用[百度坐标转换API](http://developer.baidu.com/map/index.php?title=webapi/guide/changeposition)来将各种坐标系数据转换为百度坐标。