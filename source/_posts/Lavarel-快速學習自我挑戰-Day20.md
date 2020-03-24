---
title: Lavarel 快速學習自我挑戰 Day20
thumbnail:
  - /images/learning/laravel/laravelday20.png
date: 2017-05-30 15:46:47
categories: Study Note
tags: Laravel
---
<img src="/images/learning/laravel/laravelday20.png">

***
### Pretty URL
1. [eloquent-sluggable 套件說明書](https://github.com/cviebrock/eloquent-sluggable)
2. require 套件 `composer require cviebrock/eloquent-sluggable 4.1`
3. 在 config/app.php 新增 provider
`Cviebrock\EloquentSluggable\ServiceProvider::class,`
4. 在 Post model 新增
```
use Cviebrock\EloquentSluggable\Sluggable;

class Post extends Model
{
    use Sluggable;

    /**
     * Return the sluggable configuration array for this model.
     *
     * @return array
     */
    public function sluggable()
    {
        return [
            'slug' => [
                'source' => 'title'
            ]
        ];
    }

}
```
5. 新增 migration `php artisan make:migration add_slug_to_posts_table --create=posts`
6. 修改 add\_slug\_to\_posts_table
```
class AddSlugToPostsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('posts', function (Blueprint $table) {
            $table->string('slug')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('posts', function (Blueprint $table) {
            $table->dropColumn('slug');
        });
    }
}
```
7. 將資料匯入資料庫 `php artisan migrate`
8. 修改 admin/posts/index view 的檢視貼文欄位
`<td><a href="{{" {{route('home.post', $post->slug)" }}}}">View post</a></td>`
9. 修改 AdminPostsController 的 post function
```
public function post($slug){

    $post = Post::where('slug', $slug)->first() ?: Post::findOrFail((int)$slug);

    $comments = $post->comments()->whereIsActive(1)->get();

    return view('post', compact('post', 'comments'));

}
```
### Pagination ([Pagination 官方文件](https://laravel.com/docs/5.2/pagination))
1. 修改 AdminPostsController 的 index function
`$posts = Post::all();`=>`$posts = Post::paginate(2);`
2. 在 admin/posts/index view 新增
```
<div class="row">
    <div class="col-sm-6 col-sm-offset-5">

        {{$posts->render()}}
        
    </div>
</div>
```
### 從 gravatar 拿大頭貼
1. 在 User model 新增 getGravatarAttribute function
```
public function getGravatarAttribute(){

    $hash = md5(strtolower(trim($this->attributes['email'])));

    return "http://www.gravatar.com/avatar/$hash";

}
```
2. 取得大頭貼
`src="{{" {{Auth::user()->gravatar" }}}}"`
### 升級到 Laravel 5.3 Part I
#### 升級
1. [更新內容](https://laravel-news.com/look-whats-coming-laravel-5-3)
2. 檢查版本 `php artisan --version`
3. 修改 composer.json
`"laravel/framework": "5.3.*",`=>`"laravel/framework": "5.3.*",`
4. 更新資料 `composer update`
5. 把 app/Providers/EventServiceProvider 的 boot function 的變數拿掉
```
public function boot()
{
    parent::boot();
}
```
6. 把 app/Providers/RouteServiceProvider 的 boot, map, mapWebRoutes function 的變數拿掉
```
public function boot()
{
    parent::boot();
}
```
```
public function map()
{
    $this->mapWebRoutes();
}
```
```
protected function mapWebRoutes()
{
    Route::group([
        'namespace' => $this->namespace, 'middleware' => 'web',
    ], function ($router) {
        require app_path('Http/routes.php');
    });
}
```
7. 接上面的步驟，將 `use Illuminate\Routing\Router;`移除
8. 修改 mapWebRoutes function 的 path
```
protected function mapWebRoutes()
{
    Route::group([
        'namespace' => $this->namespace, 'middleware' => 'web',
    ], function ($router) {
        require base_path('routes/web.php');
    });
}
```
#### 更新 routes
1. 在 app/Http/Controllers/Controller.php 刪除 `AuthorizesResources,`
2. [更新 routes 檔案](https://github.com/laravel/laravel/tree/5.3/app/Http/Controllers/Auth)
3. 將更新檔案複製到 app/Http/Controllers/Auth 目錄底下
4. 新增以下兩行到 routes/web.php
```
Auth::routes();
Route::get('/logout', 'Auth\LoginController@logout');
```
5. 修改 LoginController 將目錄導向 admin
`protected $redirectTo = '/admin';`
6. 客製化 routes 來符合舊的路由設定
```
Route::group(['middleware'=>'admin'], function(){

    Route::get('/admin', function(){

        return view('admin.index');

    });

    Route::resource('admin/users', 'AdminUsersController', ['names'=>[

        'index'=>'admin.users.index',
        'create'=>'admin.users.create',
        'store'=>'admin.users.store',
        'edit'=>'admin.users.edit'

    ]]);

    Route::resource('admin/posts', 'AdminPostsController', ['names'=>[

        'index'=>'admin.posts.index',
        'create'=>'admin.posts.create',
        'store'=>'admin.posts.store',
        'edit'=>'admin.posts.edit'

    ]]);

    Route::resource('admin/categories', 'AdminCategoriesController', ['names'=>[

        'index'=>'admin.categories.index',
        'create'=>'admin.categories.create',
        'store'=>'admin.categories.store',
        'edit'=>'admin.categories.edit'

    ]]);

    Route::resource('admin/comments', 'PostCommentsController', ['names'=>[

        'index'=>'admin.comments.index',
        'create'=>'admin.comments.create',
        'store'=>'admin.comments.store',
        'edit'=>'admin.comments.edit'

    ]]);

    Route::resource('admin/comments/replies', 'CommentRepliesController', ['names'=>[

        'index'=>'admin.comments.replies.index',
        'create'=>'admin.comments.replies.create',
        'store'=>'admin.comments.replies.store',
        'edit'=>'admin.comments.replies.edit'

    ]]);

});
```