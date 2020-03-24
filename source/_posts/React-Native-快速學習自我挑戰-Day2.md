---
title: React Native 快速學習自我挑戰 Day2
thumbnail:
  - /images/learning/reactNative/reactnativeday2.png
date: 2017-08-05 00:43:27
categories: Study Note
tags: React-Native
---
<img src="/images/learning/reactNative/reactnativeday2.png">

***
### React Native 上的 HTTP 請求
1. 新增檔案 /src/components/AlbumList.js
```
import React from 'react';
import { View, Text } from 'react-native';

const AlbumList = () => {
    return (
        <View>
            <Text>Album List!!!</Text>
        </View>
    );
};

export default AlbumList;
```
2. 在 index.js 引入函式庫
`import AlbumList from './src/components/AlbumList';`
3. 用 View 把物件包起來
```
const App = () => (
    <View>
        <Header headerText={'Albums'} />
        <AlbumList />
    </View>
);
```
4. Functional Component vs Class Component
    - Functional Component
        - 用來呈現固定資料
        - 不能處理讀取檔案
        - 很容易寫入
    - Class Component
        - 用來取得動態資料來源
        - 處理可能會改變的資料 (讀取資料、使用者事件...等等)
        - 知道它什麼時候要渲染到裝置上 (對資料讀取非常有幫助)
        - 要寫更多程式
5. Functional Component 範例
```
const Header = () => {
    return <Text>Hi there!</Text>
}
```
6. Class Component 範例
```
class Header extends Component {
    render () {
        return <Text>Hi There!</Text>
    }
}
```
7. 接下來要把本來的 Functional Component 換成 Class Component，要先修改引用的函式庫
`import React, { Component } from 'react';`
8. 將 AlbumList 換成 Class Component
```
class AlbumList extends Component {
    render () {
        return (
            <View>
                <Text>Album List!!!</Text>
            </View>
        );
    }
}
```
9. 在 Component 裡面加上 componentWillMount
```
class AlbumList extends Component {
    componentWillMount () {
        console.log('componentWillMount in AlbumList');
    }

    render () {
        return (
            <View>
                <Text>Album List!!!</Text>
            </View>
        );
    }
}
```
10. 安裝 axios `npm install --save axios`
11. 在 componentWillMount 引入 API
```
componentWillMount () {
        axios.get('https://rallycoding.herokuapp.com/api/music_albums')
            .then(response => console.log(response));
    }
```
12. App 的時間軸
    - 啟動 React Native
    - RN 決定要渲染 "App" 到螢幕上
    - "App" 決定要渲染它自己、"Header" 和 "AlbumList"
    - "AlbumList" 發覺到有東西要被渲染，呼叫 componentWillMount
    - "AlbumList" 開啟 HTTP 請求
    - "App"、"AlbumList" 和 "Header" 出現在螢幕上
    - 過好幾毫秒之後，HTTP 請求傳回 JSON data
13. 要處理資料比畫面顯示還晚的問題，要用 state 的方式處理，state 由以下三步驟來完成
    - 設定預設值或是初始值
    - 讀取資料，且要告訴 Component 資料已經更新
    - 最後，要確定 Component 有使用這些資料
14. 設定初始值
`state = { albums: [] };`
15. 讀取資料，而且拿那個值來更新 component，修改 componentWillMount 底下的 .then，這邊要用 setState，而不是 state = [{}]，因為這樣跟起始值一樣
`.then(response => this.setState({albums: response.data }));`
16. 在 render 裡面 console.log 結果
`console.log(this.state);`
17. 加入 state 後的時間軸
    - 啟動 React Native
    - RN 決定要渲染 "App" 到螢幕上
    - "App" 決定要渲染它自己、"Header" 和 "AlbumList"
    - **"AlbumList" 取得起始值 { albums: [] }**
    - "AlbumList" 發覺到有東西要被渲染，呼叫 componentWillMount
    - "AlbumList" 開啟 HTTP 請求
    - **"AlbumList" 的渲染方法被呼叫**
    - "App"、"AlbumList" 和 "Header" 出現在螢幕上
    - 過好幾毫秒之後，HTTP 請求傳回 JSON data
    - **叫做 "setState" 的 request handler 會更新 albums**
    - **"AlbumList" 的渲染方法被呼叫**
18. State 的規則
    - State 的定義：一個純 JavaScript 物件，被用來記錄和回應被用戶觸發的事件
    - 當我們需要更新 component 顯示的東西，叫做 "this.setState"
    - 只能用 "setState" 來改變 state，不要用 "this.state = 123"
19. 用 renderAlbums 取得值，map 在這邊是 foreach 的功能
```
renderAlbums () {
    return this.state.albums.map(album => <Text>{album.title}</Text>);
}
```
20. 把 renderAlbums 放在 \<View><\/View> 裡面
`{this.renderAlbums()}`
21. 新增 key
```
renderAlbums () {
        return this.state.albums.map(album =>
            <Text key={album.title}>{album.title}</Text>
        );
    }
```
22. 新增 AlbumDetail.js
```
import React from 'react';
import { View, Text } from 'react-native';

const AlbumDetail = (props) => {
    return (
        <View>
            <Text>{props.album.title}</Text>
        </View>
    );
};

export default AlbumDetail;
```
23. 在 AlbumList 引入 AlbumDetail
`import AlbumDetail from './AlbumDetail';`
24. 修改 renderAlbums，album={album} 是將 props 命名為 album，並傳給 AlbumList
```
renderAlbums () {
    return this.state.albums.map(album =>
        <AlbumDetail key={album.title} album={album} />
    );
}
```
25. 新增 /src/components/Card.js
```
import React from 'react';
import { View } from 'react-native';

const Card = () => {
    return (
        <View></View>
    );
};

export default Card;
```
26. 幫 Card 新增 styles
```
const styles = {
    containerStyle: {
        borderWidth: 1,
        borderRadius: 2,
        borderColor: '#ddd',
        borderBottomWidth: 0,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 2,
        elevation: 1,
        marginLeft: 5,
        marginRight: 5,
        marginTop: 10
    }
};
```
27. 在 Card 的 View 裡面新增 style
`<View style={styles.containerStyle}></View>`
28. 在 AlbumDetails 引用 Card
`import Card from './Card';`
29. 把 View 改成 Card
```
<Card>
    <Text>{props.album.title}</Text>
</Card>
```
30. 把上層的值傳到這邊使用，用 props.children 就可以直接取得值 
```
const Card = (props) => {
    return (
        <View style={styles.containerStyle}>
            {props.children}
        </View>
    );
};
```
31. 新增 /src/components/CardSection.js
```
import React from 'react';
import { View } from 'react-native';

const CardSection = (props) => {
    return (
        <View style={styles.containerStyle}>
            {props.children}
        </View>
    );
};

const styles = {
    containerStyle: {
        borderBottomWidth: 1,
        padding: 5,
        backgroundColor: '#fff',
        justifyContent: 'flex-start',
        flexDirection: 'row',
        borderColor: '#ddd',
        position: 'relative'
    }
};

export default CardSection;
```
32. 在 AlbumDetail 加入 CardSection
```
<Card>
    <CardSection>
        <Text>{props.album.title}</Text>
    </CardSection>
</Card>
```