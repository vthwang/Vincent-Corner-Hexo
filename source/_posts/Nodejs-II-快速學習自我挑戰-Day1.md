---
title: Nodejs II 快速學習自我挑戰 Day1
thumbnail:
  - /blogs/images/learning/nodejsII/NodejsIIDay01.png
date: 2017-11-02 16:36:32
categories: 學習歷程
tags: Nodejs
---
<img src="/blogs/images/learning/nodejsII/NodejsIIDay01.png">

***
### 課程簡介
1. 課程內容
    - 使用 Node/Express/Mongo 創建 Server Side Application
    - 很多 node modules/packages
    - 從手稿到專案部署
    - 2 個有一步步解說的深度專案
2. 課程內容沒有的
    - 沒有 Nodejs 簡介
    - 沒有簡單的 todo List 或 REST API
    - 不會只告訴你讓你自己線上部署你自己的應用
3. 課程的先備知識
    - HTML/CSS/JavaScript
    - 基礎的 Node.js/Express 知識
    - 如果沒有 Node/Express/MongoDB 的知識，我會解說
4. 課程可以學到的東西
    - 如何從無到有包含部署製作一個 server-side 應用
    - 都是關於 Express 框架
    - 在本地工作和遠端 MongoDB 部署
    - 處理本地和 Google OAuth 認證
    - 在 Server 處理畫面和編排
    - ES6 JavaScript 觀念
5. 專案一：VidJot - 可以讓創作者註冊且寫下他們對下一個影片的想法
    - 使用 Express、Mongoose、Passport、Bcrypt、Express-Session、Handlebars.js、Bootstrap 4 beta
6. 專案二：StoryBooks - 社交網路，用來創建公開和私有的故事，使用者可以使用 Google OAuth 選擇允許或關閉留言
    - 使用 Express、Mongoose、Passport、Google OAuth、Private/Public Stories、Helper Functions、Moment.js、Materialize CSS
### 環境設定
#### 開發環境設定
1. VS code 設定檔案
```
{
  "editor.fontSize": 26,
  "terminal.integrated.fontSize": 26,
  "terminal.integrated.shell.windows": "C:\\Program Files\\Git\\bin\\bash.exe"
  "editor.wordWrap": "on"
  "editor.tabSize": 2,
}
```
#### 什麼是 Node.js
1. 什麼是 Node.js?
    - JavaScript runtime 使用 V8 JavaScript Engine，正是 Google 瀏覽器所使用的 Engine
    - V8 Engine 用 C++ 寫的，用來幫助 JavaScript 編譯到非常快的機器
    - 允許我們在 Server 上面運行 JS (像是 PHP、Rails、Java...等等)
    - 跨平台執行 (Windows、Linux、MacOS)
    - 用來建立非常快速且可規模化的 Real-time Application，因為他有非同步式的特色
    - 使用事件驅動，非阻塞式 I/O model
2. 可以用 Node 做什麼？
    - 用 filesystem 操作檔案
    - 建立網頁伺服器，處理進來的 Http 請求和回傳回應，可以使用像是 express 的框架讓這件事情更簡單
    - 與資料庫連線 (MongoDB、MySQL、Postgres、Redis... 等等)
    - 強大的 APIs 和後端介面
    - 強大的 Server side apps 且可以讀取 views
3. Blocking Model vs. Non-Blocking
    - Blocking 要等事件完成才進行下一件事情，Non-Blocking 在事情完成前，先繼續做其它事情，等到事情完成會有 callback，然後回去執行 callback 的動作
#### 安裝和探索 Node.js
1. chrome 可以使用的語法
    - `document`
2. Node server 可以用的語法
    - `global`
    - `process.env.USER`
#### 安裝本地 MongoDB
1. [下載 MongoDB](https://www.mongodb.com/download-center?jmp=nav#community)
2. 安裝在 C 槽，在 mongodb 根目錄新增 data 的資料夾，在 data 的資料夾再新增 db 的資料夾。在 mongodb 根目錄新增 log，在 log 的資料夾新增檔案 `mongo.log`
3. 用系統管理員打開 cmd，跳到 mongodb bin 目錄，`cd c:/mongodb/bin`
4. `mongod --directoryperdb --dbpath C:\mongodb\data\db --logpath C:\mongodb\log\mongo.log --logappend --rest --install`
5. `net start MongoDB`
6. `mongo`
7. `show databases`
#### 註冊 mlab
1. [mLab](https://mlab.com/)
#### 註冊 Heroku
1. [Heroku](https://www.heroku.com/)















