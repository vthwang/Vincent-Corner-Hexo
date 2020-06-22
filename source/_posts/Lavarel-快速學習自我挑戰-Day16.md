---
title: Lavarel 快速學習自我挑戰 Day16
thumbnail:
  - /images/learning/laravel/laravelday16.jpg
date: 2017-05-26 12:23:31
categories: Study Note
tags: Laravel
toc: true
---
<img src="/images/learning/laravel/laravelday16.jpg">

***
### Application Post Part II
#### 對貼文分類新增 model 和 migration
1. 新增 model `php artisan make:model Category -m`
2. 在 category 的 model 處理 mass assignment
`protected $fillable = ['name'];`
3. 在 create\_categories_table 新增欄位 `$table->string('name');`
4. 將欄位寫入資料庫 `php artisan migrate`
#### 與貼文分類顯示或創建貼文
1. 修改 posts 的 index view
`<td>{{" {{$post->category ? $post->category->name : 'Uncategorized'" }}}}</td>`
2. 修改 AdminPostsController 的 create function
```
$categories = Category::lists('name','id')->all();
return view('admin.posts.create', compact('categories'));
```
3. 修改 Post create view
```
<div class="form-group">
    {!! Form::label('category_id', 'Category:') !!}
    {!! Form::select('category_id', [''=>'Choose Categories'] + $categories, null, ['class'=>'form-control']) !!}
</div>
```
#### 編輯貼文
1. 修改 AdminPostsController 的 edit function
```
$post = Post::findOrFail($id);
$categories = Category::lists('name', 'id')->all();
return view('admin.posts.edit', compact('post', 'categories'));
```
2. 複製 create view 到 edit view 並修改 form
`{!! Form::model($post, ['method'=>'PATCH', 'action'=>['AdminPostsController@update', $post->id], 'files'=>true]) !!}`
3. 在 posts index view 的名字新增超連結
`<td><a href="{{" {{route('admin.posts.edit', $post->id)" }}}}">{{" {{$post->user->name" }}}}</a></td>`
4. 修改 post edit view 的 category
`{!! Form::select('category_id', $categories, null, ['class'=>'form-control']) !!}`
5. 修改 AdminPostsController 的 update function
```
$input = $request->all();

if($file = $request->file('photo_id')){

    $name = time() . $file->getClientOriginalName();

    $file->move('images', $name);

    $photo = Photo::create(['file'=>$name]);

    $input['photo_id'] = $photo->id;

}

Auth::user()->posts()->whereId($id)->first()->update($input);

return redirect('/admin/posts');
```
6. 在 post index view 縮短字的長度 `{{" {{str_limit($post->body, 30)" }}}}`
#### 刪除貼文
1. 在 post edit view 新增 delete button
```
{!! Form::open(['method'=>'DELETE', 'action'=>['AdminPostsController@destroy', $post->id]]) !!}

    {{csrf_field()}}

    <div class="form-group">
        {!! Form::submit('Delete Post', ['class'=>'btn btn-danger col-sm-6']) !!}
    </div>

{!! Form::close() !!}
```
2. 修改 AdminPostsController 的 destroy function
```
$post = Post::findOrfail($id);

unlink(public_path() . $post->photo->file);

$post->delete();

return redirect('/admin/posts');
```
#### 刪除使用者時也刪除貼文
1. 修改 create\_posts_table
`$table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');`
2. 更新資料庫 `php artisan migrate:refresh`
#### 在編輯貼文時顯示圖片
1. 修改 post edit view
```
<div class="col-sm-3">

    <img src="{{$post->photo->file}}" alt="" class="img-responsive">

</div>
```
#### 設定分類
1. 新增 Controller
`php artisan make:controller --resource AdminCategoriesController`
2. 新增 routes
`Route::resource('admin/categories', 'AdminCategoriesController');`
3. 新增 categories index view
```
@extends('layouts.admin');

@section('content')

    <h1>Categories</h1>

@stop
```
4. 修改 layout.admin 的 routes
```
<li>
    <a href="{{route('admin.categories.index')}}">All Categories</a>
</li>

<li>
    <a href="{{route('admin.categories.create')}}">Create Category</a>
</li>
```
#### 創建分類
1. 修改 AdminCategoriesController 的 index
```
$categories = Category::all();

return view('admin.categories.index', compact('categories'));
```
2. 修改 categories index view
```
@extends('layouts.admin');

@section('content')

    <h1>Categories</h1>

    <div class="col-sm-6">

        {!! Form::open(['method'=>'POST', 'action'=>'AdminCategoriesController@store']) !!}

            <div class="form-group">
                {!! Form::label('name', 'Name:') !!}
                {!! Form::text('name', null, ['class'=>'form-control']) !!}
            </div>

            {{csrf_field()}}

            <div class="form-group">
                {!! Form::submit('Create Category', ['class'=>'btn btn-primary']) !!}
            </div>

        {!! Form::close() !!}

    </div>

    <div class="col-sm-6">

        @if($categories)

        <table class="table">
            <thead>
            <tr>
                <th>id</th>
                <th>Name</th>
                <th>Created date</th>
            </tr>
            </thead>
            <tbody>

            @foreach($categories as $category)
            <tr>
                <td>{{$category->id}}</td>
                <td>{{$category->name}}</td>
                <td>{{$category->created_at ? $category->created_at->diffForHumans() : 'No date'}}</td>
            </tr>
            @endforeach
        </table>

        @endif

    </div>

@stop
```
3. 在 AdminCategoriesController store function
```
Category::create($request->all());
return redirect('admin/categories');
```
#### 更新和刪除分類
1. 修改 category edit view
```
@extends('layouts.admin');

@section('content')

    <h1>Categories</h1>

    <div class="col-sm-6">

        {!! Form::model($category, ['method'=>'PATCH', 'action'=>['AdminCategoriesController@update', $category->id]]) !!}

        <div class="form-group">
            {!! Form::label('name', 'Name:') !!}
            {!! Form::text('name', null, ['class'=>'form-control']) !!}
        </div>

        {{csrf_field()}}

        <div class="form-group">
            {!! Form::submit('Update Category', ['class'=>'btn btn-primary']) !!}
        </div>
        {!! Form::close() !!}

    </div>

    <div class="col-sm-6">

    </div>

@stop
```
2. 修改 AdminCategoriesController 的 edit function
```
$category = Category::findOrFail($id);
return view('admin.categories', compact('category'));
```
3. 在 category edit view 新增 delete button
```
{!! Form::open(['method'=>'DELETE', 'action'=>['AdminCategoriesController@destroy', $category->id]]) !!}

{{csrf_field()}}

<div class="form-group">
    {!! Form::submit('Delete Category', ['class'=>'btn btn-danger col-sm-6']) !!}
</div>

{!! Form::close() !!}
```
4. 修改 AdminCategoriesController 的 destroy function
```
Category::findOrFail($id)->delete();
return redirect('/admin/categories');
```
5. 修改 AdminCategoriesController 的 update function
```
$category = Category::findOrFail($id);
$category->update($request->all());
return redirect('/admin/categories');
```