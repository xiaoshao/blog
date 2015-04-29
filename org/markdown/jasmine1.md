
 #+TITLE: jasmine带你飞(1)-----JS BDD框架入门

 #+KEYS: test,javascript,BDD

 #+AUTHOR: Qi Lei
##introduction jasmine.js##

Jasmine is a behavior-driven development framework for testing JavaScript code. It does not depend on any other JavaScript frameworks. It does not require a DOM. And it has a clean, obvious syntax so that you can easily write tests.

其他Javascript的测试框架也有很多，e.g：Jasmine，Qunit，JsTestDriver，JSUnit，Mocha等。Jasmine是一套Javascript行为驱动开发框架（BDD），干净简洁，表达力强且易于组织，不依赖于其他任何框架和DOM，可运行于Node.js，浏览器端或移动端。
##configure environment##
To install Jasmine on your local box:

Clone Jasmine -

```
git clone https://github.com/jasmine/jasmine.git

```

Create a Jasmine directory in your project -

``` 
mkdir my-project/jasmine
```

Move latest dist to your project directory - 

```
mv jasmine/dist/jasmine standalone-2.0.0.zip my-project/jasmine
```

Change directory - 
```
cd my-project/jasmine
Unzip the dist - unzip jasmine-standalone-2.0.0.zip
```

Add the following to your HTML file:

```
\<link rel="shortcut icon" type="image/png" href="jasmine/lib/jasmine-2.0.0/jasmine_favicon.png">
\<link rel="stylesheet" type="text/css" href="jasmine/lib/jasmine-2.0.0/jasmine.css">
\<script type="text/javascript" src="jasmine/lib/jasmine-2.0.0/jasmine.js"></script>
\<script type="text/javascript" src="jasmine/lib/jasmine-2.0.0/jasmine-html.js"></script>
\<script type="text/javascript" src="jasmine/lib/jasmine-2.0.0/boot.js"></script>
```
spec 和 src 和 SpecRunner.html 是 Jasmine 的一个完整示例，用浏览器打开 SpecRunner.html，即可看到执行的结果。
##basic conception
###describe
A test suite begins with a call to the global Jasmine function describe with two parameters: a string and a function. The string is a name or title for a spec suite – usually what is being tested. The function is a block of code that implements the suite.

describe 是 Jasmine 的全局函数，作为一个 Test Suite 的开始，它通常有 2 个参数：字符串和方法。它相当于一个测试集，比如我们要测试登录所有场景，那么不同场景都会用specs去描述，decibe，则包含了所有的场景，字符串作为特定 Suite 的名字和标题。方法是包含实现 Suite 的代码。 
###Specs
Specs 通过调用 it 的全局函数来定义。和 describe 类似，it 也是有 2 个参数，字符串和方法。每个 Spec 包含一个或多个 expectations 来测试需要测试代码。

Specs are defined by calling the global Jasmine function it, which, like describe takes a string and a function. The string is the title of the spec and the function is the spec, or test. A spec contains one or more expectations that test the state of the code. An expectation in Jasmine is an assertion that is either true or false. A spec with all true expectations is a passing spec. A spec with one or more false expectations is a failing spec.
###Expectations
Expectations 是由方法 expect 来定义，一个值代表实际值。另外的匹配的方法，代表期望值。
Expectations are built with the function expect which takes a value, called the actual. It is chained with a Matcher function, which takes the expected value.

```
describe("A suite is just a function", function() {
  var a;

  it("and so is a spec", function() {
    a = true;

    expect(a).toBe(true);
  });
});
```
###Matcher
什么是matcher？匹配器，相当于junit中的assertthat等,在Jasmine中，每个Matcher实现一个“expect”和“actrual”的布尔判断，Jasmine会根据Matcher判断expectation是true or false ，然后决定spec是success通过还是failed。所有Matcher可以通过not 执行否定判断。
####toBe
toBe检查两个比较对象是否是同一对象，而不仅仅检查它们是否相同。

```
it("toBe matcher compare ", function() {
var a = 6;
var b = a;
expect(a).toBe(b);
expect(a).not.toBe(null);
});
```
###toEqual
toEqual判断两个对象是否相等，可以对比简单的值类型的变量和对象.

```
describe("toEqual matcher two object equal", function() {
it("matcher value", function() {
    var a = 6;
    expect(a).toEqual(7);
});
it("matcher object", function() {
    var foo = {
        a: 10,
        b: 20
    };
    var bar = {
        a: 10,
        b: 20
    };
    expect(foo).toEqual(bar);
});
});
```
###toMatch
toMatch检查对象是否匹配正则表达式

```
it("toMatch regular", function() {
var message = "qilei test";
expect(message).toMatch(/test/);
expect(message).toMatch("qilei");
expect(message).not.toMatch(/qa/);
});
```
###toBeDefined and toBeUndefined

toBeDefined检查定义和未定义的匹配器

```
it("toBeDefined is undefined", function() {
var a = {
    test: "test"
};
expect(a.test).toBeDefined();
expect(a.qilei).not.toBeDefined();
expect(a.qilei).toBeUnDefined();
});
```
###toBeNull
toBeNull 它检查一个对象是否为空。

```
it("toBeNull is null", function() {
var a = null;
var test = "test";
expect(null).toBeNull();
expect(a).toBeNull();
expect(test).not.toBeNull();
});
```
###toBeTruthy and toBeFalsy
判断对象是ture or false

```
it("toBeTruthy and toBeFalsy", function() {
var test, test1 = "qilei";
expect(test1).toBeTruthy();
expect(test).not.toBeTruthy();
expect(test).toBeFalsy();
});
```
###toContain

判断一个数组是否包含某个元素值：

```
it("toContain", function() {
var test = ["qi", "lei", "test"];
expect(a).toContain("test");
expect(a).not.toContain("is");
});

```
###toBeLessThan and toBeGreaterThan
检查对象是否大于或小于另一个

```
it("toBeLessThan and toBeGreaterThan", function() {
var num = 27,
    num1 =32 ;
expect(num).toBeLessThan(num1);
expect(num).not.toBeLessThan(num1);
expect(num).toBeGreaterThan(num1);
});

```
###toBeCloseTo
检查一个数字是否接近另一个数字，只需要给定一个小数精确程度作为第二个参数。

```
it("toBeCloseTo示例", function() {
var pi = 3.1415926,
    e = 2.78;
expect(pi).not.toBeCloseTo(e, 2);
expect(pi).toBeCloseTo(e, 0);
});
```
###toThrow
判断一个函数是否有抛出异常：

```
it("toThrow", function() {
var foo = function() {
    return 1 + 2;
};
var bar = function() {
    return a + 1; //a不存在
};
expect(foo).not.toThrow();
expect(bar).toThrow();
});
```
###自定义matcher
如果你想自定义一个matcher来运行你的测试的话，你必须使用beforeEach。

我假设你想添加一个叫做toBeSameName的匹配器，作用是检查一个对象是否是同名。在每个文件的顶部（或者在一个describe的顶部），你应该添加如下代码

```
  beforeEach(function() {
      this.toBeSameName({
          toBeSameName: function() {
              this.name_message = function() {
     return "Expected " + this.actual + " to be same";
               };
              return this.actual.equal("qilei");
          }
        }); 
   });   
```


匹配器将接收两个参数

确保this.actual是到基准的距离。message函数计算了上下边界的值，匹配器的结果是一个简单地边界检查。

```
 beforeEach(function() {
      this.addMatchers({
          toBeWithinOf: function(distance, base) {
              this.message = function() {
                  var lower = base - distance;
                  var upper = base + distance;
                  return "Expected " + this.actual + " to be between " +
                  lower + " and " + upper + " (inclusive)";
     };
              return Math.abs(this.actual - base) <= distance;
              }
       });
   });
```
Enter text in [Markdown](http://daringfireball.net/projects/markdown/). Use the toolbar above, or click the **?** button for formatting help.
