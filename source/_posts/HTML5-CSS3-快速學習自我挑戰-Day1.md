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













