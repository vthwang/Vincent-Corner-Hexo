---
title: Lavarel 快速學習自我挑戰 Day13
thumbnail:
  - /images/learning/laravel/laravelday13.jpg
date: 2017-05-04 03:07:21
categories: Study Note
tags: Laravel
toc: true
---
<img src="/images/learning/laravel/laravelday13.jpg">

***
### Application
#### 基礎設定
1. 開新的專案 `composer create-project --prefer-dist laravel/laravel codehacking 5.2.29`
2. 新增資料庫、設定環境變數、進行 migration `php artisan migrate`
#### 設定 views
1. 新增登入介面 `php artisan make:auth`
2. 在 view 將目錄權限分開 新增 `admin/index` `admin/users/index` `admin/users/create` `admin/users/edit` `admin/posts/index` `admin/posts/create` `admin/posts/edit` `admin/categories/index` `admin/categories/edit`
#### User table migration
1. 加入 git 專案：`git init`、`git add .`、`git commit -m "my first commit - admin view created"`
2. 新增資料欄位到 create\_users_table.php
`$table->integer('role_id')->index()->unsigned()->nullable();`
`$table->integer('is_active')->default(0);`
3. 新增 model `php artisan make:model Role -m`
4. 新增資料欄位到 create\_roles_table.php
`$table->string('name');`
#### Relation setup and data entry
1. 新增 Relation 到 User model
```
    public function role(){

        return $this->belongsTo('App\Role');

    }
```
2. 將資料重新 migrate 到資料庫 `php artisan migrate:refresh`
#### 用 Tinker 測試 Relation
1. 進入 tinder 模式 `php aritsan tinker`
2. 找到第一個 User `$user = App\User::find(1)`
3. 檢查該 user 的 role `$user->role`
4. 新增 User ` App\User::create(['name'=>'Edwin Diaz', 'email'=>'edwin@codingfaculty.com']);`
#### Admin Controller and Routes
1. 新增 routes `Route::resource('admin/users', 'AdminUsersController');`
2. 新增 controller `php artisan make:controller --resource AdminUsersController`
3. 在 AdminUsersController 的 index function 加入 `return view('admin.users.index');`
4. 在 AdminUsersController 的 create function 加入 `return view('admin.users.create');`
5. 在 AdminUsersController 的 show function 加入 `return view('admin.users.show');`
6. 在 AdminUsersController 的 edit function 加入 `return view('admin.users.edit');`
#### 安裝 nodejs & 下載檔案
1. 安裝 gulp `npm install --global gulp`
#### Gulp & assets
1. 安裝套件 `npm install`
2. 將 css、js 檔案放置到 resources\assets
3. 將 font 檔案放置到 public
4. 設定 gulpfile.js
```
    .styles([
        
        'libs/blog-post.css',
        'libs/bootstrap.css',
        'libs/font-awesome.css',
        'libs/metisMenu.css',
        'libs/sb-admin-2.css'
        
    ], './public/css/libs.css')
    
    .scripts([
        
        'libs/jquery.js',
        'libs/bootstrap.js',
        'libs/metisMenu.js',
        'libs/sb-admin-2.js',
        'libs/scripts.js'
        
    ], './public/js/libs.js')
```
5. 編譯檔案 `gulp`
6. 新增 view /layouts/admin.blade.php
#### 修正頁面
1. 修改 resources/assets/sass/app.scss
`#admin-page {padding-top: 0px;}`
2. 重新編譯檔案 `gulp`
3. 新增 routes
```
Route::get('/admin', function(){

   return view('admin.index');

});
```
4. 修改 admin/index view
```
@extends('layouts.admin')

@section('content')

    <h1>Admin</h1>

@stop
```
#### 顯示 Users
1. 修改 admin/users/index view
```
@extends('layouts.admin')

@section('content')

    <h1>Users</h1>

@stop
```
2. 修改 AdminUsersController
```
public function index()
    {
        $users = User::all();

        return view('admin.users.index', compact('users'));
    }
```
3. 在 admin/users/index view 新增 table
```
    <table class="table">
      <thead>
        <tr>
            <th>Id</th>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Active</th>
            <th>Created</th>
            <th>Updated</th>
        </tr>
      </thead>
      <tbody>
      @if($users)

          @foreach($users as $user)

        <tr>
            <td>{{$user->id}}</td>
            <td>{{$user->name}}</td>
            <td>{{$user->email}}</td>
            <td>{{$user->role->name}}</td>
            <td>{{$user->is_active == 1 ? 'Active' : 'No Active'}}</td>
            <td>{{$user->created_at->diffForHumans()}}</td>
            <td>{{$user->updated_at->diffForHumans()}}</td>
        </tr>

          @endforeach

      @endif
      </tbody>
    </table>
```
#### 新增 Create Page
```
@extends('layouts.admin')

@section('content')

    <h1>Create User</h1>

@stop
```
#### 安裝 laravel collective html package
1. `composer require "laravelcollective/html":"^5.2.0"`
2. 在 config/app.php 新增 provider `Collective\Html\HtmlServiceProvider::class,`
3. 在 config/app.php 新增 aliases
`'Form' => Collective\Html\FormFacade::class,`
`'Html' => Collective\Html\HtmlFacade::class,`
#### Create Page Form 表單
1. 在 admin/users/create view 新增表單
```
{!! Form::open(['method'=>'POST', 'action'=>'AdminUsersController@store']) !!}
        <div class="form-group">
            {!! Form::label('name', 'Name:') !!}
            {!! Form::text('name', null, ['class'=>'form-control']) !!}
        </div>

        <div class="form-group">
            {!! Form::label('email', 'Email:') !!}
            {!! Form::email('email', null, ['class'=>'form-control']) !!}
        </div>

        <div class="form-group">
            {!! Form::label('role_id', 'Role:') !!}
            {!! Form::select('role_id', [''=>'Choose Options'] + $roles , null, ['class'=>'form-control']) !!}
        </div>

        <div class="form-group">
            {!! Form::label('status', 'Status:') !!}
            {!! Form::select('status', array(1 => 'Active', 0 => 'No Active'), 0, ['class'=>'form-control']) !!}
        </div>

        <div class="form-group">
            {!! Form::label('password', 'Password:') !!}
            {!! Form::password('password', ['class'=>'form-control']) !!}
        </div>

        {{csrf_field()}}

        <div class="form-group">
            {!! Form::submit('Create User', ['class'=>'btn btn-primary']) !!}
        </div>
    {!! Form::close() !!}
```
2. Role 的資料引入 (用 controller 抓取資料) - 修改 AdminUsersController
```
public function create()
    {
        $roles = Role::lists('name', 'id')->all();

        return view('admin.users.create', compact('roles'));
    }
```
3. 新增 Request `php artisan make:request UsersRequest`
4. 新增 rules function validation
```
public function rules()
    {
        return [
            'name' => 'required',
            'email' => 'required',
            'role_id' => 'required',
            'is_active' => 'required',
            'password' => 'required'
        ];
    }
```
5. 將 AdminUsersController 的 store function 的 Request 換成 UsersRequest (要 import)
`public function store(UsersRequest $request)`
6. 新增 views/includes/form_error.blade.php
```
@if(count($errors) > 0)

    <div class="alert alert-danger">

        <ul>

            @foreach($errors->all() as $error)

                <li>{{$error}}</li>

            @endforeach

        </ul>

    </div>

@endif
```
7. 在 create page view include form error `@include('includes.form_error')`