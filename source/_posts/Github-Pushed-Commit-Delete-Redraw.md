---
title: Github Pushed Commit Delete (Redraw)
thumbnail:
  - /images/github.jpg
date: 2016-11-17 14:47:14
categories: Skill Share
tags:
---
<img src="/images/github.jpg">

***
#### 如果 Commit 之後並 Push 到遠端，想要在本地端用 CI 去 Delete/Redraw，就可以用以下方法。
1. 如果要刪除倒數第一個 Commit，用以下方法。
```
git reset --hard HEAD^
git push -f
```
2. 如果要刪除倒數二個 Commit，用以下方法。
```
git reset --hard HEAD^^
git push -f
```
