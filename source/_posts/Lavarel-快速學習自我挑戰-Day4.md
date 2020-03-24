---
title: Lavarel 快速學習自我挑戰 Day4
thumbnail:
  - /images/learning/laravel/laravelday4.jpg
date: 2017-04-25 13:12:19
categories: Study Note
tags: Laravel
---
<img src="/images/learning/laravel/laravelday4.jpg">

***
### Raw SQL Queries - [Database 設定官方文件](https://laravel.com/docs/5.2/database)
1. insert data (直接在 Routes.php 設定)
```
Route::get('/insert', function(){
    DB::insert('insert into posts(title, content) values(?, ?)', ['PHP with Laravel', 'Laravel is the best thing that has happened to PHP']);
});
```
2. read data
```
Route::get('/read', function() {
    $results = DB::select('select * from posts where id = ?', [1]);

    return $results; (傳回陣列)

//    return var_dump($results); (傳回值的詳細資料)
//    foreach($results as $post){
//
//        return $post->title;
//
//    }(傳回單一項目)
});
```
3. update data
```
Route::get('/update', function(){
    $updated = DB::update('update posts set title = "update title" where id = ?', [1]);
    return $updated;
});
```
4. delete data
```
Route::get('/delete', function(){
    $deleted = DB::delete('delete from posts where id = ?', [1]);
    return $deleted;
});
```

### Eloquent / ORM - [Eloquent 設定官方文件](https://laravel.com/docs/5.2/eloquent)
- 創建一個 model：`php artisan make:model`
- 在 model 的 class 宣告 table 名稱：`protected $table = 'posts';`
- 在 Routes 引入 class：`use App\Post;`
1. 用 model 的方式讀取所有資料
```
Route::get('/find', function(){

    $posts = Post::all(); // 加入 Post 的所有紀錄

    foreach($posts as $post) {
        return $post->title;
    }

});
```
2. 用 model 的方式讀取單一資料
```
Route::get('/find', function(){

    $post = Post::find(1);
    return $post->title;

});
```
3. 用 eloquent 的方式取得資料：`$posts = Post::where('id', 1)->orderBy('id', 'desc')->take(1)->get();`
    - eloquent -> 取得或失敗：`$posts = Post::findOrFail(2);`
4. save data
```
Route::get('/basicinsert', function(){

    $post = new Post;

    $post->title = 'new Eloquent title insert';
    $post->content = 'Wow eloquent is really cool, look at this content';

    $post->save();

});
```
5. 修改 data
```
Route::get('/basicinsert1', function(){

    $post = Post::find(1);

    $post->title = 'new Eloquent title insert 1';
    $post->content = 'Wow eloquent is really cool, look at this content 1';

    $post->save();

});
```
6. Mass Assignment
    - 在路由用 create 來新增 model
    `Post::create(['title'=>'the create method', 'content'=> 'WOW I\'m learning a lot with Edwin Diaz']);`
    - 在 model 裡面設定 protected
    `protected $fillable = ['title', 'content'];`
7. update data
`Post::where('id', 2)->where('is_admin', 0)->update(['title'=>'NEW PHP TITLE', 'content'=>'I love my instructor Edwin']);`
8. delete data
- 方法 1
```
Route::get('/delete', function(){

    $post = Post::find(1);

    $post->delete();

});
```
- 方法 2
```
Route::get('/delete2', function(){

    Post::destroy(2);
    // Post::destroy([4,5]); //刪除多筆資料
    // Post::where('is_admin', 0)->delete(); //加上條件的刪除法

});
```
9. Soft delete / trashing
    - 在 model 引入 softdelete
    `use Illuminate\Database\Eloquent\SoftDeletes;`
    - 在 model 使用 protected
    `protected $dates = ['deleted_at'];`
    - 建立新的 model
    `php artisan make:migration add_deleted_at_column_to_posts_tables --table=posts`
    - 設定新的 model
        - up 的部分：`$table->softDeletes();`
        - down 的部分：`$table->dropColumn('deleted_at');`
    -  **提醒：在刪除 model 之前要先 reset 才不會造成資料庫錯誤**
    - 直接在 Routes 進行刪除：`Post::find(3)->delete();`
10. 取得 deleted / trashed 紀錄
```
Route::get('resoftdelete', function(){

// 取得單一紀錄
//    $post = Post::find(3);
//    return $post;

// 取得包含丟到回收桶的紀錄
//    $post = Post::withTrashed()->where('is_admin', 0)->get();
//    return $post;

// 只取得丟到回收桶的紀錄
//    $post = Post::onlyTrashed()->where('is_admin', 0)->get();
//    return $post;

});
```
11. 恢復  deleted / trashed 紀錄
```
Route::get('/restore', function(){

    Post::withTrashed()->where('is_admin', 0)->restore();

});
```
12. 永久移除紀錄
```
Route::get('/forcedelete', function(){

    Post::onlyTrashed()->where('is_admin', 0)->forceDelete();

});
```