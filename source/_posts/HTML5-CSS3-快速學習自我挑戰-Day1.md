---
title: HTML5+CSS3 快速學習自我挑戰 Day1
thumbnail:
  - /images/learning/htmlcss/HtmlCssDay1.jpg
date: 2017-11-04 05:39:50
categories: 學習歷程
tags: 
    - HTML
    - CSS
---
<img src="/images/learning/htmlcss/HtmlCssDay1.jpg">

***
### 課程介紹
#### 學習內容
1. 動手做 HTML5、CSS3 和 jQuery
2. 製作七步驟，從草稿到完整的有功能且優化的網站
3. 簡單使用網站設計原則和訣竅
4. 如何取得且使用很棒的圖片、文字和圖標，全部免費
5. Responsive 網頁設計，讓不同的大小畫面都漂亮
6. 如何使用 jQuery 製作非常酷的動畫
7. 如何優化網站
8. 課程主要分為四部分
    - 網站設計基礎
    - 基礎 HTML 和 CSS
    - 用被應用在真實世界的七步驟完成很酷的網站
    - 優化網站
### 開始使用 HTML
#### 什麼是 HTML
1. HTML = Hyper Text Markup Language
2. HTML 檔案用 HTML 標籤來寫 `<h1> <p> <a>`
3. 標籤用來包裝元素的開始和結束 `<tagname>content</tagname>`
#### HTML 架構
1. HTML 裡面由 head 和 body 組成，在檔案開頭要宣告檔案類型
```
<!DOCTYPE html>
<html>
    <head>
        <title></title>
    </head>
    <body>
    </body>
</html>
```
#### 填滿架構
1. [Lorem Ipsum 產生器](https://www.lipsum.com/)
2. 常用 HTML 標籤
    - `<p></p>` 段落
    - `<strong></strong>` 粗體
    - `<em></em>` 斜體
    - `<u></u>` 底線
    - `<br>` 換行
#### 圖片和屬性
1. [隨機產生人像](https://randomuser.me/)
2. 引入圖片 `<img src="logo.jpg" alt="The HTML5 logo">`
#### 超連結
1. 超連結文字
`<a href="https://www.udemy.com" target="_blank">Link to Udemy</a>`
2. 超連結圖片
`<a href="logo.jpg" target="_blank">HTML logo</a>`
### CSS 格式
#### 開始使用 CSS
1. CSS = Cascading Style Sheets
2. CSS 定義 HTML 要長什麼樣子
3. HTML 是內容，CSS 是樣式
4. CSS 可以寫的地方
    - 加在 HTML tag 裡面
    - 加在 HTML 檔案裡面
    - 把 CSS code 放在外部檔案
5. 新增 style.css，然後在 index.html 引入
`<link rel="stylesheet" type="text/css" href="style.css">`
#### 開始讓網頁變漂亮
1. 修改 style.css 檔案
```
body {
    font-family: Helvetica Neue, Arial;
    font-size: 18px;
}

h1, h2 {
    color: green;

}

h1 {
    font-size: 40px;
}

h2 {
    font-size: 25px;
}

p {
    font-size: 18px;
    text-align: justify;
}
```
#### 顏色
1. RGB #RRGGBB 每個顏色最小 0，最大 ff
2. 要有透明度，則採用 rgba
#### Classes 和 IDs
1. id 只能用一次，用 # 表示
2. 在 sytle.css 新增 class
```
.main-text {
    text-align: justify;
}

.author-text {
    font-size: 22px;
}
```
3. 把前段的的 `<p>` 改成 `<p class="main-text">`，作者的 `<p>` 改成 `<p class="author-text">`
#### CSS box model
1. Box model 分為四部分
    - Content：文字，圖片..等等
    - Padding：在 Content 內部的透明區域，在 box 裡面
    - Border：在 Padding 和 Content 的外面
    - Margin：Boxes 之間的距離
<img src="/images/learning/htmlcss/css-model.png">
2. Box-sizing：CSS 同樣也可以定義整個 box width 和 Height，而不只有 Content
<img src="/images/learning/htmlcss/box-sizing.png">
3. 在 HTMTL，有 block 元素和 inline 元素，包含 Heading 和 Paragraph 都是 block 元素，而圖片，粗體和連結都屬於 inline 元素，inline 元素你只能設定它的 height 或是它的 width
4. 在 style.css 設定元素
```
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}
```
5. 設定 h1 `margin-bottom: 20px;` h2 `margin-bottom: 10px;` .main-text `margin-bottom: 20px;`
#### 建立一個簡單的版面編排
1. 新增網頁架構
```
<div class="container">
    <div class="blog-post">
        內文
    </div>

    <div class="other-posts">
        右邊選單欄
    </div>

    <div class="clearfix"></div>

    <div class="author-box">
        作者欄
    </div>
</div>
```
2. clearfix 處理換 row 的問題，margin 的值是 `top right bottom left`，float 是強制靠左，讓元素整合在一起
```
.clearfix:after {
    content: "";
    display: table;
    clear: both;
}

.container {
    width: 1140px;
    margin: 20px auto 0 auto;
}

.blog-post {
    width: 75%;
    float: left;
    padding-right: 30px;
}

.other-posts {
    width: 25%;
    float: left;
}

.author-box {
    padding-top: 20px;
    border-top: 1px solid #333;
}
```
#### 擦亮我們的 blog post
1. 把 html logo 放到內文第二部分，然後側邊選單欄新增內容
```
<div class="other-posts">
    <div class="other">
        The first other blog post
    </div>
    <div class="other">
        Yet another blog post
    </div>
    <div class="other">
        The best blog post ever: read this!
    </div>
</div>
```
2. 調整側邊欄的間距，作者欄的圖片大小且變成圓形，然後讓作者區塊的文字平行對齊
```
.author-text {
    font-size: 22px;
    float: left;
    margin-top: 30px;
    margin-left: 10px;
}

.other {
    margin-bottom: 40px;
}

.author-box img {
    height: 100px;
    width: 100px;
    border-radius: 50%;
    float: left;
}

.blog-post img {
    height: 150px;
    width: auto;

}
```
#### Relative 和 Absolute
1. 在 blog post 內文第一部分標題後面新增日期 `<p class="date">Nov 11th, 2017</p>`
2. 在 .blog-post 的 class 下的 position 設為 relative
```
.blog-post {
    ...
    position: relative;
}
```
3. 在 .date 的 position 設為 absolute 並調整間距
```
.date {
    position: absolute;
    top: 10px;
    right: 30px;
}
```
#### 開始使用 Chrome Developer Tools
1. Windows F12 開啟，Mac Command + Option + I