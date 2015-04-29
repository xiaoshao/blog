 #+TITLE: Linux&Unix Command(1) Chmod

 #+KEYS: Linux Command

 #+DATE: <2015-04-20 Mon>

 #+AUTHOR: Cao Xiaoqi

Chmod 用来在Linux或者类Unix操作系统上修改文件或者目录的权限。

### Chmod 命令


使用权限：所有用户

使用方式：

```
	chmod [OPTION]... MODE[,MODE]... FILE...
```

说明：Linux/Unix 的档案权限分为三个等级：档案拥有者、群组和其他。


### Chmod 参数说明

* **-c :** [Linux/Unix] 输出被改变的文件信息
* **-f :** [All] 执行修改，如果发生错误，仍然继续修改。
* **-h :** [MAC] 执行修改时，如果修改的是Link文件，只修改Link文件，不修改Link所指文件。
* **-R :** [All] 对当前目录的所有目录和文件及其子目录及文件，即以递归方式修改。
* **-v :** [All] 输出所有修改的文件的信息。

### Mode 说明

Mode 适用于组合较为复杂的修改模式。其语法规范如下：

```
	mode	::= clause [, clause ...]
	clause 	::= [who ...] [action ...] action
	action	::= op [perm ...]
	who		::= a | u | g | o
	op		::= + | - | =
	perm	::= r | s | t | w | x | X | u | g | o
```


#### who

* **a :** All, 即所有用户。

```
	chmod a=rwx test.log
	//修改test.log文件对所有用户的权限。
```

* **u :** user, 即当前用户。

```
	chmod u=rwx test.log
	//修改test.log文件对当前用户的权限。
```

* **g :** group, 即当前组。

```
	chmod g=rwx test.log
	//修改test.log文件对当前group的权限。
```

* **o :** other, 即其他用户。

```
	chmod o=rwx test.log
	//修改test.log文件对其他用户的权限。
```

#### op

* **+ :** 增加权限

```
	chmod u+wx test.log
	//增加test.log文件对当前用户的权限。
```

* **- :** 取消权限

```
	chmod u-wx test.log
	//取消test.log文件对当前用户的权限。
```

* **= :** 设置权限

```
	chmod u=rwx test.log
	//设置test.log文件对当前用户的权限。
```

#### perm

* **r :** read, 读取权限， 数字值为：4

```
	chmod u=r test.log
	chmod 400 test.log
	//设置test.log文件对当前用户为只读权限。
```

* **w :** write, 写入权限， 数字值为：2

```
	chmod u=w test.log
	chmod 200 test.log
	//设置test.log文件对当前用户为只写权限。
```

* **x :** execute, 可执行权限， 数字值为：1

```
	chmod u=x test.log
	chmod 100 test.log
	//设置test.log文件对当前用户为只可执行权限。
```

* **u :** user, 使用User的权限赋值。

```
	chmod g=u test.log
	//设置test.log文件对当前group的权限为当前user的权限。
```

* **g :** group, 使用Group的权限赋值。

```
	chmod u=g test.log
	//设置test.log文件对当前user的权限为当前group的权限。
```

* **o :** other, 使用Other的权限赋值。

```
	chmod u=o test.log
	//设置test.log文件对当前user的权限为当前other的权限。
```

### 例子

* 为所有用户分配读权限

```
	chmod a=r file
	chmod u=r,g=r,o=r file
	chmod 444 file
```

* 为当前User增加执行权限

```
	chmod u+x file
```

* 为User分配读写执行权限，其他为只读权限。

```
	chmod u=rwx,go=r file
	chmod 744 file
```