---
title: React Native 快速學習自我挑戰 Day1
thumbnail:
  - /images/learning/reactNative/reactnativeday1.png
date: 2017-08-03 18:50:32
categories: 學習歷程
tags: React-Native
---
<img src="/images/learning/reactNative/reactnativeday1.png">

***
### 開始課程
#### 第一支程式的 Roadmap
1. 在每個作業系統安裝 dependencires
2. 針對不同編輯器安裝不同的 ESLint
3. 生成 React Native 專案
4. [課程 Repo](https://github.com/StephenGrider/ReactNativeReduxCasts)
### 在不同的系統部署環境
#### OSX 安裝流程
1. 了解 Dependency 的用途
    - XCode：打包程式和 React Natvie Library 到可安裝的 app，然後用 iOS 模擬器運行
    - HomeBrew：被用來安裝 node
    - Node/NPM：Node 在瀏覽器之外運行 JavaScript，NPM 被用來安裝和管理 dependencies，Node 和 NPM 會在一起
    - watchman：在硬碟上監控檔案，等待它們被改變
    - RN CLI：React Native Command Line 界面，用來產生新的 React Native 專案
2. 依序安裝
3. 開啟專案 `react-native run-ios`
#### Windows 安裝流程
1. 必須安裝的軟體
    - python 2.7
    - node
    - JAVA SDK
    - Android Studio
    - `npm install -g react-native-cli --no-optional`
2. 開啟 Android Studio，修正所有錯誤，開啟 AVD，啟動一個模擬器
3. 設定環境變數，JAVA\_HOME，值為 **C:\Program Files\Java\jdk\_版本號**，另外將 **C:\Users\使用者名稱\AppData\Local\Android\sdk\platform-tools** 加入 path 環境變數
4. 開啟專案 `react-native run-android`
### ESLint 設定 (VS code)
1. `npm install eslint -g` 全域安裝 ESLint
2. `npm install --save-dev eslint-config-standard`
3. 在專案根目錄新增檔案 **.eslintrc**
4. 在 .eslintrc 新增以下內容
```
{
    "extends": "standard"
}
```
### 向前進！
1. [React Native 安裝疑難排解](https://rallycoding.com/blog/troubleshooting-react-native-startup/)
2. 從 ios.index.js 開始，先刪除所有檔案，首先引入函式庫
```
import React from 'react';
import ReactNative from 'react-native';
```
3. React vs React Native
    - React 知道 compoent 該怎麼表現
    - React 知道如何拿一堆 components 且讓他們一起運作
    - React Native 知道如何從 component 取得 output 且將它呈現在螢幕上
    - React Native 提供核心套件 (image, text)
4. 創建一個 Component
```
const App = () => {
    return (
        <Text>Some Text</Text>
    );
};
```
5. 將套件內容讀取出來
`ReactNative.AppRegistry.registerComponent('albums', () => App);`
6. 將 `ReactNative` 取代為 `{ Text, AppRegistry }`，這樣的做法就是只使用 ReactNative 裡面的 Text 元件
`import { Text, AppRegistry } from 'react-native';`
`AppRegistry.registerComponent('albums', () => App);`
7. 創建 Component 的部分可以簡化
```
const App = () => (
    <Text>Some Text</Text>
);
```
8. 新增一個檔案 src/components/header.js
9. 在 header.js 引入函式庫
```
import React from 'react';
import { Text } from 'react-native';
```
10. 製作 Component
```
const Header = () => {
    return <Text>Albums!</Text>;
};
```
11. 接下來要讓 Component 可以在 app 的其它部分使用，但是只有 root Component 才用 "AppRegistry"，在這邊我們使用`export default Header;`
12. 在 root 呼叫 Component
`import Header from './src/components/header';`
13. 再來直接將 Header 放在 Component 裡面
```
const App = () => (
    <Header />
);
```
### 處理樣式問題
1. 在 header.js 新增樣式
```
const styles = {
    textStyle: {
        fontSize: 20
    }
};
```
2. 將樣式加入 component
```
const Header = () => {
    const { textStyle } = styles;

    return <Text style={textStyle}>Albums!</Text>;
};
```
3. 引入 view `import { Text, View } from 'react-native';`
4. 新增 viewStyle
```
const styles = {
    viewStyle: {
        backgroundColor: '#F8F8F8'
    },
    textStyle: {
        fontSize: 20
    }
};
```
5. 使用 viewStyle
```
const Header = () => {
    const { textStyle, viewStyle } = styles;

    return (
        <View style={viewStyle}>
            <Text style={textStyle}>Albums!</Text>
        </View>
    );
};
```
6. 使用 flexbox
    - justifyContent: 'flex-end' 將物件移至垂直最下方
    - justifyContent: 'center' 將物件移至垂直中間
    - justifyContent: 'flex-start' 將物件置於垂直上方，其實就是預設
    - alignItems: 'flex-start' 將物件置於水平上方，其實就是預設
    - alignItems: 'center' 將物件移至水平中間
    - alignItems: 'flex-end' 將物件移至水平最右方
7. 修改 viewStyle
```
viewStyle: {
        backgroundColor: '#F8F8F8',
        justifyContent: 'center',
        alignItems: 'center',
        height: 60,
        paddingTop: 15,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.2,
        elevation: 2,
        position: 'relative'
    },
```
#### 讓 Header 可以再使用
1. 將本來文字的地方用 props 取代 `{props.headerText}`
2. 另外要將 props 的變數放入 function `const Header = (props) => {`
3. 在 index 的 component 裡面放入 props `<Header headerText={'Albums'} />`