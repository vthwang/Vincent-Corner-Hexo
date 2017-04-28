---
title: Lavarel 快速學習自我挑戰 Day5
thumbnail:
  - /blogs/images/learning/laravel/laravelday5.jpeg
date: 2017-04-26 10:19:30
categories: 學習歷程
tags: Laravel
---
<img src="/blogs/images/learning/laravel/laravelday5.jpeg">

***
### Eloquent Relationship
1. One to One Relationship
    - 新增 user_id 到 migration
    `$table->integer('user_id')->unsigned();`
    - 新增一個 function 到 User.php
    `public function post(){return $this->hasOne('App\Post');}`
    - 新增 routes
    `Route::get('/user/{id}/post', function($id){return User::find($id)->post->title;});`
2. Reverse One to One Relationship (Inverse Relationship)
    - 新增一個 function 到 Post.php
    `public function user(){return $this->belongsTo('App\User');}`
    - 新增 routes
    `Route::get('/user/{id}/post', function($id){return User::find($id)->post->content;});`
3. One to Many Relationship
    - 新增一個 function 到  User.php
    `public function posts(){return $this->hasMany('App\Post');}`
    - 新增 routes
```
    Route::get('/posts', function(){

    $user = User::find(1);

    foreach ($user->posts as $post) {

        echo $post->title ."<br>"; (不要使用 return，return 只能傳回一個內容)

    }

});
```
4. Many to Many Relationship
    - 新增一個 model
    `php artisan make:model Role -m`
    - 新增一個 migration
    `php artisan make:migration create_users_roles_table --create=role_user`
    - 在 create\_roles_table 新增姓名
    `$table->string('name');`
    - 在 create\_users\_roles\_table 新增 user\_id 和 role\_id
    `$table->integer('user_id');`
    `$table->integer('role_id');`
    - 在 User.php 新增一個 function
    `public function roles(){return $this->belongsToMany('App\Role');}`
    - 新增 routes (1)
    `Route::get('/user/{id}/role', function($id){`
    `$user = User::find($id);`
    `foreach ($user->roles as $role) {return $role->name;}});`
    - 新增 routes (2)
    `Route::get('/user/{id}/role', function($id){`
        `$user = User::find($id)->roles()->orderBy('id', 'desc')->get();`
        `return $user;`
    `});`
5. 取得 Intermediate table
    - 在  Role.php 新增 belongsToMany
    `public function users(){return $this->belongsToMany('App\User');}`
    - 在 User.php 的 roles function 新增 withPivot
    `return $this->belongsToMany('App\Role')->withPivot('created_at');`
    - 新增 routes
```
Route::get('/user/pivot', function(){

    $user = User::find(1);

    foreach($user->roles as $role){

        return $role->pivot->created_at;

    }

});
```
6. 
