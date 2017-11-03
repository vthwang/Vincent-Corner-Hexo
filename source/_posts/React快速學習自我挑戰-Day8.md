---
title: React快速學習自我挑戰 Day8
thumbnail:
  - /images/learning/react/reactday8.jpg
date: 2017-03-13 22:56:31
categories: 學習歷程
tags: React
---
<img src="/images/learning/react/reactday8.jpg">

***
1. Middleware 是一個 function，Middleware 可以選擇讓 action 通過，還可以操縱 action。
2. 在到達 reducer 之前，我們可以在 action 上的所有不同型態的小任務做 console.log 或 stop。
3. application state 擁有 application 全部的 data。
4. 新增 data 需要 dispatch 一個 action 來呼叫(action creactor)，然後他要 AJAX request 負責。
5. 在處理 action type 的時候，不可將不同型態的值傳遞到 reducer，需要先做 `export const FETCH_WEATHER = 'FETCH_WEATHER';`。
6. axios 是一個從瀏覽器製作 Ajax request 的 Library。
7. Promise 不包含任何 data。
8. Redux Promis 是一個 Middleware，在點擊任何 reducer 之前，Middleware 都可以選擇讓 action 通過，還可以操縱 action。
9. state.push 的用法會回傳一整個新的 array；用 state.concat 則是將新東西加上 array。
10. ES5 `return state.concat([action.payload.data]);` = ES6 `return [ action.payload.data, ...state ];`。
11. `{ weather }` === `{ weather: weather }`。