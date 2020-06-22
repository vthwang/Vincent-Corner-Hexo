---
title: Nodejs 快速學習自我挑戰 Day6
thumbnail:
  - /images/learning/nodejs/nodejsday6.png
date: 2017-09-15 14:01:22
categories: Study Note
tags: Nodejs
toc: true
---
<img src="/images/learning/nodejs/nodejsday6.png">

***
### MongoDB，Mongoose 和 REST APIs (Todo API)
#### 安裝 MongoDB 和 Mongoose
1. [下載 MongoDB](https://www.mongodb.com/download-center?jmp=nav#community)
2. 將檔案解壓縮後，修改檔名為 mongo，然後移動到家目錄底下
3. 在家目錄新增 mongo-data 的資料夾
4. 啟動 server 並指定路徑`./mongod --dbpath ~/mongo-data`
5. 新開分頁，執行 `./mongo`
6. 寫入資料庫 `db.Todos.insert({text: 'File new node course'})`
7. `db.Todos.find()` ，搜尋資料庫會發現剛剛輸入的資料
8. [Robomongo](https://robomongo.org/)
#### 建立 NoSQL Vocabulary
1. SQL 有 table 結構，NoSQL 則是使用物件的形式 (Collection)
2. SQL 每一筆資料稱為 Row/Record，NoSQL 則稱為 Document
3. SQL 每一個欄位稱為 Column，NoSQL 則稱為 Field
#### 連接 MongoDB 並寫入資料
1. [MongoDB native](https://github.com/mongodb/node-mongodb-native)
2. `mkdir node-todo-api`
3. `npm init`
4. `npm install mongodb@2.2.5 --save`
5. 新增 playground/mongodb-connect.js
```
const MongoClient = require('mongodb').MongoClient;

MongoClient.connect('mongodb://localhost:27017/TodoApp', (err, db) => {
    if (err) {
        return console.log('Unable to connect to MongoDB server');
    }
    console.log('Connected to MongoDB server');

    db.close();
});
```
6. `node playground/mongodb-connect.js`
7. 在 playground/mongodb-connect.js 插入一行
```
db.collection('Todos').insertOne({
        text: 'Something to do',
        completed: false
    }, (err, result) => {
        if (err) {
            return console.log('Unable to insert todo', err);
        }
        console.log(JSON.stringify(result.ops, undefined, 2));
    });
```
8. `node playground/mongodb-connect.js`
9. 在 playground/mongodb-connect.js 新增 Users 資料表，且新增 fields (name, age, location)
```
// Insert new doc into Users (name, age, location)
    db.collection('Users').insertOne({
        name: 'Andrew',
        age: 25,
        location: 'Philadelphia'
    }, (err, result) => {
        if (err) {
            return console.log('Unable to insert User', err);
        }
        console.log(JSON.stringify(result.ops));
    });
```
10. `node playground/mongodb-connect.js`
#### ObjectId
1. 將 `const MongoClient = require('mongodb').MongoClient;` 取代為 `const { MongoClient, ObjectID }  = require('mongodb');`
#### 取得資料
1. 直接在 Robo 裡面的 Todos 新增 document
```
{
  text: "Walk the dog",
  completed: false
}
```
2. 複製 mongodb-connect.js 並新增為 mongodb-find.js
```
const { MongoClient, ObjectID }  = require('mongodb');

MongoClient.connect('mongodb://localhost:27017/TodoApp', (err, db) => {
    if (err) {
        return console.log('Unable to connect to MongoDB server');
    }
    console.log('Connected to MongoDB server');

    db.collection('Todos').find().toArray().then((docs) => {
        console.log('Todos');
        console.log(JSON.stringify(docs, undefined, 2));
    }, (err) => {
        console.log('Unable to fetch todos', err);
    });

    // db.close();
});
```
3. `node playground/mongodb-find.js`
4. `db.collection('Todos').find({completed: false}).toArray().then((docs) => {`
5. 這樣就只會出現 false 的選項了 `node playground/mongodb-find.js`
6. `db.collection('Todos').find({_id: new ObjectID('59bb791adf952c24d5ae60b7')})`
7. 也可以用 id 的方式搜尋 `node playground/mongodb-find.js`
8. 用計數的方式算出東西
```
db.collection('Todos').find().count().then((count) => {
    console.log(`Todos count: ${count}`);
}, (err) => {
    console.log('Unable to fetch todos', err);
});
```
#### Deleting Document
1. 一次刪除很多 deleteMany
```
db.collection('Todos').deleteMany({text: 'Eat lunch'}).then((result) => {
    console.log(result);
});
```
2. 一次刪除一個 deleteOne
```
db.collection('Todos').deleteOne({text: 'Eat lunch'}).then((result) => {
    console.log(result);
});
```
3. 選擇一個然後刪除，如果有多個一樣的，會自動選擇第一筆找到的 findOneAndDelete
```
db.collection('Todos').findOneAndDelete({completed: false}).then((result) => {
    console.log(result);
});
```
#### 更新資料
1. 更新 Todos，set 改變值，returnOriginal 設為 false 就是回傳值的時候，傳回更新後的值，預設為 true
```
db.collection('Todos').findOneAndUpdate({
    _id: new ObjectID('59bcaa59fd4847c2497a0104')
}, {
    $set: {
        completed: true
    }
}, {
    returnOriginal: false
}).then((result) => {
    console.log(result);
});
```
2. 更新 Users，inc 設為 1 就是把值增加 1
```
db.collection('Users').findOneAndUpdate({
    _id: new ObjectID('59bb7a6630523c252369e2e4')
}, {
    $set: {
        name: 'Andrew'
    },
    $inc: {
        age: 1
    }
},{
    returnOriginal: false
}).then((result) => {
    console.log(result);
});
```
#### 設定 Mongoose
1. [Mongoose 官方網站](http://mongoosejs.com/)
2. `npm i mongoose@4.5.9 --save`
3. 使用 Mongoose 寫入資料到 MongoDB
```
var mongoose = require('mongoose');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/TodoApp');

var Todo = mongoose.model('Todo', {
    text: {
        type: String
    },
    completed: {
        type: Boolean
    },
    completedAt: {
        type: Number
    }
});

var newTodo = new Todo({
    text: 'Cook dinner'
});

newTodo.save().then((doc) => {
    console.log('Save todo', doc);
}, (e) => {
    console.log('Unable to save todo');
});
```
4. 再寫入別的資料
```
var otherTodo = new Todo({
    text: 'Feed the cat',
    completed: true,
    completedAt: 123
});

otherTodo.save().then((doc) => {
    console.log(JSON.stringify(doc, undefined, 2));
}, (e) => {
    console.log('Unable to save', e);
});
```
#### Validators，Types 和 Defaults
1. 修改 server/server.js，新增 model，並設定驗證
```
var User = mongoose.model('User', {
    email: {
        type: String,
        required: true,
        trim: true,
        minlength: 1
    }
});
```
2. 插入物件並儲存
```
var user = new User({
    email: 'andrew@example.com     '
});

user.save().then((doc) => {
    console.log('User saved', doc);
}, (e) => {
    console.log('Unable to save user', e);
});
```
3. 這個部分有一個很特別的地方，如果 type 設為 String，輸入數字或是布林值都會變成 text，並不會出錯。