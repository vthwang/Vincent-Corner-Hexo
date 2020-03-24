---
title: Nodejs 快速學習自我挑戰 Day2
thumbnail:
  - /images/learning/nodejs/nodejsday2.jpg
date: 2017-06-11 22:07:05
categories: Study Note
tags: Nodejs
---
<img src="/images/learning/nodejs/nodejsday2.jpg">

***
### Note App
#### 刪除 Note
1. 修改 removeNote function，先取得所有 notes，然後把跟標題不一樣的 title 取出來，然後存起來，所以選定的 title 就被刪除了
```
var removeNote = (title) => {
    var notes = fetchNotes();
    var filteredNotes = notes.filter((note) => note.title !== title);
    saveNotes(filteredNotes);
};
```
2. 在 removeNote function 傳回 true 或 false，如果長度不一樣為 true，代表資料刪除，反之亦然。
`return notes.length !== filteredNotes.length;`
3. 在 app.js 用 noteRemoved 這個變數取得剛剛傳回來的值，如果 true，就顯示「 Note was removed」，false 的話，顯示「 Note not found 」
```
else if (command === 'remove') {
    var noteRemoved = notes.removeNote(argv.title);
    var message = noteRemoved ? 'Note was removed' : 'Note not found';
    console.log(message);
}
```
#### 閱讀 Note
1. 修改 getNote function，先取得所有的 notes，然後把標題一樣的取出來，最後 return 陣列 0 (就是取出來的資料)
```
var getNote = (title) => {
    var notes = fetchNotes();
    var filteredNotes = notes.filter((note) => note.title === title);
    return filteredNotes[0];
};
```
2. 將傳來回的物件用 note 取得，如果存在，顯示資料
```
var note = notes.getNote(argv.title);
    if (note) {
        console.log('Note found');
        console.log('--');
        console.log(`Title: ${note.title}`);
        console.log(`Body: ${note.body}`);
    } else {
        console.log('Note not found');
    }
```
3. 為了簡化重複的部分，將重複的部分移到 notes.js，並用 function 包裝，還要記得把 logNote export 出去
```
var logNote = (note) => {
    console.log('--');
    console.log(`Title: ${note.title}`);
    console.log(`Body: ${note.body}`);
};

module.exports = {
    /* 其它 note function */
    logNote
};
```
4. 剛剛重複的部分，用 function 取代 `notes.logNote(note);`
#### Note.js 應用除錯
1. 使用 `node debug` 除錯，`n` 跳到下一個錯誤，`c` 直接跳到結果或是 `debugger` 處，`repl` 可以輸入指令看相關變數
#### list Notes
1. 直接 return 取得的所有資料
```
var getAll = () => {
    return fetchNotes();
};
```
2. 用 forEach 列出取得的所有 notes
```
else if (command === 'list') {
    var allNotes = notes.getAll();
    console.log(`Printing ${allNotes.length} note(s).`);
    allNotes.forEach((note) => notes.logNote(note));
}
```
#### 進階 Yargs
1. 用 yargs .command 來編寫 help 命令的內容
```
const titleOptions = {
    describe: 'Title of note',
        demand: true,
        alias: 't'
};

const bodyOptions = {
    describe: 'Body of note',
        demand: true,
        alias: 'b'
}

const argv = yargs
    .command('add', 'Add a new note', {
        title: titleOptions,
        body: bodyOptions
    })
    .command('list', 'List all notes')
    .command('read', 'Read a note', {
        title: titleOptions
    })
    .command('remove', 'Remove a note', {
        title: titleOptions
    })
    .help()
    .argv;
```
#### Arrow function
1. 如果只有一個變數，()可以省略，另外，`var square = x => x * x;` 等於
```
var square = (x) => {
    var result = x * x;
    return result;
};
```
2. 使用 Arrow function 的時候，argument 和 this.name 不能使用 (所以這邊的 sayHi 是讀不出來的)
```
var user = {
    name: 'Vincent',
    sayHi: () => {
        console.log(arguments);
        console.log(`Hi. I'm ${this.name}`);
    },
    sayHiAlt () {
        console.log(arguments);
        console.log(`Hi. I'm ${this.name}`);
    }
};

user.sayHiAlt(1, 2, 3);
```
### Weather App
#### Async
1. 下列的程式，會依照下列順序執行 `Starting app` => `Finishing up` => `Second setTimeout` => `Inside of callback`
```
console.log('Starting app');

setTimeout(() => {
    console.log('Inside of callback');
}, 2000);

setTimeout(() => {
    console.log('Second setTimeout');
}, 0);


console.log('Finishing up');
```
#### callback Function & APIs
1. Callback 範例，最後會輸出 `{ id: 31, name: 'Vikram' }`
```
var getUser = (id, callback) => {
    var user = {
        id: id,
        name: 'Vikram'
    };

    setTimeout(() => {
        callback(user);
    }, 3000);
};

getUser(31, (userObject) => {
    console.log(userObject);
});
```
2. [第三方 request 插件](https://www.npmjs.com/package/request)
3. 啟動 npm 專案 `npm init`
4. 安裝 request 套件 `npm install request@2.73.0 --save`
5. 在根目錄新增 app.js 開始專案
6. 先 require request 套件，然後從 google api 擷取 json 資訊
```
const request = require('request');

request ({
    url: 'https://maps.googleapis.com/maps/api/geocode/json?address=1301%20lombard%20street%20philadelphia',
    json: true
}, (error, response, body) => {
    console.log(body);
});
```