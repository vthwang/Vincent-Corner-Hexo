---
title: React快速學習自我挑戰 Day9
thumbnail:
  - /blogs/images/reactday9.jpg
date: 2017-03-14 20:17:57
categories: 學習歷程
tags: React
---
<img src="/blogs/images/reactday9.jpg">

***
1. [React Sparkline(畫圖工具)](https://github.com/borisyankov/react-sparklines)。
2. class based component：有變數傳遞。 function based component：無變數傳遞。
3. action type 用 const 定義，這樣才能在 action 和 reducer 裡面指定 action type。
4. 在本專案中用的 middleware 就是 redux promise，我們用 redux promise 來處理收到的 promise，然後使用 axios 來產生 AJAX request，這個 middleware 會自動偵測我們提供的 promise 的 payload，middleware 會停止 action 並等到問題解決、promise 才會解決，middleware 就會從 request 把回傳的 data 拿來塞在 payload 這個 property，然後把 action 送到本專案的所有 reducer 中。
5. 雖然 Ajax request 本質上涉及非同步式語言，但我們完全不需要思考到非同步語言的部分。我們只要寫創造 action、然後流向 reducer，我們並不需要擔心任何 promise 或是 callback。
6. 我們從不做 state.weather.push 這樣的動作，不要直接修改 state，取而代之的是，我們 return 一個新物件來代替已經存在的 state。
