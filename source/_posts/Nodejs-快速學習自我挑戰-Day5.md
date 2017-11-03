---
title: Nodejs 快速學習自我挑戰 Day5
thumbnail:
  - /images/learning/nodejs/nodejsday5.jpg
date: 2017-09-14 11:24:09
categories: 學習歷程
tags: Nodejs
---
<img src="/images/learning/nodejs/nodejsday5.jpg">

***
### 網頁伺服器及應用程式部署
#### 進階 template
1. 註冊 partials
`hbs.registerPartials(__dirname + '/views/partials')`
2. 將 footer code 移到 views/partials/footer.hbs
```
<footer>
    <p>Copyright {{currentYear}}</p>
</footer>
```
3. 本來 footer 的區塊用 `{{" {{> footer" }}}}` 取代
4. nodemon 監控 js 和 hbs 檔案 `nodemon server.js -e js, hbs`
5. 將 header code 移到 views/partials/header.hbs
```
<header>
    <h1>{{pageTitle}}, 123</h1>
    <p><a href="/">Home</a></p>
    <p><a href="/about">About</a></p>
</header>
```
6. 本來 footer 的區塊用 `{{" {{> header" }}}}` 取代
7. 使用 hbs 的 Helper 來取得年份
```
hbs.registerHelper('getCurrentYear', () => {
    return new Date().getFullYear();
});
```
8. 本來 `{{" {{currentYear"}}}}` 用 `{{" {{getCurrentYear" }}}}` 取代
9. 使用 hbs 的 Helper 註冊 screamIt 然後將 text 變數送進去
```
hbs.registerHelper('screamIt', (text) => {
    return text.toUpperCase();
});
```
10. 使用 screamIt，text 變數設為 welcomeMessage`{{" {{screamIt welcomeMessage" }}}}`
#### Express Middleware
1. 註冊一個 middleware，然後 console 時間以及擷取的狀態
```
app.use((req, res, next) => {
    var now = new Date().toString();

    console.log(`${now}: ${req.method} ${req.url}`);
    next();
});
```
2. 新增 maintenance.hbs
```
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Some Website</title>
</head>
<body>
    <h1>We'll be right back</h1>
    <p>
        The site is currently being updated.
    </p>
</body>
</html>
```
3. 使用 middleware 把頁面通通導向 maintenance
```
app.use((req, res ,next) => {
   res.render('maintenance');
});
```
#### Git 版本控制
1. [Git 官方網站](https://git-scm.com/)
2. 啟動 git 專案 `git init`
3. 新增檔案 `git add`
4. 新增 .gitignore 讓部分檔案不上傳
5. 對新增的檔案做 commit `git commit -m 'Commit Content'`
#### 設置 ssh key
1. ssh key 目錄 `~/.ssh`
2. 產生 ssh key `ssh-keygen -t rsa -b 4096 -C 'YOUR@EMAIL'`
3. 設定完成會產生出 id\_rsa(此為私密金鑰，不能給別人) 和 id\_rsa_pub(此為公開金鑰，用於第三方軟件)
4. 開啟 ssh-agent `eval "$(ssh-agent -s)"`
5. 將 ssh 私鑰加入 ssh-agent `ssh-add ~/.ssh/id_rsa`
6. 將 ssh key 貼到 Github => Setting => SSH and GPG key `pbcopy < ~/.ssh/id_rsa.pub`
7. 跟 Github 進行連線 `ssh -T git@github.com`
#### 部署 apps
1. [heroku](https://www.heroku.com/)
2. 安裝 heroku cli `brew install heroku`
3. 在本地端 cli 登入 heroku `heroku login`
4. 新增 ssh key 到 keroku `heroku keys:add`
5. 檢查在電腦上的 key `heroku keys`
6. 跟 heroku 進行連線 `ssh -v git@heroku.com`
7. 修改 server.js 讓 port 動態調整，先取得 env 的 PORT，如果不存在則使用預設的 3000 Port
`const port = process.env.PORT || 3000;`
8. 修改 server.js 的 app.listen
```
app.listen(port, () => {
    console.log(`Server is up on port ${port}`);
});
```
9. 在 package.json 的 script 新增 start，讓 server 知道要執行哪個檔案
```
"scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start": "node server.js"
  }
```
10. 開啟 heroku 專案 `heroku create`
11. 將專案推到 heroku `git push heroku`
12. 用瀏覽器開啟 keroku 的專案`heroku open`
### 測試 Apps
#### Mocha 和基本測試
1. `mkdir node-tests`
2. `cd node-tests`
3. `npm init`，全部直接使用預設值
4. 新增檔案 utils/utils.js
`module.exports.add = (a, b) => a + b;`
5. [Mocha 官方網站](https://mochajs.org/)
6. 安裝 mocha 且不在正式上線時使用，僅用於開發用途
`npm i mocha@3.0.0 --save-dev`
7. 新增 utils/util.test.js
```
const utils = require('./utils');

it('should add two numbers', () => {
    var res = utils.add(33, 11);
});
```
8. 修改 package.json，**搜尋所有資料夾
```
"scripts": {
    "test": "mocha **/*.test.js"
},
```
9. `npm test` 執行測試
10. 加一行錯誤
`throw new Error('Value not correct!')`
11. 再執行 `npm test`，就會發現錯誤了
12. 加 if statement，回傳得到的錯誤值
```
if (res !== 44) {
    throw new Error(`Expected 44, but got ${res}.`)
}
```
13. 在 utils/utils.js 新增一個 module
`module.exports.square = (x) => x * x;`
14. 在 utils.utils.test.js 多新增一個 test
```
it ('should square a number', () => {
    var res = utils.square(3);

    if (res !== 9) {
        throw new Error(`Expected 9, but got ${res}.`)
    }
});
```
#### 監控和自動重啟測試
1. `nodemon --exec 'npm test'`
2. 在 package.json 直接新增 command
`"test-watch": "nodemon --exec \"npm test\""`
3. `npm run test-watch`
#### 使用 Assertion Library
1. [Assertion Library](https://github.com/mjackson/expect)
2. 安裝 expect `npm install expect@1.20.2 --save-dev`
3. 用 expect 簡化函數
```
const expect = require('expect');

const utils = require('./utils');

it('should add two numbers', () => {
    var res = utils.add(33, 11);

    expect(res).toBe(44).toBeA('number');
});

it ('should square a number', () => {
    var res = utils.square(3);

    expect(res).toBe(9).toBeA('number');
});

it ('should expect some values', () => {
    expect(12).toNotBe(12);
    expect({name: 'andrew'}).toNotEqual({name: 'Andrew'});
    expect([2, 3, 4]).toExclude(1);
    expect({
        name: 'Andrew',
        age: 25,
        location: 'Philadelphia'
    }).toExclude({
        age: 23
    })
});
```
4. 在 utils/utils.js 新增 module
```
module.exports.setName = (user, fullName) => {
    var names = fullName.split(' ');
    user.firstName = names[0];
    user.lastName = names[1];
    return user;
};
```
5. 用 expect 確認回傳的物件是正確值
```
// should verify first and last names are set
// assert it includes firstName and lastName with proper values
it ('should set firstName and lastName', () => {
    var user = {location: 'Philadelphia', age: 25};
    var res = utils.setName(user, 'Andrew Mead');

    expect(res).toInclude({
        firstName: 'Andrew',
        lastName: 'Mead',
        age: 25
    });
});
```
#### 測試非同步式程式碼
1. 在 utils/utils.js 新增一個 asyncAdd
```
module.exports.asyncAdd = (a, b, callback) => {
    setTimeout(() => {
        callback(a + b);
    }, 1000);
};
```
2. 在 utils/utils.test.js 測試 asyncAdd，這邊一定要使用 done，這樣才知道他是非同步，會等完成再執行 expect
```
it('should async add two numbers', (done) => {
    utils.asyncAdd(4, 3, (sum) => {
        expect(sum).toBe(7).toBeA('number');
        done();
    });
});
```
3. 在 utils/utils.js 新增一個 asyncSquare
```
module.exports.asyncSquare = (x, callback) => {
    setTimeout(() => {
        callback(x * x);
    }, 1000);
};
```
4. 在 utils/utils.test.js 測試 asyncSqure
```
it('should async square a number', (done) => {
    utils.asyncSquare(5, (res) => {
        expect(res).toBe(25).toBeA('number');
        done();
    });
});
```
#### 測試 Express 應用
1. 安裝 Express
`npm i express@4.14.0 --save`
2. 新增 server/server.js
```
const express = require('express');

var app = express();

app.get('/', (req, res) => {
    res.send('Hello world!');
});

app.listen(3000);
```
3. 執行 server
`node server/server.js `
4. 去瀏覽器輸入 `http://localhost:3000/` 就會看到 Hello world!
5. [SuperTest](https://github.com/visionmedia/supertest)
6. `npm i supertest@2.0.0 --save-dev`
7. 修改 server/server.js 輸出內容讓其它地方可用
`module.exports.app = app;`
8. 新增 server/server.test.js
```
const request = require('supertest');

var app = require('./server').app;

it('should return hello world response', (done) => {
    request(app)
        .get('/')
        .expect('Hello world!')
        .end(done);
});
```
9. 引入 expect，用 expect 客製化測試
```
const request = require('supertest');
const expect = require('expect');

var app = require('./server').app;

it('should return hello world response', (done) => {
    request(app)
        .get('/')
        .expect(404)
        .expect((res) => {
            expect(res.body).toInclude({
                error: 'Page not found.'
            });
        })
        .end(done);
});
```
10. 在 server/server.js 新增路由
```
// GET /users
// Give users a name prop and age prop
app.get('/users', (req, res) => {
    res.send([{
        name: 'Mike',
        age: 27
    }, {
        name: 'Andrew',
        age: 25
    }, {
        name: 'Jen',
        age: 26
    }]);
});
```
11. 在 server/server.test.js 新增測試
```
// Make a new test
// assert 200
// Assert that you exist in users array
it('should return my user object', (done) => {
    request(app)
        .get('/users')
        .expect(200)
        .expect((res) => {
            expect(res.body).toInclude({
                name: 'Andrew',
                age: 25
            });
        })
        .end(done);
});
```
#### 使用 describe() 組織測試
1. 修改 utils/utils.test.js
```
const expect = require('expect');

const utils = require('./utils');

describe('Utils', () => {

    describe('#add', () => {
        it('should add two numbers', () => {
            var res = utils.add(33, 11);

            expect(res).toBe(44).toBeA('number');
        });

        it('should async add two numbers', (done) => {
            utils.asyncAdd(4, 3, (sum) => {
                expect(sum).toBe(7).toBeA('number');
                done();
            });
        });
    });

    it ('should square a number', () => {
        var res = utils.square(3);

        expect(res).toBe(9).toBeA('number');
    });

    it('should async square a number', (done) => {
        utils.asyncSquare(5, (res) => {
            expect(res).toBe(25).toBeA('number');
            done();
        });
    });
});

// should verify first and last names are set
// assert it includes firstName and lastName with proper values
it ('should set firstName and lastName', () => {
    var user = {location: 'Philadelphia', age: 25};
    var res = utils.setName(user, 'Andrew Mead');

    expect(res).toInclude({
        firstName: 'Andrew',
        lastName: 'Mead',
        age: 25
    });
});

// it ('should expect some values', () => {
    // expect(12).toNotBe(12);
    // expect({name: 'andrew'}).toNotEqual({name: 'Andrew'});
    // expect([2, 3, 4]).toExclude(1);
    // expect({
    //     name: 'Andrew',
    //     age: 25,
    //     location: 'Philadelphia'
    // }).toExclude({
    //     age: 23
    // })
// });
```
2. 修改 server/server.test.js
```
const request = require('supertest');
const expect = require('expect');

var app = require('./server').app;

// Server
    // GET /
        // some test case
    // GET /users
        // some test case

describe('Server', () => {

    describe('GET /', () => {
        it('should return hello world response', (done) => {
            request(app)
                .get('/')
                .expect(404)
                .expect((res) => {
                    expect(res.body).toInclude({
                        error: 'Page not found.'
                    });
                })
                .end(done);
        });
    });

    describe('GET /users', () => {
        // Make a new test
        // assert 200
        // Assert that you exist in users array
        it('should return my user object', (done) => {
            request(app)
                .get('/users')
                .expect(200)
                .expect((res) => {
                    expect(res.body).toInclude({
                        name: 'Andrew',
                        age: 25
                    });
                })
                .end(done);
        });
    });
});
```
#### Test Spies
1. 新增 spies/db.js
```
module.exports.saveUser = (user) => {
    console.log('Saving the user', user);
};
```
2. 新增 spies/app.js
```
var db = require('./db');

module.exports.handleSignup = (email, password) => {
    // Check if email already exists
    db.saveUser({email, password});
    // Save the user to the database
    // Send the welcome email
};
```
3. 新增 spies/app.test.js
```
const expect = require('expect');

describe('App', () => {

    it('should call the spy correctly', () => {
        var spy = expect.createSpy();
        spy('Andrew', 25);
        expect(spy).toHaveBeenCalledWith('Andrew', 25);
    });

});
```
4. `npm install rewire@2.5.2 --save-dev`
5. 在 spies/app.test.js 使用 rewire 引入 app
`var app = rewire('./app');`
6. 用 describe 將 rewire 單元測試分類在一起
```
describe('App', () => {
    var db = {
        saveUser: expect.createSpy()
    };
    app.__set__('db', db);

    it('should call saveUser with user object', () => {
        var email = 'andrew@example.com';
        var password = '123abc';

        app.handleSignup(email, password);
        expect(db.saveUser).toHaveBeenCalledWith({email, password});
    });

});
```