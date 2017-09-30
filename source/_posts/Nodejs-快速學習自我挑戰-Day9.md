---
title: Nodejs 快速學習自我挑戰 Day9
thumbnail:
  - /blogs/images/learning/nodejs/nodejsday9.png
date: 2017-09-28 06:14:39
categories: 學習歷程
tags: Nodejs
---
<img src="/blogs/images/learning/nodejs/nodejsday9.png">

***
### 安全和認證
#### Private Routes 和 Auth Middleware
1. 在 server/server.js 新增 get
```
app.get('/users/me', (req, res) => {
    var token = req.header('x-auth');

    User.findByToken(token).then((user) => {
        if (!user) {

        }

        res.send(user);
    });
});
```
2. 在 server/models/users.js 新增 findByToken
```
UserSchema.statics.findByToken = function (token) {
    var User = this;
    var decoded;

    try {
        decoded = jwt.verify(token, 'abc123')
    } catch (e) {

    }

    return User.findOne({
        '_id': decoded._id,
        'tokens.token': token,
        'tokens.access': 'auth'
    });
};
```
3. 使用 Postman 新增 user 並取得 x-auth，然後新增 GET {{url}}/users/me，並在 Header 插入剛剛取得的 x-auth，就會順利取得 _id 和 email
4. 將 在 server/models/users.js 的 error 部分處理好
```
try {
    decoded = jwt.verify(token, 'abc123')
} catch (e) {
    return Promise.reject();
}
```
5. 將 server/server.js 的 error 部分處理好
```
User.findByToken(token).then((user) => {
    if (!user) {
        return Promise.reject();
    }

    res.send(user);
}).catch((e) => {
    res.status(401).send();
});
```
6. 新增 server/middleware/authenticate.js
```
var {User} = require('./../models/user');

var authenticate = (req, res, next) => {
    var token = req.header('x-auth');

    User.findByToken(token).then((user) => {
        if (!user) {
            return Promise.reject();
        }

        req.user = user;
        req.token = token;
        next();
    }).catch((e) => {
        res.status(401).send();
    });
};

module.exports = {authenticate};
```
7. 在 server/server.js 引入 authenticate
`var {authenticate} = require('./middleware/authenticate');`
8. 在 /users/me 的部分使用 authenticate
```
app.get('/users/me', authenticate, (req, res) => {
    res.send(req.user);
});
```
#### Hashing Passwords
1. 安裝 bcryptjs
`npm i bcryptjs@2.3.0 --save`
2. [bcrypt 文件](https://www.npmjs.com/package/bcryptjs)
3. 在 playground/hashing.js 新增 bcrypt function
```
const {SHA256} = require('crypto-js');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

var password = '123abc!';

bcrypt.genSalt(10, (err, salt) => {
    bcrypt.hash(password, salt, (err, hash) => {
        console.log(hash);
    });
});
```
4. `node playground/hashing.js`
5. 將產出的 hashing 和本來的 password 比較，如果 true 則等於相等
```
var hashedPassword = '$2a$10$.fiP4qt.xBk3w4CIZB1jN.x.WHFrexbi4Dk3Y/er/0MJASi8S1u1y';

bcrypt.compare(password, hashedPassword, (err, res) => {
    console.log(res);
});
```
6. 在 server/models/user.js 新增 UserSchema.pre function，如果 password 修改則要重新 hash，如果沒有修改則不 hash，避免重複 hash 的情況發生
```
UserSchema.pre('save', function (next) {
    var user = this;

    if (user.isModified('password')) {
        bcrypt.genSalt(10, (err, salt) => {
            bcrypt.hash(user.password, salt, (err, hash) => {
                user.password = hash;
                next();
            });
        });
    } else {
        next();
    }
});
```
#### 與 Users 傳送測試資料庫
1. 新增 server/tests/seed/seed.js，把 todos 物件從 server.test.js 移出來，然後新增 populateTodos
```
const {ObjectID} = require('mongodb');

const {Todo} = require('./../../models/todo');

const todos = [{
    _id: new ObjectID(),
    text: 'First test todo'
}, {
    _id: new ObjectID(),
    text: 'Second test todo',
    completed: true,
    completedAt: 333
}];

const populateTodos = (done) => {
    Todo.remove({}).then(() => {
        return Todo.insertMany(todos);
    }).then(() => done());
};

module.exports = {todos, populateTodos};
```
2. 在 server/tests/server.test.js 引入 seed
```
const {todos, populateTodos} = require('./seed/seed');

beforeEach(populateTodos);
```
3. 在 server/tests/seed/seed.js 新增 Users 物件
```
const jwt = require('jsonwebtoken');

const {User} = require('./../../models/user');

const userOneId = new ObjectID();
const userTwoId = new ObjectID();
const users = [{
    _id: userOneId,
    email: 'andrew@example.com',
    password: 'userOnePass',
    tokens: [{
        access: 'auth',
        token: jwt.sign({_id: userOneId, access: 'auth'}, 'abc123').toString()
    }]
}, {
    _id:userTwoId,
    email: 'jen@example.com',
    password: 'userTwoPass'
}];
```
4. 新增 populateUsers 並匯出
```
const populateUsers = (done) => {
    User.remove({}).then(() => {
        var userOne = new User(users[0]).save();
        var userTwo = new User(users[1]).save();

        return Promise.all([userOne, userTwo])
    }).then(() => done());
};

module.exports = {todos, populateTodos, users, populateUsers};
```
5. 在 在 server/tests/server.test.js 引入 populateUsers
```
const {todos, populateTodos, users, populateUsers} = require('./seed/seed');

beforeEach(populateUsers);
```
#### 測試 POST /users 和 GET /users/me
1. 











