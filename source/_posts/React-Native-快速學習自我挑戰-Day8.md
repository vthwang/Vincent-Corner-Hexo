---
title: React Native 快速學習自我挑戰 Day8
thumbnail:
  - /images/learning/reactNative/ReactNativeDay8.png
date: 2018-06-15 16:37:05
categories: Study Note
tags: React-Native
toc: true
---
<img src="/images/learning/reactNative/ReactNativeDay8.png">

***
### 讓使用者到處導航
#### 處理導航列
1. 安裝套件
`npm i --save react-native-router-flux`
#### Router 裡面的導覽列
1. 新增 src/Router.js
```
import React from 'react';
import { Scene, Router } from 'react-native-router-flux';
import LoginForm from './components/LoginForm';

const RouterComponent = () => {
    return (
        <Router>
            <Scene key="root">
                <Scene key="login" component={LoginForm} title="Please Login" />
            </Scene>
        </Router>
    );
};

export default RouterComponent;
```
2. 在 src/App.js 將 Router 引入並使用
```
import Router from './Router';

<Provider store={store}>
    <Router />
</Provider>
```
#### 顯示多個 Scenes
1. 新增 src/components/EmployeeList.js
```
import React, { Component } from 'react';
import { View, Text } from 'react-native';

class EmployeeList extends Component {
    render() {
        return (
            <View>
                <Text>EmployList</Text>
                <Text>EmployList</Text>
                <Text>EmployList</Text>
                <Text>EmployList</Text>
                <Text>EmployList</Text>
            </View>
        );
    }
}

export default EmployeeList;
```
2. 在 src/Router.js 新增 EmployeeList 的 Scene
```
import EmployeeList from './components/EmployeeList';

<Scene key="logoin" component={LoginForm} title="Please Login" initial/>
<Scene key="employeeList" component={EmployeeList} title="Employees" />
```
#### 在路由之間移動導覽列
1. 在 src/Actions/index.js 使用 Router 的 Actions 功能
```
import { Actions } from 'react-native-router-flux';

const loginUserSuccess = (dispatch, user) => {
    dispatch({
        type: LOGIN_USER_SUCCESS,
        payload: user
    });

    Actions.employeeList();
};
```
#### 使用 Buckets 分類 Scenes
1. 在 src/Router.js 將路由分類
```
<Scene key="root" hideNavBar>
    <Scene key="auth">
        <Scene key="logoin" component={LoginForm} title="Please Login" initial/>
    </Scene>
    <Scene key="main">
        <Scene key="employeeList" component={EmployeeList} title="Employees" />
    </Scene>
</Scene>
```
2. 在 src/Actions/index.js 修改 Actions
```
const loginUserSuccess = (dispatch, user) => {
    dispatch({
        type: LOGIN_USER_SUCCESS,
        payload: user
    });

    Actions.main();
};
```
#### 導覽列按鈕
1. 修改 src/Router.js
```
<Scene key="main">
    <Scene
        rightTitle="Add"
        onRight={() => { console.log('right!!!') }}
        key="employeeList"
        component={EmployeeList}
        title="Employees"
    />
</Scene>
```
#### 導航至 Employee Creation Form
1. 新增 src/components/EmployeeCreate.js
```
import React, { Component } from 'react';
import { View, Text } from 'react-native';

class EmployeeCreate extends Component {
    render() {
        return(
            <View>
                <Text>Employee From</Text>
            </View>
        );
    }
}

export default EmployeeCreate;
```
2. 在 src/Router.js 新增並連結 employeeCreate Scene
```
import { Scene, Router, Actions } from 'react-native-router-flux';
import EmployeeCreate from './components/EmployeeCreate';

<Scene key="main">
    <Scene
        rightTitle="Add"
        onRight={() => Actions.employeeCreate() }
        key="employeeList"
        component={EmployeeList}
        title="Employees"
        initial
    />
    <Scene key="employeeCreate" component={EmployeeCreate} title="Create Employee" />
</Scene>
```
#### 建立 Employee Creation Form
1. 修改 src/components/EmployeeCreate.js
```
import { Card, CardSection, Input, Button } from "./common";


class EmployeeCreate extends Component {
    render() {
        return(
            <Card>
                <CardSection>
                    <Input
                        label="Name"
                        placeholder="Jane"
                    />
                </CardSection>

                <CardSection>
                    <Input
                        label="Phone"
                        placeholder="555-555-5555"
                    />
                </CardSection>

                <CardSection>
                </CardSection>

                <CardSection>
                    <Button>
                        Create
                    </Button>
                </CardSection>
            </Card>
        );
    }
}
```
#### Employee Form Actions
1. 在 src/actions/types.js 新增 EMPLOYEE_UPDATE
`export const EMPLOYEE_UPDATE = 'employee_update';`
2. 新增 src/actions/EmployeeActions.js
```
import {
    EMPLOYEE_UPDATE
} from './types'

export const employeeUpdate = ({ prop, value }) => {
    return {
        type: EMPLOYEE_UPDATE,
        payload: { prop, value }
    };
};
```
3. 新增 src/reducers/EmployeeFormReducer.js
```
import {
    EMPLOYEE_UPDATE
} from '../actions/types';

const INITIAL_STATE = {};

export default (state = INITIAL_STATE, action) => {
    switch (action.type) {
        default:
            return state;
    }
};
```
#### 在 Reducer 的層次來處理 Form Update
1. 修改 src/reducers/EmployeeFormReducer.js
```
const INITIAL_STATE = {
    name: '',
    phone: '',
    shift: ''
};


export default (state = INITIAL_STATE, action) => {
    switch (action.type) {
        case EMPLOYEE_UPDATE:
            // action.payload === { prop: 'name', value: 'jane' }
            return { ...state, [action.payload.prop]: action.payload.value }
        default:
            return state;
    }
};
```
2. 新增 src/actions/AuthActions.js 並將 index.js 的內容全部剪貼過去
3. 將其它 Actions 在 src/actions/index.js 輸出
```
export * from './AuthActions';
export * from './EmployeeActions';
```
#### 動態 Property 更新
1. 修改 src/reducers/index.js 
```
import EmployeeFromReducer from './EmployeeFromReducer';

export default combineReducers({
    employeeForm: EmployeeFromReducer
});
```
2. 修改 src/components/EmployeeCreate.js 跟 Actions 做連結
```
import { connect } from 'react-redux';
import { employeeUpdate } from "../actions";

<CardSection>
    <Input
        label="Name"
        placeholder="Jane"
        value={this.props.name}
        onChangeText={value => this.props.employeeUpdate({ prop: 'name', value })}
    />
</CardSection>

<CardSection>
    <Input
        label="Phone"
        placeholder="555-555-5555"
        value={this.props.phone}
        onChangeText={value => this.props.employeeUpdate({ prop: 'phone', value })}
    />
</CardSection>

const mapStateToProps = (state) => {
    const { name, phone, shift } = state.employeeForm;

    return { name, phone, shift };
};

export default connect(mapStateToProps, { employeeUpdate })(EmployeeCreate);
```
#### Picker 元件
1. 修改 src/components/EmployeeCreate.js 引入 Picker 元件
```
import { Picker } from 'react-native';

<CardSection>
    <Picker
        style={{ flex: 1 }}
        selectedValue={this.props.shift}
        onValueChange={value => this.props.employeeUpdate({ prop: 'shift', value })}
    >
        <Picker.Item label="Monday" value="Monday" />
        <Picker.Item label="Tuesday" value="Tuesday" />
        <Picker.Item label="Wednesday" value="Wednesday" />
        <Picker.Item label="Thursday" value="Thursday" />
        <Picker.Item label="Friday" value="Friday" />
        <Picker.Item label="Saturday" value="Saturday" />
        <Picker.Item label="Sunday" value="Sunday" />
    </Picker>
</CardSection>
```
#### Pickers 和樣式覆蓋
1. 修改 src/components/EmployeeCreate.js 新增樣式
```
import { Picker, Text } from 'react-native';

<CardSection style={{ flexDirection: 'column' }}>
    <Text style={styles.pickerTextStyle}>Shift</Text>
</CardSection>

const styles = {
    pickerTextStyle: {
        fontSize: 18,
        paddingLeft: 20
    }
};
```
2. 修改 src/components/common/CardSection.js，讓它從上一層取得樣式，陣列裡面的樣式，右邊的會覆蓋左邊的
```
<View style={[styles.containerStyle, props.style]}>
    {props.children}
</View>
```