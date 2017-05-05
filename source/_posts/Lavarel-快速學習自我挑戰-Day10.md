---
title: Lavarel 快速學習自我挑戰 Day10
thumbnail:
  - /blogs/images/learning/laravel/laravelday10.png
date: 2017-05-01 23:21:35
categories: 學習歷程
tags: Laravel
---
<img src="/blogs/images/learning/laravel/laravelday10.png">

***
### Model Manipulation
#### Dates
1. 搜尋套件 `composer search carbon`
2. 引用套件 `use Carbon\Carbon;`
3. 新增 routes
```
Route::get('/dates', function(){

   $date = new DateTime('+1 week');

   echo $date->format('m-d-Y');

   echo '<br>';

   echo Carbon::now()->addDays(10)->diffForHumans();

   echo '<br>';

   echo Carbon::now()->subMonth(5)->diffForHumans();

   echo '<br>';

   echo Carbon::now()->yesterday()->diffForHumans();

});
```
#### Accessors (pull data out of database)
1. 修改 model
```
public function getNameAttribute($value){

//        return ucfirst($value); //第一個字大寫
        return strtoupper($value); //全部變成大寫

    }
```
2. 修改 routes
```
Route::get('/getname', function(){

    $user = User::find(1);

    echo $user->name;

});
```
#### Mutators - [Mutators 設定官方文件](https://laravel.com/docs/5.2/eloquent-mutators)
1. 修改 model
```
public function setNameAttribute($value){

        $this->attributes['name'] = strtoupper($value);

    }
```
2. 修改 routes
```
Route::get('/setname', function(){

    $user = User::find(1);

    $user->name= "william";

    $user->save();

});
```
#### Query Scopes - [Query Scopes 設定官方文件](https://laravel.com/docs/5.2/eloquent#query-scopes)
1. 修改 PostsController
```
public function index()
    {
        $posts = Post::latest();

        return view('posts.index', compact('posts'));
    }

```
2. 修改 Post model
```
public static function scopeLatest($query){

        return $query->orderBy('id', 'asc')->get();

    }
```
### 上傳檔案
#### 新增 Views
1. 修改第三個參數 `'files'=>true` 來新增 enctype ，並加入上傳的 input
```
{!! Form::open(['method'=>'POST', 'action'=>'PostsController@store', 'files'=>true]) !!}


        <div class="form-group">
            {!! Form::label('title', 'Title:') !!}
            {!! Form::text('title', null, ['class'=>'form-control']) !!}
        </div>

        {{csrf_field()}}

        <div class="form-group">
            {!! Form::file('file', ['class'=>'form-control']) !!}
        </div>


        <div class="form-group">
            {!! Form::submit('Create Post', ['class'=>'btn btn-primary']) !!}
        </div>
    {!! Form::close() !!}
```
#### 取得上傳檔案資訊
1. 修改 PostsController
```
public function store(CreatePostRequest $request)
    {
        $file = $request->file('file'); //取得檔案，會以暫存檔(temp)呈現

        echo "<br>";

        echo $file->getClientOriginalName(); //取得原始名稱

        echo "<br>";

        echo $file->getClientSize(); //取得檔案大小
    }
```
#### 將上傳的檔案寫入資料庫 (persist file data into database)
1. 新增一個 migration 並關聯到 posts
`php artisan make:migration add_path_column_to_posts --table=posts`
2. 新增 migration 到資料庫
`php artisan migrate`
3. 讓 path 欄位可寫入
`protected $fillable = ['path'];`
4. 設定 PostsController 讓檔案可以寫入資料庫
```
public function store(CreatePostRequest $request)
    {
        $input = $request->all();

        if($file = $request->file('file')){

            $name = $file->getClientOriginalName();

            $file->move('images', $name);

            $input['path'] = $name;

        }

        Post::create($input);
    }
```
#### 顯示上傳的圖片
1. 新增 image-container 到 index.blade.php
```
<div class="image-container">

    <img height="100" src="{{$post->path}}" alt="">
    
</div>
```
2. 新增目錄到 Post model
`public $directory = '/images/';`
3. 用 Accessors 新增圖片路徑
```
public function getPathAttribute($value){

        return $this->directory . $value;

    }
```