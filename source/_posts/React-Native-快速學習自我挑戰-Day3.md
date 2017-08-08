---
title: React Native 快速學習自我挑戰 Day3
thumbnail:
  - /blogs/images/learning/reactNative/reactnativeday3.jpg
date: 2017-08-08 17:41:08
categories: 學習歷程
tags: React-Native
---
<img src="/blogs/images/learning/reactNative/reactnativeday3.jpg">

***
### 處理 Component 的排版
#### Flexbox 排版
1. justifyContent: 'space-between'：上下頂到邊，平均分配空間排列
2. justifyContent: 'space-around'：上下不頂到邊，平均分配空間排列
3. flexDirection：'row', 'column'：決定方向
#### 修改版面
1. 修改 AlbumDetail.js，在 react-native 多引用 View
`import { Text, View } from 'react-native';`
2. 修改 AlbumDetail，將 artist 放進去
```
const AlbumDetail = (props) => {
    return (
        <Card>
            <CardSection>
                <View></View>
                <View style={styles.headerContentStyle}>
                    <Text>{props.album.title}</Text>
                    <Text>{props.album.artist}</Text>
                </View>
            </CardSection>
        </Card>
    );
};
```
3. 新增 styles
```
const styles = {
    headerContentStyle: {
        flexDirection: 'column',
        justifyContent: 'space-around'
    }
};
```
4. 在 react-native 多引用 Image
`import { Text, View, Image } from 'react-native';`
5. 新增 image
```
<View>
    <Image source={{ uri: props.album.thumbnail_image }} />
</View>
```
6. 簡化傳遞的參數
```
const AlbumDetail = ({ album }) => {
    const { title, artist, thumbnail_image } = album;
    
    return (
        <Card>
            <CardSection>
                <View>
                    <Image source={{ uri: thumbnail_image }} />
                </View>
                <View style={styles.headerContentStyle}>
                    <Text>{title}</Text>
                    <Text>{artist}</Text>
                </View>
            </CardSection>
        </Card>
    );
};
```
7. 新增圖片的 style
```
thumbnailStyle: {
    height:50,
    width: 50
}
```
8. 將 sytle 加到圖片的 tag
`<Image style={styles.thumbnailStyle} source={{"{{uri: thumbnail_image" }}}} />`
9. 簡化 style 的參數
```
const AlbumDetail = ({ album }) => {
    const { title, artist, thumbnail_image } = album;
    const { thumbnailStyle, headerContentStyle} = styles;

    return (
        <Card>
            <CardSection>
                <View>
                    <Image
                        style={thumbnailStyle}
                        source={{ uri: thumbnail_image }}
                    />
                </View>
                <View style={headerContentStyle}>
                    <Text>{title}</Text>
                    <Text>{artist}</Text>
                </View>
            </CardSection>
        </Card>
    );
};
```
10. 新增兩個 styles: headerTextStyle、thumbnailContainerStyle
```
const styles = {
    headerContentStyle: {
        flexDirection: 'column',
        justifyContent: 'space-around'
    },
    headerTextStyle: {
        fontSize: 18
    },
    thumbnailStyle: {
        height:50,
        width: 50
    },
    thumbnailContainerStyle: {
        justifyContent: 'center',
        alignItems: 'center',
        marginLeft: 10,
        marginRight: 10
    }
};
```
11. 加入簡化的常數
```
const {
    thumbnailStyle,
    headerTextStyle,
    headerContentStyle,
    thumbnailContainerStyle
} = styles;
```
12. 加入 style
```
<CardSection>
    <View style={thumbnailContainerStyle}>
        <Image
            style={thumbnailStyle}
            source={{ uri: thumbnail_image }}
        />
    </View>
    <View style={headerContentStyle}>
        <Text style={headerTextStyle}>{title}</Text>
        <Text>{artist}</Text>
    </View>
</CardSection>
```
13. 新增專輯封面 style
```
imageStyle: {
    height: 300,
    flex: 1,
    width: null
}
```
```
const {
    thumbnailStyle,
    headerTextStyle,
    headerContentStyle,
    thumbnailContainerStyle,
    imageStyle
} = styles;
```
```
<CardSection>
    <Image style={imageStyle} source={{ uri: image }} />
</CardSection>
```
14. 讓畫面可以滾動，修改 albumList.js
`import { ScrollView } from 'react-native';`
```
render () {
    console.log(this.state);

    return (
        <ScrollView>
            {this.renderAlbums()}
        </ScrollView>
    );
}
```
15. 畫面卡住的問題，要修改 index.ios.js
```
const App = () => (
    <View style={{ flex: 1 }}>
        <Header headerText={'Albums'} />
        <AlbumList />
    </View>
);
```
16. 新增 src/components/Button.js
```
import React from 'react';
import { Text } from 'react-native';

const Button = () => {
    return (
        <Text>Click me!!!</Text>
    );
};

export default Button;
```
17. 在 albumDetail.js 引用 Button
`import Button from './Button';`
再新增一個 CardSection
```
<CardSection>
    <Button/>
</CardSection>
```
18. 在 Button.js 新增 TouchableOpacity，讓使用者點擊 button 會有反饋
`import { Text, TouchableOpacity } from 'react-native';`
```
<TouchableOpacity>
    <Text>Click me!!!</Text>
</TouchableOpacity>
```
19. 新增 Button style
```
const styles = {
    buttonStyle: {
        flex: 1,
        alignSelf: 'stretch',
        backgroundColor: '#fff',
        borderRadius: 5,
        borderWidth: 1,
        borderColor: '#007aff',
        marginLeft: 5,
        marginRight: 5
    }
};
```
```
const Button = () => {
    const { buttonStyle } = styles;

    return (
        <TouchableOpacity style={buttonStyle}>
            <Text>Click me!!!</Text>
        </TouchableOpacity>
    );
};
```
20. 新增 Text style
```
textStyle: {
    alignSelf: 'center',
    color: '#007aff',
    fontSize: 16,
    fontWeight: '600',
    paddingTop: 10,
    paddingBottom: 10
},
```
```
const Button = () => {
    const { buttonStyle, textStyle } = styles;

    return (
        <TouchableOpacity style={buttonStyle}>
            <Text style={textStyle}>
                Click me!!!
            </Text>
        </TouchableOpacity>
    );
};
```
21. 在 albumDetail.js 加上 onPress function，然後把値傳送到 Button.js 
```
<CardSection>
    <Button onPress={() => console.log(title)} />
</CardSection>
```
```
const Button = ({ onPress }) => {
    const { buttonStyle, textStyle } = styles;

    return (
        <TouchableOpacity onPress={onPress} style={buttonStyle}>
            <Text style={textStyle}>
                Click me!!!
            </Text>
        </TouchableOpacity>
    );
};
```
22. 在 albumDetail.js 新增 button 的超連結
`import { Text, View, Image, Linking } from 'react-native';`
`const { title, artist, thumbnail_image, image, url } = album;`
```
<CardSection>
    <Button onPress={() => Linking.openURL(url)} />
</CardSection>
```
23. 讓 Button 文字元件化
修改 albumDetail.js
```
<CardSection>
    <Button onPress={() => Linking.openURL(url)}>
        Buy Now
    </Button>
</CardSection>
```
修改 Button.js
```
const Button = ({ onPress, children }) => {
    const { buttonStyle, textStyle } = styles;

    return (
        <TouchableOpacity onPress={onPress} style={buttonStyle}>
            <Text style={textStyle}>
                {children}
            </Text>
        </TouchableOpacity>
    );
};
```