---
title: Nodejs II 快速學習自我挑戰 Day2
thumbnail:
  - /images/learning/nodejsII/NodejsIIDay02.png
date: 2017-11-10 17:32:45
categories: 學習歷程
tags: Nodejs
---
<img src="/images/learning/nodejsII/NodejsIIDay02.png">

***
### Mongoose 和本地端 MongoDB
#### 安裝 Mongoose 和連接
1. 安裝 Mongoose `npm install --save mongoose`
2. [Mongoose 官方網站](http://mongoosejs.com/)
3. 在 app.js 新增 mongoose connect 連接到本地端伺服器，記得要使用 useMongoClient，不然會出現奇怪的錯誤，如果連接成功，顯示 MongoDB connected，失敗則出現錯誤
```
mongoose.connect('mongodb://localhost/vidjot-dev', {
    useMongoClient: true
})
    .then(() => console.log('MongoDB connected...'))
    .catch(err => console.log(err));
```
4. 加入這一行避免 deprecation 警告出現，把預設已經 deprecated 的 library 用 global promise 取代
`mongoose.Promise = global.Promise;`
#### 建立理想的 Model
1. 新增 models/Idea.js，新增 ideas 的 model
```
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Create Schema
const IdeaSchema = new Schema({
    title: {
        type: String,
        required: true,
    },
    details: {
        type: String,
        required: true
    },
    data: {
        type: Date,
        default: Date.now
    }
});

mongoose.model('ideas', IdeaSchema);
```
2. 在 app.js 讀取 models
```
require('./models/Idea');
const Idea = mongoose.model('ideas');
```
#### 新增 Idea Form
1. 在 views/partials/_navbar.handlebars 加入右側選單，直接加在左側選單的 ul 下面
```
<ul class="navbar-nav ml-auto">
    <li class="nav-item dropdown">
        <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" id="navbarDropdownMenuLink">Video Ideas</a>
        <div class="dropdown-menu">
            <a href="/ideas" class="dropdown-item">Ideas</a>
            <a href="/ideas/add" class="dropdown-item">Add Ideas</a>
        </div>
    </li>
</ul>
```
2. 在 app.js 新增 ideas/add 的路由
```
app.get('/ideas/add', (req, res) => {
    res.render('ideas/add');
});
```
3. 新增 views/ideas/add.handlebars
```
<div class="card card-body">
    <h3>Video Idea</h3>
    <form action="/ideas" method="post">
        <div class="form-group">
            <label for="title">Title</label>
            <input type="text" class="form-control" name="title">
        </div>
        <div class="form-group">
            <label for="details">Details</label>
            <textarea class="form-control" name="details"></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Submit</button>
    </form>
</div>
```
#### 伺服端的 Form Validation
1. [Body-Parser 外掛](https://github.com/expressjs/body-parser)
2. 安裝 body-parser `npm install body-parser --save`
3. 在 app.js 引入 body-parser `const bodyParser = require('body-parser');`
4. 在 app.js 呼叫 Body parser middleware
```
// Body parser middleware
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
```
5. Server Side 處理表單，如果沒有資料，回傳 text，並且將本來有輸入的值放回去，最後，如果全部都有資料則 passed
```
// Process Form
app.post('/ideas', (req, res) => {
    let errors = [];

    if(!req.body.title) {
        errors.push({text:'Please add a title'});
    }
    if(!req.body.details) {
        errors.push({text:'Please add some details'});
    }

    if(errors.length > 0){
        res.render('ideas/add', {
            errors: errors,
            title: req.body.title,
            details: req.body.details
        })
    } else {
        res.send('passed');
    }
});
```
6. 在 views/ideas/add.handlebars 新增錯誤訊息，將剛剛回傳的 errors 放進來
```
{{#each errors}}
    <div class="alert alert-danger">{{text}}</div>
{{else}}

{{/each}}
```
7. 在 views/ideas/add.handlebars 的表單輸入加入 required，可使用前端認證
```
<input type="text" class="form-control" name="title" required>
<textarea class="form-control" name="details" required></textarea>
```
#### 將 Idea 存到 MongoDB
1. 在 app.js 確認沒有錯誤的話則寫入資料庫
```
} else {
    const newUser = {
        title: req.body.title,
        details: req.body.details,
    }
    new Idea(newUser)
        .save()
        .then(idea => {
            res.redirect('/ideas');
        })
}
```
2. 進入 mongo 模式 `mongo`
3. 查詢資料庫
    - 顯示資料庫 `show dbs`
    - 進入資料庫 `use vidjot-dev`
    - 顯示資料庫內的 collections `show collections`
    - 讀取指定 collection 的內容 `db.ideas.find();`
#### 從 MongoDB 讀取 Ideas
1. 在 app.js 新增 ideas 的路由，然後傳送資料過去，且排列順序按照 date 降冪排列
```
app.get('/ideas', (req, res) => {
    Idea.find({})
        .sort({date: 'desc'})
        .then(ideas => {
            res.render('ideas/index', {
                ideas: ideas
            });
        });
});
```
2. 新增 views/ideas/index.handlebars 並用 each 讀出資料
```
{{#each ideas}}
    <div class="card card-body mb-2">
        <h4>{{title}}</h4>
        <p>{{details}}</p>
    </div>
{{else}}
    <p>No video ideas listed</p>
{{/each}}
```
#### 編輯 Idea Form
1. 在 app.js 新增編輯 Idea Form 的路由，只找尋一個然後傳過去下個頁面
```
// Edit Idea Form
app.get('/ideas/edit/:id', (req, res) => {
    Idea.findOne({
        _id: req.params.id,
    })
    .then(idea => {
        res.render('ideas/edit', {
            idea: idea
        });
    });
});
```
2. 在 views/ideas/index.handlebars 新增一個 Edit 的連結
`<a class="btn btn-dark btn-block" href="/ideas/edit/{{id}}">Edit</a>`
3. 從 views/ideas/add.handlebars 複製新增到 views/ideas/edit.handlebars，且將值放進去
```
{{#each errors}}
    <div class="alert alert-danger">{{text}}</div>
{{else}}

{{/each}}

<div class="card card-body">
    <h3>Edit Video Idea</h3>
    <form action="/ideas" method="post">
        <div class="form-group">
            <label for="title">Title</label>
            <input type="text" class="form-control" name="title" value="{{idea.title}}" required>
        </div>
        <div class="form-group">
            <label for="details">Details</label>
            <textarea class="form-control" name="details" required>{{idea.details}}</textarea>
        </div>
        <button type="submit" class="btn btn-primary">Submit</button>
    </form>
</div>
```
#### 更新 Idea Data
1. [Method Override](https://github.com/expressjs/method-override)
2. 安裝 method-override `npm install method-override --save`
3. 在 app.js 引入 `const methodOverride = require('method-override');`
4. 在 app.js 新增 method-override 的 middleware `app.use(methodOverride('_method'));`
5. 修改 views/ideas/edit.handlebars 的表單 action 且新增 hidden input
```
<form action="/ideas/{{idea.id}}?_method=PUT" method="post">
    <input type="hidden" name="_method" value="PUT">
```
6. 在 app.js 更新表單，然後將值存到資料庫
```
// Edit Form process
app.put('/ideas/:id', (req, res) => {
    Idea.findOne({
        _id: req.params.id
    })
    .then(idea => {
        // new values
        idea.title = req.body.title;
        idea.details = req.body.details;

        idea.save()
            .then(idea => {
                res.redirect('/ideas');
            })
    });
});
```
#### 移除 Idea Data
1. 在 views/ideas/index.handlebars 新增 Delete 按鈕
```
<form action="/ideas/{{id}}?_method=DELETE" method="post">
    <input type="hidden" name="_method" value="DELETE">
    <input type="submit" class="btn btn-danger btn-block" value="Delete">
</form>
```
2. 在 app.js 新增刪除路由，用 remove 直接把檔案從資料庫刪除
```
// Delete Idea
app.delete('/ideas/:id', (req, res) => {
    Idea.remove({_id: req.params.id})
        .then(() => {
            res.redirect('/ideas');
        });
});
```
#### Flashing Messaging
1. [Express Session](https://www.npmjs.com/package/express-session)
2. [Connect Flash](https://github.com/jaredhanson/connect-flash)
3. 安裝 Express Session 和 Connect Flash `npm install express-session connect-flash --save`
4. 在 app.js 引入 Express Session 和 Connect Flash
```
const flash = require('connect-flash');
const session = require('express-session');
```
5. 在 app.js 把 Express Session 和 Connect Flash 的 middleware
```
// Express session middleware
app.use(session({
    secret: 'secret',
    resave: true,
    saveUninitialized: true
}));

app.use(flash());
```
6. 在 app.js 把區域變數變成全域變數，這樣訊息就可以在 handlebars 的頁面顯示
```
// Global variables
app.use(function(req, res, next) {
    res.locals.success_msg = req.flash('success_msg');
    res.locals.error_msg = req.flash('error_msg');
    res.locals.error = req.flash('error');
    next();
});
```
7. app.js 在所有路由跳轉之前，送出 flash 訊息
`req.flash('success_msg', 'Video Idea added');`
`req.flash('success_msg', 'Video Idea updated');`
`req.flash('success_msg', 'Video Idea removed');`
8. 新增 views/partials/_msg.handlebars
```
{{#if success_msg}}
    <div class="alert alert-success">{{success_msg}}</div>
{{/if}}

{{#if error_msg}}
    <div class="alert alert-danger">{{error_msg}}</div>
{{/if}}
```
9. 在 views/layouts/main.handlebars 的 `{{"{{body"}}}}` 上方引入 `{{"{{> _msg"}}}}`