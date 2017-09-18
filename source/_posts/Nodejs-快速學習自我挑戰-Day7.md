---
title: Nodejs 快速學習自我挑戰 Day7
thumbnail:
  - /blogs/images/learning/nodejs/nodejsday7.png
date: 2017-09-17 19:56:53
categories: 學習歷程
tags: Nodejs
---
<img src="/blogs/images/learning/nodejs/nodejsday7.png">

***
### MongoDB，Mongoose 和 REST APIs (Todo API)
#### 安裝 Postman
1. [Postman 官網](https://www.getpostman.com/)
#### Resource Creation Endpoint - POST /todos
1. 新增 server/db/mongoose.js
```
var mongoose = require('mongoose');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/TodoApp');

module.exports = {mongoose};
```
2. 新增 server/models/todo.js
```
var mongoose = require('mongoose');

var Todo = mongoose.model('Todo', {
    text: {
        type: String,
        required: true,
        minlength: 1,
        trim: true
    },
    completed: {
        type: Boolean,
        default: false
    },
    completedAt: {
        type: Number,
        default: null
    }
});

module.exports = {Todo};
```
3. 新增 server/models/user.js
```
var mongoose = require('mongoose');

var User = mongoose.model('User', {
    email: {
        type: String,
        required: true,
        trim: true,
        minlength: 1
    }
});

module.exports = {User};
```
4. 剛剛把 server/server.js 的資料都搬到了其它資料夾，所以檔案簡化為
```
var {mongoose}  = require('./db/mongoose');
var {Todo} = require('./models/todo');
var {User} = require('./models/user');
```
5. 安裝 body-parse 可以把 JSON 轉換為 object
`npm i express@4.14.0 body-parser@1.15.2 --save`
6. 在 server/server.js 引入 Library
```
var express = require('express');
var bodyParser = require('body-parser');
```
7. 使用 express
```
var app = express();

app.use(bodyParser.json());

app.post('/todos', (req, res) => {
    console.log(req.body);
});

app.listen(3000, () => {
    console.log('Started on port 3000');
});
```
8. 在 Postman 新增 Post `http://localhost/todos`，選擇 Body，選擇 raw，選擇 JSON，並送出 Post
```
{
	"text": "This is from postman"
}
```
9. 在 console 就會看到傳進去的資料
10. [HTTP Status Codes：確認 HTTP 狀態碼](https://httpstatuses.com/)
11. 修改 app.post，如果 OK 就寫入 MongoDB，並回傳 OK 的訊息，如果有問題就回傳 error。
```
app.post('/todos', (req, res) => {
    var todo = new Todo({
        text: req.body.text
    });

    todo.save().then((doc) => {
        res.send(doc);
    }, (e) => {
        res.status(400).send(e);
    });
});
```
#### 測試 POST /todos
1. `npm i expect@1.20.2 mocha@3.0.2 nodemon@1.10.2 supertest@2.0.0 --save-dev`
2. 把 server/server.js 輸出
`module.exports = {app};`
3. 新增 server/tests/server.test.js
```
const expect = require('expect');
const request = require('supertest');

const {app} = require('./../server');
const {Todo} = require('./../models/todo');

beforeEach((done) => {
    Todo.remove({}).then(() => done());
});

describe('POST /todos', () => {
    it('should create a new todo', (done) => {
        var text = 'Test todo text';

        request(app)
            .post('/todos')
            .send({text})
            .expect(200)
            .expect((res) => {
                expect(res.body.text).toBe(text);
            })
            .end((err, res) => {
                if (err) {
                    return done(err);
                }

                Todo.find().then((todos) => {
                    expect(todos.length).toBe(1);
                    expect(todos[0].text).toBe(text);
                    done();
                }).catch((e) => done(e));
            });
    });

    it('should not create todo with invalid body data', (done) => {
        request(app)
            .post('/todos')
            .send({})
            .expect(400)
            .end((err, res) => {
                if (err) {
                    return done(err);
                }
                Todo.find().then((todos) => {
                    expect(todos.length).toBe(0);
                    done();
                }).catch((e) => done(e));
            });
    });
});
```
#### List Resources - GET /todos
1. 在 server/server.js 新增 GET
```
app.get('/todos', (req, res) => {
    Todo.find().then((todos) => {
        res.send({todos});
    }, (e) => {
        res.status(400).send(e);
    });
});
```
2. `node server/server.js`
3. 去 Postman 測試
    - 新增 GET http://localhost:3000/todos
    - 右方 save as，新增一個新的 collection，Todo App，把指令加進去
    - 再新增 POST http://localhost:3000/todos，選 raw，JSON，並寫入資料
    - 也加入新的 collection
#### 測試 GET /todos
1. 修改 server/tests/server.test.js
```
const todos = [{
    text: 'First test todo'
}, {
    text: 'Second test todo'
}];
// 在測試每一筆的時候，插入兩筆
beforeEach((done) => {
    Todo.remove({}).then(() => {
        return Todo.insertMany(todos);
    }).then(() => done());
});
```
2. 第一個測試直接找 {text}
`Todo.find({text}).then((todos) => {`
3. 第二個測試改為兩筆
`expect(todos.length).toBe(2);`
4. 新增 GET 測試
```
describe('GET /todos', () => {
    it('should get all todos', (done) => {
        request(app)
            .get('/todos')
            .expect(200)
            .expect((res) => {
                expect(res.body.todos.length).toBe(2);
            })
            .end(done);
    });
});
```
#### Mongoose Queries 和 ID Validation
1. 新增 playground/mongoose-queries.js
```
const {ObjectID} = require('mongodb');

const {mongoose} = require('./../server/db/mongoose');
const {Todo} = require('./../server/models/todo');
const {User} = require('./../server/models/user');

var id = '59be9ceb9e82d91c669205a611';

if (!ObjectID.isValid(id)) {
    console.log('ID not valid');
}

Todo.find({
    _id: id
}).then((todos) => {
    console.log('Todos', todos);
});

Todo.findOne({
    _id: id
}).then((todo) => {
    console.log('Todo', todo);
});

Todo.findById(id).then((todo) => {
    if (!todo) {
        return console.log('Id not found');
    }
    console.log('Todo by id', todo);
}).catch((e) => console.log(e));
```
2. `nodemon playground/mongoose-queries.js`
3. 新增 query user
```
User.findById('59be61a5c4e4cea95cfe65ea').then((user) => {
    if (!user) {
        return console.log('Unable to find user');
    }

    console.log(JSON.stringify(user, undefined, 2));
}, (e) => {
    console.log(e);
});
```
#### 取得 individual Resource - GET /todos/:id
1. 取得資料的思路
```
// Valid id using isValid
    // 404 - send back empty send

// findById
    // success
        // if todo - send it back
        // if no todo - send back 404 with empty body
    // error
        // 400 - and send empty body back
```
2. 引入 ObjectId
`var {ObjectID} = require('mongodb');`
3. 取得 id
```
app.get('/todos/:id', (req, res) => {
    var id = req.params.id;

    if (!ObjectID.isValid(id)) {
        return res.status(404).send();
    }

    Todo.findById(id).then((todo) => {
        if (!todo) {
            return res.status(404).send();
        }

        res.send({todo});
    }).catch((e) => {
        res.status(400).send();
    });
});
```
#### 測試 GET /todos/:id
1. 在 server/tests/server.test.js 引入 ObjectId
`const {ObjectID} = require('mongodb');`
2. 在傳入的陣列新增 id
```
const todos = [{
    _id: new ObjectID(),
    text: 'First test todo'
}, {
    _id: new ObjectID(),
    text: 'Second test todo'
}];
```
3. 寫測試
```
describe('GET /todo/:id', () => {
    it('should return todo doc', (done) => {
        request(app)
            .get(`/todos/${todos[0]._id.toHexString()}`)
            .expect(200)
            .expect((res) => {
                expect(res.body.todo.text).toBe(todos[0].text);
            })
            .end(done);
    });

    it('should return 404 if todo not found', (done) => {
        var hexId = new ObjectID().toHexString();

        request(app)
            .get(`/todos/${hexId}`)
            .expect(404)
            .end(done);
    });

    it('should return 404 for non-object ids', (done) => {
        request(app)
            .get('/todos/123abc')
            .expect(404)
            .end(done);
    });
});
```