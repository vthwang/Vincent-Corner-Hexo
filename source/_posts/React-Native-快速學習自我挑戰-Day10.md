---
title: React Native 快速學習自我挑戰 Day10
thumbnail:
  - /images/learning/reactNative/ReactNativeDay10.jpg
date: 2018-06-21 12:01:08
categories: 學習歷程
tags: React-Native
---
<img src="/images/learning/reactNative/ReactNativeDay10.jpg">

***
### 程式碼再利用 - 編輯和建立
#### 重複使用 Employee Form
1. 修改 src/components/ListItem.js，點擊 row 就會導向新增的頁面
```
import { Text, TouchableWithoutFeedback, View } from 'react-native';
import { Actions } from 'react-native-router-flux';

class ListItem extends Component {
    onRowPress() {
        Actions.employeeCreate({ employee: this.props.employee });
    }

    render() {
        const { name } = this.props.employee;

        return (
            <TouchableWithoutFeedback onPress={this.onRowPress.bind(this)}>
                <View>
                    <CardSection>
                        <Text style={styles.titleStyle}>
                            {name}
                        </Text>
                    </CardSection>
                </View>
            </TouchableWithoutFeedback>
        );
    }
}
```
#### 建立表單 v.s. 編輯表單
1. 編輯表單的方式
    - 使用者導向編輯表單
    - EmployeeFormReducer 是空的
    - 表單是空的
    - 我們必須要在 FormReducer 預載入 state 
    - 使用者編輯表單 - 我們不改變任何 employee 的 model
    - 使用者送出表單
    - 我們從 reducer 儲存資料
#### 可重複使用的表單
1. 新增 src/components/EmployeeForm.js，將本來在 EmployeeCreate.js 的三個 cardSection 分離到 EmployeeForm.js
```
import React, { Component } from 'react';
import { View, Text, Picker } from 'react-native';
import { connect } from 'react-redux';
import { employeeUpdate } from "../actions";
import { CardSection, Input } from "./common";

class EmployeeForm extends Component {
    render() {
        return (
            <View>
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

                <CardSection style={{ flexDirection: 'column' }}>
                    <Text style={styles.pickerTextStyle}>Shift</Text>
                    <Picker
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
            </View>
        );
    }
}

const styles = {
    pickerTextStyle: {
        fontSize: 18,
        paddingLeft: 20
    }
};

const mapStateToProps = (state) => {
    const { name, phone, shift } = state.employeeForm;

    return { name, phone, shift };
};

export default connect(mapStateToProps, { employeeUpdate })(EmployeeForm);
```
2. 修改 src/components/EmployeeCreate.js，引入剛剛分離的 EmployeeForm.js，這邊所使用的 `...this.props` 是把在 Create 表單的所有 state 都傳入 EmployeeForm
```
import { Card, CardSection, Button } from "./common";
import EmployeeForm from './EmployeeForm';

<Card>
    <EmployeeForm {...this.props} />
    <CardSection>
        <Button onPress={this.onButtonPress.bind(this)}>
            Create
        </Button>
    </CardSection>
</Card>
```
#### 獨立的 Employee 編輯表單
1. 新增 src/components/EmployeeEdit.js 
```
import React, { Component } from 'react';
import { connect } from 'react-redux';
import EmployeeForm from './EmployeeForm';
import { Card, CardSection, Button } from "./common";

class EmployeeEdit extends Component {
    render() {
        return(
            <Card>
                <EmployeeForm />
                <CardSection>
                    <Button>
                        Save Changes
                    </Button>
                </CardSection>
            </Card>
        );
    }
}

export default connect()(EmployeeEdit);
```
2. 我們現在要為編輯 Employee 進行客製化，這代表兩件事情
    - 我們必須確定這個表單總是和某一個 Employee 一起導向，然後載入那個 Employee 的資料到 Form Reducer，這就是表單一打開的初始值
    - 我們要新增另外一個 Action Creator 來更新特定 Employee
#### 從 State 初始化表單
1. 修改 src/Router.js 新增 Scene
```
import EmployeeEdit from './components/EmployeeEdit';

<Scene key="employeeEdit" component={EmployeeEdit} title="Edit Employee" />
```
2. 修改 src/components/ListItem.js 的 Action，點擊 row 之後會導向編輯 Employee 的頁面
`Actions.employeeEdit({ employee: this.props.employee });`
3. 修改 src/components/EmployeeEdit.js 將預設值載入，並測試按鈕送出的值是否正確
```
import _ from 'lodash';
import { employeeUpdate } from "../actions";

componentWillMount() {
        _.each(this.props.employee, (value, prop) => {
            this.props.employeeUpdate({ prop, value });
        });
    }

    onButtonPress() {
        const { name, phone, shift } = this.props;
        console.log(name, phone, shift);
    }
}

const mapStateToProps = (state) => {
    const { name, phone, shift } = state.employeeForm;

    return { name, phone, shift };
};

export default connect(mapStateToProps, { employeeUpdate })(EmployeeEdit);
```
#### 更新 Firebase 的紀錄
1. 在 src/actions/EmployeeActions.js 新增一個新的 Action
```
export const employeeSave = ({ name, phone, shift, uid }) => {
    const { currentUser } = firebase.auth();

    return () => {
        firebase.database().ref(`/users/${currentUser.uid}/employees/${uid}`)
            .set({ name, phone, shift })
            .then(() => console.log('saved!'));
    };
};
```
2. 修改 src/components/EmployeeEdit.js 讓點擊 Button 之後啟動 employeeSave 的 Action
```
import { employeeUpdate, employeeSave } from "../actions";

onButtonPress() {
    const { name, phone, shift } = this.props;

    this.props.employeeSave({name, phone, shift, uid: this.props.employee.uid });
}

export default connect(mapStateToProps, {
    employeeUpdate, employeeSave
})(EmployeeEdit);
```
#### 清除表單屬性
1. 在 src/actions/types.js 新增 EMPLOYEE_SAVE_SUCCESS
`export const EMPLOYEE_SAVE_SUCCESS = 'employee_save_success';`
2. 修改 src/actions/EmployeeActions.js 讓畫面返回並清空資料
```
import {
    EMPLOYEES_FETCH_SUCCESS,
    EMPLOYEE_SAVE_SUCCESS
} from './types'

return () => {
    firebase.database().ref(`/users/${currentUser.uid}/employees/${uid}`)
        .set({ name, phone, shift })
        .then(() => {
            dispatch( {type: EMPLOYEE_SAVE_SUCCESS});
            Actions.pop()
        });
};
```
3. 修改 src/reducers/EmployeeFromReducer.js 讓 Reducer 變回起始值
```
import {
    EMPLOYEE_CREATE,
    EMPLOYEE_SAVE_SUCCESS
} from '../actions/types';

case EMPLOYEE_SAVE_SUCCESS:
    return INITIAL_STATE;
```
#### 在 Employees 傳送訊息
1. [React-Native-Communications 套件](https://www.npmjs.com/package/react-native-communications)
2. 修改 src/components/EmployeeEdit.js，點擊按鈕之後會傳送訊息給該 Employee
```
import Communications from 'react-native-communications';

onTextPress() {
    const { phone, shift } = this.props;

    Communications.text(phone, `Your upcoming shift is on ${shift}`);
}

<CardSection>
    <Button onPress={this.onTextPress.bind(this)}>
        Text Schedule
    </Button>
</CardSection>
```
#### Modals 作為可重複使用的元件
1. [Modal 官方文件](https://facebook.github.io/react-native/docs/modal)
2. 新增 src/components/common/Confirm.js
```
import React from 'react';
import { Text, View, Modal } from 'react-native';
import { CardSection } from "./CardSection";
import { Button } from "./Button";

const Confirm = () => {
    
};

export { Confirm };
```
3. 在 src/components/common/index.js 新增
`export * from './Confirm';`
4. 設定 Modal 呈現的資料
```
const Confirm = ({ children, visible, onAccept, onDecline }) => {
    return (
        <Modal
            visible={visible}
            transparent
            animationType="slide"
            onRequestClose={() => {}}
        >
            <View>
                <CardSection>
                    <Text>{children}</Text>
                </CardSection>
                <CardSection>
                    <Button onPress={onAccept}>Yes</Button>
                    <Button onPress={onDecline}>No</Button>
                </CardSection>
            </View>
        </Modal>
    );
};
```
#### Modal 樣式
1. 在 src/components/common/Confirm.js 新增樣式
```
const Confirm = ({ children, visible, onAccept, onDecline }) => {
    const { containerStyle, textStyle, cardSectionStyle } = styles;

    return (
        ...
            <View style={containerStyle}>
                <CardSection style={cardSectionStyle}>
                    <Text style={textStyle}>
                        {children}
        ...
    );
};

const styles = {
    cardSectionStyle: {
        justifyContent: 'center',
    },
    textStyle: {
        flex: 1,
        fontSize: 18,
        textAlign: 'center',
        lineHeight: 40
    },
    containerStyle: {
        backgroundColor: 'rgba(0, 0, 0, 0.75)',
        position: 'relative',
        flex: 1,
        justifyContent: 'center',

    }
};
```
2. 在 src/components/EmployeeEdit.js 新增元件
```
import { Card, CardSection, Button, Confirm } from "./common";

class EmployeeEdit extends Component {
    state = { showModal: false };

    <CardSection>
        <Button onPress={() => this.setState({ showModal: !this.state.showModal })}>
            Fire Employee
        </Button>
    </CardSection>

    <Confirm
        visible={this.state.showModal}
    >
        Are you sure you want to delete this?
    </Confirm>
}
```
#### Employee 刪除的 Action Creator
1. 在 src/components/EmployeeEdit.js 新增 Decline 和 Accept 的 helper
```
onAccept() {

}

onDecline() {
    this.setState({ showModal: false });
}

<Confirm
    visible={this.state.showModal}
    onAccept={this.onAccept.bind(this)}
    onDecline={this.onDecline.bind(this)}
>
```
2. 在 src/actions/EmployeeActions.js 新增 delete 的 function
```
export const employeeDelete = ({ uid }) => {
    const { currentUser } = firebase.auth();

    return () => {
        firebase.database().ref(`/users/${currentUser.uid}/employees/${uid}`)
            .remove()
            .then(() => {
                Actions.pop()
            });
    }
};
```
#### 完成 Employee Delete
1. 修改 src/components/EmployeeEdit.js 將 Accept function 完成
```
import { employeeUpdate, employeeSave, employeeDelete } from "../actions";

onAccept() {
    const { uid } = this.props.employee;

    this.props.employeeDelete({ uid });
}

export default connect(mapStateToProps, {
    employeeUpdate, employeeSave, employeeDelete
})(EmployeeEdit);
```
### 完成課程
<img src="/images/learning/reactNative/Stephen Grider-The Complete React Native and Redux Course.jpg">