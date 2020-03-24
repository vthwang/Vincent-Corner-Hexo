---
title: Lavarel 快速學習自我挑戰 Day22
thumbnail:
  - /images/learning/laravel/laravelday22.jpg
date: 2017-06-01 15:04:36
categories: Study Note
tags: Laravel
---
<img src="/images/learning/laravel/laravelday22.jpg">

***
### 部署 app 與共享主機
#### 主機相關
1. 申請 godaddy 主機[(一元主機)](http://www.tkqlhce.com/ie77p-85-7NVWVUVWTNPOWUQORV)
2. 啟用 ssh 連線並匯入金鑰 `ssh -i ~/.ssh/id_rsa 帳號@ip`
3. Select PHP verion => 選擇 5.6 => 啟用 zip => 儲存
#### Composer install
1. 預設就裝好了。
2. 如果沒有，使用 wget 或是 curl 取得 composer
`wget https://getcomposer.org/installer`
`curl -sS https://getcomposer.org/installer | php`
3. 檢查 composer 是否可用 `php installer --check`
4. 安裝 composer `php installer`
5. 執行 composer `php composer.phar`
#### laravel install
1. 用 composer 下載 laravel installer
`composer global require "laravel/installer"`
2. 新增 path 到 ~/.bash_profile
`export PATH="$PATH:$HOME/.composer/vendor/bin"`
3. 更新檔案
`source .bash_profile`
4. 執行 `laravel` 語法
#### 上傳專案
1. 直接到 cpanel 上傳檔案
#### 設定環境檔案
1. 下載相依檔案 `composer update`
2. 複製 env 範例檔 `cp .env.example .env`
3. 設定 .env
4. 新增 APP_KEY `php artisan key:generate` 
#### 發佈
1. 修改 documentroot 到 public folder
2. 如果主目錄路徑不同，可修改 public 目錄下的 index.php
3. 修改 config/app.php 的 URL 網址、時區(Asia/Taipei)
4. 將 adimin/media/index view 的 form path 改為 `delete/media`
5. 將 routes/web.php 的 delete media route 改為
`Route::get('admin/delete/media', 'AdminMediasController@deleteMedia');`
6. 修改 .env 將 debug 關閉且將環境改為 production
### 升級到 5.4
1. 刪除 bootstrap/cache/compiled.php
2. 修改 composer.json
`"phpunit/phpunit": "~5.7",`
`"laravel/framework": "5.4.*",`
`"laravelcollective/html": "5.4.*",`
`"cviebrock/eloquent-sluggable": "4.2.1",`
3. 更新套件 `composer update`
4. 清除快取 `php artisan view:clear`
5. 清除路由快取 `php artisan route:clear`
6. 刪除 gulpfile.js
7. 新增 webpack.mix.js
```
const { mix } = require ('laravel-mix');

mix.js('resources/assets/js/app.js', 'public/js')
    .sass('resources/assets/sass/app.css', 'public/css');

mix.styles([

    'resources/assets/css/libs/blog-post.css',
    'resources/assets/css/libs/bootstrap.css',
    'resources/assets/css/libs/font-awesome.css',
    'resources/assets/css/libs/metisMenu.css',
    'resources/assets/css/libs/sb-admin-2.css'

], 'public/css/libs.css');

mix.scripts([

    'resources/assets/js/libs/jquery.js',
    'resources/assets/js/libs/bootstrap.js',
    'resources/assets/js/libs/metisMenu.js',
    'resources/assets/js/libs/sb-admin-2.js',
    'resources/assets/js/libs/scripts.js'

], './public/js/libs.js');

```
8. 將 package.json 取代為
```
{
  "private": true,
  "scripts": {
    "dev": "node node_modules/cross-env/dist/bin/cross-env.js NODE_ENV=development node_modules/webpack/bin/webpack.js --progress --hide-modules --config=node_modules/laravel-mix/setup/webpack.config.js",
    "watch": "node node_modules/cross-env/dist/bin/cross-env.js NODE_ENV=development node_modules/webpack/bin/webpack.js --watch --progress --hide-modules --config=node_modules/laravel-mix/setup/webpack.config.js",
    "watch-poll": "node node_modules/cross-env/dist/bin/cross-env.js NODE_ENV=development node_modules/webpack/bin/webpack.js --watch --watch-poll --progress --hide-modules --config=node_modules/laravel-mix/setup/webpack.config.js",
    "hot": "node node_modules/cross-env/dist/bin/cross-env.js NODE_ENV=development node_modules/webpack-dev-server/bin/webpack-dev-server.js --inline --hot --config=node_modules/laravel-mix/setup/webpack.config.js",
    "production": "node node_modules/cross-env/dist/bin/cross-env.js NODE_ENV=production node_modules/webpack/bin/webpack.js --progress --hide-modules --config=node_modules/laravel-mix/setup/webpack.config.js"
  },
  "devDependencies": {
    "axios": "^0.15.3",
    "bootstrap-sass": "^3.3.7",
    "jquery": "^3.1.1",
    "laravel-mix": "^0.8.1",
    "lodash": "^4.17.4",
    "vue": "^2.2.2"
  }
}
```
9. 安裝相依套件 `npm install`
10. 執行 webpack `npm run dev`
11. 監控 webpack 任何變化 `npm run watch`
### 完成課程結業證書
<img src="/images/learning/laravel/EdwinDiaz_Laravel.jpg">