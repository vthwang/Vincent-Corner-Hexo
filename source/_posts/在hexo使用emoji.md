---
title: 在hexo使用emoji
thumbnail:
  - /blogs/images/emoji.png
date: 2016-09-11 10:15:30
categories: 技術分享
tags:
---
<img src="/blogs/images/emoji.png">

***
## 修改渲染器

```
cd /workspace/blogs/   //跳轉到hexo的目錄
npm un hexo-renderer-marked --save
npm i hexo-renderer-markdown-it --save
```

## 下載markdown-it-emoji插件：

```
npm install markdown-it-emoji --save
```

## 編輯Hexo的最上層的配置文件_config.yml來配置markdown渲染器

```
markdown:
  render:
    html: true
    xhtmlOut: false
    breaks: true  //這邊我改成true直接在.md裡面enter就換行
    linkify: true
    typographer: true
    quotes: '“”‘’'
  plugins:
    - markdown-it-footnote
    - markdown-it-sup
    - markdown-it-sub
    - markdown-it-abbr
    - markdown-it-emoji
```
