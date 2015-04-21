 #+TITLE: Change the log entries before push to repo

 #+KEYS: git

 #+DATE: <2015-04-21>

 #+AUTHOR: ZW Shao

 #+description: 我们经常会因为某些原因想在提交代码之前或者提交代码之后，更改某些提交的记录使整个提交日志看起来更加合理。

 ##首先我们查看一下提交的日志信息。
 ```
 git log

commit 009992ecf1b471d51a0b71f97169b8eca777eb1e
Author: Shao Zengwei <zengwei19861029@163.com>
Date:   Tue Apr 21 14:42:43 2015 +0800

    Change my blog

commit b46c20329b4a63af603e017e341adeaaafce3b96
Author: Shao Zengwei <zengwei19861029@163.com>
Date:   Tue Apr 21 14:42:18 2015 +0800

    Second commit. Zengwei Shao

commit 862044dd9988e60057a21429cb9b4d8fc3a588be
Author: Shao Zengwei <zengwei19861029@163.com>
Date:   Tue Apr 21 11:39:36 2015 +0800

    This is the inital commit for blog. Zengwei Shao

    some changes
```
我们看到第三条里面有一个some changes 是不小心在提交的时候写错了，那么我们需要修改一个这个comment。

```
git rebase -i HEAD~4

pick 862044d This is the inital commit for blog. Zengwei Shao
pick b46c203 Second commit. Zengwei Shao
pick 69b838d Change my blog
pick e88a316 delete the useless files. Zengwei Shao

# Rebase 96f1ffd..e88a316 onto 96f1ffd
#
# Commands:
#  p, pick = use commit
#  r, reword = use commit, but edit the commit message
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#  f, fixup = like "squash", but discard this commit's log message
#  x, exec = run command (the rest of the line) using shell
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

我们看到上面有四次提交，第一次我创建了一个文件，第二次我再次创建了一个文件，第三次我修改了第一次创建的文件，第四次我认为第二次创建的文件没有什么作用，我删除掉了它。
如果我们把这样的记录push到repo，就会让人感觉到很奇怪，那么我们就需要对记录处理一下，然后再提交到repo。

1）更改提交的顺序

我们更改一下第三条记录和第四条记录的顺序。
```
pick 862044d This is the inital commit for blog. Zengwei Shao
pick b46c203 Second commit. Zengwei Shao
pick e88a316 delete the useless files. Zengwei Shao
pick 69b838d Change my blog
```
当我们保存的时候，git就会自动帮我们更改提交的顺序。不过也有意外的情况，就是两个提交之间有相互依赖的情况，例如上面第一题和第三次我们就不能交换他们的提交顺序。

2）合并两个提交
```
pick 862044d This is the inital commit for blog. Zengwei Shao
pick b46c203 Second commit. Zengwei Shao
s e88a316 delete the useless files. Zengwei Shao
pick 69b838d Change my blog
```
我们可以看到我把上面的pick改为s，那么我们会把第三条记录合并到第二条记录中，同时会提示我们更改comment。同时我们也可以把s改为f，这样我们就直接把第三条合并到第二条记录，不用修改comment，直接使用第二条记录的comment。

3）修改comment
```
git rebase -i HEAD~3
pick 862044d This is the inital commit for blog. Zengwei Shao
pick e25b7fa merged two commits. Zengwei Shao
pick 787b360 Change my blog

pick 862044d This is the inital commit for blog. Zengwei Shao
r 1476fff merged two commits. Zengwei Shao
pick 3b1d509 Change my blog
```
我们把第二条记录的pick改为r，当我们在保存的时候，就会提醒我们更改comment。

4) 对某个提交添加部分修改

```
git rebase -i HEAD~3
pick 862044d This is the inital commit for blog. Zengwei Shao
edit e25b7fa merged two commits. Zengwei Shao
pick 787b360 Change my blog
```
当我们保存之后会进入一个临时branch，然后我们可以进行某些修改，修改结束之后，我们可以添加我们的修改到第二个提交。
```
git add . -p
git commit --amend
git rebase --continue
```

git rebase 有六个commands，分别是， pick, reword, edit, squash, fixup, exec;在上面除了exec我们都使用过了，exec是在某一个记录之后执行一个shell脚本。
 



