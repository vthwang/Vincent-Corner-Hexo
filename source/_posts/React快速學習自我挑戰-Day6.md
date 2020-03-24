---
title: React快速學習自我挑戰 Day6
thumbnail:
  - /images/learning/react/reactday6.png
date: 2017-03-10 13:02:52
categories: Study Note
tags: React
---
<img src="/images/learning/react/reactday6.png">

***
1. 當知道 action creactor 將要呼叫(但不知道什麼時候)，當被呼叫的時候，我想要確定 flow 的結果能夠經過 dispatch function，然後這個 dispatch function 會像是漏斗般的接收這些 actions，最後再把 actions 分別送回不同的 reducers。
2. action 通常有兩種值：type 和 payload。
3. 不管 action 有沒有 dispatch，reducer 都會被呼叫，所以 function 隨時會頻繁的被呼叫，因為 action 不在乎任何時間、任何特定的 reducer。
4. 用來 combine reducer 的 object 的任何 key 都會以 global state key 的方式結尾。
5. 當想要做一個可以直接接觸 redux state 的 component，就要用 container。
6. 定義一個 function 呼叫 Map state 來 process ，然後我們 connect book detail 的 props。
7. Redux 控制整個 application 的 state，state 是 single plain javascript object。
8. Component state 跟 application state 是完全分離的。
9. 用 combineReducer 的方法可以將 reducer 全部連結在一起。
    - function 內每一個 key 都會指定一個 reducer，然後 reducer 必須對創造 state 負責。
10. reducer 負責隨著時間改變 application state，這個是透過 action 來使用。
11. 當有一個 action dispatch，action 會流過 application 內不同的 reducer；所以每一個 reducer 有選擇的根據收到不同的 action type 來 return state。
12. action creator 是一個  simple function 來 return 一個 action，action 是 single plain javascript object。