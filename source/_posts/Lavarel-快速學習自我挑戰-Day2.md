---
title: Lavarel 快速學習自我挑戰 Day2
thumbnail:
  - /blogs/images/learning/laravel/laravelday2.png
date: 2017-04-23 16:15:17
categories: 學習歷程
tags: Laravel
---
<img src="/blogs/images/learning/laravel/laravelday2.png">

***
### Laravel 目錄結構
/app/Http/Controllers：make request、routes 設定。
/config： 註冊外掛進入 packages、database 連線 (但是連線資訊都設定在根目錄的 .env)、mail 連線。
/database/migration：透過檔案建立資料，會非常常用。
/public：css folder、javascript folder、image folder。
/resources/views：存放畫面的位置，跟 controller 保持連線。
/vendor：存放套件的地方。

### Route 設定 - [路由設定官方文件](https://laravel.com/docs/5.2/routing)
**修改 /app/Http/routes.php**
傳 id, name 兩個變數到頁面的範例。
```
Route::get('/post/{id}/{name}', function($id, $name){
    return "This is post number ". $id . " " .$name;
});
```

### 路由命名法
查詢路由狀態。
`php artisan route:list`
將路由用簡短的方式命名，以下用`admin.home`來取得路由。
```
Route::get('admin/posts/example', array('as'=>'admin.home' ,function(){
    $url = route('admin.home');

    return "this url is ". $url;
}));
```
### Controller - [Controller 設定官方文件](https://laravel.com/docs/5.2/controllers)
1. Controller 是用來處理來自 database 資訊的 class，然後將資料丟到 view (反之亦然)。
2. Controller 路徑 - /app/Http/Controllers/Controller.php。
3. 用 terminal 創建一個 Controller。
    - `php artisan make:controller PostsController(Name)`
    - `php artisan make:controller --resource PostsController(Name)`

### 在路由設定 Controller
1. 設定 routes.php
`Route::get('/post', 'PostsController@index');` (讀取 Controller 的 index)
2. 修改 PostsController.php
`public function index() {return 'its working';}`

### 在 Controller 傳送 data
1. 設定 routes.php
`Route::get('/post/{id}', 'PostsController@index');` (讀取 Controller 的 index)
2. 修改 PostsController.php
`public function index($id) {return 'its working the number' . $id;}`

### Resources & Controller
1. 設定 routes.php - 用 resource 的做法會產生 GET、DELETE、PUT...等不同 Method。
`Route::resource('posts', 'PostsController');`
2. 檢查路由狀態
`php artisan route:list`
3. 測試 show method
`public function show($id) {return "This is the show method yaaa" . $id;}`
4. 測試 create method
`public function create() {return "I am the method that creates stuff:)";}`