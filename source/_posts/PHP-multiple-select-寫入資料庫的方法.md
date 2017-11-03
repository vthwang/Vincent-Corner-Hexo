---
title: PHP multiple select 寫入資料庫的方法
thumbnail:
  - /images/php_mysql_array.jpg
date: 2016-12-01 13:48:23
categories: 技術分享
tags:
---
<img src="/images/php_mysql_array.jpg">

***
1. 填入文字的頁面需要用陣列的方式傳遞資料 `name="item[]"`
```
<label for="item[]" class="formTitle">選擇項目</label>
<select name="item[]" class="form-control selectpicker" multiple>
  <option>項目一</option>
  <option>項目二</option>
  <option>項目三</option>
</select>
```
2. 在取得值之前，要先將取得的陣列用文字的方式顯示。
```
// 得到 item 的值
$item= $_POST["item"];
// 將取得的陣列用「、」分開
$itemArray= implode("、", $item);
```
3. 將得到的值寫入 DataTable 資料表內的 DataColumn 欄位，值為剛剛取得的陣列值 `$itemarray`
```
$sql_query = INSERT INTO DataTable (`DataColumn`) VALUES ('$itemarray');
```
