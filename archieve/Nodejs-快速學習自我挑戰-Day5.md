---
title: Nodejs 快速學習自我挑戰 Day5
thumbnail:
  - /blogs/images/learning/nodejs/nodejsday5.jpg
date: 2017-06-14 11:24:09
categories: 學習歷程
tags: Nodejs
---
<img src="/blogs/images/learning/nodejs/nodejsday5.jpg">

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















