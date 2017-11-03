---
title: React快速學習自我挑戰 Day12
thumbnail:
  - /images/learning/react/reactday12.jpg
date: 2017-04-03 14:41:19
categories: 學習歷程
tags: React
---
<img src="/images/learning/react/reactday12.jpg">

***
1. `{title.touched ? title.error : ''}`，如果 title.touched 是  true，顯示 title.error，如果不是，什麼都不要顯示。
2. ```{`form-group ${title.touched && title.invalid ? 'has-danger' : ''}`}```，如果 title 被 touched，而且 title 是 invalid，顯示 className "has-danger"，否則顯示空白 string。
3. 盡量避免使用 context。只有在我們使用 react-router 的時候再使用 context。
4. Create Post 是一個 action creator，action creator 可以創造一個 promise 當作他自己的 payload。當我們呼叫 action creator，就會產生一個當作 payload 的 promise，所以當 promise 解決以後，就等同於我們順利創建一個 post 了。
5. 要存取 react-router，我們必須定義 contextTypes。這告訴 react 我想要從 parent component 存取這個 property。
6. [Lorem Ipsum 產生器](http://www.lipsum.com/)。
7. redux thunk 是用來處理非同步的 action creator。
8. dispatch method 是 redux store 的一部份，包含了 application state。
9. [Firebase react library](https://www.firebase.com/docs/web/libraries/react/)。
