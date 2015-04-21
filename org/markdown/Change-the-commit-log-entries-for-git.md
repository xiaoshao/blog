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
git rebase -i HEAD~3

pick 862044d This is the inital commit for blog. Zengwei Shao
pick b46c203 Second commit. Zengwei Shao
pick 009992e Change my blog

# Rebase 96f1ffd..009992e onto 96f1ffd
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

我们可以看到有六个commands，分别是， pick, reword, edit, squash, fixup, exec;

pick 就是不做任何更改，继续使用这个提交
reword 修改提交的comment
edit 



