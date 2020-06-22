---
title: React快速學習自我挑戰 Day11
thumbnail:
  - /images/learning/react/reactday11.png
date: 2017-03-30 14:35:46
categories: Study Note
tags: React
toc: true
---
<img src="/images/learning/react/reactday11.png">

***
1. React Lifecycle method 是一個 React Component class 的 function，用來被 React 自動呼叫。
2. componentWillMount 是一個 Lifecycle method，他會在第一次 component 將要被 DOM render 的時候自動呼叫 componentWillMount，但是當下一次執行 component 的時候，就不會再執行 componentWillMount。
3. componentWillMount 用在不知道什麼情況下要 fetch data。
4. 如果要讓 react component 可以呼叫 action creator，我們必須要把 component 提升為 container。
5. 製作 container 的方法。
    * import connect
    * import action creator
    * 定義 mapDispatchToProps function，然後連接到 component。
6. [Redux Form](https://github.com/erikras/redux-form)。
7. `import { reducer as formReducer } from 'redux-form';`，import redux-form，拿取 reducer 這個 property，然後建立一個名為 formReducer 的變數。(此用法為了避免命名上的衝突)
8. `const { handleSubmit } = this.props;` === `const handleSubmit = this.props.handleSubmit;`
9. ` const { fields: { title, categories, content},  handleSubmit } = this.props;` === `const title = this.props.fields.title;`。
10. reduxform 可以被用來注入 action creators 到 component 裡面，然後創建一個在 component 外的 container。
11. reduxform 和 connect 的不同就是 reduxform 有一個額外的參數傳遞給他。
    * connect：第一個參數是 mapStateToProps，第二個是 mapDispatchToProps。
    * reduxform：第一個是 form config，第二個是 mapStateToProps，第三個是 mapDispatchToProps。
