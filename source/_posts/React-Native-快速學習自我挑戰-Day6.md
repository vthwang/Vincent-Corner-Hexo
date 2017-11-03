---
title: React Native 快速學習自我挑戰 Day6
thumbnail:
  - /images/learning/reactNative/reactnativeday6.png
date: 2017-08-18 19:54:13
categories: 學習歷程
tags: React-Native
---
<img src="/images/learning/reactNative/reactnativeday6.png">

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
1. 新增 src/reducers/LibraryReducer.js
`export default () => [];`
2. 在 reducers/index.js 引入 LibraryReducer.js
```
import { combineReducers } from 'redux';
import LibraryReducer from './LibraryReducer';

export default combineReducers({
    libraries: LibraryReducer
});
```
3. 新增 src/reducers/LibraryList.json
```
[
  {"id": 0,
    "title": "Webpack",
    "description": "Webpack is a module bundler. It packs CommonJs/AMD modules i. e. for the browser. Allows to split your codebase into multiple bundles, which can be loaded on demand."
  },
  {"id": 1,
    "title": "React",
    "description": "React makes it painless to create interactive UIs. Design simple views for each state in your application, and React will efficiently update and render just the right components when your data changes."
  },
  {"id": 2,
    "title": "Redux",
    "description": "Redux is a predictable state container for JavaScript apps. It helps you write applications that behave consistently, run in different environments (client, server, and native), and are easy to test."
  },
  {"id": 3,
    "title": "React-Redux",
    "description": "React-Redux is the official set of bindings between the React and Redux libraries. With this library you can keep your views and data in sync."
  },
  {"id": 4,
    "title": "Lodash",
    "description": "A modern JavaScript utility library delivering modularity, performance, & extras. Lodash is released under the MIT license & supports modern environments."
  },
  {"id": 5,
    "title": "Redux-Thunk",
    "description": "Redux Thunk middleware allows you to write action creators that return a function instead of an action. The thunk can be used to delay the dispatch of an action, or to dispatch only if a certain condition is met."
  },
  {"id": 6,
    "title": "ESLint",
    "description": "ESLint is an open source JavaScript linting utility originally created by Nicholas C. Zakas in June 2013. Code linting is a type of static analysis that is frequently used to find problematic patterns or code that doesn't adhere to certain style guidelines."
  },
  {"id": 7,
    "title": "Babel",
    "description": "Babel has support for the latest version of JavaScript through syntax transformers. These plugins allow you to use new syntax, right now without waiting for browser support."
  },
  {"id": 8,
    "title": "Axios",
    "description": "Promise based HTTP client for the browser and node.js. With Axios, you can make XMLHttpRequests from the browser or Node with the full Promise Api."
  }
]
```
#### The Connect Function
1. 引入 json 的資料，然後輸出
```
import data from './LibraryList.json';

export default () => data;
```
2. 新增 src/components/LibraryList.js，在這邊有一點要注意，可以直接引入 json 來使用，但是在 redux 不能這樣用
```
import React, { Component } from 'react';
import { connect } from 'react-redux';

class LibraryList extends Component {
    render() {
        return;
    }
}

export default connect()(LibraryList);
```
#### Connect 與 MapStateToProps
1. 在 LibraryList.js 新增 mapStateToProps function
```
const mapStateToProps = state => {
    return { libraries: state.libraries };
};
```
2. 在 LibraryList 裡面 console，會看到物件和 dispatch
```
class LibraryList extends Component {
    render() {
        console.log(this.props);
        return;
    }
}
```
### 用正確的方法渲染 List
#### 實作 ListView
1. 引入 ListView，然後用 componentWillMount 來取得值，最後送到 ListView
```
import { ListView } from 'react-native';

class LibraryList extends Component {
    componentWillMount() {
        const ds = new ListView.DataSource({
            rowHasChanged: (r1, r2) => r1 !== r2
        });
        
        this.dataSource = ds.cloneWithRows(this.props.libraries);
    }
    
    renderRow() {
        
    }
    
    render() {
        return (
            <ListView
                dataSource={this.dataSource}
                renderRow={this.renderRow}
            />
        );
    }
}
```
#### 渲染單一的列
1. 新增 ListItem.js
```
import React, { Component } from 'react';

class ListItem extends Component {
    render() {
        
    }
}

export default ListItem;
```
2. 在 LibraryList.js 引入 ListItem，然後放在 renderRow 裡面，並傳入 props 叫做 Library
```
import ListItem from './ListItem';

renderRow(library) {
    return <ListItem library={library} />;
}
```
#### 美化 List
1. 引入 CardSection，然後讓接收上一層傳過來的值並顯示它
```
import { CardSection } from './common';

class ListItem extends Component {
    render() {
        const { titleStyle } = styles;

        return (
            <CardSection>
                <Text style={titleStyle}>
                    {this.props.library.title}
                </Text>
            </CardSection>
        );
    }
}
```
2. 新增樣式
```
const styles = {
    titleStyle: {
        fontSize: 18,
        paddingLeft: 15
    }
};
```
3. 在 app.js 的 View 新增 flex 1 的樣式，讓 List 可以在整頁滾動
`<View style={{"{{ flex: 1 "}}}}>`
#### 創建 Selection Reducer
1. 新增 src/reducers/SelectionReducer.js，在畫面產生的時候，預設不要選任何東西，所以送出 null
```
export default () => {
    return null;
};
```
2. 在 reducer/index.js 把 SelectionReducer 加入
```
import SelectionReducer from './SelectionReducer';

export default combineReducers({
    libraries: LibraryReducer,
    selectedLibraryId: SelectionReducer
});
```
#### 介紹 Action Creator
1. 在 Component 裡面用 Action Creator 呼叫 Action，Action 會去要求 Reducer 改變值
2. 新增 src/actions/index.js
```
export const selectLibrary = (libraryId) => {
    return {
        type: 'select_library',
        payload: libraryId
    };
};
```
#### 呼叫 Action Creators
1. 在 ListItem.js 引入所有 actions
`import * as actions from '../actions';`
2. 在 ListItem.js 引入 connect，connect 的第一個參數是傳入的 props 值，目前沒有要傳東西，所以用 null，第二個參數是 actions，最後把 action 傳入 ListItem 的 component
```
import { connect } from 'react-redux';

export default connect(null, actions)(ListItem);
```
#### 新增 Touchable 元件
1. 在 ListItem.js 引入 TouchableWithoutFeedback 和 View
`import { Text, TouchableWithoutFeedback, View } from 'react-native';`
2. 把 TouchableWithoutFeedback 和 View 加到元件裡面，onPress 之後，使用 action
```
class ListItem extends Component {
    render() {
        const { titleStyle } = styles;
        const { id, title } = this.props.library;

        return (
            <TouchableWithoutFeedback
                onPress={() => this.props.selectLibrary(id)}
            >
                <View>
                    <CardSection>
                        <Text style={titleStyle}>
                            {title}
                        </Text>
                    </CardSection>
                </View>
            </TouchableWithoutFeedback>
        );
    }
}
```
#### Reducer 的規則
1. 修改 SelectionReducer.js，如果選到東西就回傳 id，如果沒有就回傳現在的 state
```
export default (state = null, action) => {
    switch (action.type) {
        case 'select_library':
            return action.payload;
        default:
            return state;
    }
};
```
#### 展開列
1. 新增 mapStateToProps 回傳 object，然後會用 props 的形式放到 component 裡面，state.selectedLibraryId 是從 reducer/index.js 裡面取得的，最後將 mapStateToProps 和 actions 放在一起，就可以比較 selectedLibraryId 和 library.id 是不是一樣，一樣的話就展開
```
const mapStateToProps = state => {
    return { selectedLibraryId: state.selectedLibraryId };
};

export default connect(mapStateToProps, actions)(ListItem);
```
2. 在 ListItem 的元件新增 renderDescription function 比較選擇的和本來的一不一樣，一樣就展開
```
renderDescription() {
    const { library, selectedLibraryId } = this.props;

    if (library.id === selectedLibraryId) {
        return (
            <Text>{library.description}</Text>
        );
    }
}
```
3. 最後把 renderDescription 放到 Component 裡面
```
<View>
    <CardSection>
        <Text style={titleStyle}>
            {title}
        </Text>
    </CardSection>
    {this.renderDescription()}
</View>
```
#### 將邏輯移出 Component
1. mapStateToProps 引入第二個參數 ownProps，它等於 this.props，所以最後可以用 expanded 簡化，它只會回傳 true 或 false
```
const mapStateToProps = (state, ownProps) => {
    const expanded = state.selectedLibraryId === ownProps.library.id;

    return { expanded };
};
```
2. 修改 renderDescription
```
renderDescription() {
    const { library, expanded } = this.props;

    if (expanded) {
        return (
            <Text>{library.description}</Text>
        );
    }
}
```
#### 動畫
1. 在 renderDescription 加入 CardSection 讓版面更漂亮
```
<CardSection>
    <Text>{library.description}</Text>
</CardSection>
```
2. 引入 LayoutAnimation
```
import {
    Text,
    TouchableWithoutFeedback,
    View,
    LayoutAnimation
} from 'react-native';
```
3. 在 ListItem 的 Component 加入 componentWillUpdate
```
componentWillUpdate() {
    LayoutAnimation.spring();
}
```
4. 流程：User 點擊 Library => 呼叫 Action Creator => Action Creator 回傳 Action，然後傳到 Reducers => 新狀態會傳到 mapstateToProps => Components 重新渲染 => View 就會更新