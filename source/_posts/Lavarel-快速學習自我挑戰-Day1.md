---
title: Lavarel 快速學習自我挑戰 Day1
thumbnail:
  - /blogs/images/learning/laravel/laravelday1.jpg
date: 2017-04-22 03:00:35
categories: 學習歷程
tags: Laravel
---
<img src="/blogs/images/learning/laravel/laravelday1.jpg">

***
### 安裝 PHP 環境
1. 安裝 [XAMPP](https://www.apachefriends.org/download.html)，選 PHP 最新版本。
2. 啟動 XAMPP，網址列輸入 localhost，可以看到 XAMPP 的最新畫面。

### 安裝 IDE (PhpStorm)
1. [官方網站](https://www.jetbrains.com/phpstorm/)。
2. [學生免費](https://www.jetbrains.com/phpstorm/buy/#edition=discounts)。
3. [下載 IDE](https://www.jetbrains.com/phpstorm/download/)。

### Install Composer (相依套件管理器)
1. [Composer官方網站](https://getcomposer.org/)。
2. 找套件的網站：[packagist](https://packagist.org/)。
3. [Download Composer](https://getcomposer.org/download/)。
4. 按照程式碼安裝之後，會產生一個 composer.phar，為了要在全域使用，在 .zshrc 裡面加上`export PATH="~/.composer/vendor/bin:$PATH"`，在指令列用`source .zshrc`更新檔案。

### 啟動 laravel 專案
1. `composer create-project --prefer-dist laravel/laravel cms 5.2.29`
2. 更改讀取權限 `chmod -R o+w cms/storage`，就可以直接預覽了。
3. 如果不想修改權限，可以在修改 httpd 設定檔。
`vim /Applications/XAMPP/xamppfiles/etc/httpd.conf`
將 `User daemon` 改成 `User 你的Username`。

### Virtual hosts
1. 修改 httpd 設定檔
`vim /Applications/XAMPP/xamppfiles/etc/httpd.conf`
把 Virtaul hosts include 進去 (將 # 移除)
`Include etc/extra/httpd-vhosts.conf`
2. 修改 hosts 檔案
`vim /etc/hosts`
加上 `127.0.0.1 cms.dev`
3. 修改 vhosts 設定檔
`vim /Applications/XAMPP/etc/extra/httpd-vhosts.conf`
將檔案修改為以下格式
```
# <URL:http://httpd.apache.org/docs/2.4/vhosts/>
# for further details before you try to setup virtual hosts.
#
# You may use the command line option '-S' to verify your virtual host
# configuration.

NameVirtualHost *:80

#
# VirtualHost example:
# Almost any Apache directive may go into a VirtualHost container.
# The first VirtualHost section is used for all requests that do not
# match a ServerName or ServerAlias in any <VirtualHost> block.
#
<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot "/Applications/XAMPP/xamppfiles/htdocs"
    ServerName localhost
    ServerAlias www.localhost
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host2.example.com
    DocumentRoot "/Applications/XAMPP/xamppfiles/htdocs/cms/public"
    ServerName cms.dev
#    ErrorLog "logs/dummy-host2.example.com-error_log"
#    CustomLog "logs/dummy-host2.example.com-access_log" common
</VirtualHost>
```

### 用 PhpStorm 打開專案
1. 點選 open，選擇 laravel 專案目錄。

### 觀念摘錄
1. MVC 架構 Model (Deals with Databse), View (Deals with the HTML), Controller (The middle-man)。
2. 快捷鍵設定 --- 加入 .zshrc
輸入 `desk` 直接跳到桌面
`alias desk="cd /Users/**USERNAME**/Desktop"`
輸入 `refzsh` 更新 .zshrc
`alias refzsh="source ~/.zshrc"`
輸入 `zsh` 編輯 .zshrc
`alias zsh="vim ~/.zshrc"`
輸入 `htdocs` 跳轉到 htdocs 目錄
`alias htdocs="cd /Applications/XAMPP/htdocs"`