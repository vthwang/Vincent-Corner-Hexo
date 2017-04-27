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

4. 
