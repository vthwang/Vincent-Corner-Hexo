---
title: WordPress 錯誤：WordPress 網站無法建立與 WordPress.org 間的安全連線（解決方法）
thumbnail:
  - /images/wordpress-2.png
date: 2019-08-28 14:44:23
categories: Skill Share
tags: WordPress
---
<img src="/images/wordpress-2.png">

***
1. 修改 /etc/hosts
`sudo vim /etc/hosts`
2. 在最下面加上一行
`66.155.40.202 api.wordpress.org`
3. 儲存離開