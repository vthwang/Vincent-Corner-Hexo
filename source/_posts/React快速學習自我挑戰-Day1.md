---
title: React快速學習自我挑戰 Day1
thumbnail:
  - /blogs/images/react.png
date: 2017-03-05 21:00:59
categories: 學習歷程
tags: React
---
<img src="/blogs/images/react.png">

***
1. Reactjs 和 Redux 有 Library 可以使用。
2. 瀏覽器尚未支援 ES6。
3. 完成的檔案用 webpack + babel 來 transpile 變成網頁。
  - index.html
  - application.js
  - style.css

***
起手專案(boilerplate)：React + Youtube API
直接在 Command line 開 atom： `atom .`
1. Component 是 JS 的 Function 的組合，用來生成 HTML。
2. 使用 const 取變數，代表不改變的值；用 var 取變數，代表會改變的值。
3. JSX 是一種 JavaScript 的類別，允許我們可以寫 HTML 在 JavaScript 裡面。
4. 寫 index.js 的邏輯
  - 創建一個元件，元件應該可以產生 HTML。
  - 把創建好的元件產生 HTML，然後放到頁面上(這個動作叫做 Render)。

***
JSX 轉換範例(使用[babel轉換工具](https://babeljs.io/repl))
轉換前(1)
```
const App = function() {
  return <div>Hi!</div>;
}
```
轉換後(1)
```
var App = function App() {
  return React.createElement(
    "div",
    null,
    "Hi!"
  );
};
```
***
轉換前(2)
```
const App = function() {
  return <ol>
    <li>1</li>
    <li>2</li>
    <li>3</li>
  </ol>;
}
```
轉換後(2)
```
var App = function App() {
  return React.createElement(
    "ol",
    null,
    React.createElement(
      "li",
      null,
      "1"
    ),
    React.createElement(
      "li",
      null,
      "2"
    ),
    React.createElement(
      "li",
      null,
      "3"
    )
  );
};
```
