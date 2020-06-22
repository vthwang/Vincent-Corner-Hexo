---
title: Lavarel 快速學習自我挑戰 Day6
thumbnail:
  - /images/learning/laravel/laravelday6.jpg
date: 2017-04-27 10:19:30
categories: Study Note
tags: Laravel
toc: true
---
<img src="/images/learning/laravel/laravelday6.jpg">

***
### Tinker
1. 使用 Tinker 建立資料
    - 進入 Tinker 模式
    `php artisan tinker`
    - 建立資料
    `$post = App\Post::create(['title'=>'PHP post from tinker','content'=>'PHP content from tinker']);`
    - 再看一次資料
    `$post`
    - 創建物件
    `$post = new App\Post`
    - 新增 title 到物件
    `$post->title = "New Title from this object"`
    - 新增 content 到物件
    `$post->content = "yeah baby I\'m coding and doing awesome"`
    - 寫入資料庫
    `$post->save()`
    - 離開 Tinker 模式
    `exit`
2. 使用 Tinker 讀取資料庫
    - 讀取資料
    `$post = App\Post::find(5);`
    - 用 constraint 的方式讀取
    ` $post = App\Post::where('id', 5)->first();`
    `$post = App\Post::whereId(5)->first();`
3. 更新和刪除資料庫
    - 更新 title
    `$post->title = "update record with id 4"`
    - 更新 content
    `$post->content = "updated record content with id 4"`
    - 寫入資料庫 `$post->save()`
    - 從資料庫刪除(丟入垃圾桶) `$post->delete()`
    - 從資料庫強迫刪除
    `$post = App\Post::onlyTrashed()`
    `$post->forceDelete()`
4. Relations in Tinker
    - 搜尋 User
    `$user = App\User::find(1)`
    - 搜尋 User 相關的 role
    `$user->roles`

### One to One Relationship (CRUD) - [Eloquent Relationship 設定官方文件](https://laravel.com/docs/5.2/eloquent-relationships)
1. 安裝＋設定
    - 新增一個專案
    `composer create-project --prefer-dist laravel/laravel onetoone 5.2.29`
    - 建立資料庫 & 設定 .env
2. 資料庫設定和 migration
    - 新增 model
    `php artisan make:model Address -m`
    - 新增欄位
    `$table->string('name');`
    - 進行 migrate
    `php artisan migrate`
3. 設定 Relation
    - 新增欄位
    `$table->integer('user_id')->nullable();`
    - 重新 migrate
    `php artisan migrate:refresh`
    - 在 User.php 設定 Relation
    `public function address(){return $this->hasOne('App\Address');}`
    - 在資料庫 insert User
    - 在 Address.php 新增 protected，讓資料可填入
    `protected $fillable = ['name'];`
    - 用 routes 新增資料
```
use App\User;
use App\Address;

Route::get('/insert', function(){

    $user = User::findOrFail(1);

    $address = new Address(['name'=>'1234 Houston av NY NY 11218']);

    $user->address()->save($address);

});
```
4. 更新資料
    - 新增 routes
```
Route::get('/update', function(){

    $address = Address::whereUserId(1)->first();

    $address->name = "4353 Update Av, alaska";

    $address->save();

});
```
5. 讀取資料
    - 新增 routes
```
Route::get('/read', function(){

    $user = User::findOrFail(1);

    echo $user->address->name;

});
```
6. 刪除資料
    - 新增 routes
```
Route::get('/delete', function(){

    $user = User::findOrFail(1);

    $user->address()->delete();

    return "done";

});
```
