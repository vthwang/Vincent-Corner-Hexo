---
title: Wordpress 處理中文檔名上傳
thumbnail:
  - /images/wordpress.png
date: 2017-03-04 16:29:52
categories: Skill Share
tags: WordPress
---
<img src="/images/wordpress.png">

***
1. 修改  wp-admin\includes\file.php
找：
```
$filename = wp_unique_filename( $uploads['path'], $file['name'], $unique_filename_callback );
```
在其後加上：
```
$fileTypeNameArr =explode("." , $filename);
$countNum=count($fileTypeNameArr)-1;
$fileExt = $fileTypeNameArr[$countNum]; //取得所上傳文件後綴名
$filename = time().'-'.rand(0,999999999).'.'.$fileExt;//將文件由原名改為時間戳
```

這樣上傳的文件會以時間戳為名稱儲存。
上傳中文名的文件後，依然能夠將原中文文件名作為文件的標題。
在後台管理界面顯示的是中文標題，因此對於使用沒有影響。
