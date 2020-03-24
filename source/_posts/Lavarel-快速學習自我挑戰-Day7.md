---
title: Lavarel 快速學習自我挑戰 Day7
thumbnail:
  - /images/learning/laravel/laravelday7.jpeg
date: 2017-04-28 23:21:35
categories: Study Note
tags: Laravel
---
<img src="/images/learning/laravel/laravelday7.jpeg">

***
### One to Many Relationship (CRUD) - [Eloquent Relationship 設定官方文件](https://laravel.com/docs/5.2/eloquent-relationships)
1. 安裝＋設定
    - 新增一個專案
    `composer create-project --prefer-dist laravel/laravel onetomany 5.2.29`
    - 建立資料庫 & 設定 .env
2. 資料庫設定和 migration
    - 新增 model
    `php artisan make:model Post -m`
    - 新增欄位
    `$table->integer('user_id')->unsigned()->nullable()->index();`
    `$table->string('title');`
    `$table->text('body');`
    - 進行 migrate
    `php artisan migrate`
3. 設定 Relation 和 mass assignment
    - 在 User.php 設定 Relation
    `public function posts() {return $this->hasMany('App\Post');}`
    - 在 Post.php 新增 protected，讓資料可填入
    `protected $fillable = ['title','body'];`
4. 用 tinker 和 routes 新增資料
    - 進入 tinker 模式
    `php artisan tinker`
    - 新增一筆 User
    `App\User::create(['name'=>'Edwin Diaz', 'email'=>'edwin@codingfaculty.com', 'password'=>bcrypt("123")])`
    - 離開 tinker 模式
    `exit`
    - 用 routes 的方式
```
Route::get('/insert', function(){

    $user = User::findOrFail(1);

    $post = new Post(['title'=>'My first post with Edwin Diaz', 'body'=>'I love Laravel, with Edwin Diaz']);
    
    $user->posts()->save($post);
    
});
```
5. 讀取資料
    - 新增 routes
```
Route::get('/read', function(){

    $user = User::findOrFail(1);

//    dd($user); //一種 collection object

    foreach($user->posts as $post){

        echo $post->title . "<br>";

    }

});
```
6. 更新資料
    - 新增 routes
```
Route::get('/update', function(){

    $user = User::find(1);

    $user->posts()->where('id', '=', '2')->update(['title'=>'I love laravel2', 'body'=>'This is awesome, thank you Edwin2']);


});
```
7. 刪除資料
    - 新增 routes
```
Route::get('/delete', function(){

   $user = User::find(1);

   $user->posts()->whereId(1)->delete();

//    $user->posts()->delete(); // 刪除全部

});
```
### Many to Many Relationship (CRUD) - [Eloquent Relationship 設定官方文件](https://laravel.com/docs/5.2/eloquent-relationships)
1. 安裝＋設定
    - 新增一個專案
    `composer create-project --prefer-dist laravel/laravel manytomany 5.2.29`
    - 建立資料庫 & 設定 .env
2. 資料庫設定和 migration
    - 新增 model
    `php artisan make:model Role -m`
    - 新增 migration
    `php artisan make:migration create_role_user_table --create=role_user`
    - 在 create\_role\_user_table 新增欄位
    `$table->integer('user_id')->unsigned()->nullable()->index();`
    `$table->integer('role_id')->unsigned()->nullable()->index();`
    - 在 create\_roles_table 新增欄位
    `$table->string('name');`
    - 進行 migrate
    `php artisan migrate`
3. 設定 Relation 和 mass assignment
    - 在 User.php 設定 Relation
    `public function roles() {return $this->belongsToMany('App\Role');}`
    - 在 Post.php 新增 protected，讓資料可填入
    `protected $fillable = ['name'];`
4. 新增資料
    - 新增 routes
```
Route::get('/create', function(){

    $user = User::find(1);

    $role = new Role(['name'=>'Administrator']);

    $user->roles()->save($role);

});
```
5. 讀取資料
    - 新增 routes
```
Route::get('/read', function(){

    $user = User::findOrFail(1);

    foreach($user->roles as $role){

        echo $role->name;

    }

});
```
6. 更新資料
    - 新增 routes
```
Route::get('/update', function(){

    $user = User::findOrFail(1);

    if($user->has('roles')){

        foreach($user->roles as $role){

            if($role->name == 'Administrator'){

                $role->name = "subscriber";

                $role->save();

            }

        }

    }

});
```
7. 刪除資料
    - 新增 routes
```
Route::get('/delete', function(){

   $user = User::findOrFail(1);

   foreach($user->roles as $role){

       $role->whereId(5)->delete();

   }

});
```
8. Attaching, Detaching and Syncing
    - attach：新增 user 的 role
    `Route::get('/attach', function(){`
        `$user = User::findOrFail(1);`
        `$user->roles()->attach(4);`
    `});`
    - detach：把 user 的 role 移除
    `Route::get('/detach', function(){`
        `$user = User::findOrFail(1);`
        `$user->roles()->detach();`
    `});`
    - sync：把 user\_id 和多個 role_id 做連結
    `Route::get('/sync', function(){`
        `$user = User::findOrFail(1);`
        `$user->roles()->sync([6,7]);`
    `});`

    





