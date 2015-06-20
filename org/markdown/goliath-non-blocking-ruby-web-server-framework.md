 #+TITLE: Goliath - Non Blocking Ruby Web Server Framework

 #+KEYS: ruby,goliath

 #+DATE: <2015-06-20 Sat>

 #+AUTHOR: Jia Feng
 
 #+description: Goliath - Non Blocking Ruby Web Server Framework

Ruby世界有很多成熟的Web Server供开发者选择，这些App Server在功能上各具特色，都有各自适合的应用场景。但如果从并发方式的角度来分类的话，大体可以分为两类：一类是基于进程和线程的并发模式，典型的Web Server包括[Unicorn](https://rubygems.org/gems/unicorn), [Rainbows](https://rubygems.org/gems/rainbows)和[Puma](https://rubygems.org/gems/puma)等；另一类是基于Non-Blocking Event Loop的并发方式，代表Web Server有[Thin](https://rubygems.org/gems/thin)和[Goliath](https://rubygems.org/gems/goliath)。

## 进程和线程并发

这种类型的Ruby Web Server主要通过操作系统级别的并发方式实现Web请求的并行处理，对于进程并发的Web Server，每个请求由一个VM进程独立处理，如果Web Server支持在每个进程中动态创建多个线程来处理Web请求，就构成了线程并发类型的Web Server。对于进程线程类Web Server的并发能力的估算可以简化为： `Number of Processes * Number of Threads` 。

下面列出了此类Web Server的中比较流行的几个：

*  单进程：WeBrick
*  多进程单线程：Unicorn
*  多进程多线程：Rainbows，Puma

这类Web Server在并发较低，I/O操作较少的场景下是可以很好的满足要求的，但在I/O操作耗时较长的场景下往往难以支持较高的并发量。

## EventMachine

要提到Non-Blocking并发就不得不提到[EventMachine](https://github.com/eventmachine/eventmachine)，前面提到的Thin和Goliath都是基于它开发的。

简单来说，EventMachine是一个事件驱动的轻量级并发库，其事件驱动的本质上就是Reactor Pattern，其他语言中类似的实现包括JBoss Netty，Python Twisted以及Node.js。

下面是一个EventMachine异步HTTP请求的栗子

```ruby
require 'eventmachine'
require 'em-http'
 
EM.run {
  EM::HttpRequest.new('http://www.sitepoint.com/').get.callback {|http|
    puts http.response
  }
}
```

`EM::run` 的执行会初始化一个EventMachine Reactor，这个操作会持续阻塞当前线程，除非有 `EM::stop` 之类的命令被执行。在传入的Block中，可以使用基于EM的异步I/O库来完成业务逻辑。

这个例子中我们发起了一个Http请求并打印Response，与传统 `Httparty#get` 的方式不同， `EM::HttpRequest#get` 不会阻塞线程，系统资源可以继续被用于处理其他任务，当请求返回时 `callback` 方法传入的Block会被Event Loop回调，从而继续处理当前的业务逻辑。

## Goliath

Goliath就是基于上述的EventMachine实现的Non-Blocking Ruby Web Server Framework，Goliath官方提供的性能测试结果表示其性能与Node.js相当，可以达到3000 req/s的并发处理能力。

下面是一个使用Goliath实现的API服务

```ruby
require 'goliath'
 
class Hello < Goliath::API
  # default to JSON output, allow Yaml as secondary
  use Goliath::Rack::Render, ['json', 'yaml']
 
  def response(env)
    [200, {}, "Hello World"]
  end
end
```

Goliath除了直接作为API开发框架之外，还可以作为中间件与其他API框架（如Grape API）结合使用。

### Non-Callback异步执行

Goliath另外一个重要的亮点就是Non-Callback事件驱动，试想一个嵌套Http请求的业务场景，基于EM你会写出如下的代码：

```ruby
EM::HttpRequest.new('http://www.sitepoint.com/').get.callback {|http|
  # extract_next_url is a fake method, you get the idea
  url = extract_next_url(http.response)
 
  EM::HttpRequest.new(url).get.callback {|http2|
    puts http2.response
  }
}
```

虽然熟悉JS程序猿可能已经习惯了 `callback` 风格的代码，但在类似复杂的情况下， `callback` 的反直觉语法仍然会给代码可读性和可维护性带来问题

但如果你在使用Goliash开发，则不会再有这样的烦恼：

```ruby
http = EM::HttpRequest.new("http://www.sitepoint.com").get
# extract_next_url is a fake method, you get the idea
url = extract_next_url(http.response)
http2 = EM::HttpRequest.new(url).get
```

上面的代码片段实现了以同步的风格编写代码，但两个Http请求却是通过异步的方式执行的。What!?，要想了解这里发生了什么神奇的事情，还要从Ruby `Fiber` 说起。

### Fiber

Fiber是Ruby 1.9.3版本引入的协作式并发机制，引用一下官方说明

> Fibers are primitives for implementing light weight cooperative concurrency in Ruby. Basically they are a means of creating code blocks that can be paused and resumed, much like threads. The main difference is that they are never preempted and that the scheduling must be done by the programmer and not the VM.

简单来说， `Thread` 是系统级别的概念，其运行是VM通过抢占式的调度实现的，而 `Fiber` 是一种协程（coroutine）的概念，一个 `Fiber` 何时获得系统资源是由程序猿控制的。下面这个栗子可以帮助你回顾/了解一下 `Fiber` 是怎么工作的：

```ruby
fiber = Fiber.new do |first|
  second = Fiber.yield first + 2
end

puts fiber.resume 10
puts fiber.resume 14
puts fiber.resume 18
```

outputs

```sh
12
14
FiberError: dead fiber called
```

如果你已经了解了 `Fiber` 是如何工作的，我们可以来看看Goliath中是如何使用 `Fiber` 实现Non-Callback异步执行的

### EM-Synchrony

[EM-Synchrony](https://github.com/igrigorik/em-synchrony)是Goliath项目的一个重要组成部分。EM-Synchrony使用Fiber改造了EventMachine以及基于EventMachine实现的许多异步I/O库，使程序猿可以以同步的代码风格实现异步的功能。

每一个Goliath服务都只有一个线程，但每个用户request都是在一个独立的 `Fiber` 中处理的，我们可以看看之前的 `EM::HttpRequest` 究竟是如何实现的：

```ruby
# em-synchrony/lib/em-synchrony/em-http.rb
begin
  require "em-http-request"
rescue LoadError => error
  raise "Missing EM-Synchrony dependency: gem install em-http-request"
end

module EventMachine
  module HTTPMethods
     %w[get head post delete put patch options].each do |type|
       class_eval %[
         alias :a#{type} :#{type}
         def #{type}(options = {}, &blk)
           f = Fiber.current
           conn = setup_request(:#{type}, options, &blk)
           if conn.error.nil?
             conn.callback { f.resume(conn) }
             conn.errback  { f.resume(conn) }
             Fiber.yield
           else
             conn
           end
         end
      ]
    end
  end
end
```

ah~, Monkey Patch，在 `get` 方法新的实现中， `callback` 会 `resume` 相应的 `Fiber` ，从而使得处理该用户请求的 `Fiber` 重新获得系统资源，并在之前调用 `get` 方法的地方继续执行。这样对程序猿来说就只需要以同步的方式编写业务代码即可。

