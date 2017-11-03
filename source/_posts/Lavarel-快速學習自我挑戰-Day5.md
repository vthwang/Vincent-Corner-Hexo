---
title: Lavarel 快速學習自我挑戰 Day5
thumbnail:
  - /images/learning/laravel/laravelday5.jpeg
date: 2017-04-26 10:19:30
categories: 學習歷程
tags: Laravel
---
<img src="/images/learning/laravel/laravelday5.jpeg">

***
### Eloquent Relationship - [Eloquent Relationship 設定官方文件](https://laravel.com/docs/5.2/eloquent-relationships)
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
6. Has Many Through Relation
    - 新增一個 model
    `php artisan make:model Country -m`
    - 新增一個 migration
    `php artisan make:migration add_country_id_column_to_users --table=users`
    - 到 add\_country\_id\_column\_to_users.php 的 up function 新增
    `$table->integer('country_id');`
    - 到 add\_country\_id\_column\_to_users.php 的 down function 新增
    `$table->dropColumn('country_id');`
    - 到 create\_countries_table 新增
    `$table->string('name');`
    - 匯入資料庫
    `php artisan migrate`
    - 在 Country Model 新增 function
    `public function posts(){return $this->hasManyThrough('App\Post', 'App\User');}`
    - 在 routes 引入 Model
    `use App\Country`
    - 新增 routes
```
Route::get('/user/country', function(){

$country = Country::find(4);

foreach ($country->posts as $post){

    return $post->title;;

}

});
```
7. Polymorphic Relation
    - 新增 photo 的 Model
    `php artisan make:model Photo -m`
    - 在 create\_photos_table 新增以下欄位
    `$table->string('path');`
    `$table->integer('imageable_id');`
    `$table->string('imageable_type');`
    - 匯入資料庫
    `php artisan migrate`
    -  不需要 user\_id，在 create\_post_talbe 移除並更新
    `$table->integer('user_id')->unsigned();`
    `php artisan migrate:refresh`
    - 在 Photo.php 新增一個 function
    `public function imageable() {return $this->morphTo();}`
    - 在 Post.php 和 User.php 各新增一個 function
    `public function photos(){return $this->morphMany('App\Photo', 'imageable');}`
    - 新增 routes
```
Route::get('post/{id}/photos', function($id){

    $post = Post::find($id);

        foreach($post->photos as $photo){

            echo $photo->path . "<br>";

        }

});
```
8. Reverse Polymorphic Relation
    - 在 routes 引入 Model
    `use App\Photo;`
    - 新增 routes
```
Route::get('photo/{id}/post', function($id){

    $photo = Photo::findOrFail($id);

    return $photo->imageable;

});
```
9. Many to Many Polymorphic Relation
    - 新增三個 model
    `php artisan make:model Video -m`
    `php artisan make:model Tag -m`
    `php artisan make:model Taggable -m`
    - 在 create\_videos\_table 和 create\_tags\_table 建立 name 的 table
    `$table->string('name');`
    - 在 create_taggables_table 建立以下 table
    `$table->integer('tag_id');`
    `$table->integer('taggable_id');`
    `$table->string('taggable_type');`
    - 在 Post.php 新增 morphToMany function
    `public function tags(){return $this->morphToMany('App\Tag', 'taggable');}`
    - 在 Tag.php  新增 morphedByMany function
    `public function posts(){ return $this->morphedByMany('App\Post', 'taggable');}`
    `public function videos(){return $this->morphedByMany('App\Video', 'taggable');}`
    - 匯入 migrate
    `php artisan migrate`
    - 新增 routes
    `Route::get('/post/tag', function(){`
        `$post = Post::find(1);`
        `foreach ($post->tags as $tag){`
            `echo $tag->name;`
        `}`
    `});`
    - import Tag model
    `use App\Tag;`
    - 新增 routes
    `Route::get('/tag/post', function(){`
    `$tag = Tag::find(2);`
    `foreach($tag->posts as $post){`
        `return $post->title;`
    `}`
    `});`


