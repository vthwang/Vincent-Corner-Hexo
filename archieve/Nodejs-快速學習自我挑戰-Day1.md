---
title: Nodejs 快速學習自我挑戰 Day1
thumbnail:
  - /blogs/images/learning/nodejs/nodejsday1.png
date: 2017-06-08 23:32:55
categories: 學習歷程
tags: Nodejs
---
<img src="/blogs/images/learning/nodejs/nodejsday1.png">

***
### 環境設定
#### 安裝
1. 安裝 [node](https://nodejs.org/en/)
#### 什麼是 Node
1. JavaScript 本來是用於瀏覽器的，現在可以用在 Server 端，node 是一套用 JavaScript Syntax 且可以用來建立程式、檔案系統，還可以直接跟資料庫溝通，甚至可以直接用 node 來建立伺服器。
2. Node 和 JavaScript 在瀏覽器裡執行都是使用同個引擎，叫做 JavaScript V8 runtime engine，這是一個開源軟體，將 JavaScript 的程式編譯成較快的機器語言，機器語言是低階語言，電腦可以直接執行不需經過轉譯，少了必須轉譯的動作，電腦只能執行特定程式碼，舉例來說，機器可以執行 JavaScript 程式碼、PHP 程式碼不需要轉譯成機器本來就知道的東西，因為 V8 引擎做得很好，Node 非常的快，使用 V8 引擎，我們可以將 JavaScript 程式碼編譯成較快速的機器語言，然後執行它，V8 引擎是用 C++ 寫的，所以如果想拓展 Node 語言，就要學用 C++。
3. Node 有檔案系統的功能，瀏覽器則控制什麼出現在視窗裡面。瀏覽器使用 `window` 呼叫指令，Node 用 `global`。
4. 瀏覽器使用 `document` 顯示 DOM，Node 使用 `process` 顯示進程。`process.exit(0);` 離開執行狀態(或用兩次 ctrl+C 也可以)。
#### 為什麼使用 Nodejs
1. Nodejs 使用事件驅動、非阻塞式 I/O 模型讓它非常輕量而且高效。I/O 是電腦非常常做的事情，當資料讀取或是寫入資料庫，就是 I/O，也稱為輸入和輸出，這是一個用來溝通物聯網和應用程式的東西，包含資料庫讀取或寫入 request，或是改變檔案系統裡的檔案，或者是傳送 http request 到伺服器，例如：Google API 取得用戶的位置。至於非阻塞式 (non-blocking) 是當有用戶從Google request URL，另外一個用戶可以讀取資料庫的資料而不需等待其他用戶的 request 完成。
2. Nodejs 套件的生態系系統 [npm](https://www.npmjs.com/) ，是世界上最大的開源資料庫生態系統。
### Note App
#### Using Require
1. Module 是單元功能，Require 是用來取用單元功能的 Node 函式。
2. [Modules](https://nodejs.org/api/)
3. 新增根目錄檔案 `app.js`
4. 先 console.log `console.log('Starting app.');`
5. 引入 filesystem `const fs = require('fs');`
6. 使用函式庫新增檔案 `fs.appendFile('greeting.txt', 'Hello world!');`
7. 引入 os `const os = require('os');`
8. 使用函式庫調出 user 資料 `var user = os.userInfo();`
9. ES5 輸出資料 `fs.appendFile('greeting.txt', 'Hello ' + user.username + '!');`
10. ES6 輸出資料 ```fs.appendFile('greeting.txt', `Hello ${user.username}!`);```













