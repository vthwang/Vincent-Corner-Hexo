---
title: React Native 學習筆記 Day01
thumbnail:
  - /images/learning/react-native2/ReactNativeDay01.jpeg
date: 2018-09-18 13:49:45
categories: 學習歷程
tags: 
    - React-Native
---
<img src="/images/learning/react-native2/ReactNativeDay01.jpeg">

***
### 學習筆記的開始
&emsp;&emsp;經過三個月的沈澱與反思，放慢腳步學習 React 和 React Native，相對於過去的速食學習，我覺得唯有踏實的把每一行語句搞懂，而且確實明白自己在做的是什麼？思索怎麼把程式碼精簡，增強效能的思維模式，才是真正把自己推往下一個層次的關鍵。所以，放下過去所學的，我又重新開始在 Udemy 上課，把關鍵知識技術內化成自己的程式力，期許這次的課程，能夠把我混沌的、抄抄寫寫的程式碼改善。
### 子元件與父原件的溝通
1. 在 InputGroup 傳入一個 onPlaceAdded 的 props 為 placeAddHandler 的 function，對傳回來的 placeName 存到 places 的陣列裡面，最後將 places 的 state 傳送到 PlaceList 的元件中去處理
```
state = {
  places: []
};

placeAddHandler = placeName => {
  this.setState( prevState => {
    return {
      places: prevState.places.concat(placeName)
    };
  });
};

render() {
  return (
    <View style={styles.container}>
      <InputGroup onPlaceAdded={this.placeAddHandler} />
      <PlaceList places={this.state.places} />
    </View>
  );
}
```
2. 讓剛剛丟進來的 onPlaceAdded 的 function，在按鈕觸發的時候啟動，並把值(this.state.placeName)傳送進去執行這個 function
```
state = {
  placeName: ""
};

placeNameChangeHandler = val => {
  this.setState({
    placeName: val
  });
};

placeSubmitHandler = () => {
  if (this.state.placeName.trim() === "") {
    return;
  }

  this.props.onPlaceAdded(this.state.placeName);
};

render() {
  return(
    <View style={styles.inputContainer}>
      <TextInput
        placeholder="An Awesome Place"
        value={this.state.placeName}
        onChangeText={this.placeNameChangeHandler}
        style={styles.placeInput}
      />
      <Button
        title="Add"
        style={styles.placeButton}
        onPress={() => this.placeSubmitHandler(this.state.placeName)}
      />
    </View>
  );
}
```
3. 把從上層拿到的 props.places 做 map 逐一項讀出來，最後呈現在畫面上面
```
const placesOutput = props.places.map((place, i) => (
  <ListItem key={i} placeName={place}/>
));
return (
  <View style={styles.listContainer}>
    {placesOutput}
  </View>
);
```
### 使用 FlatList
1. 把剛剛的 view 改成 FlatList，可以用 renderItem 把項目一條一條列出來，
```
return (
  <FlatList
    style={styles.listContainer}
    data={props.places}
    renderItem={(info) => (
      <ListItem
        placeName={info.item.value}
        onItemPressed={() => props.onItemDeleted(info.item.key)}
      />
    )}
  />
);
```
2. 在 App.js 的 places state 放入 key 和 value，這樣在剛剛的 FlatList 就可以做使用
```
placeAddHandler = placeName => {
  this.setState( prevState => {
    return {
      places: prevState.places.concat({key: Math.random(), value: placeName})
    };
  });
};
```
3. 在 App.js 的地方比對 key，將 place.key 不等於 key 的值找出來回傳，就可以達到刪除的效果了
```
placeDeletedHandler = key => {
  this.setState( prevState => {
    return {
      places: prevState.places.filter(place => {
        return place.key !== key;
      })
    };
  });
};
```








