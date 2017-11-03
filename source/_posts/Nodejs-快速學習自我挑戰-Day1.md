---
title: Nodejs 快速學習自我挑戰 Day1
thumbnail:
  - /images/learning/nodejs/nodejsday1.png
date: 2017-06-10 23:32:55
categories: 學習歷程
tags: Nodejs
---
<img src="/images/learning/nodejs/nodejsday1.png">

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
7. 如果使用函式庫新增檔案出現錯誤，有其他兩種解法
```
Option1
fs.appendFile('greeting.txt', 'Hello world!', function (err) {
   if (err) {
        console.log('Unable to write to file');
   }
});

Option2
fs.appendFileSync('greeting.txt', 'Hello world!');
```
7. 引入 os `const os = require('os');`
8. 使用函式庫調出 user 資料 `var user = os.userInfo();`
9. ES5 輸出資料 `fs.appendFile('greeting.txt', 'Hello ' + user.username + '!');`
10. ES6 輸出資料 
```
fs.appendFile('greeting.txt', `Hello ${user.username}!`);
```
#### Require 自己的檔案
1. 新增根目錄檔案 notes.js 加入一行 `console.log('Starting notes.js')`
2. 在 app.js require 檔案 `const notes = require('./notes.js');`
3. 在 notes.js 新增 addNote function
```
module.exports.addNote = () => {
    console.log('addNote');
    return 'New note';
};
```
4. 在 app.js 使用 function
```
var res = notes.addNote();
console.log(res);
```
5. 在 notes.js 新增 add function
```
module.exports.add = (a, b) => {
    return a + b;
};
```
6. 在 app.js 使用 function
`console.log('Result:', notes.add(9, -2));`
#### 使用第三方套件
1. 啟動 npm 專案 `npm init`
2. 安裝 lodash ` npm install lodash --save`
3. Require module 到 app.js `const _ = requrie('lodash');`
4. 使用 lodash function 去除陣列中一樣的內容
```
var filteredArray = _.uniq(['Vincent', 1, 'Vincent', 1, 2, 3, 4]);
console.log(filteredArray);
```
#### 使用 Nodemon 開始專案
1. 安裝 Nodemon `npm install nodemon -g`
2. 啟動 Nodemon 來監控專案 `nodemon app.js`
#### 從使用者取得 input
1. 在 app.js 新增 process.argv 監控 command
```
var command = process.argv[2];
console.log('Command:', command);
console.log(process.argv);
```
2. 在 app.js 新增 if else function 給不同的 command 不同 output
```
if (command === 'add') {
    console.log('Adding new note');
} else if (command === 'list') {
    console.log('Listing all notes');
} else if (command === 'read') {
    console.log('Reading note');
} else if (command === 'remove') {
    console.log('Removing note');
} else {
    console.log('Command not recognized');
}
```
3. 檢查 command `node app.js remove`
### 使用 Yargs 簡化 input
1. 安裝 Yargs `npm install yargs@4.7.1 --save`
2. Require Yargs `const yargs = require('yargs');`
3. 修改 app.js 的 if function
```
if (command === 'add') {
    notes.addNote(argv.title, argv.body);
} else if (command === 'list') {
    notes.getAll();
} else if (command === 'read') {
    notes.getNote(argv.title);
} else if (command === 'remove') {
    notes.removeNote(argv.title);
} else {
    console.log('Command not recognized');
}
```
4. 在 notes.js 新增 addNote, getAll, getNote, removeNote function
```
var addNote = (title, body) => {
    console.log('Adding note', title, body);
};

var getAll = () => {
    console.log('Getting all notes');
};

var getNote = (title) => {
    console.log('Getting note', title);
};

var removeNote = (title) => {
    console.log('Removing note', title);
};
```
5. 在 notes.js 輸出 function (ES6)
```
module.exports = {
    addNote,
    getAll,
    getNote,
    removeNote
};
```
#### 使用 JSON
1. 先引入 fileSystem，然後用 originalNote 新增 JSON 物件，新增一個變數 originalNoteString 用 stringify 將 originalNote 轉為 String，然後再新增一個變數 note 將 originalNoteString parse 回 JSON 物件。
```
const fs = require('fs');

var originalNote = {
    title: 'Some title',
    body: 'Some body'
};
var originalNoteString = JSON.stringify(originalNote);
fs.writeFileSync('notes.json', originalNoteString);

var noteString = fs.readFileSync('notes.json');
var note = JSON.parse(originalNoteString);
console.log(typeof note);
console.log(note.title);
```
#### 新增和儲存 Note
1. 首先在 addNote 傳入 title 和 body 兩個變數，然後用 notes.push 把得到的兩個變數傳進去 notes 陣列裡面，最後用 String 的方式寫入 notes-data.json。過程中，為了避免資料重複，用 notesString 取得檔案內的所有 note，然後用 notes.filter 檢查 title 是不是一樣，最後，如果不一樣，再將檔案寫入 notes-data.json。
```
var addNote = (title, body) => {
    var notes = [];
    var note = {
        title,
        body
    };

    try {
        var notesString = fs.readFileSync('notes-data.json');
        notes = JSON.parse(notesString);
    } catch (e) {

    }

    var duplicateNotes = notes.filter((note) => note.title === title);

    if (duplicateNotes.length === 0) {
        notes.push(note);
        fs.writeFileSync('notes-data.json', JSON.stringify(notes));
    }
};
```
#### 重複使用 function
1. 將本來在 addNote 的 fucntion 移出來
```
var fetchNotes = () => {
    try {
        var notesString = fs.readFileSync('notes-data.json');
        return JSON.parse(notesString);
    } catch (e) {
        return [];
    }
};

var saveNotes = (notes) => {
    fs.writeFileSync('notes-data.json', JSON.stringify(notes));
};
```
2. addNote function 移出來的 function 用 fetchNotes 和 saveNotes 取代
```
var addNote = (title, body) => {
    var notes = fetchNotes();
    var note = {
        title,
        body
    };
    var duplicateNotes = notes.filter((note) => note.title === title);

    if (duplicateNotes.length === 0) {
        notes.push(note);
        saveNotes(notes);
        return note;
    }
};
```
3. 將從 notes.js return 出來的 note 用 if else function 來顯示是否完成新增 notes 的動作
```
if (command === 'add') {
    var note = notes.addNote(argv.title, argv.body);
    if (note) {
        console.log('Note created');
        console.log('--');
        console.log(`Title: ${note.title}`);
        console.log(`Body: ${note.body}`);
    } else {
        console.log('Note title taken');
    }
}
```