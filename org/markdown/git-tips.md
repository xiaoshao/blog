 #+TITLE: Git Tips
 
 #+AUTHOR: Heaton

 #+description: To help you use git easier

# Git Tips

## 如何让Git命令变短 - Alias

```sh
git config --global alias.[name] "command"
```

#### Examples

```sh
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.cob "checkout -b"
git config --global alias.back "checkout master"
git config --global alias.cof "checkout --"
git config --global alias.pl "pull --rebase origin master"
git config --global alias.plf "!git stash && git pl && git stash pop" # 在本地有未提交修改的时候用
git config --global alias.lo "log --graph --oneline"
git config --global alias.l "log --pretty=format:'%C(yellow)%h %C(red)%ad %C(green)%d %C(reset)%s [%C(blue)%an]' --date=short --graph"
```

## 命令行查看log的工具 - tig

![TIG](https://heaton.github.io/resources/images/tig.png)

#### install

```sh
brew install tig
```

## 从别的Branch上拿commit - cherry-pick

![cherry-pick](https://heaton.github.io/resources/images/cherry-pick.png)

```sh
git cherry-pick [CommitID]
git cherry-pick --no-commit [CommitID] # 把commit内容放到本地的cache里面
```

在 [GitStudy](https://github.com/heaton/gitstudy) 上已经有建好的branch可以尝试该命令

## 找回误删的commit - reflog

Git 不会真正删除commit，即使你输入命令 git reset --hard HEAD^ ，你可以用过Reflog找回

```sh
git reflog
git reset --hard [commitID]
```

## 找回误删的branch - reflog

我们同样可以通过 Reflog 来找回误删的branch

```sh
git log --walk-reflogs # 找到你删掉branch最后的一个commitID
git branch [branchName] [commitID]
```

## 有用的配置

```sh
git config --global --list  # 看有哪些全局配置
git config --global push.default simple  # 默认push到当前branch，这样你只要输入 git push origin 就可以了
git config --global pull.rebase true  # pull 默认使用rebase
git config --global branch.autosetuprebase always # 当你在branch上时，默认使用rebase而不是merge
```

## 修改本地的commits - rebase -i

`rebase -i` 可以修改commit顺序，修改commit的提交信息，压缩多个commit，删掉commit并把修改加入cache等等。

每次输入 `git rebase -i` 后都会有具体说明。

