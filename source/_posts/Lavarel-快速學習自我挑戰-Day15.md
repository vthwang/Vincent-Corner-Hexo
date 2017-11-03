---
title: Lavarel 快速學習自我挑戰 Day15
thumbnail:
  - /images/learning/laravel/laravelday15.png
date: 2017-05-25 20:10:35
categories: 學習歷程
tags: Laravel
---
<img src="/images/learning/laravel/laravelday15.png">

***
### Application Post Part I
#### 設定 routes
1. 設定 404 page view
```
@extends('layouts.app')

@section('content')

    <h1 class="text-center">Opps no page available</h1>

@stop
```
2. 新增 routes 在 admin group 裡面
`Route::resource('admin/posts', 'AdminPostsController');`
3. 新增 Controller
`php artisan make:controller --resource AdminPostsController`
4. 在 Controller 的 index
`return view('admin.posts.index');`
5. 新增 /views/admin/posts/index.blade.php
```
@extends('layouts.admin')

@section('content')

    <h1>Posts</h1>

@stop
```
6. 修改 layouts 的連結
All Posts -> `{{" {{route('admin.posts.index')" }}}}`
Create Post -> `{{" {{route('admin.posts.create')" }}}}`
7. 修改 Create 和 Edit 的 view
```
@extends('layouts.admin')

@section('content')

    <h1>Create Post</h1>

@stop
```
```
@extends('layouts.admin')

@section('content')

    <h1>Edit Post</h1>

@stop
```
8. 修改 Controller 的 create
`return view('admin.posts.create');`
#### Migration
1. 新增 model
`php artisan make:model Post -m`
2. 在 create\_posts_table 新增欄位
```
    $table->integer('user_id')->unsigned()->index();
    $table->integer('category_id')->unsigned()->index();
    $table->integer('photo_id')->unsigned()->inex();
    $table->string('title');
    $table->text('body');
```
3. 寫入資料庫 `php artisan migrate`
#### 顯示貼文
1. 在 Post model 處理 mass assignment
```
protected $fillable = [

    'category_id',
    'photo_id',
    'title',
    'body'

];
```
2. 進入 tinker 模式新增資料庫內容 `php artisan tinker`
3. 新增一行資料 `$post = App\Post::create(['title'=>'my first post', 'body'=>'I love laravel with Edwin Diaz']);`
4. 修改 Controller 的 Index function
```
$posts = Post::all();
return view('admin.posts.index', compact('posts'));
```
5. 在 Post index view 新增一個 table 讀取資料庫資料
```
<table class="table">
    <thead>
    <tr>
        <th>Id</th>
        <th>User</th>
        <th>Category</th>
        <th>Photo</th>
        <th>Title</th>
        <th>body</th>
        <th>Created</th>
        <th>Updated</th>
    </tr>
    </thead>
    <tbody>

    @if($posts)

        @foreach($posts as $post)

    <tr>
        <td>{{$post->id}}</td>
        <td>{{$post->user_id}}</td>
        <td>{{$post->category_id}}</td>
        <td>{{$post->photo_id}}</td>
        <td>{{$post->title}}</td>
        <td>{{$post->body}}</td>
        <td>{{$post->created_at->diffForHumans()}}</td>
        <td>{{$post->updated_at->diffForHumans()}}</td>
    </tr>

        @endforeach

    @endif
    </tbody>
</table>
```
#### Relationship 設定
1. 在 User model 新增 posts function
```
public function posts(){

    return $this->hasMany('App\Post');

}
```
2. 在 Post model 新增 user function
```
public function user(){

    return $this->belongsTo('App\User');

}
```
3. 修改 index view 的 user 欄位 `{{ "{{$post->user->name" }}}}`
4. 在 Post model 新增 photo 和 category function
```
public function photo(){
        
    return $this->belongsTo('App\Photo');
    
}

public function category(){
    
    return $this->belongsTo('App\Category');
}
```
5. 在 Role model 讓 name 可寫入
```
protected $fillable = [

    'name'

];
```
#### 創建表單
1. 新增 create view 表單
```
{!! Form::open(['method'=>'POST', 'action'=>'AdminPostsController@store', 'files'=>true]) !!}

    <div class="form-group">
        {!! Form::label('title', 'Title:') !!}
        {!! Form::text('title', null, ['class'=>'form-control']) !!}
    </div>

    <div class="form-group">
        {!! Form::label('category_id', 'Category:') !!}
        {!! Form::select('category_id', array(''=>'options'), null, ['class'=>'form-control']) !!}
    </div>

    <div class="form-group">
        {!! Form::label('photo_id', 'Photo:') !!}
        {!! Form::file('photo_id', null, ['class'=>'form-control']) !!}
    </div>

    <div class="form-group">
        {!! Form::label('body', 'Description:') !!}
        {!! Form::textarea('body', null, ['class'=>'form-control', 'rows'=>3]) !!}
    </div>

    {{csrf_field()}}

    <div class="form-group">
        {!! Form::submit('Create Post', ['class'=>'btn btn-primary']) !!}
    </div>

{!! Form::close() !!}
```
2. 新增 Request
`php artisan make:request PostsCreateRequest`
3. 修改 PostscreateRequest
```
public function authorize()
    {
        return true;
    }

public function rules()
    {
        return [

            'title'         =>'required',
            'category_id'   =>'required',
            'photo_id'      =>'required',
            'body'          =>'required'

        ];
    }
```
4. 在 create post view include error message
`@include('includes.form_error')`
#### 創建貼文
1. 更新 Controller 的 store function
```
$input = $request->all();

$user = Auth::user();

if($file = $request->file('photo_id')){

    $name = time() . $file->getClientOriginalName();
    
    $file->move('images', $name);
    
    $photo = Photo::create(['file'=>$name]);
    
    $input['photo_id'] = $photo->id;

}

$user->posts()->create($input);

return redirect('/admin/posts');
```
2. 修改 Post index view 來顯示圖片
`<img height="100" src="{{ "{{$post->photo ? $post->photo->file : 'http://placehold.it/400x400'" }}}}" alt="">`




