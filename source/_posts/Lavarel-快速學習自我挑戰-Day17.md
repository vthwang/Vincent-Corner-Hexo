---
title: Lavarel 快速學習自我挑戰 Day17
thumbnail:
  - /blogs/images/learning/laravel/laravelday17.png
date: 2017-05-27 01:21:27
categories: 學習歷程
tags: Laravel
---
<img src="/blogs/images/learning/laravel/laravelday17.png">

***
### Application Media
#### 設定和顯示
1. 新增 view views/media/index.blade.php
2. 設定 media index view
```
@extends('layouts.admin')

@section('content')

    <h1>Media</h1>

    @if($photos)

    <table class="table">
        <thead>
        <tr>
            <th>id</th>
            <th>Name</th>
            <th>Created</th>
            <th>Email</th>
        </tr>
        </thead>
        <tbody>

        @foreach($photos as $photo)

        <tr>
            <td>{{$photo->id}}</td>
            <td>{{$photo->file}}</td>
            <td>{{$photo->created_at ? $photo->created_at : 'no date'}}</td>
        </tr>

        @endforeach
        </tbody>
    </table>

    @endif

@stop
```
3. 新增 media controller `php artisan make:control AdminMediasController`
4. 新增 routes `Route::resource('admin/media', 'AdminMediasController');`
5. 修改 layout admin
```
<li>
    <a href="{{route('admin.media.index')}}">All Media</a>
</li>

<li>
    <a href="{{route('admin.media.upload')}}">Upload Media</a>
</li>
```
6. 在 AdminMediasController 新增 index function
```
public function index(){
        
    $photos = Photo::all();
    
    return view('admin.media.index', compact('photos'));
    
}
```
7. 修改 routes
`Route::get('admin/media/upload', ['as'=>'admin.media.upload', 'uses'=>'AdminMediasController@store']);`
#### 設定 view
1. 刪除 routes (因為這個是為了不讓錯誤顯示)
`Route::get('admin/media/upload', ['as'=>'admin.media.upload', 'uses'=>'AdminMediasController@store']);`
2. 修改 layouts admin view
`<a href="{{" {{route('admin.media.create')" }}}}">Upload Media</a>`
3. 在 AdminMediasController 新增 create function
```
public function create(){

    return view('admin.media.create');

}
```
4. 新增 media create view
```
@extends('layouts.admin')

@section('content')

    <h1>Upload Media</h1>

@stop

```
#### 新增上傳外掛
1. [Dropzone 上傳外掛](http://www.dropzonejs.com/#installation)
2. 在 media create view 新增 script section
```
@section('scripts')

    <script src="https://cdnjs.cloudflare.com/ajax/libs/dropzone/4.3.0/min/dropzone.min.js"></script>

@stop
```
3. 在 media create view 新增 style section
```
@section('styles')

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/dropzone/4.3.0/min/dropzone.min.css">
    
@stop
```
4. 在 layouts admin view 新增 yield 才能使用 section `@yield('styles')` `@yield('scripts')`
#### 上傳檔案
1. 在 AdminMediasController 新增 store function
```
public function store(Request $request){

    $file = $request->file('file');

    $name = time() . $file->getClientOriginalName();

    $file->move('images', $name);

    Photo::create(['file'=>$name]);

    return $name;

}
```
#### 刪除圖片
1. 在 media index view 新增  delete button
```
<td>
    {!! Form::open(['method'=>'DELETE', 'action'=>['AdminMediasController@destroy', $photo->id]]) !!}

        {{csrf_field()}}

        <div class="form-group">
            {!! Form::submit('Delete Post', ['class'=>'btn btn-danger']) !!}
        </div>
    {!! Form::close() !!}
</td>
```
2. 在 AdminMediaController 新增 destroy function
```
public function destroy($id){

    $photo = Photo::findOrFail($id);

    unlink(public_path() . $photo->file);

    $photo->delete();

    return redirect('/admin/media');

}
```