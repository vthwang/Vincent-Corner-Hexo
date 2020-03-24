---
title: React Native 快速學習自我挑戰 Day5
thumbnail:
  - /images/learning/reactNative/reactnativeday5.png
date: 2017-08-17 16:39:32
categories: Study Note
tags: React-Native
---
<img src="/images/learning/reactNative/reactnativeday5.png">

***
### 處理 Authentication Credentials
#### 讓 User 登入
1. 在送出 button 地方，要取得值之後，做 callback function
2. 在送出的 button 加上 onPress 來取得值
`<Button onPress={this.onButtonPress.bind(this)}>`
3. 在 LoginForm.js 引入 firebase
`import firebase from 'firebase';`
4. 新增 onButtonPress 的 callback function
```
onButtonPress() {
        const { email, password } = this.state;

        firebase.auth().signInWithEmailAndPassword(email, password);
    }
```
5. 登入的三種模式
    - 登入 => 成功
    - 登入 => 失敗 => 創建帳號 => 成功
    - 登入 => 失敗 => 創建帳號 => 失敗 => 出現錯誤
#### 錯誤處理
1. 點擊之後，用 catch 來處理失敗的 Promise，最後顯示出 error，error 要新增一個空白的 state 讓它去改變
```
state = { email: '', password: '', error: '' };

    onButtonPress() {
        const { email, password } = this.state;

        firebase.auth().signInWithEmailAndPassword(email, password)
            .catch(() => {
                firebase.auth().createUserWithEmailAndPassword(email, password)
                    .catch(() => {
                        this.setState({ error: 'Authentication Failed.'})
                    });
            });
    }
```
2. 把 Text 補回來，因為要讓 error 顯示
`import { Text } from 'react-native';`
3. 新增 Text 區塊來顯示 error
```
<Text style={styles.errorTextStyle}>
    {this.state.error}
</Text>
```
4. 新增 error Text 的 style 樣式
```
const styles = {
    errorTextStyle: {
        fontSize: 20,
        alignSelf: 'center',
        color: 'red'
    }
};
```
#### 更多 Authentication Flow
1. 在登入錯誤的密碼之後，如果又正確登入，要把錯誤訊息移除，所以要在 onPress 的 callback function 裡面把 state 設為預設空值
`this.setState({error: ''});`
2. 為了要讓送出的時候，等候存取資料庫回覆前，要做一個旋轉圖示 Spinner 讓用戶知道在等候，新增 src/components/Spinner.js
```
import React from 'react';
import { View } from 'react-native';

const Spinner = () => {
    return (
        <View />
    );
};

export { Spinner };
```
3. 在 components/index.js 新增 component
`export * from './Spinner';`
#### 建立一個活動 Spinner
1. 新增 ActivityIndicator
`import { View, ActivityIndicator } from 'react-native';`
2. 新增 spinner styles
```
const styles = {
    spinnerStyle: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center'
    }
};
```
3. 將 style 加到 View，然後從上層元件取得 size props，最後用預設的方式，如果沒有 size 的 props，預設 large
```
const Spinner = ({ size }) => {
    return (
        <View style={styles.spinnerStyle}>
            <ActivityIndicator size={size || 'large'} />
        </View>
    );
};
```
#### JSX 中有條件的渲染
1. 預設不顯示 loading
`state = { email: '', password: '', error: '', loading: false };`
2. 在 onButtonPress 的 callback function 加上 loading true，做法就是在點選登入時，清掉所有錯誤，然後顯示 Loading
`this.setState({error: '', loading: true });`
3. 把 Spinner 的元件也 load 進來
`import { Button, Card, CardSection, Input, Spinner } from "./common";`
4. 新增一個 renderButton 的 function，如果 this.state.loading === true，就 return spinner，如果不是，就 return 本來的 Button
```
renderButton() {
    if (this.state.loading) {
        return <Spinner size="small" />;
    }

    return (
        <Button onPress={this.onButtonPress.bind(this)}>
            登入
        </Button>
    )
}
```
5. 最後把本來送出 Button 的地方用 renderButton 的 function 取代
```
<CardSection>
    {this.renderButton()}
</CardSection>
```
#### 清除表單 Spinner
1. 建立 LoginSuccess function
```
onLoginSuccess() {
    this.setState({
        email: '',
        password: '',
        loading: false,
        error: ''
    });
}
```
2. 建立 LoginFail function
```
onLoginFail() {
    this.setState({ error: 'Authentication Failed', loading: false });
}
```
3. 送出表單時候，正確的話，執行 .then 裡面的 function，錯誤的話，執行 .catch 裡面的 function
```
firebase.auth().signInWithEmailAndPassword(email, password)
    .then(this.onLoginSuccess.bind(this))
    .catch(() => {
        firebase.auth().createUserWithEmailAndPassword(email, password)
            .then(this.onLoginSuccess.bind(this))
            .catch(this.onLoginFail.bind(this));
    });
```
#### 處理 Authentication 事件
1. 新增一個 state 叫做 loggedIn，預設為未登入，然後在 componentWillMount 新增 onAuthStateChanged 的 function，如果是 user 就登入
```
state = { loggedIn: false };

componentWillMount() {
    firebase.auth().onAuthStateChanged((user) => {
        if (user) {
            this.setState({ loggedIn: true});
        } else {
            this.setState({ loggedIn: false });
        }
    });
}
```
#### 更多有條件的渲染
1. 把 loggedIn 的 state 改成 null，然後新增 renderContent，登入時在讀取資料會先跑出 Spinner，成功的話就顯示登出的 Button，失敗的話就回到登入表單
```
state = { loggedIn: null };

renderContent() {
    switch (this.state.loggedIn) {
        case true:
            return <Button>登出</Button>;
        case false:
            return <LoginForm />;
        default:
            return <Spinner size="large"/>;
    }
}
```
2. 引入 Button 和 Spinner
`import { Header, Button, Spinner } from './components/common';`
3. 修改 button 樣式，修改 src/component/common/Button.js
```
import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';

const Button = ({ onPress, children }) => {
    const { buttonStyle, textStyle, viewStyle } = styles;

    return (
        <View style={viewStyle}>
            <TouchableOpacity onPress={onPress} style={buttonStyle}>
                <Text style={textStyle}>
                    {children}
                </Text>
            </TouchableOpacity>
        </View>
    );
};

const styles = {
    textStyle: {
        alignSelf: 'center',
        color: '#007aff',
        fontSize: 16,
        fontWeight: '600',
        paddingTop: 10,
        paddingBottom: 10
    },
    viewStyle: {
        flexDirection: 'row',
    },
    buttonStyle: {
        flex: 1,
        alignSelf: 'stretch',
        justifyContent: 'center',
        height: 45,
        backgroundColor: '#fff',
        borderRadius: 5,
        borderWidth: 1,
        borderColor: '#007aff',
        marginLeft: 5,
        marginRight: 5
    }
};

export { Button };
```
#### 讓 User 登出和結束
1. 用 firebase 的語法讓用戶登出
```
return (
    <Button onPress={() => firebase.auth().signOut()}>
        登出
    </Button>
);
```