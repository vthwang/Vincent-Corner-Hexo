---
title: Lavarel 快速學習自我挑戰 Day19
thumbnail:
  - /images/learning/laravel/laravelday19.jpg
date: 2017-05-29 00:58:12
categories: Study Note
tags: Laravel
---
<img src="/images/learning/laravel/laravelday19.jpg">

***
### Application 留言功能 Part II
#### 顯示留言
1. 在 admin/posts/index view 新增文章連結
`<td><a href="{{" {{route('home.post', $post->id)" }}}}">view post</a></td>`
2. 在 admin/posts/index view 新增評論連結
`<td><a href="{{" {{route('admin.comments.show', $post->id)" }}}}">View Comments</a></td>`
3. 新增 admin/comments/show view
4. 在 PostCommentsController 新增 show function
```
public function show($id)
{   
    $post = POST::findOrfail($id);
    
    $comments = $post->comments;
    
    return view('admin.comments.show', compact('comments'));   
}
```
5. 修改 Post model
```
public function comments(){

    return $this->hasMany('App\Comment');

}
```
#### 在文章中顯示留言
1. 新增 Auth 到留言區塊，讓登入的使用者才可以留言
```
@if(Auth::check())
@endif
```
2. 修改 AdminPostsController 的 post function
```
public function post($id){

    $post = Post::findOrFail($id);

    $comments = $post->comments()->whereIsActive(1)->get();

    return view('post', compact('post', 'comments'));

}
```
3. 新增 posted comments 到 post view
```
@if(count($comments) > 0)
    @foreach($comments as $comment)
        <div class="media">
            <a class="pull-left" href="#">
                <img height="64" class="media-object" src="{{$comment->photo}}" alt="">
            </a>
            <div class="media-body">
                <h4 class="media-heading">{{$comment->author}}
                    <small>{{$comment->created_at->diffForHumans()}}</small>
                </h4>
            {{$comment->body}}
            </div>
        </div>
    @endforeach
@endif
```
#### 回覆留言功能
1. 新增 routes
```
Route::group(['middleware'=>'auth'], function() {
    
    Route::post('comment/reply', 'CommentRepliesController@createdReply');

});
```
2. 在 CommentRepliesController 新增 CreateReply function
```
public function createReply(Request $request){

    $user = Auth::user();

    $data = [

        'post_id' => $request->post_id,
        'author' => $user->name,
        'email' => $user->email,
        'photo' => $user->photo->file,
        'body' => $request->body

    ];


    CommentReply::create($data);

    $request->session()->flash('reply_message', 'Your reply has been submitted and is waiting moderation');

    return redirect()->back();


}
```
3. 在 CommentReply model 新增 `'photo'` 讓欄位可寫入
4. 新增 reply comment 到 post view
```
@if(count($comment->replies) > 0)

    @foreach($comment->replies as $reply)

            <!-- Nested Comment -->
            <div class="media">
                <a class="pull-left" href="#">
                    <img height="64" class="media-object" src="{{$reply->photo}}" alt="">
                </a>
                <div class="media-body">
                    <h4 class="media-heading">{{$reply->author}}
                        <small>{{$reply->created_at->diffForHumans()}}</small>
                    </h4>
                    <p>{{$reply->body}}</p>
                </div>

                {!! Form::open(['method'=>'POST', 'action'=>'CommentRepliesController@createReply']) !!}

                    <input type="hidden" name="comment_id" value="{{$comment->id}}">

                    <div class="form-group">
                        {!! Form::label('body', 'Body:') !!}
                        {!! Form::text('body', null, ['class'=>'form-control', 'rows'=>1]) !!}
                    </div>

                    {{csrf_field()}}

                    <div class="form-group">
                        {!! Form::submit('submit', ['class'=>'btn btn-primary']) !!}
                    </div>

                {!! Form::close() !!}

            </div>
            <!-- End Nested Comment -->

    @endforeach

@endif
```
5. 在 layouts.blog-post view 生成 script 區塊
`@yield('scripts')`
6. 新增 div
```
<div class="comment-reply-container">

    <button class="toggle-reply btn btn-primary pull-right">Reply</button>

    <div class="comment-reply">
    /* Nested Comment*/
    </div>
</div>

```
7. 在 resources/assets/scss/app.css 修改樣式，新增 `.comment-reply {display: none;}`，並用`gulp`編譯。
8. 新增 scripts 區塊
```
@section('scripts')

    <script>

        $(".comment-reply-container .toggle-reply").click(function(){

            $(this).next().slideToggle("slow");

        });

    </script>

@stop
```
#### 在主管理介面顯示回覆
1. 複製 comments/show view 到 comments/replies/show view，將 comment 改為 reply。
2. 在 admin/comments/index view 新增
`<td><a href="{{" {{route('admin.comments.replies.show', $comment->id)" }}}}">View Replies</a></td>`
3. 在 CommentRepliesController 新增 show function
```
public function show($id)
{
    $comment = Comment::findOrFail($id);

    $replies = $comment->replies;

    return view('admin.comments.replies.show', compact('replies'));
}
```
4. 在 CommentRepliesController 新增 update function
```
public function update(Request $request, $id)
{
    CommentReply::findOrFail($id)->update($request->all());

    return redirect()->back();
}
```
5. 修改 post view
```
@if($reply->is_active == 1)
    /*nested comment*/
    @else
    <h1 class="text-center">No Relies</h1>
@endif
```
6. 在 CommentRepliesController 新增 destroy function
```
public function destroy($id)
{
    CommentReply::findOrFail($id)->delete();
    
    redirect()->back();
}
```