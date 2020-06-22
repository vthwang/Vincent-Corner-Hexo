---
title: Nodejs II 快速學習自我挑戰 Day1
thumbnail:
  - /images/learning/nodejsII/NodejsIIDay01.png
date: 2017-11-02 16:36:32
categories: Study Note
tags: Nodejs
toc: true
---
<img src="/images/learning/nodejsII/NodejsIIDay01.png">

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
### VidJot Project
#### 介紹
1. [VidJot](http://www.vidjot.tech/)
#### 安裝和啟動 Express
1. [Express 官方網站](http://expressjs.com/)
2. 設定 npm 預設值
    - `npm set init-author-name="Vincent Adler"`
    - `npm set init-license="MIT"`
3. 開新專案 `npm init`
    - `description: App to create video ideas`
    - `entry point: (index.js) app.js`
4. 安裝 express `npm install express --save`
5. 在根目錄新增 app.js
```
const express = require('express');

const app = express();

const port = 5000;

app.listen(port, () => {
    console.log(`Server started on Port ${port}`);
});
```
#### 基礎路由和 Nodemon
1. 在 app.js 新增路由
```
// Index Route
app.get('/', (req, res) => {
    res.send('INDEX');
});

// About Route
app.get('/about', (req, res) => {
    res.send('ABOUT')
});
```
2. 安裝 nodemon `npm install -g nodemon`
3. 檢查 npm 套件安裝位置 `npm root -g`
4. 使用 nodemon `nodemon`
#### Express Middleware
1. [Middleware 簡介](http://expressjs.com/en/guide/using-middleware.html)
2. 在 app.js 新增 middleware
```
app.use(function(req, res, next) {
    console.log(Date.now());
    next();
});
```
3. 在 middleware 放入 req.name 可以在 app.get 取得
```
app.use(function(req, res, next) {
    req.name = 'Vincent Adler';
    next();
});
```
```
app.get('/', (req, res) => {
    res.send(req.name);
});
```
#### 使用模板
1. [handlebars.js 官方網站](http://handlebarsjs.com/)
2. [在 express 使用 handlebars](https://github.com/ericf/express-handlebars)
3. [EJS](https://github.com/mde/ejs)
4. 安裝 express-handlebars `npm install express-handlebars --save`
5. 引入 express-handlebars
`const exphbs  = require('express-handlebars');`
6. 新增 handlebars middleware
```
app.engine('handlebars', exphbs({
    defaultLayout: 'main'
}));
app.set('view engine', 'handlebars');
```
7. 新增 views/index.handlebars `<h1>Welcome</h1>`
8. 新增 views/layouts/main.handlebars，`{% raw %}{{{body}}}{% endraw %}` 會讀出被 render 的 view
```
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>VidJot</title>
</head>
<body>
    {{{body}}}
</body>
</html>
```
9. 把 app.js route 的 send 都改成 render
```
app.get('/', (req, res) => {
    res.render('index');
});

app.get('/about', (req, res) => {
    res.render('about')
});
```
10. 新增 views/about.handlebars `<h1>About</h1>`
11. 讓讀取的資料變成動態
```
app.get('/', (req, res) => {
    const title = 'Welcome';
    res.render('index', {
        title: title
    });
});
```
12. 修改 views/index.handlebars `<h1>{{"{{title"}}}}</h1>`
#### Bootstrap 和 Partials
1. [取得 Bootstrap 的 CDN](http://getbootstrap.com/docs/4.0/getting-started/introduction/)
2. 在 views/layouts/main.handlebars 引入 CDN
```
// CSS
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">

// JS
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
```
3. 在 views/layouts/main.handlebars，body 用 container 包住
```
<div class="container">
    {{{body}}}
</div>
```
4. 新增 views/partials/_navbar.handlebars
```
<nav class="navbar navbar-expand-sm navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="#">VidJot</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="/">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/about">About</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
```
5. 在 views/layouts/main.handlebars 引入 navbar partial `{{"{{> _navbar"}}}}`
6. 包裝一下 views/index.handlebars
```
<div class="jumbotron text-center">
    <h1 class="display-3">{{title}}</h1>
    <p class="lead">Jot down ideas for your next YouTube Videos</p>
    <a href="/ideas/add" class="btn btn-dark btn-lg">Add Video Idea</a>
</div>
```
7. 包裝一下 views/about.handlebars
```
<h1>About</h1>
<p>This is a Node/Express app for jotting down ideas for future Youtube videos</p>
<p>Version: 1.0.0</p>
```