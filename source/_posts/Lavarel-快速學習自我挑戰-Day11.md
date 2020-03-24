---
title: Lavarel 快速學習自我挑戰 Day11
thumbnail:
  - /images/learning/laravel/laravelday11.jpg
date: 2017-05-02 03:43:56
categories: Study Note
tags: Laravel
---
<img src="/images/learning/laravel/laravelday11.jpg">

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
#### 取得登入的使用者資料
1. 修改 HomeController
```
public function index()
    {
        $user = Auth::user();

        return view('home', compact('user'));
    }
```
2. 在 view 取得資料 `{{ "{{$user->name" }}}}`
3. `Auth::check`：檢查登入資料、`Auth::attempt`：檢查是否有權限。
### Middleware - [Middleware 設定官方文件](https://laravel.com/docs/5.2/middleware)
#### 建立 Middleware
1. 建立一個新的 middleware：`php artisan make:middleware RoleMiddleware`
2. 進入維護模式：`php artisan down`
3. 關閉維護模式：`php artisan up`
4. 在 kernal.php 新增 alias：`'role' => \App\Http\Middleware\RoleMiddleware::class,`
5. 新增 routes `Route::get('/admin/user/roles', ['middleware'=>'role', function(){return "Middleware role";}]);`
6. 修改 RoleMiddleware 導向至首頁 `return redirect('/');`
#### Middleware 應用 - roles, migration and relations
1. 新增 Role Model：`php artisan make:model Role -m`
2. 新增 role_id 到 User table：`$table->integer('role_id');`
3. 新增 name 到 Role table：`$table->string('name');`
4. 更新資料庫：`php artisan migrate:refresh`
5. 在 User Model 新增 relation
```
    public function role(){
    
        return $this->belongsTo('App\Role');
        
    }
```
#### Middleware 應用 1
1. 新增一個新的 middleware：`php aritsan make:middleware IsAdmin`
2. 在 kernal.php 新增 alias：`'IsAdmin' => \App\Http\Middleware\IsAdmin::class,`
3. 在 User Model 新增 function
```
    public function isAdmin(){

        if($this->role->name == 'administrator'){

            return true;

        }

        return false;

    }
```
4. 在 routes 測試 function
```
    if($user->isAdmin()){

        echo "this user is a administrator";

    }
```
#### Middleware 應用 2
1. 將 function 從 routes 移動到 IsAdmin middle ware 的 handle function
```
    $user = Auth::user();

    if($user->isAdmin()){

        return redirect()->intended('/admin');

    }
```
2. 新增 routes 連到 controller：`Route::get('/admin', 'AdminController@index');`
3. 新增 controller：`php artisan make:controller AdminController`
4. 新增 function 到 controller
```
public function __construct()
    {
        $this->middleware('IsAdmin');
    }
    
    public function index(){
        
        return "you are and administrator because you are seeing this page";
        
    }
```
5. 如果不是 administrator 就導向首頁
```
    $user = Auth::user();

    if(!$user->isAdmin()){

        return redirect('/');

    }
```