---
title: React Native 快速學習自我挑戰 Day9
thumbnail:
  - /images/learning/reactNative/ReactNativeDay9.png
date: 2018-06-19 17:20:04
categories: Study Note
tags: React
toc: true-Native
toc: true
---
<img src="/images/learning/reactNative/ReactNativeDay9.png">

***
### 使用 Firebase 當作資料儲藏庫
#### Firebase JSON 架構
1. Firebase 的資料庫會有 Users 的 Collection，然後個別的 User 會有自己的 Employees 的 Collection
2. 在 Authentication 的使用者並不會自己新增到資料庫，需要自己手動新增，它們是兩個分離的系統
#### Firebase 的資料安全
1. 預設中，只要用戶登入之後，就可以存取所有資料庫的資料，所以我們要修改這個部分
2. 修改 database 中的 rule
```
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```
#### 使用 Firebase 建立紀錄
1. 在建立 employees 的頁面，連結按鈕，然後產生 action 來儲存記錄到 Firebase，最後畫面返回到 Employess 列表的頁面，我們新增的 employee 就會出現在列表上
2. 在 src/components/EmployeeCreate.js 的 button 連結 employeeCreate 的事件
```
import { employeeUpdate, employeeCreate } from "../actions";

onButtonPress() {
    const { name, phone, shift } = this.props;

    this.props.employeeCreate({ name, phone, shift });
}

<Button onPress={this.onButtonPress.bind(this)}>
    Create
</Button>

export default connect(mapStateToProps, {
    employeeUpdate, employeeCreate
})(EmployeeCreate);
```
3. 在 src/actions/EmployeeActions.js 新增 employeeCreate 的 action，並用 console.log 讀出三個值，實際在模擬器上面會發現 shift 的值是 empty，沒辦法出現，問題在下一章會解決
```
export const employeeCreate = ({ name, phone, shift }) => {
    console.log(name, phone, shift);
};
```
#### 預設 Form 值
1. 修改 src/components/employeeCreate.js 如果 shift 為空值則傳回 Monday
`this.props.employeeCreate({ name, phone, shift: shift || 'Monday' });`
#### 成功地儲存資料到 Firebase
1. 修改 src/actions/EmployeeActions.js 將資料傳送到 Firebase
```
import firebase from 'firebase';

export const employeeCreate = ({ name, phone, shift }) => {
    const { currentUser } = firebase.auth();

    firebase.database().ref(`/users/${currentUser.uid}/employees`)
        .push({ name, phone, shift });
};
```
#### 重設表單屬性
1. 修改 src/actions/EmployeeActions.js 在 Action 儲存完資料之後，返回本來的頁面
```
import { Actions } from 'react-native-router-flux';

return () => {
    firebase.database().ref(`/users/${currentUser.uid}/employees`)
        .push({name, phone, shift})
        .then(() => {
            Actions.pop()
        });
};
```
2. 修改 src/actions/EmployeeActions.js 新增 EMPLOYEE_CREATE 讓資料送出之後，預設值變為空值
```
import {
    EMPLOYEE_UPDATE,
    EMPLOYEE_CREATE
} from './types'

return (dispatch) => {
    firebase.database().ref(`/users/${currentUser.uid}/employees`)
        .push({name, phone, shift})
        .then(() => {
            dispatch( {type: EMPLOYEE_CREATE } );
            Actions.pop()
        });
};
```
3. 在 src/actions/types.js 新增 EMPLOYEE_CREATE
`export const EMPLOYEE_CREATE = 'employee_create';`
4. 修改 src/reducers/EmployeeFormReducer.js 傳回預設值
```
import {
    EMPLOYEE_UPDATE,
    EMPLOYEE_CREATE
} from '../actions/types';

case EMPLOYEE_CREATE:
    return INITIAL_STATE;
```
#### 從 Firebase 取得資料
1. 修改 src/actions/EmployeeActions.js 新增 employeesFetch 來取得資料
```
import {
    EMPLOYEE_UPDATE,
    EMPLOYEE_CREATE,
    EMPLOYEES_FETCH_SUCCESS
} from './types'

export const employeesFetch = () => {
    const { currentUser } = firebase.auth();

    return (dispatch) => {
        firebase.database().ref(`/users/${currentUser.uid}/employees`)
            .on('value', snapshot => {
                dispatch({ type: EMPLOYEES_FETCH_SUCCESS, payload: snapshot.val()} );
            });
    };
};
```
2. 在 src/actions/types.js 新增 EMPLOYEES_FETCH_SUCCESS 
`export const EMPLOYEES_FETCH_SUCCESS = 'employees_fetch_success';`
#### 藉由 ID 儲存資料
1. 修改 src/components/EmployList.js 在讀取之前，呼叫 employeesFetch 的 action
```
import { connect } from 'react-redux';
import { employeesFetch } from "../actions";

componentWillMount() {
    this.props.employeesFetch();
}

export default connect(null, { employeesFetch })(EmployeeList);
```
2. 新增 src/reducers/EmployeeReducer.js
```
import {
    EMPLOYEES_FETCH_SUCCESS
} from "../actions/types";

const INITIAL_STATE = {};

export default (state = INITIAL_STATE, action) => {
    switch (action.type) {
        case EMPLOYEES_FETCH_SUCCESS:
            // return { ...state, [id]: action.payload }; (用 id 的方式處理)
            return action.payload;
        default:
            return state;
    }
};
```
3. 在 src/reducers/index.js 新增 EmployeeReducer
```
import EmployeeReducer from './EmployeeReducer';

employees: EmployeeReducer
```
#### 建立動態 DataSource
1. 修改 src/components/EmployeeList.js，新增一個 createDataSource 的 function，如果使用把 dataSoure 的 function 放在 componentWillMount，在翻頁的時候，東西就會不見，所以新增一個 function 來處理它
```
import { ListView, View, Text } from 'react-native';

componentWillMount() {
    this.props.employeesFetch();

    this.createDataSource(this.props);
}

componentWillReceiveProps(nextProps) {
    // nextProps are the next set of props that this component
    // will be rendered  with
    // this.props is still the old set of props

    this.createDataSource(nextProps);
}

createDataSource({ employees }) {
    const ds = new ListView.DataSource({
        rowHasChanged: (r1, r2) => r1 !== r2
    });

    this.dataSource = ds.cloneWithRows(employees);
}
```
#### 把物件轉成陣列
1. 安裝 lodash
`npm install --save lodash`
2. 修改 src/components/EmployeeList.js 用 lodash 將物件轉成陣列
```
import _ from 'lodash';

const mapStateToProps = state => {
    const employees = _.map(state.employees, (val, uid) => {
        return { ...val, uid }; // { shift: 'Monday', name: 'S', id" '1j2j34' };
    });

    return { employees };
};

export default connect(mapStateToProps, { employeesFetch })(EmployeeList);
```
#### 在 Employee List 建立 List
1. 修改 src/components/EmployeeList.js 把資料讀出來
```
import { ListView } from 'react-native';
import ListItem from './ListItem';

renderRow(employee) {
    return <ListItem employee={employee} />;
}

render() {
    console.log(this.props);
    return (
        <ListView
            enableEmptySections
            dataSource={this.dataSource}
            renderRow={this.renderRow}
        />
    );
}
```
2. 新增 src/components/ListItem.js
```
import React, { Component } from 'react';
import { Text } from 'react-native';
import { CardSection } from './common';

class ListItem extends Component {
    render() {
        const { name } = this.props.employee;

        return (
            <CardSection>
                <Text style={styles.titleStyle}>
                    {name}
                </Text>
            </CardSection>
        );
    }
}

const styles = {
    titleStyle: {
        fontSize: 18,
        paddingLeft: 15
    }
};

export default ListItem;
```