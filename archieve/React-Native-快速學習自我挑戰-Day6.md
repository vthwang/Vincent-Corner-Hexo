---
title: React Native 快速學習自我挑戰 Day6
thumbnail:
  - /blogs/images/learning/reactNative/reactnativeday6.png
date: 2017-08-18 19:54:13
categories: 學習歷程
tags: React-Native
---
<img src="/blogs/images/learning/reactNative/reactnativeday6.png">

***
### 深入了解 Redux
#### Redux 的基礎
1. 建立新專案
`react-native init tech_stack`
2. [JSPlaygrounds](https://stephengrider.github.io/JSPlaygrounds/)
3. Reducer：一個可以回傳一些資料的 function
4. Action：一個告訴 reducer 如何改變它的資料的物件
5. State：給 app 使用的資料
#### 更多 Redux
1. 簡易 Redux 範例
```
const reducer = (state = [], action) => {
	if (action.type === 'split_string') {
    return action.payload.split('');
  } else if (action.type === 'add_character') {
  	return [ ...state, action.payload ];
  }
  
  return state;
};

const store = Redux.createStore(reducer);

store.getState();

const action = {
  type: 'split_string',
  payload: 'asdf'
};

store.dispatch(action);

store.getState();

const action2 = {
  type: 'add_character',
  payload: 'd'
};

store.dispatch(action2);
store.getState();
```
#### Application 樣板
1. 安裝 redux
`npm install --save redux react-redux`
2. 新增 src/app.js
```
import React from 'react';
import { View } from 'react-native';

const App = () => {
    return (
        <View />
    );
};

export default App;
```
3. 刪除 ios.index.js 的所有內容，用以下取代
```
import { AppRegistry } from 'react-native';
import App from './src/app';

AppRegistry.registerComponent('tech_stack', () => App );
```
4. 在 app.js 引入函式庫
```
import { Provider } from 'react-redux';
import { createStore } from 'redux';
```
5. 新增 src/reducers/index.js
```
import { combineReducers } from 'redux';

export default combineReducers({
    libraries: () => []
});
```
6. 引入 reducers，將 reducers 放到 createStore 裡面
```
import reducers from './reducers';

const App = () => {
    return (
        <Provider store={createStore(reducers)}>
            <View />
        </Provider>
    );
};
```
#### 渲染 Header
1. 新增 src/components/common，把舊檔案複製進去
2. 引入 Header
`import { Header } from './components/common';`
3. 使用 Header
```
const App = () => {
    return (
        <Provider store={createStore(reducers)}>
            <View>
                <Header headerText="Tech Stack" />
            </View>
        </Provider>
    );
};
```
#### Data 的 Library List
1. 


















