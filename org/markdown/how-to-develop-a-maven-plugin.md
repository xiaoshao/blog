 #+TITLE: How to develop a maven plugin
 
 #+AUTHOR: zw shao

 #+description: How to develop a maven plugin and how to use it.
---

 #初始化一个Maven plugin project
 ---

 	```
 	mvn archetype:generate \
  		-DgroupId=sample.plugin \
  		-DartifactId=hello-maven-plugin \
  		-DarchetypeGroupId=org.apache.maven.archetypes \
  		-DarchetypeArtifactId=maven-archetype-plugin
 	```
 ###生成的maven plugin的目录结构如下
 ---

 	```
 	└── hello-maven-plugin
    ├── pom.xml
    └── src
        ├── it
        │   ├── settings.xml
        │   └── simple-it
        │       ├── pom.xml
        │       └── verify.groovy
        └── main
            └── java
                └── sample
                    └── plugin
                        └── MyMojo.java
 	```
 其中pom.xml是整个plugin的配置文件，你可以在pom.xml的头部可以看到如下信息

 	
 	```
 		<groupId>sample.plugin</groupId>
  		<artifactId>hello-maven-plugin</artifactId>
  		<version>1.0-SNAPSHOT</version>
  		<packaging>maven-plugin</packaging>

  		<name>hello-maven-plugin Maven Plugin</name>
 	```

 MyMojo.java 继承了AbstractMojo类，在其头部可以看到如下信息
 @Mojo( name = "touch", defaultPhase = LifecyclePhase.PROCESS_SOURCES )，
 而且MyMojo.java中实现了AbstractMojo的execute的抽象方法。

##一个简单的Hello world mvn plugin插件
---
 
 注释了MyMojo.java中的execute中的代码，然后在其中添加如下代码`getLog().info("Hello world");`,

###release maven plugin到本地repo
---

在root directory（hello-maven-plugin）下运行如下命令
```
mvn install
```
上面命令将会发布你的plugin到local repo（~/.m2）下。

##使用hello world mvn plugin
---

###创建一个新的project，然后使用maven管理dependency。

###在新的project的pom.xml中plugins下添加下面内容

```
	<plugin>
        <groupId>sample.plugin</groupId>
  		<artifactId>hello-maven-plugin</artifactId>
  		<version>1.0-SNAPSHOT</version>
    </plugin>
```

###下载新的project dependency并且运行mvn plugin

```
mvn dependency:resolve

mvn sample.plugin:hello-maven-plugin:touch
```
运行之后你将会看到 hello world。

### 最后你可以发布你的plugin到remote repo `mvn deploy`.





 	

