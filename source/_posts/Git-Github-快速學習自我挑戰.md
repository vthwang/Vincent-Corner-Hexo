---
title: Git & Github 快速學習自我挑戰
thumbnail:
  - /images/learning/git/GitDay1.jpg
date: 2018-04-21 15:18:51
categories: 學習歷程
tags: 
    - Git
---
<img src="/images/learning/git/GitDay1.jpg">

***
### Git 環境設定
1. 設定 email 和 username
```
git config --global user.email "Email"
git config --global user.name "Name"
```
2. 檢視是否設定正確
`git config --list`
### Git 基礎操作
Git 操作流程
<img src="/images/learning/git/gitflow.png">
#### Git Init 安裝數據庫
1. 新增資料夾，用 cd 進入資料夾，使用 `git init` 開啟新的 git
2. 新增完成之後，出現 master，就是現在在 master 分支
#### 基礎指令
1. 加入索引 `git add .`
2. 檢查狀態 `git status`
3. 提交更新 `git commit -m '修改記錄'`
4. 查詢紀錄 `git log`
#### gitignore 忽略檔案
1. 新增 .gitignore 檔案
2. 直接加上你要忽略的檔案
3. *.html：忽略全部的 html 檔案
4. forder/：忽略整個資料夾
#### 工作還原技巧
1. 取消索引
    - 全部檔案取消索引 `git reset HEAD`
    - 單一檔案取消索引 `git reset HEAD 檔案名稱`
2. 還原檔案
    - 恢復單一檔案到最新的 commit 狀態 `git checkout 檔案名稱`
    - 還原工作目錄與索引，會跟最後一次 commit 保持一樣 `git reset --hard`
#### 指令大全
1. 基礎設定
```
查詢版本
git version
查詢設定列表
git config --list
輸入姓名
git config --global user.name "你的名字"
輸入email
git config --global user.email "你的email"
```
2. 新增本地/遠端數據庫
```
在本地資料夾新增數據庫
git init
複製遠端數據庫
git clone 遠端數據庫網址
```
3. 增加/刪除檔案
```
增加檔案進入索引
git add 檔案名稱
增加全部檔案進入索引
git add .
查詢狀態
git status
顯示歷史紀錄
git log
將索引提交到數據庫
git commit -m '更新訊息'
```
4. 還原指令
```
還原工作目錄與索引，會跟最後一次 commit 保持一樣
git reset --hard
全部檔案取消索引
git reset HEAD
單一檔案取消索引
git reset HEAD 檔案名稱
恢復單一檔案到最新 commit 狀態
git checkout 檔案名稱
刪除最近一次 commit
git reset --hard "HEAD^" 
上面語法如果刪除錯了可以再用此語法還原
git reset --hard ORIG_HEAD 
刪除最近一次 commit，但保留異動內容
git reset --soft "HEAD^" 
commit 後發現有幾個檔案忘了加入進去，想要補內容進去時
git commit --amend
```
5. 分支
```
顯示所有本地分支
git branch
新增分支
git branch 分支名稱
切換分支
git checkout 分支名稱
合併指定分支到目前的分支
git merge 分支名稱
刪除分支
git branch -d 分支名稱
```
6. 遠端數據庫操作
```
複製遠端數據庫
git clone 遠端數據庫網址
查詢遠端數據庫
git remote
將本地分支推送到遠端分支
git push 遠端數據庫名稱 遠端分支名稱
將遠端分支拉下來與本地分支進行合併
git pull
```
7. 標籤
```
查詢標籤
git tag
查詢詳細標籤
git tag -n
刪除標籤
git tag -d 標籤名稱
新增輕量標籤
git tag 標籤名稱
新增標示標籤
git tag -am "備註內容" 標籤名稱
```
8. 暫存
```
暫時儲存當前目錄
git stash
瀏覽 stash 列表
git stash list 
還原暫存
git stash pop
清除最新暫存
git stash drop
清除全部暫存
git stash clear
```
### 分支
1. [好的分支範例](http://nvie.com/posts/a-successful-git-branching-model/)
#### HEAD 了解目前所在的位置
1. `git branch` 瀏覽目前分支
2. `git checkout` HEAD 前四碼
3. `git checkout master` 復原到 master 分支
#### 分支建立
1. `git branch '分支名稱'` 建立分支
2. `git checkout '分支名稱'` 切換分支
#### 合併分支
1. `git merge '分支名稱'` 合併分支
#### 標籤
1. 切換到標籤的 commit：`git checkout '標籤名稱'`
### 團隊協作
#### 遠端數據庫
1. `git remote` 查詢遠端數據庫
2. `git remote rename '原名稱' '修改名稱'` 修改遠端主機名稱
3. `git push origin(預設遠端主機名稱) master(分支名稱)` 推送分支
#### 下載遠端數據庫
1. `git pull` 把檔案下載下來
#### Github Pages
1. 進入 Repo 之後，選擇 Setting，選擇 Branch，然後發佈就可以看到網頁了
#### 小型團隊分支協作篇
1. git pull = git fetch + git merge
2. 如果怕 pull 下來導致數據庫太亂又擔心有衝突的時候，可以先使用 `git fetch origin(遠端數據庫) branch1(遠端分支)`，下完指令之後，會出現一個 FETCH_HEAD 的分支，可以等確定沒有問題之後再跟現有的分支合併
#### 學習資源
1. [連猴子都能懂得 Git 入門指南](https://backlog.com/git-tutorial/tw/)
2. [保哥 30 天 Git 教學](https://github.com/doggy8088/Learn-Git-in-30-days/blob/master/zh-tw/README.md)
3. [Git 官方繁體教學](https://git-scm.com/book/zh-tw/v1)












