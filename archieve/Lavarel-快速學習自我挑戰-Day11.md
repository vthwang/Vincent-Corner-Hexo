---
title: Lavarel 快速學習自我挑戰 Day11
thumbnail:
  - /blogs/images/learning/laravel/laravelday11.jpg
date: 2017-05-02 03:43:56
categories: 學習歷程
tags: Laravel
---
<img src="/blogs/images/learning/laravel/laravelday11.jpg">

***
### Form Login - [Authentication 設定官方文件](https://laravel.com/docs/5.2/authentication)
#### 安裝新的 Laravel
1. `composer create-project --prefer-dist laravel/laravel login 5.2.29`
2. 設定 vhost
#### Database 連線和 migration
1. 建立資料庫、設定 .env
2. 直接 migrate `php artisan migrate`
#### 建立登入系統
1. `php artisan make:auth`
#### 