---
title: Nodejs 快速學習自我挑戰 Day10
thumbnail:
  - /images/learning/nodejs/nodejsday10.jpg
date: 2017-10-08 00:37:59
categories: Study Note
tags: Nodejs
---
<img src="/images/learning/nodejs/nodejsday10.jpg">

***
### 安全和認證
#### 讓 Todo Routes Private
1. 修改 server/models/todo.js 新增 _creator
```
_creator: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
}
```
2. 修改 server/tests/seed/seed.js 新增 _creator
```
const todos = [{
    _id: new ObjectID(),
    text: 'First test todo',
    _creator: userOneId
}, {
    _id: new ObjectID(),
    text: 'Second test todo',
    completed: true,
    completedAt: 333,
    _creator: userTwoId
}];
```
3. 修改 server/server.js，加入 authenticate，然後新增 _creator
```
app.post('/todos', authenticate, (req, res) => {
    var todo = new Todo({
        text: req.body.text,
        _creator: req.user._id
    });

    todo.save().then((doc) => {
        res.send(doc);
    }, (e) => {
        res.status(400).send(e);
    });
});

app.get('/todos', authenticate, (req, res) => {
    Todo.find({
        _creator: req.user._id
    }).then((todos) => {
        res.send({todos});
    }, (e) => {
        res.status(400).send(e);
    });
});
```
4. 在 server/tests/server.test.js 的 POST 部分設置 x-auth
`.set('x-auth', users[0].tokens[0].token)`
5. 在 server/tests/server.test.js 的 GET 部分設置 x-auth，並在回送時設定長度為 1，因為設置了 creator，只會回傳一個 todo
```
describe('GET /todos', () => {
    it('should get all todos', (done) => {
        request(app)
            .get('/todos')
            .set('x-auth', users[0].tokens[0].token)
            .expect(200)
            .expect((res) => {
                expect(res.body.todos.length).toBe(1);
            })
            .end(done);
    });
});
```
6. 在 server/server.js 修改 POST /users/login 的 token 為 1
```
expect(user.tokens[1]).toInclude({
    access: 'auth',
    token: res.headers['x-auth']
});
```
7. 在 server/server.js 修改 GET /todos/:id'，新增 authenticate middleware，且修改 findById 成 findOne
```
app.get('/todos/:id', authenticate, (req, res) => {

Todo.findOne({
    _id: id,
    _creator: req.user._id
}
```
8. 在 server/tests/server.test.js 修改 GET /todos 和 GET /todo/:id 都加上 `.set('x-auth', users[0].tokens[0].token)`
9. 在 server/server.js 修改 DELETE /todos/:id'，新增 authenticate middleware，且修改 findByIdAndRemove 成 findOneAndRemove
```
app.delete('/todos/:id', authenticate, (req, res) => {

Todo.findOneAndRemove({
    _id: id,
    _creator: req.user._id
}
```
10. 在 server/tests/server.test.js 的 describe('GET /todo/:id') 加上一個測試，如果被其他使用者建立的 todo 則 404
```
it('should not return todo doc created by other user', (done) => {
    request(app)
        .get(`/todos/${todos[1]._id.toHexString()}`)
        .set('x-auth', users[0].tokens[0].token)
        .expect(404)
        .end(done);
});
```
11. 在 server/tests/server.test.js 的 DELETE /todos/:id 的每個測試都加上
`.set('x-auth', users[1].tokens[0].token)`
12. 在新增一個測試，如果 todo 對不上 user 就回傳 404
```
it('should not remove a todo', (done) => {
    var hexId = todos[0]._id.toHexString();

    request(app)
        .delete(`/todos/${hexId}`)
        .set('x-auth', users[1].tokens[0].token)
        .expect(404)
        .end((err, res) => {
            if (err) {
                return done(err);
            }

            Todo.findById(hexId).then((todo) => {
                expect(todo).toExist();
                done();
            }).catch((e) => done(e));
        });
});
```
13. 在 server/server.js 修改 PATCH /todos/:id'，新增 authenticate middleware，且修改 findByIdAndUpdate 成 findOneAndUpdate
```
app.patch('/todos/:id', authenticate, (req, res) => {

Todo.findOneAndUpdate({_id: id, _creator: req.user._id}, {$set: body}, {new: true})
```
#### 改善 App 組態設定
1. 在 server/config/config.js 修改成用 json 的方式讀取環境變數
```
var env = process.env.NODE_ENV || 'development';

if (env === 'development' || env === 'test') {
    var config = require('./config.json');
    var envConfig = config[env];

    Object.keys(envConfig).forEach((key) => {
        process.env[key] = envConfig[key];
    });
}
```
2. 新增 server/config/config.json，把組態檔放進去
```
{
  "test": {
    "PORT": 3000,
    "MONGODB_URI": "mongodb://localhost:27017/TodoAppTest",
    "JWT_SECRET": "fadskljfalkfwerlkmvvsfgreio3"
  },
  "development": {
    "PORT": 3000,
    "MONGODB_URI": "mongodb://localhost:27017/TodoApp",
    "JWT_SECRET": "fadskljfa3kfwe345mvvsfgreio3"
  }
}
```
3. 在 server/tests/seed/seed.js 的 jwt.sign 值都改為 `process.env.JWT_SECRET`
4. 在 server/tests/seed/user.js 的 jwt.sign 和 jwt.verify 值都改為 `process.env.JWT_SECRET`
5. 在 heroku 設定 JWT_SECRET
`heroku config:set JWT_SECRET=fadskljfa3kfwe345mvvs2g3eio3`
#### 部署到 Heroku
1. 取得 MONGODB_URI
`heroku config:get MONGODB_URI`
2. 取得值 - mongodb://帳號:密碼@連線網址:39994/資料庫名稱
3. 進入 Robo 3T 進行新的連線並測試
4. `git push master heroku`
#### 進階的 Postman
1. 在 POST /users 和 /users/login 的 Test 選項寫入下面兩行，在送出時就會設定 x-auth 為全域的變數
```
var token = postman.getResponseHeader('x-auth');
postman.setEnvironmentVariable('x-auth', token);
```
2. 在其他的 header 加上 {{"{{x-auth" }}}} 取得變數
3. 在 POST /todos 的 Test 選項寫入下面兩行，在送出時就會設定 todoId 為全域的變數
```
var body = JSON.parse(responseBody);
postman.setEnvironmentVariable('todoId', body._id);
```
4. 在其他有 id 的 url 上面加上 {{"{{todoId" }}}}
#### 升級 expect
1. `npm install expect@21.2.1 --save-dev`
2. 把 server/tests/server.test.js 的 toNotExist 改成 toBeFalsy，把 toExist 改成 toBeTruthy
3. 在 PATCH /todos/:id 的部份把 `expect(res.body.todo.completedAt).toBeA('number');` 取代為 `expect(typeof res.body.todo.completedAt).toBe('number');`
4. 將 .toNotBe 改為 .not.toBe
5. 將 toInclude 改為 toMatchObject，toObject 會拋回原始的 user 資料
`expect(user.toObject().tokens[1]).toMatchObject({`
### 使用 Socket.io 的即時 Web Apps
#### 創建一個專案
1. `mkdir node-chat-app`
2. `cd node-chat-app`
3. `npm init`
4. `git init`
5. 新增 server/server.js
```
const path = require('path');
const express = require('express');

const publicPath = path.join(__dirname, '../public');
const port = process.env.PORT || 3000;
var app = express();

app.use(express.static(publicPath));

app.listen(port, () => {
    console.log(`Server is up on ${port}`);
});
```
6. 新增 public/index.html
```
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
    <p>Welcome to the chat app</p>
</body>
</html>
```
7. `npm i express --save`
8. 推到 Github
```
git add .
git commit -m 'Init commit'
git remote add origin https://github.com/TingSyuanWang/node-chat-app.git
git push -u origin master
```
9. 發佈到 heroku
```
heroku create
git push heroku master
```
#### 增加 Socket.io 到 App
1. `npm i socket.io --save`
2. 新增 http 和 socketIO 到 server/server.js，
```
const http = require('http');
const socketIO = require('socket.io');

var server = http.createServer(app);
var io = socketIO(server);

io.on('connection', (socket) => {
    console.log('New user connected');

    socket.on('disconnect', () => {
        console.log('User was disconnected');
    });
});

server.listen(port, () => {
    console.log(`Server is up on ${port}`);
});
```
3. 新增 socket.io 到 index.html
```
<script src="/socket.io/socket.io.js"></script>
<script>
    var socket = io();

    socket.on('connect', () => {
        console.log('Connected to server');
    });

    socket.on('disconnect', () => {
        console.log('Disconnected from server');
    });
</script>
```
#### Events 的 Emitting 和 Listening
1. 新增 public/js/index.js
```
var socket = io();

socket.on('connect', function () {
    console.log('Connected to server');

    socket.emit('createEmail', {
        to: 'jen@example.com',
        text: 'Hey. This is Andrew.'
    });
});

socket.on('disconnect', function () {
    console.log('Disconnected from server');
});

socket.on('newEmail', function (email) {
    console.log('New email', email);
});
```
2. 在 public/index.html 引入 script
`<script src="js/index.js"></script>`
3. 在 server/server.js 在 connect 的時候，傳出 newEmail，然後等待接收 createEmail
```
socket.emit('newEmail', {
    from: 'mike@example.com',
    text: 'Hey. What is going on',
    createdAt: 123
});

socket.on('createEmail', (newEmail) => {
    console.log('createEmail', newEmail);
});
```
4. 在 public/js/index.js 新增 emit
```
socket.emit('createMessage', {
    from: 'Andrew',
    text: 'Yup, that works for me.'
});
```
5. 在 server/server.js 接收 client 的 emit
```
socket.on('createMessage', (message) => {
    console.log('createMessage', message);
});
```
6. 在 server/server.js 新增 emit
```
socket.emit('newMessage', {
    from: 'John',
    text: 'See you then',
    createdAt: 123123
});
```
7. 在 public/js/index.js 把接收的 Message console 出來
```
socket.on('newMessage', function (message) {
    console.log('newMessage', message);
});
```