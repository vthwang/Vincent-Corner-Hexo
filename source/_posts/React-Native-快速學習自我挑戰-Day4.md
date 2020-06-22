---
title: React Native 快速學習自我挑戰 Day4
thumbnail:
  - /images/learning/reactNative/reactnativeday4.jpg
date: 2017-08-16 05:41:09
categories: Study Note
tags: React
toc: true-Native
toc: true
---
<img src="/images/learning/reactNative/reactnativeday4.jpg">

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
export * from './Button';
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
8. Text input 流程：TextInput => 使用者輸入 text => OnChange 事件被呼叫 => 給新的文字 「setState」=> 元件重新渲染
9. 新增 src/components/common/Input.js
```
import React from 'react';
import { TextInput, View, Text } from 'react-native';

const Input = ({ label }) => {
    return (
        <View>
            <Text>{label}</Text>
        </View>
    );
};

export { Input };
```
10. 在 common/index.js 加入 `export * from './Input';` 讓 input 可以到處存取
11. 修改 LoginForm.js，把 import react-native 刪除，新增 Input 到 common import
```
<Input
    value={this.state.text}
    onChangeText={text => this.setState({ text })}
/>
```
12. 修改 Input.js
```
const Input = ({ label, value, onChangeText }) => {
    return (
        <View>
            <Text>{label}</Text>
            <TextInput
                value={value}
                onChangeText={onChangeText}
                style={{ height: 20, width: 100 }}
            />
        </View>
    );
};

```
13. 在 Input.js 新增 styles 
```
const styles = {
    inputStyle: {
        color: '#000',
        paddingRight: 5,
        paddingLeft: 5,
        fontSize: 18,
        lineHeight: 23,
        flex: 2
    },
    labelStyle: {
        fontSize: 18,
        paddingLeft: 20,
        flex: 1
    },
    containerStyle: {
        height: 40,
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center'
    }
};
```
14. 在元件中加入 styles
```
const Input = ({ label, value, onChangeText }) => {
    const { inputStyle, labelStyle, containerStyle } = styles;

    return (
        <View style={containerStyle}>
            <Text style={labelStyle}>{label}</Text>
            <TextInput
                style={inputStyle}
                value={value}
                onChangeText={onChangeText}
            />
        </View>
    );
};
```
15. 在 LoginForm.js 加入 label
```
<Input
    label="Email"
    value={this.state.text}
    onChangeText={text => this.setState({ text })}
/>
```
16. 在 Input.js 加入 autoCorrect 且改成 false，讓 apple 不自動選取文字，新增 placeholder 參數
```
<TextInput
    placeholder={placeholder}
    autoCorrect={false}
    style={inputStyle}
    value={value}
    onChangeText={onChangeText}
/>
```
17. 取得上一層傳遞的 placeholder
`const Input = ({ label, value, onChangeText, placeholder }) => {`
18. 傳遞 placeholder 參數給 Input 元件
```
<Input
    placeholder="user@gmail.com"
    label="Email"
    value={this.state.text}
    onChangeText={text => this.setState({ text })}
/>
```
19. 把 state 改為 email，避免重複使用參數
```
state = { email: '' };

<CardSection>
    <Input
        placeholder="user@gmail.com"
        label="Email"
        value={this.state.email}
        onChangeText={email => this.setState({ email })}
    />
</CardSection>
```
20. 新增 password 欄位
```
state = { email: '', password: '' };

<CardSection>
    <Input
        placeholder="password"
        label="Password"
        value={this.state.password}
        onChangeText={password => this.setState({ password })}
    />
</CardSection>
```
21. 在 Input.js 加入 secureTextEntry
```
const Input = ({ label, value, onChangeText, placeholder, secureTextEntry }) => {
    const { inputStyle, labelStyle, containerStyle } = styles;

    return (
        <View style={containerStyle}>
            <Text style={labelStyle}>{label}</Text>
            <TextInput
                secureTextEntry={secureTextEntry}
                placeholder={placeholder}
                autoCorrect={false}
                style={inputStyle}
                value={value}
                onChangeText={onChangeText}
            />
        </View>
    );
};
```
22. 直接加入 secureTextEntry，它就會知道是 true，如果沒有設定就是 undefined，在這邊跟 false 的意思一樣
```
<CardSection>
    <Input
        secureTextEntry
        placeholder="password"
        label="Password"
        value={this.state.password}
        onChangeText={password => this.setState({ password })}
    />
</CardSection>
```