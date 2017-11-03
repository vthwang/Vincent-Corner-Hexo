---
title: React快速學習自我挑戰 Day7
thumbnail:
  - /images/learning/react/reactday7.png
date: 2017-03-11 20:15:40
categories: 學習歷程
tags: React
---
<img src="/images/learning/react/reactday7.png">

***
1. React Component 只負責顯示 data，而 Redux 則負責提取 data。
2. 設計一個元件的時候，記得要先問自己該元件是 Container 還是 Component。
3. 基本上需要跟 Redux 溝通的就是 Container。
4. 下面範例中，this (就是 SearchBar) 有一個 function 叫做 onInputChange，然後把這個 function bind 到 this，然後把得到值放到下方的 onInputChange 裡面。
```
constructor(props) {
        super(props);

        this.state = { term: '' };

        this.onInputChange = this.onInputChange.bind(this);
    }

    onInputChange(event) {
        this.setState({ term: event.target.value })
    }
```
5. 如果不希望 User 一直重新整理頁面，我們可以加 event handler。
6. [open weather API](http://openweathermap.org/forecast5)。
    - sign up 之後，進入 API Key 的頁面，就可以拿到 API key 囉！
7. [JSON Formatter (chrome 外掛)](https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa/related)。