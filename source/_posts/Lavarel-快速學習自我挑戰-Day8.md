---
title: Lavarel 快速學習自我挑戰 Day8
thumbnail:
  - /images/learning/laravel/laravelday8.png
date: 2017-04-29 23:21:35
categories: 學習歷程
tags: Laravel
---
<img src="/images/learning/laravel/laravelday8.png">

***
### Polymorphic Relationship (CRUD) - [Eloquent Relationship 設定官方文件](https://laravel.com/docs/5.2/eloquent-relationships)
1. 安裝＋設定
    - 新增一個專案
    `composer create-project --prefer-dist laravel/laravel polymorphic 5.2.29`
    - 建立資料庫 & 設定 .env
2. 資料庫設定和 migration
    - 新增 三個model
    `php artisan make:model Staff -m`
    `php artisan make:model Product -m`
    `php artisan make:model Photo -m`
    - 新增 Staff 和 Product migration 欄位
    `$table->string('name');`
    - 新增 Photo migration 欄位
    `$table->string('path');`
    `$table->integer('imageable_id');`
    `$table->string('imageable_type');`
    - 進行 migrate
    `php artisan migrate`
3. 設定 Relation 和 mass assignment
    - 在 Photo.php 設定 Relation
    `public function imageable(){return $this->morphTo();}`
    - 在 Photo.php 新增 protected，讓資料可填入
    `protected $fillable = ['path'];`
    - 在 Staff.php 和 Product.php 設定 Relation
    `public function photos(){return $this->morphMany('App\Photo', 'imageable');}`
    - 在 Staff.php 新增 protected，讓資料可填入
    `protected $fillable = ['name'];`
4. 新增資料
    - 新增 routes
```
use App\Staff;

Route::get('/create', function(){

    $staff = Staff::find(1);

    $staff->photos()->create(['path'=>'example.jpg']);


});
```
5. 讀取資料
    - 新增 routes
```
Route::get('/read', function(){

    $staff = Staff::findOrFail(1);

    foreach($staff->photos as $photo){

        return $photo->path;

    }

});
```
6. 更新資料
    - 新增 routes
```
Route::get('/update', function(){

    $staff = Staff::findOrFail(1);

    $photo = $staff->photos()->whereId(1)->first();

    $photo->path = "Update example.jpg";

    $photo->save();

});
```
7. 刪除資料
    - 新增 routes
```
Route::get('/delete', function(){

    $staff = Staff::findOrFail(1);

    $staff->photos()->whereId(1)->delete();

});
```
8. Assign & Unassign
    - assign
    `Route::get('/assign', function(){`
        `$staff = Staff::findOrFail(1);`
        `$photo = Photo::findOrFail(4);`
        `$staff->photos()->save($photo);`
    `});`
    - unassign
    `Route::get('/un-assign', function(){`
    `$staff = Staff::findOrFail(1);`
    `$staff->photos()->whereId(4)->update(['imageable_id'=>'', 'imageable_type'=>'']);`
    `});`
### Polymorphic Many to Many Relationship (CRUD) - [Eloquent Relationship 設定官方文件](https://laravel.com/docs/5.2/eloquent-relationships)
1. 安裝＋設定
    - 新增一個專案
    `composer create-project --prefer-dist laravel/laravel polymorphicmanytomany 5.2.29`
    - 建立資料庫 & 設定 .env
2. 資料庫設定和 migration 
    - 新增 三個model
    `php artisan make:model Post -m`
    `php artisan make:model Video -m`
    `php artisan make:model Tag -m`
    `php artisan make:model Taggable -m`
    - 新增 Post、Video 和 Tag migration 欄位
    `$table->string('name');`
    - 新增 Taggable migration 欄位
    `$table->integer('tag_id');`
    `$table->integer('taggable_id');`
    `$table->string('taggable_type');`
    - 進行 migrate
    `php artisan migrate`
3. 設定 Relation 和 mass assignment
    - 在 Post.php 和 Video.php 設定 Relation
    `public function tags(){return $this->morphToMany('App\Tag', 'taggable');}`
    - 在 Post.php、Video.php 和 Tag.php 新增 protected，讓資料可填入
    `protected $fillable = ['name'];;`
4. 新增資料
    - 新增 routes
```
Route::get('/create', function(){

    $post = Post::create(['name'=>'My first post 1']);

    $tag1 = Tag::find(1);

    $post->tags()->save($tag1);

    $video = Video::create(['name'=>'Video.mov']);

    $tag2 = Tag::find(2);

    $video->tags()->save($tag2);

});
```
5. 讀取資料
    - 新增 routes
```
Route::get('/read', function(){

    $post = Post::findOrFail(1);

    foreach ($post->tags as $tag){

        echo $tag;

    }

});
```
5. 更新資料
    - 新增 routes
```
Route::get('/update', function(){

//    $post = Post::findOrFail(1);
//
//    foreach ($post->tags as $tag){
//
//        return $tag->whereName('PHP')->update(['name'=>'Updated PHP']);
//
//    }

    $post = Post::findOrFail(1);

    $tag = Tag::find(2);

    $post->tags()->save($tag);

//    $post->tags()->attach($tag);
//
//    $post->tags()->sync([1,2]);

});
```
6. 刪除資料
    - 新增 routes
```
Route::get('/delete', function(){

    $post = Post::find(2);

    foreach ($post->tags as $tag){

        $tag->whereId(4)->delete();

    }


});
```