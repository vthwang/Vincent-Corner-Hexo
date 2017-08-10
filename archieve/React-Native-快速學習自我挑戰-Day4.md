---
title: React Native 快速學習自我挑戰 Day4
thumbnail:
  - /blogs/images/learning/reactNative/reactnativeday4.jpg
date: 2017-08-09 05:41:09
categories: 學習歷程
tags: React-Native
---
<img src="/blogs/images/learning/reactNative/reactnativeday4.jpg">

***
### 使用 Firebase 進行認證
#### 前置作業
1. 新增新的專案 `react-native init auth`
2. 新增 src/app.js
```
import React, { Component } from 'react';
import { View, Text } from 'react-native';

class App extends Component {
    render() {
        return (
            <View>
                <Text>An App!</Text>
            </View>
        );
    }
}

export default App;
```
3. 在 ios.index.js 把 app.js 放進來
```
import { AppRegistry } from 'react-native';
import App from './src/app';

AppRegistry.registerComponent('auth', () => App);
```
4. 將 Album 專案的 src/components/Button.js Card.js CardSection.js header.js 複製到新專案目錄的 src/components/common/ 底下
5. 在 src/components/common 底下新增 index.js
```
export * from './BUtton';
export * from './Card';
export * from './CardSection';
export * from './Header';
```
6. 在個別檔案用元件的方式輸出
`export { Button };`
`export { Card };`
`export { CardSection };`
`export { Header };`
#### Firebase
1. [Firebase](https://firebase.google.com/)
2. 在專案目錄下安裝 firebase `npm install --save firebase`
3. Import firebase，且在 app.js 的 component 下新增 componentWillMount
`import firebase from 'firebase';`
```
componentWillMount() {
    firebase.initializeApp({
        {CONFIG CODE FROM FIREBASE}
    });
}
```
4. 新增 src/components/LoginForm.js
```
import React, { Component } from 'react';
import { View } from 'react-native';
import { Button, Card, CardSection } from "./common";

class LoginForm extends Component {
    render() {
        return (
            <Card>
                <CardSection />
                <CardSection />
                <CardSection>
                    <Button>
                        Log in
                    </Button>
                </CardSection>
            </Card>
        );
    }
}

export default LoginForm;
```
5. 在 app.js 引用 LoginForm 且放到 View 裡面
`import LoginForm from './components/LoginForm';`
```
<View>
    <Header headerText="Authentication" />
    <LoginForm />
</View>
```
6. 在 LoginForm.js 新增輸入欄位
`import { TextInput } from 'react-native';`
```
<CardSection>
    <TextInput style={{ height: 20, width: 100 }} />
</CardSection>
```
7. 產生 state
`state = { text: '' };`
```
<CardSection>
    <TextInput
        value={this.state.text}
        onChangeText={text => this.setState({ text })}
        style={{ height: 20, width: 100 }}
    />
</CardSection>
```









