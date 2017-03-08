---
title: React快速學習自我挑戰 Day3
thumbnail:
  - /blogs/images/reactday3.png
date: 2017-03-07 22:13:59
categories: 學習歷程
tags: React
---
<img src="/blogs/images/reactday3.png">

***
1. 在 React 中，只有最上層的元件需要從 API 或 flux 取得資料。
2. 用 className 來當作平常在 html 看到的 class，以跟 class based function 做區別。
3. `function()`可以簡化為`() =>`。
4. React 處理 List 的時候，不要使用 for 迴圈，用 map 來取代。
5. React 會辨識變數是否為 List 或是 Array of Component。
6. 在處理 List 的時候，React會要求給每個 element 一個 ID。
7. 以下兩行一樣，下面為 ES6 語法。
    - `const VideoListItem = (props) => { const video = props.video;`
    - `const VideoListItem = ({video}) => {`
8. 以下兩行一樣，下面為 ES6 語法。(string interpolation)
    - `const url = 'https://www.youtube.com/embed/' + videoId;`
    - ```const url = `https://www.youtube.com/embed/${videoId}`;```
9. 降低 callback function 執行速度的套件 `lodash` 。
10. 在 class based component，我們將 state 設定在 constructor 裡面。
11. 範例中，四個元件用了兩個 callback function，我們要用 redux 來讓 callback 更乾淨。
12. 在 react 中用的 state 屬於 Component level，而在 redux 上面使用的則是 application level。
