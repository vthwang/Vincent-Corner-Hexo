---
title: React快速學習自我挑戰 Day2
thumbnail:
  - /blogs/images/reactday2.png
date: 2017-03-06 10:13:59
categories: 學習歷程
tags: React
---
<img src="/blogs/images/reactday2.png">

***
1. 從 node modules 呼叫 react：`import React from 'react';`。
2. 從 node modules 呼叫 react-dom：`import ReactDOM from 'react-dom';`。
3. React Render 要用元件方式包裝：`<App />`。
4. 指定 Render 的地方：`document.querySelector('.container')`。
5. 每個檔案都只能有一個元件。
6. Youtube API 的使用。
    - 註冊 Youtube API Key。
        * 前往[Goolge開發者界面](https://console.developers.google.com)。
        * 點選左方選單的 Library。
        * 搜尋 Youtube，並選擇「YouTube Data API v3」。
        * Enable 該套件。
        * 選擇左方選單的 Credentials。
        * Create Credentials => API key => Restrict Key。
        * 設定名稱，設定類別為「HTTP referrers (web sites) 」
        * Save => 拿到 API Key
    - 安裝 Youtube API 套件。
        * Youtube API Search
        * `npm install --save youtube-api-search`
7. 輸出值：`export default SearchBar;`。
8. 得到輸出值：`import SearchBar from './components/search_bar';`(需要包含路徑)。
9. Class Base Method: `class SearchBar extends React.Component`。
10. 語法糖：`import React, { Component } from 'react';` 等於
    `import React from 'react';`
    `const Component = React.Component;`
11. React 處理事件有兩個步驟。
    - Declare "Event handler" => 當事件發生時啟動 handler
    - Pass "Event handler" => 直接跳到我們想對事件顯示的某元素
12. State 是 React 最令人困惑的部分。
    - 定義：State 是 JS 純物件，且用來記錄和對使用者事件做反應。不論元件的 State 是否改變、元件是否立刻 Render或是子原件也重新 Rerender，每一個 Class based 元件都有自己的 State Object。
13. 所有的 JS classes 都有一個名為 constructor 的特別函式。
14. class 的元件用來追蹤 State 的狀態或是值需要持續改變；functional 的元件用來取得某些資訊。

***
建立搜尋欄位
```
const SearchBar = () => {
  return <input />
};
```
即時顯示值
this.state => 創建一個 term 的空值。
this.setState => 得到現在 input 裡面的值(並非直接改變)。
value={this.state.term} => 取得 this.state 的值。
```
class SearchBar extends Component {
  constructor(props) {
    super(props);

    this.state = { term: '' };
  }

  render() {
    return (
      <div>
        <input
          value={this.state.term}
          onChange={event => this.setState({ term: event.target.value })} />
        Value of the input: {this.state.term}
      </div>
    );
  }
}
```
