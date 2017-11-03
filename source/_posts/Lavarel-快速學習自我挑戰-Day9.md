---
title: Lavarel 快速學習自我挑戰 Day9
thumbnail:
  - /images/learning/laravel/laravelday9.png
date: 2017-04-30 23:21:35
categories: 學習歷程
tags: Laravel
---
<img src="/images/learning/laravel/laravelday9.png">

***
### Form and Validation
1. 設定 Migration & Relations
    - 在 create\_posts\_table.php 新增 user\_id
    `$table->integer('user_id')->unsigned();`
    - 重新將資料匯入資料庫
    `php artisan migrate:refresh`
2. 設定 Views & Routes
    - 設定 Controller Route
    `Route::resource('/posts', 'PostsController');`
    - 在 resources/views 底下新增 posts，新增 index、edit、create、show 的 blade.php View 模板
3. 設定 create 的 markup
```
@extends('layouts.app')

@section('content')

    <form method="post" action="/posts">

        <input type="text" name="title" placeholder="Enter title">

        // 避免 TokenMismatchException Error
        {{csrf_field()}}

        <input type="submit" name="submit">

    </form>

@stop

@yield('footer')
```
4. 設定 Controller & View
    - 在 PostsController 的 create 新增 View
    `public function create(){return view('posts.create');}`
    - 在 PostsController 的 store 回傳資料
    `public function store(Request $request){return $request->all();}`
5. 將資料傳送到資料庫
    - 修改 PostsController 的 store function
```
    public function store(Request $request)
    {

//        return $request->all();

        // First method
        
        Post::create($request->all());
        
          // second method

//        $input = $request->all();
//
//        $input['title'] = $request->title;
//
//        Post::create($request->all());

          // third method

//        $post = new Post;
//
//        $post->title = $request->title;
//
//        $post->save();

    }
```
6. 讀取資料
    - 在 PostsController 的 store 新增導向函式
    `return redirect('/posts')`
    - 在 PostsController 的 index 讀取所有的 post 並傳送給 index 的 View 去呈現
    `$posts = Post::all();`
    `return view('posts.index', compact('posts'));`
    - 修改 index.blade.php
```
@extends('layouts.app')

@section('content')

    <ul>
        @foreach($posts as $post)
            <li>{{$post->title}}</li>
        @endforeach
    </ul>

@endsection

@yield('footer')
```
7. 顯示單一貼文並修改
    - 在 PostsController 的 show 讀取特定 id 的 post 並傳送給 show 的 View 去呈現
    `$post = Post::findOrFail($id);`
    `return view('posts.show', compact('post'));`
    - 修改 show.blade.php
    `<h1>{{ "{{$post->title" }}}}</h1>`
    - 讓 index.blade.php 可以超連結
    `<li><a href="{{ "{{route('posts.show', $post->id)" }}}}"> {{ "{{$post->title}" }}}}</a></li>`
8. edit 頁面製作
    - 在 PostsController 的 edit 讀取特定 id 的 post 並傳送給 edit 的 View 使用
    `$post = Post::findOrFail($id);`
    `return view('posts.edit', compact('post'));`
    - 修改 edit.blade.php
```
@extends('layouts.app')

@section('content')

    <h1>Edit Post</h1>

    <form method="post" action="/posts/{{$post->id}}}">

        //取得 Token
        {{csrf_field()}}

        <input type="hidden" name="_method" value="PUT">

        <input type="text" name="title" placeholder="Enter title" value="{{$post->title}}">

        <input type="submit" name="submit">

    </form>

@endsection

@yield('footer')
```
9. 編輯紀錄並重新導向
    - 修改 PostsController 的 update function
        `$post = Post::findOrFail($id);`
        `$post->update($request->all());`
        `return redirect('/posts');`
    - 在 show.blade.php 新增超連結到編輯
    ` <h1><a href="{{ "{{route('posts.edit', $post->id)" }}}}">{{ "{{$post->title" }}}}</a></h1>`
10. 刪除貼文
    - 修改 PostsController 的 delete function
    `$post = Post::whereId($id)->delete();`
    `return redirect('/posts');`
    - 新增 delete button edit.blade.php
```
<form method="post" action="/posts/{{$post->id}}">

        {{csrf_field()}}

        <input type="hidden" name="_method" value="DELETE">

        <input type="submit" value="DELETE">

    </form>
```
### Forms - Package and Validation - [Forms & HTML 設定官方文件](https://laravelcollective.com/docs/5.2/html)
### [Validation 設定官方文件](https://laravel.com/docs/5.2/validation)
1. 安裝套件 & 測試
    - 在 composer.json 的 require 新增套件
    `"laravelcollective/html":"^5.2.0"`
    - 更新套件
    `composer update`
    - 在 config/app.php 的 provider 新增
    `Collective\Html\HtmlServiceProvider::class,`
    - 在 config/app.php 的 aliases 新增
    `'Form' => Collective\Html\FormFacade::class,`
    `'Html' => Collective\Html\HtmlFacade::class,`
    - 在 create.blade.php 將 `<form method="post" action="/posts">` 取代來測試套件
    `{!! Form::open() !!}`
2. 修改 form 套件的內容
    - 修改 form package 的傳遞方式 
    `{!! Form::open(['method'=>'POST', 'action'=>'PostsController@store']) !!}`
    `{!! Form::close() !!}`
    - 將表單改為 form package 的形式，並使用 Bootstrap 的 class
```
<div class="form-group">

            {!! Form::label('title', 'Title:') !!}
            {!! Form::text('title', null, ['class'=>'form-control']) !!}

        </div>

        {{csrf_field()}}

        <div class="form-group">

            {!! Form::submit('Create Post', ['class'=>'btn btn-primary']) !!}

        </div>
```
3. Update & Delete
    - 修改 edit.blade.php
```
{!! Form::model($post, ['method'=>'PATCH', 'action'=>['PostsController@update', $post->id]]) !!}

        {{csrf_field()}}

        {!! Form::label('title', 'Title:') !!}
        {!! Form::text('title', null, ['class'=>'form-control']) !!}

        {!! Form::submit('Update Post', ['class'=>'btn btn-info']) !!}

    {!! Form::close() !!}

    {!! Form::open(['method'=>'DELETE', 'action'=>['PostsController@destroy', $post->id]]) !!}

        {{csrf_field()}}

    {!! Form::submit('Delete Post', ['class'=>'btn btn-danger']) !!}

    {!! Form::close() !!}
```
4. Validation
    - 將 validate function 新增到 PostsController 的 store function
```
$this->validate($request, [

            'title'=> 'required',
            'content'=> 'required'

        ]);
```
5. 顯示錯誤
    - 修改 validation
    `$this->validate($request, [`
        `'title'=> 'required|max:4'`
    `]);`
    - 在 create.blade.php 新增 error display
```
@if(count($errors) > 0)

    <div class="alert alert-danger">

        <ul>

            @foreach($errors->all() as $error)

                <li>{{$error}}</li>

            @endforeach

        </ul>

    </div>

@endif
```
6. advanced validation
    - 新增一個 request
    `php artisan make:request CreatePostRequest`
    - 修改 PostsController 的 store function，並 import Request
    `public function store(Requests\CreatePostRequest $request)`
    - 修改 CreatePostRequest.php 的 authorize 為 `true`
    - 修改 CreatePostRequest.php 的 rules 為 required (validation的效果)
    `'title' => 'required'`
    - 將 validation 註解掉
    `$this->validate($request, [`
    `'title'=> 'required|max:4'`
    `]);`
7. PhpStorm snippet
    - PhpStorm->Preferences->Editor->Live template

