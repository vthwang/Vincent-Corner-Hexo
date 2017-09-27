---
title: Nodejs 快速學習自我挑戰 Day8
thumbnail:
  - /blogs/images/learning/nodejs/nodejsday8.png
date: 2017-09-19 01:30:30
categories: 學習歷程
tags: Nodejs
---
<img src="/blogs/images/learning/nodejs/nodejsday8.png">

***
### MongoDB，Mongoose 和 REST APIs (Todo API)
#### 部署 API 到 Heroku
1. 安裝 Heroku CLI
`brew install heroku/brew/heroku`
2. 在 server/server.js 新增 port 的設定
`const port = process.env.PORT || 3000;`
3. 修改 app.listen
```
app.listen(port, () => {
    console.log(`Started up at port ${port}`);
});
```
4. 在 package.json 新增 start 指令，並新增 engine
```
"scripts": {
    "start": "node server/server.js",
    "test": "mocha server/**/*.test.js",
    "test-watch": "nodemon --exec 'npm test'"
  },
  "engines": {
    "node": "6.11.3"
  },
```
5. `heroku create`
6. `heroku addons:create mongolab:sandbox`
7. 可以取得 MongoDB URI `heroku config`
8. 修改 server/db/mongoose.js
`mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/TodoApp');`
9. `git push heroku master`
10. 如果應用發生問題，可以用以下指令確認 `heroku logs`
#### Postman 環境
1. 進去 Postman，右上角有 Management Environment，點進去之後，新增 Todo App Local 和 Todo App Heroku，分別設定 url 為 localhost:3000 和 Heroku 的網址
2. 然後將網址都改為 {{url}} 的變數代替
#### 刪除 Resource - DELETE /todos/:id
1. 新增 playground/mongoose-remove.js
```
const {ObjectID} = require('mongodb');

const {mongoose} = require('./../server/db/mongoose');
const {Todo} = require('./../server/models/todo');
const {User} = require('./../server/models/user');

// 移除全部
Todo.remove({}).then((result) => {
    console.log(result);
});

// Todo.findOneAndRemove
Todo.findOneAndRemove({_id: '59c0c37efd4847c2497a12a7'}).then((todo) => {
    console.log(todo);
});

// Todo.findByIdAndRemove
Todo.findByIdAndRemove('59c0c37efd4847c2497a12a7').then((todo) => {
    console.log(todo);
});
```
2. 在 server/server.js 新增 delete route
```
app.delete('/todos/:id', (req, res) => {
    var id = req.params.id;

    if (!ObjectID.isValid(id)) {
        return res.status(404).send();
    }

    Todo.findByIdAndRemove(id).then((todo) => {
        if (!todo) {
            return res.status(404).send();
        }

        res.send({todo});
    }).catch((e) => {
        res.status(400).send();
    });
});
```
3. 使用 Postman 測試，並儲存
#### 測試 DELETE /todos/:id
1. 新增第一個測試，最後的部分是驗證資料是否被刪除
```
describe('DELETE /todos/:id', () => {
    it('should remove a todo', (done) => {
        var hexId = todos[1]._id.toHexString();

        request(app)
            .delete(`/todos/${hexId}`)
            .expect(200)
            .expect((res) => {
                expect(res.body.todo._id).toBe(hexId)
            })
            .end((err, res) => {
                if (err) {
                    return done(err);
                }

                Todo.findById(hexId).then((todo) => {
                    expect(todo).toNotExist();
                    done();
                }).catch((e) => done(e));
            });
    });
});
```
2. 基本上做法跟 GET 差不多，複製 code，然後把 .get 改成 .delete 即可
```
it('should return 404 if todo not found', (done) => {
    var hexId = new ObjectID().toHexString();

    request(app)
        .delete(`/todos/${hexId}`)
        .expect(404)
        .end(done);
});

it('should return 404 if object id is invalid', (done) => {
    request(app)
        .delete('/todos/123abc')
        .expect(404)
        .end(done);
});
```
#### 更新 Resource - PATCH /todos/:id
1. `npm i --save lodash@4.15.0`
2. 修改 server/server.js，引入 lodash，將其它引入的資料用 const。
```
const _ = require('lodash');
const express = require('express');
const bodyParser = require('body-parser');
const {ObjectID} = require('mongodb');
```
3. 新增 patch，如果 completed = true，寫入日期，如果沒有，把 completed 設為 false 且 completedAt 設為 null
```
app.patch('/todos/:id', (req, res) => {
    var id = req.params.id;
    var body = _.pick(req.body, ['text', 'completed']);

    if (!ObjectID.isValid(id)) {
        return res.status(404).send();
    }

    if (_.isBoolean(body.completed) && body.completed ) {
        body.completedAt = new Date().getTime();
    } else {
        body.completed = false;
        body.completedAt = null;
    }

    Todo.findByIdAndUpdate(id, {$set: body}, {new: true}).then((todo) => {
        if (!todo) {
            return res.status(404).send();
        }

        res.send({todo});
    }).catch((e) => {
        res.status(400).send();
    });
});
```
4. 用 Postman 測試，傳入 JSON，本地端測試完，再用 Heroku
```
{
	"completed": true,
	"text": "update from postman"
}
```
#### 測試 PATCH /todos/:id
1. PATCH test 的設計邏輯
```
describe('PATCH /todos/:id', () => {
    it('should update the todo', (done) => {
        // grab id of first item
        // update text, set completed true
        // 200
        // text is changed, completed is true, completedAt is a number .toBeA
        
    });
    
    it('should clear completedAt when todo is not completed', (done) => {
        // grab id of second todo item
        // update text, set completed to false
        // 200
        // text is changed, completed is false, completedAt is null .toNotExist
    });
});
```
2. 測試修改 completed 為 true
```
it('should update the todo', (done) => {
    var hexId = todos[0]._id.toHexString();
    var text = 'This should be the new text';

    request(app)
        .patch(`/todos/${hexId}`)
        .send({
            completed: true,
            text
        })
        .expect(200)
        .expect((res) => {
            expect(res.body.todo.text).toBe(text);
            expect(res.body.todo.completed).toBe(true);
            expect(res.body.todo.completedAt).toBeA('number');
        })
        .end(done);
});
```
3. 測試修改 completed 為 false
```
it('should clear completedAt when todo is not completed', (done) => {
    var hexId = todos[1]._id.toHexString();
    var text = 'This should be the new text!!';

    request(app)
        .patch(`/todos/${hexId}`)
        .send({
            completed: false,
            text
        })
        .expect(200)
        .expect((res) => {
            expect(res.body.todo.text).toBe(text);
            expect(res.body.todo.completed).toBe(false);
            expect(res.body.todo.completedAt).toNotExist();
        })
        .end(done);
});
```
#### 創建測試 Database
1. 修改 package.json
```
"scripts": {
  "start": "node server/server.js",
  "test": "export NODE_ENV=test || \"SET NODE_ENV=test\" && mocha server/**/*.test.js",
  "test-watch": "nodemon --exec 'npm test'"
},
```
2. 修改 server/db/mongoose.js
`mongoose.connect(process.env.MONGODB_URI);`
3. 新增 server/config/config.js
```
var env = process.env.NODE_ENV || 'development';

if (env === 'development') {
    process.env.PORT = 3000;
    process.env.MONGODB_URI = 'mongodb://localhost:27017/TodoApp';
} else if (env === 'test') {
    process.env.PORT = 3000;
    process.env.MONGODB_URI = 'mongodb://localhost:27017/TodoAppTest';
}
```
4. 在 server/server.js 引入 config
`require('./config/config');`
5. `node server/server.js`，會進入 development 環境
6. `npm test`，會進入 test 環境，會再新建一個資料庫
### 安全和認證
#### 建立 User Model
1. `npm i validator@5.6.0 --save`
2. 修改 server/models/user.js
```
const mongoose = require('mongoose');
const validator = require('validator');

var User = mongoose.model('User', {
    email: {
        type: String,
        required: true,
        trim: true,
        minlength: 1,
        unique: true,
        validate: {
            validator: validator.isEmail,
            message: '{VALUE} is not a valid email'
        }
    },
    password: {
        type: String,
        require: true,
        minlength: 6,
    },
    tokens: [{
        access: {
            type: String,
            require: true
        },
        token: {
            type: String,
            require: true
        }
    }]
});

module.exports = {User};
```
3. 修改 server/server.js
```
app.post('/users', (req, res) => {
    var body = _.pick(req.body, ['email', 'password']);
    var user = new User(body);

    user.save().then((user) => {
        res.send(user);
    }).catch((e) => {
        res.status(400).send(e);
    });
});
```
#### JWTs 和 Hashing
1. `npm install crypto-js@3.1.6 --save`
2. 新增 playground/hashing.js
```
const {SHA256} = require('crypto-js');

var message = 'I am user number 3';
var hash = SHA256(message).toString();

console.log(`Message: ${message}`);
console.log(`Hash: ${hash}`);

var data = {
    id: 4
};
var token = {
    data,
    hash: SHA256(JSON.stringify(data) + 'somesecret').toString()
};

var resultHash = SHA256(JSON.stringify(token.data) + 'somesecret').toString();

if (resultHash === token.hash) {
    console.log('Data was not changed');
} else {
    console.log('Data was changed. Do not trust!');
}
```
3. 驗證 data 如果不同會跳出資料改變的訊息
```
token.data.id = 5;
token.hash = SHA256(JSON.stringify(token.data)).toString();
```
4. `npm i jsonwebtoken@7.1.9 --save`
5. [JWT 官方網站](https://jwt.io/)
6. 使用 jwt 來進行驗證
```
const jwt = require('jsonwebtoken');

var data = {
    id: 10
};

var token = jwt.sign(data, '123abc');
console.log(token);

var decoded = jwt.verify(token, '123abc');
console.log('decoded', decoded);
```
#### 產生 Auth Tokens 和 Setting Headers
1. 修改 server/models/user.js
```
const mongoose = require('mongoose');
const validator = require('validator');
const jwt = require('jsonwebtoken');
const _ = require('lodash');

var UserSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        trim: true,
        minlength: 1,
        unique: true,
        validate: {
            validator: validator.isEmail,
            message: '{VALUE} is not a valid email'
        }
    },
    password: {
        type: String,
        require: true,
        minlength: 6,
    },
    tokens: [{
        access: {
            type: String,
            require: true
        },
        token: {
            type: String,
            require: true
        }
    }]
});

UserSchema.methods.toJSON = function () {
    var user = this;
    var userObject = user.toObject();

    return _.pick(userObject, ['_id', 'email']);
};

UserSchema.methods.generateAuthToken = function () {
    var user = this;
    var access = 'auth';
    var token = jwt.sign({_id: user._id.toHexString(), access}, 'abc123').toString();

    user.tokens.push({access, token});

    return user.save().then(() => {
        return token;
    });
};

var User = mongoose.model('User', UserSchema);

module.exports = {User};
```
2. 修改 server/server.js
```
// POST /users
app.post('/users', (req, res) => {
    var body = _.pick(req.body, ['email', 'password']);
    var user = new User(body);

    user.save().then((user) => {
        return user.generateAuthToken();
    }).then((token) => {
        res.header('x-auth').send(user);
    }).catch((e) => {
        res.status(400).send(e);
    });
});
```