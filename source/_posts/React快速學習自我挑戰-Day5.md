---
title: React快速學習自我挑戰 Day5
thumbnail:
  - /blogs/images/learning/react/reactday5.jpg
date: 2017-03-09 11:01:39
categories: 學習歷程
tags: React
---
<img src="/blogs/images/learning/react/reactday5.jpg">

***
1. Reducer 是一個 function 用來 return piece of the application state。
2. Reducer 產出 state 的值。
3. 在檔名的命名中，應該在前面加前綴，例如：`reducer_books.js`。(不是一定要，作者提供的方法)
4. Container 是 react component，對 Redux 所管理的 state 有直接的連結。
5. 有一個 Library 叫做 React-Redux，負責 React 和 Redux 的溝通橋樑。(本身 React 和 Redux 是完全分開的 Library)
6. Container 在 Redux 的官方文件中叫做 Smart Component。
7. 以整體來說，整個 App 並不在乎任何 state，而是由各個元件去在乎個別需要在乎的 state(所以 App 被稱為 dumb component)。
8. mapStateToProps 以陣列的形式得到 application state。
9. Redux 建構 application state，React 提供 View 來顯示 State，這兩個是不同的 Library，唯有透過 React-Redux 才能將這兩個連結。
10. 如果 application state 改變，Container 也會跟著 rerender。
11. 按按鈕 => 呼叫 action creator => action automatically sent to all reducers => reducer 可以選擇根據 action 來 return 不同的 state，然後將 state pipe into application => application state 會 pump back into React application，然後所有的 components 就會 rerender。
    - action creator 會 return 物件。
    - 在所有不同的 reducer 裡面，我們會設置一個 switch statement。
