---
title: Lavarel 快速學習自我挑戰 Day18
thumbnail:
  - /images/learning/laravel/laravelday18.png
date: 2017-05-28 16:02:04
categories: Study Note
tags: Laravel
---
<img src="/images/learning/laravel/laravelday18.png">

***
### Application 留言功能 Part I
#### 設定環境
1. 新增 views/admin/comments/index.blade.php 和 views/admin/comments/replies/index.blade.php
2. 新增 routes
```
Route::resource('admin/comments', 'PostCommentsController');
Route::resource('admin/comments/replies', 'CommentRepliesController');
```
3. 新增 model
`php artisan make:model Comment -m`
`php artisan make:model CommentReply -m`
4. 新增欄位到 create\_comments_table
```
Schema::create('comments', function (Blueprint $table) {
    $table->increments('id');
    $table->integer('post_id')->unsigned()->index();
    $table->integer('is_active')->default(0);
    $table->string('author');
    $table->string('photo');
    $table->string('email');
    $table->text('body');
    $table->timestamps();


    $table->foreign('post_id')->references('id')->on('posts')->onDelete('cascade');

});
```
5. 新增欄位到 create\_comment\_replies_table
```
Schema::create('comment_replies', function (Blueprint $table) {
    $table->increments('id');
    $table->integer('comment_id')->unsigned()->index();
    $table->integer('is_active')->default(0);
    $table->string('author');
    $table->string('photo');
    $table->string('email');
    $table->text('body');
    $table->timestamps();


    $table->foreign('comment_id')->references('id')->on('comments')->onDelete('cascade');
});
```
6. 匯入資料庫 `php artisan migrate`
#### Relationship & Mass Assignment
1. 在 Post model 新增
```
public function comments(){
        
    return $this->hasMany('App\Post');
    
}
```
2. 在 Comment model 新增
```
protected $fillable = [

    'post_id',
    'author',
    'email',
    'body',
    'is_active'

];

public function replies(){

    return $this->hasMany('App\CommentReply');

}
```
3. 在 CommentReply 新增
```
protected $fillable = [

    'comment_id',
    'author',
    'email',
    'body',
    'is_active'

];

public function comment(){

    return $this->belongsTo('App\Comment');

}
```
4. 新增 Controller
`php artisan make:controller --resource PostCommentsController`
`php artisan make:controller --resource CommentRepliesController`
#### 設定 views
1. 新增 layouts/blog-home.blade.php 和 layouts/blog-post.blade.php view
2. 新增 layouts/blog.blade.php
#### 創建貼文
1. 將 admin route 移到 group 裡面
2. 新增 routes 
`Route::get('/post/{id}', ['as'=>'home.post', 'uses'=>'AdminPostsController@post']);`
3. 新增 post function 到 AdminPostsController
```
public function post($id){

    $post = Post::findOrFail($id);

    return view('post', compact('post'));

}
```
4. 將 view 的 tilte 改為動態產生 `{{" {{$post->title" }}}}`
5. 修改作者、時間、圖片、內文
    - `{{" {{$post->user->name" }}}}`
    - `{{" {{$post->created_at->diffForHumans()" }}}}`
    - `{{" {{$post->photo->file" }}}}`
    - `{{" {{$post->body" }}}}`
#### 創建留言
1. 把 post view 的留言區改為 open form
```
<div class="well">
    <h4>Leave a Comment:</h4>

    {!! Form::open(['method'=>'POST', 'action'=>'PostCommentsController@store']) !!}

    <input type="hidden" name="post_id" value="{{$post->id}}">

        <div class="form-group">
            {!! Form::label('body', 'Body:') !!}
            {!! Form::textarea('body', null, ['class'=>'form-control', 'rows'=>3]) !!}
        </div>

        {{csrf_field()}}

        <div class="form-group">
            {!! Form::submit('Submit comment', ['class'=>'btn btn-primary']) !!}
        </div>

    {!! Form::close() !!}

</div>
```
2. 修改 PostCommentsController 的 store function
```
public function store(Request $request)
    {
    $user = Auth::user();

    $data = [

        'post_id' => $request->post_id,
        'author' => $user->name,
        'email' => $user->email,
        'photo' => $user->photo->file,
        'body' => $request->body

    ];

    Comment::create($data);

    $request->session()->flash('comment message', 'Your message has been submitted and is waiting moderation');

    return redirect()->back();

}
```
3. 顯示訊息，修改 post view
```
@if(Session::has('comment message'))

    {{session('comment message')}}

@endif
```
#### 顯示貼文
1. 修改 PostCommentsController 的 index function
```
$comments = Comment::all();
return view('admin.comments.index', compact('comments'));
```
2. 修改 Comment model
```
public function post(){

    return $this->belongsTo('App\Post');

}
```
3. 修改  comments/index view
```
@if(count($comments) > 0)

<h1>Comments</h1>

<table class="table">
    <thead>
    <tr>
        <th>id</th>
        <th>Author</th>
        <th>Email</th>
        <th>Body</th>
    </tr>
    </thead>
    <tbody>

    @foreach($comments as $comment)

    <tr>
        <td>{{$comment->id}}</td>
        <td>{{$comment->author}}</td>
        <td>{{$comment->email}}</td>
        <td>{{$comment->body}}</td>
        <td><a href="{{route('home.post', $comment->post->id)}}">View Post</a></td>

    </tr>

    @endforeach
    </tbody>
</table>

    @else

    <h1 class="text-center">No Comments</h1>

@endif
```
#### 審核和刪除貼文
1. 在 comments/index view 新增審核按鈕
```
<td>

    @if($comment->is_active == 1)

        {!! Form::open(['method'=>'PATCH', 'action'=> ['PostCommentsController@update', $comment->id]]) !!}

            <input type="hidden" name="is_active" value="0">

            {{csrf_field()}}

            <div class="form-group">
                {!! Form::submit('Un-approve', ['class'=>'btn btn-success']) !!}
            </div>

        {!! Form::close() !!}

        @else

        {!! Form::open(['method'=>'PATCH', 'action'=> ['PostCommentsController@update', $comment->id]]) !!}

        <input type="hidden" name="is_active" value="1">

        {{csrf_field()}}

        <div class="form-group">
            {!! Form::submit('Approve', ['class'=>'btn btn-info']) !!}
        </div>

        {!! Form::close() !!}


    @endif

</td>
```
2. 在 comments/index view 新增刪除按鈕
```
<td>

    {!! Form::open(['method'=>'DELETE', 'action'=> ['PostCommentsController@destroy', $comment->id]]) !!}

    {{csrf_field()}}

    <div class="form-group">
        {!! Form::submit('Delete', ['class'=>'btn btn-danger']) !!}
    </div>

    {!! Form::close() !!}

</td>
```
3. 修改 PostCommentsController 的 update function
```
Comment::findOrFail($id)->update($request->all());

return redirect('/admin/comments');
```
4. 修改 PostCommentsController 的 delete function
```
Comment::findOrFail($id)->delete();

return redirect()->back();
```