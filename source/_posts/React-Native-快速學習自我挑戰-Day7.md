---
title: React Native 快速學習自我挑戰 Day7
thumbnail:
  - /images/learning/reactNative/reactnativeday7.png
date: 2018-06-12 09:51:47
categories: Study Note
tags: React-Native
---
<img src="/images/learning/reactNative/reactnativeday7.png">

***
### 還沒完成
#### 下一個 App 的概覽
1. 這個篇章要講 Navigation，開啟一個新專案
`react-native init manager`
#### 這個 App 的挑戰
1. 需要使用在登入畫面使用 Redux-ify
2. Header 的內容需要隨著螢幕去改變
3. 每一個使用者都應該要有自己的內容
4. 需要能夠打入文字
5. 需要全螢幕的 overlay
#### 再稍微做一下設定
1. 安裝 react-redux 和 redux 套件，記得 react-redux 是用來串聯 react 和 redux 的套件
`npm install --save react-redux redux`
2. 修改根目錄的 index.js
```
import { AppRegistry } from 'react-native';
import App from './src/App';

AppRegistry.registerComponent('manager', () => App);
```
3. 新增 src/App.js
```
import React, { Component } from 'react';
import { View, Text } from 'react-native';
import { Provider } from 'react-redux';
import { createStore } from 'redux';

class App extends Component {
    render() {
        return (
            <Provider store={createStore()}>
                <View>
                    <Text>
                        Hello!
                    </Text>
                </View>
            </Provider>
        );
    }
}

export default App;
```
#### 更多模板設定
1. 新增預設的 reducer，新增 src/reducers/index.js
```
import { combineReducers } from 'redux';

export default combineReducers({
    banana: () => []
});
```
2. 在 src/App.js 引入 reducer 並使用它
```
import reducers from './reducers';

<Provider store={createStore(reducers)}>
```
3. 安裝 Firebase
`npm install --save firebase`
4. 在 src/App.js 引入 firebase 並載入設定檔案
```
import firebase from 'firebase';

componentWillMount() {
    const config = {
        apiKey: '',
        authDomain: '',
        databaseURL: '',
        projectId: '',
        storageBucket:'',
        messagingSenderId: ''
    };

    firebase.initializeApp(config);
}
```
### 處理資料 React 和 Redux 做比較
#### 在 Redux 世界的登入表單
1. 登入表單的四個 component state
    - email
    - password
    - loading
    - error
2. state 的傳遞方式，「email」、「password」=> 登入確認 => 「loading」、「error」
#### 重建登入表單
1. 複製上一個專案的 src/components/common 到 src/components/common
2. 新增 src/components/LoginForm.js
```
import React, { Component } from 'react';
import { Card, CardSection, Input, Button } from './common';

class LoginForm extends Component {
    render() {
        return (
            <Card>
                <CardSection>
                    <Input
                        label="Email"
                        placeholder="email@gmail.com"
                    />
                </CardSection>
                <CardSection>
                    <Input
                        label="Password"
                        placeholder="password"
                    />
                </CardSection>
                <CardSection>
                    <Button>
                        Login
                    </Button>
                </CardSection>
            </Card>
        );
    }
}

export default LoginForm;
```
3. 在 App.js 引入 LoginForm，然後使用 LoginForm
```
import LoginForm from './components/LoginForm';

render() {
    return (
        <Provider store={createStore(reducers)}>
            <LoginForm/>
        </Provider>
    );
}
```
#### 使用 Action Creators 來處理表單更新
1. Redux 運作的邏輯
    - 使用者輸入內容
    - 使用新文字來呼叫 Action Creator
    - Action Creator 回傳一個 Action
    - Action 傳送給所有 Reducers
    - Reducers 計算新的 State
    - State 傳送給所有 Componenets
    - Components 重新渲染新的畫面
    - 等待新的改變...回到第一個動作
2. 在 src/components/LoginForm.js 的 Email Input 新增 onChange 事件
```
<Input
    label="Email"
    placeholder="email@gmail.com"
    onChangeText={this.onEmailChange.bind(this)}
/>
```
3. 在 src/components/LoginForm.js 將 onChange 事件獨立
```
onEmailChange(text) {

}
```
4. 新增 src/actions/index.js 新增 emailChanged 的 Action Creator
```
export const emailChanged = (text) => {
    return {
        type: 'email_changed',
        payload: text
    };
};
```
#### 完成 Action Creator
1. 在 src/components/LoginForm.js 跟 Action Creator 做連結
```
import { connect } from 'react-redux';
import { emailChanged } from "../actions";

onEmailChange(text) {
    this.props.emailChanged(text)
}

export default connect(null, { emailChanged })(LoginForm);
```
2. 修改 src/reducers/index.js
```
import { combineReducers } from 'redux';
import AuthReducer from './AuthReducer';

export default combineReducers({
    auth: AuthReducer
});
```
3. 新增 src/reducers/AuthReducer.js
```
const INITIAL_STATE = { email: '' };

export default (state = INITIAL_STATE, action) => {
    switch (action.type) {
        default:
            return state;
    }
}
```
#### Typed Actions
1. Typed Actions 主要是為了避免寫程式上輸入的錯誤，所以特別把它獨立出來
2. 新增 src/actions/types，用 const 的方式輸出
`export const EMAIL_CHANGED = 'email_changed';`
3. 在 src/actions/index.js 引入 types.js，將變數改為 EMAIL_CHANGED
```
import { EMAIL_CHANGED } from "./types";

export const emailChanged = (text) => {
    return {
        type: EMAIL_CHANGED,
        payload: text
    };
};
```
4. 在 src/reducers/AuthReducer.js 的地方也引入 EMAIL_CHANGED
```
import { EMAIL_CHANGED } from "../actions/types";

export default (state = INITIAL_STATE, action) => {
    switch (action.type) {
        case EMAIL_CHANGED:

        default:
            return state;
    }
}
```
### 不要讓 State 異變
#### 一成不變的 State
1. 觀察以下程式碼，最後會發現 `newState === state`，原因就是 state 會連結物件，在以下範例中，state 和 newState 連結的會是一樣的物件，最後就會得到 `newState === state` 的結果
    - `const state = {}`
    - `const newState = state`
    - `newState.color = 'red';`
#### 建立一成不變的 State
1. 在 src/reducers/AuthReducer.js 的 case EMAIL_CHANGED 回傳物件 {}，這邊的意思是說把所有的 state 讀回來，然後把 email 這個變數放到所有的 state，如果所有的 state 有 email 的話，則會用新的覆蓋
```
case EMAIL_CHANGED:
    return { ...state, email: action.payload };
```
2. mapStateToProps function 用來取得某個部份的 state 到我們的 components 裡面
#### 更多關於建立一成不變的 State
1. 在 src/components/LoginForm.js 新增 onPasswordChange 的 function，然後跟資料流連結
```
import { emailChanged, passwordChanged } from "../actions";

onPasswordChange(text) {
    this.props.passwordChanged(text);
}

// 修改 Password Input 的值
onChangeText={this.onPasswordChange.bind(this)}
value={this.props.password}

const mapStateToProps = state => {
    return {
        email: state.auth.email,
        password: state.auth.password
    };
};

export default connect(mapStateToProps, { emailChanged, passwordChanged })(LoginForm);
```
2. 修改 src/actions/index.js 新增 passwordChanged 的 Action
```
import {
    EMAIL_CHANGED,
    PASSWORD_CHANGED
} from "./types";


export const passwordChanged = (text) => {
    return {
        type: PASSWORD_CHANGED,
        payload: text
    }
};
```
3. 在 src/actions/types.js 新增 PASSWORD_CHANGED
`export const PASSWORD_CHANGED = 'password_changed';`
4. 在 AuthReducer 新增 PASSWORD 的 case
```
import {
    EMAIL_CHANGED,
    PASSWORD_CHANGED
} from "../actions/types";

const INITIAL_STATE = {
    email: '',
    password: ''
};

export default (state = INITIAL_STATE, action) => {
    switch (action.type) {
        case EMAIL_CHANGED:
            return { ...state, email: action.payload };
        case PASSWORD_CHANGED:
            return { ...state, password: action.payload };
        default:
            return state;
    }
}
```
#### 同步和異步的 Action Creators
1. 預計使用的 State
    - email：當使用者在 email 欄位輸入文字的時候要改變
    - password：當使用者在 password 欄位輸入文字的時候要改變
    - loading：當開始傳送認證請求的時候為 True，當完成的時候則為 False
    - error：預設是 empty string，當我們在認證請求失敗的時候，就要將 error 訊息傳到這個欄位
    - user：預設是 null，當成功認證的時候，放到 user model
2. 在 js 裡面，執行一個 function 最後都要 return 東西回來，如果有 Ajax 請求的話，就要用特別的方式處理。
#### 介紹 Redux Thunk
1. 安裝 redux-thunk
`npm install --save redux-thunk`
2. 預設 Action Creator 規則
    - Action Creator 都是 functions
    - 一定要 return action
    - Action 是一個有 'type' 值的 object
3. 使用 Thunk 的 Action Creator 規則 (本來上面的規則一樣可用)
    - Action Creator 都是 functions
    - 一定要 return function
    - function 會使用 dispatch 來呼叫
4. Thunk 的方式就可以允許我們用手動的方式去 dispatch 一個 action 來呼叫所有不同的 reducers
5. 新增一個 action 到 src/actions/index.js
```
import firebase from 'firebase';

export const loginUser = ({ email, password }) => {
    firebase.auth().signInWithEmailAndPassword(email, password)
        .then(user => console.log(user));
};
```
#### 運用 Redux Thunk
1. 修改 src/App.js 把 redux-thunk 呼叫進來
```
import ReduxThunk from 'redux-thunk';

render() {
    const store = createStore(reducers, {}, applyMiddleware(ReduxThunk));

    return (
        <Provider store={store}>
            <LoginForm/>
        </Provider>
    );
}
```
2. Redux Thunk 的流程
    - Action Creator 被呼叫
    - Action Creator 回傳一個 function
    - Redux Thunk 看我們回傳了一個 function 並且使用 dispatch 呼叫他
    - 我們進行登入的請求
    - 等待...
    - 等待...
    - 請求完成，使用者已登入
    - .then 運作
    - Dispatch 我們的 action
3. 修改 src/actions/index.js 的 loginUser，用 dispatch 的方式回傳
```
export const loginUser = ({ email, password }) => {
    return (dispatch) => {
        firebase.auth().signInWithEmailAndPassword(email, password)
            .then(user => {
                dispatch({ type: 'LOGIN_USER_SUCCESS', payload: user });
            });
    };
};
```
4. 修改 src/components/LoginForm.js，讓 LoginUser 的 action 可以使用
```
import { emailChanged, passwordChanged, loginUser } from "../actions";

onButtonPress() {
    const { email, password } = this.props;

    this.props.loginUser({ email, password });
}

<Button onPress={this.onButtonPress.bind(this)}>
    Login
</Button>

export default connect(mapStateToProps, {
    emailChanged, passwordChanged, loginUser
})(LoginForm);
```
#### 讓 LoginUser 更穩固
1. 在 src/actions/types.js 新增 LOGIN_USER_SUCCESS
`export const LOGIN_USER_SUCCESS = 'login_user_success';`
2. 在 src/actions/index.js 新增 LOGIN_USER_SUCCESS，並放到 dispatch 裡面
```
import {
    EMAIL_CHANGED,
    PASSWORD_CHANGED,
    LOGIN_USER_SUCCESS
} from "./types";

return (dispatch) => {
    firebase.auth().signInWithEmailAndPassword(email, password)
        .then(user => {
            dispatch({ type: LOGIN_USER_SUCCESS, payload: user });
        });
};
```
3. 在 src/reducers/AuthReducer.js 新增 LOGIN_USER_SUCCESS 並回傳 state
```
import {
    EMAIL_CHANGED,
    PASSWORD_CHANGED,
    LOGIN_USER_SUCCESS
} from "../actions/types";

const INITIAL_STATE = {
    email: '',
    password: '',
    user: null
};

case LOGIN_USER_SUCCESS:
    return { ...state, user: action.payload };
```
#### 建立使用者帳戶
1. 在 src/actions/types.js 新增 LOGIN_USER_FAIL
`export const LOGIN_USER_FAIL = 'login_user_fail';`
2. 在 src/actions/index.js 將 LOGIN_USER_FAIL 加入，如果無法登入則創建帳戶，再無法創建帳戶，則彈出錯誤訊息
```
import {
    EMAIL_CHANGED,
    PASSWORD_CHANGED,
    LOGIN_USER_SUCCESS,
    LOGIN_USER_FAIL
} from "./types";

export const loginUser = ({ email, password }) => {
    return (dispatch) => {
        firebase.auth().signInWithEmailAndPassword(email, password)
            .then(user => loginUserSuccess(dispatch, user))
            .catch(() => {
                firebase.auth().createUserWithEmailAndPassword(email, password)
                    .then(user => loginUserSuccess(dispatch, user))
                    .catch(() => loginUserFail(dispatch));
            });
    };
};

const loginUserFail = (dispatch) => {
    dispatch({ type: LOGIN_USER_FAIL });
};

const loginUserSuccess = (dispatch, user) => {
    dispatch({
        type: LOGIN_USER_SUCCESS,
        payload: user
    });
};
```
#### 顯示錯誤訊息
1. 在 src/reducers/AuthReduer.js 將 LOGIN_USER_FAIL 引入，然後新增 error 的 state
```
import {
    LOGIN_USER_FAIL
} from "../actions/types";

const INITIAL_STATE = {
    user: null,
    error: ''
};

case LOGIN_USER_FAIL:
    return { ...state, error: 'Authentication Failed!'};
```
2. 在 src/components/LoginForm.js 新增 renderError 的 function，然後把 error 讀出
```
import { View, Text } from 'react-native';

renderError() {
    if (this.props.error) {
        return (
            <View style={{ background: 'white' }}>
                <Text style={styles.errorTextStyle}>
                    {this.props.error}
                </Text>
            </View>
        );
    }
}

{this.renderError()}

const styles = {
    errorTextStyle: {
        fontSize: 20,
        alignSelf: 'center',
        color: 'red'
    }
};

const mapStateToProps = state => {
    return {
        error: state.auth.error
    };
};
```
#### Firebase 疑難雜症
1. 如果在 src/reducers/AuthReducer.js 的 `case LOGIN_USER_SUCCESS:` 新增一個 `banana;`，實際執行之後就會發現，出現 Authentication Failed 的錯誤訊息，而不是紅色的錯誤畫面，原因在於 firebase 如果執行失敗，就會直接跳到 catch 的語法，導致沒有出現錯誤，而是出現 Authentication Failed
#### 在載入時顯示 Spinner
1. 在 src/actions/type.js 加上 LOGIN_USER
`export const LOGIN_USER = 'login_user';`
2. 在 src/actions/index.js dispatch LOGIN_USER
```
import {
    LOGIN_USER
} from "./types";

return (dispatch) => {
        dispatch({ type: LOGIN_USER });

        firebase.auth().signInWithEmailAndPassword(email, password)
            ...
    };
```
3. 在 src/reducers/AuthReduer.js，新增 loading 的 case，如果登入成功的話，則把所有值清除，回到預設值 `...INITIAL_STATE`
```
import {
    LOGIN_USER
} from "../actions/types";

const INITIAL_STATE = {
    loading: false
};

case LOGIN_USER:
    return { ...state, loading: true, error: '' };
case LOGIN_USER_SUCCESS:
    return { ...state, ...INITIAL_STATE, user: action.payload};
case LOGIN_USER_FAIL:
    return { ...state, error: 'Authentication Failed!', password: '', loading: false };
```
4. 在 src/components/LoginForm.js 引入 Spinner，並新增 renderButton 事件
```
import { Card, CardSection, Input, Button, Spinner } from './common';

renderButton() {
    if (this.props.loading) {
        return <Spinner size="large" />
    }

    return (
        <Button onPress={this.onButtonPress.bind(this)}>
            Login
        </Button>
    );
}

<CardSection>
    {this.renderButton()}
</CardSection>
```