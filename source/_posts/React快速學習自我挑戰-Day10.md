---
title: React快速學習自我挑戰 Day10
thumbnail:
  - /images/learning/react/reactday10.jpg
date: 2017-03-22 10:16:50
categories: 學習歷程
tags: React
---
<img src="/images/learning/react/reactday10.jpg">

***
1. [Redux Blog Post API Reference](http://reduxblog.herokuapp.com/)。
2. Postman 是一個 HTTP client 的 API。
3. `npm install --save react-router@2.0.0-rc5`，安裝 react router。
4. React-Router 套件有 History 的子套件，用來管理網頁的 URL，監控改變並隨著時間更新。
5. History 對 URL 互動，並將更新傳送給 React-Router，React-Router 拿到 URL 之後並根據 URL 決定哪個 React Component 需要更新。
6. Router 是一個當 URL 改變時，我們需要決定哪個 React Component 需要重新 render 的物件。
7. browserHistory 是一個告訴 React-Router 如何 interpret URL changes 物件。
8. History 有 browserHistory、hashHistory、memoryHistory 可以使用。
9. IndexRoute 是一個做起來像是 Route，但是當 URL 符合我們所定義的 parent path 才會出現的 helper。