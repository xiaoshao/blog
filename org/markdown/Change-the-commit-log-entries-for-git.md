 #+TITLE: Change the log entries before push to repo

 #+KEYS: git

 #+DATE: <2015-04-21>

 #+AUTHOR: ZW Shao

 #+description: 我们经常会因为某些原因想在提交代码之前或者提交代码之后，更改某些提交的记录使整个提交记录看起来更加合理。

 ##首先我们查看一下提交的日志信息。
 ```
 git log
```
 现在我觉得我的文件名不是很合适，我想将他修改为‘Change-the-log-entries-for-git.md’,可是我不想让别人看到我有这样的低级错误。这时候我们就需要修改一下我们commit的记录。



