---
title: JavaScript用AJAX的方式獲得時間
thumbnail:
  - /images/javascript.jpg
date: 2016-11-05 23:22:31
categories: Skill Share
tags:
---
<img src="/images/javascript.jpg">

***
1. 新增一個js的檔案，將以下程式碼複製貼上
```
var xmlHttp;
function srvTime(){
try {
  //FF, Opera, Safari, Chrome
  xmlHttp = new XMLHttpRequest();
}
catch (err1) {
  //IE
  try {
    xmlHttp = new ActiveXObject('Msxml2.XMLHTTP');
  }
  catch (err2) {
    try {
      xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
    }
    catch (eerr3) {
      //AJAX not supported, use CPU time.
      alert("AJAX not supported");
    }
  }
}
xmlHttp.open('HEAD',window.location.href.toString(),false);
xmlHttp.setRequestHeader("Content-Type", "text/html");
xmlHttp.send('');
return xmlHttp.getResponseHeader("Date");
}

var st = srvTime();
var date = new Date(st);
```
2. 新增時間
```
var localTime = new Date();
```
