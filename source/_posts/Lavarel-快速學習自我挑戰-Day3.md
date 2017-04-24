---
title: Lavarel 快速學習自我挑戰 Day3
thumbnail:
  - /blogs/images/learning/laravel/laravelday3.jpg
date: 2017-04-24 15:12:12
categories: 學習歷程
tags: Laravel
---
<img src="/blogs/images/learning/laravel/laravelday3.jpg">

***
### Views - [Views 設定官方文件](https://laravel.com/docs/5.2/views)
路徑：/resources/views
1. 在 Controller 新增一個 function
`public function contact(){return view('contact');}`
2. 新增一個 view (檔名為xxx.blade.php)
    - 可以將 view 的檔案設定在子目錄下。例：新增一個 pages/contact.php，路由部分則要設定為 `view(page/contact(或是page.contact)')`
3. Routes 設定
`Route::get('/contact', 'PostsController@contact');`

### 傳送 data 到 Views
1. 設定 Routes
`Route::get('post/{id}', 'PostsController@show_post');`
2. 在 Controller 新增一個 function
`public function show_post($id){return view('post')->with('id',$id);}`
3. 在 View 裡面使用 data `{{ "{{$id" }}}}`

### 傳送多 data 到 Views
1. 設定 Routes
`Route::get('post/{id}/{name}/{password}', 'PostsController@show_post');`
2. 在 Controller 使用 compact function
`public function show_post($id, $name, $password){return view('post', compact('id','name','password'));}`
3. 在 View 裡面使用 data

### blade (PHP模板引擎) - [blade 設定官方文件](https://laravel.com/docs/5.2/blade)
`!` + `tab` => html 模板
`div.container` + `tab` => class 為 container 的 div 容器
`@yield('content')` => 產生一個內容的區塊
`@extends('layouts.app')` => 使用 layouts.app 裡面的內容
`@section('content')` => 產生自定義內容

blade 使用範例：
1. 在 PostsController 裡的 Contact 新增人名 array，並傳送 data
`$people = ['Edwin', 'Jose', 'James', 'Peter', 'Maria'];`
`return view('contact', compact('people'));`
2. 在 contact.blade.php 裡面列出人名 (blade 的函式皆以 @ 開頭)
```
@if (count($people))
  <ul>
  @foreach($people as $person)
      <li>{{$person}}</li>
  @endforeach
  </ul>
@endif
```

### Database Migration - [Migration 設定官方文件](https://laravel.com/docs/5.2/migrations)
sqlite：file based database，資料庫內容儲存於檔案裡，應用於小專案。
1. 先設定 .env
2. `php artisan migrate` (將資料庫設定檔自動移入資料庫)

自定義 migration
1. 自行創建一個 migration 檔案：`php artisan make:migration (migration_NAME) (FLAG)`
範例：`php artisan make:migration create_posts_table --create="posts"`
2. 在 migration 裡面新增 table 項目。(`$table->string('title');`)

撤回上一步完成的 migration：`php artisan migrate:rollback`。

### 新增 column 到存在的 table
1. 新增一個 migration：`php artisan make:migration add_is_admin_column_to_posts_tables --table="posts"(定義相關table)`
2. 在新增的 migration 檔案的 up 新增 `$table->integer('is_admin')->unsigned();`
3. 在新增的 migration 檔案的 down 新增 `$table->dropColumn('is_admin');`

### Migration 命令
刪除所有資料庫內容：`php artisan migrate:reset`
更新資料庫內容(刪除資料庫再重新新增):`php artisan migrate:refresh`
確認 migration 狀態：`php artisan migrate:status`