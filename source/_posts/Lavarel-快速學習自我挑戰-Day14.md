---
title: Lavarel 快速學習自我挑戰 Day14
thumbnail:
  - /images/learning/laravel/laravelday14.jpg
date: 2017-05-05 00:06:02
categories: Study Note
tags: Laravel
toc: true
---
<img src="/images/learning/laravel/laravelday14.jpg">

***
### Application 2
#### 上傳功能
1. 新增 enctype (`'type'=>true`) `{!! Form::open(['method'=>'POST', 'action'=>'AdminUsersController@store', 'files'=>true]) !!}`
2. 新增 migration `php artisan make:migration add_photo_id_to_users --table=users`
3. 修改 add\_photo\_id\_to\_users_table
```
public function up()
{
    Schema::table('users', function (Blueprint $table) {

        $table->string('photo_id');
    });
}
public function down()
{
    Schema::table('users', function (Blueprint $table) {

        $table->dropColumn('photo_id');
    });
}
```
4. 在 Create Page 新增 upload 欄位
```
<div class="form-group">
    {!! Form::label('file', 'Title:') !!}
    {!! Form::file('file', null, ['class'=>'form-control']) !!}
</div>
```
5. 在 User model 讓欄位可寫入 `protected $fillable = ['name', 'email', 'password', 'role_id', 'is_active', 'photo_id']`
6.  修改 AdminUsersController 的 store function
```
    public function store(UsersRequest $request)
    {
        User::create($request->all());

        return redirect('/admin/users');
    }
```
7. 新增 Model 和 migration `php artisan make:model Photo -m`
8. 在 create\_photos\_table 新增欄位 `$table->string('file');`
9. 在 Photo model 讓 file 可寫入 `protected $fillable = ['file'];`
10. 在 User model 新增 relationship `public function photo(){return $this->belongsTo('App\Photo');}`
#### 新增連結
1. 在 layouts/admin.blade.php 新增 route link
```
<li>
    <a href="{{route('admin.users.index')}}">All Users</a>
</li>

<li>
    <a href="{{route('admin.users.create')}}">Create User</a>
</li>
```
2. 修改 create page
```
<div class="form-group">
    {!! Form::label('photo_id', 'Photo:') !!}
    {!! Form::file('photo_id', null, ['class'=>'form-control']) !!}
</div>
```
3. 在 AdminUsersController 的 store function 新增
```
if($file = $request->file('photo_id')) {

    $name = time() . $file->getClientOriginalName();

    $file->move('images', $name);

    $photo = Photo::create(['file'=>$name]);

    $input['photo_id'] = $photo->id;

}
```
4. 繼續在 store function 將密碼加密後儲存所有檔案
```
$input['password'] = bcrypt($request->password);

User::create($input);
```
5. 新增路徑資訊到 Photo model
```
protected $uploads = '/images/';

public function getFileAttribute($photo){

    return $this->uploads . $photo;

}
```
6. 新增 photo 到 User index page
`<td><img height="50" src="{{ "{{$user->photo ? $user->photo->file : 'no user photo'" }}}}" alt=""></td>`
#### Edit page
1. 修改 AdminUsersController 的 edit function (傳送 role 的資訊)
```
public function edit($id)
    {
        $user = User::findOrFail($id);

        $roles = Role::lists('name', 'id')->all();

        return view('admin.users.edit', compact('user', 'roles'));
    }
```
2. 修改 edit page (先從 create page 複製頁面，將 form 連結 model)
```
@extends('layouts.admin')

@section('content')

    <h1>Edit User</h1>

    {!! Form::model($user, ['method'=>'PATCH', 'action'=>['AdminUsersController@update', $user->id], 'files'=>true]) !!}
    <div class="form-group">
        {!! Form::label('name', 'Name:') !!}
        {!! Form::text('name', null, ['class'=>'form-control']) !!}
    </div>

    <div class="form-group">
        {!! Form::label('email', 'Email:') !!}
        {!! Form::email('email', null, ['class'=>'form-control']) !!}
    </div>

    <div class="form-group">
        {!! Form::label('role_id', 'Role:') !!}
        {!! Form::select('role_id', $roles , null, ['class'=>'form-control']) !!}
    </div>

    <div class="form-group">
        {!! Form::label('is_active', 'Status:') !!}
        {!! Form::select('is_active', array(1 => 'Active', 0 => 'No Active'), 0, ['class'=>'form-control']) !!}
    </div>

    <div class="form-group">
        {!! Form::label('photo_id', 'Photo:') !!}
        {!! Form::file('photo_id', null, ['class'=>'form-control']) !!}
    </div>

    <div class="form-group">
        {!! Form::label('password', 'Password:') !!}
        {!! Form::password('password', ['class'=>'form-control']) !!}
    </div>

    {{csrf_field()}}

    <div class="form-group">
        {!! Form::submit('Create User', ['class'=>'btn btn-primary']) !!}
    </div>
    {!! Form::close() !!}

    @include('includes.form_error')

@stop
```
3. 在 edit page 新增圖片
```
<div class="col-sm-3">

    <img src="{{$user->photo ? $user->photo->file : 'http://placehold.it/400x400'}}" alt="" class="img-responsive img-rounded">
    
</div>

<div class="col-sm-9">

</div>
```
4. 將 users/index view 的圖片改成若無圖片，顯示 sample 圖片
`<td><img height="50" src="{{ "{{$user->photo ? $user->photo->file : 'http://placehold.it/400x400'" }}}}" alt=""></td>`
5. 將 AdminUsersController 的 update function 改用 UsersRequest 來做 validation
`public function update(UsersRequest $request, $id){}`
6. 修改 AdminUsersController 的 update function
```
public function update(UsersRequest $request, $id)
{
    $user = User::findOrFail($id);

    $input = $request->all();

    if($file = $request->file('photo_id')) {

        $name = time() . $file->getClientOriginalName();

        $file->move('images', $name);

        $photo = Photo::create(['file' => $name]);

        $input['photo_id'] = $photo->id;

    }

    $user->update($input);

    return redirect('/admin/users')
}
```
7. 新增新的 Request `php artisan make:request UsersEditRequest`
8. 修改 Request
`public function authorize(){return true;}`
```
public function rules()
    {
        return [
            'name' => 'required',
            'email' => 'required',
            'role_id' => 'required',
            'is_active' => 'required',
        ];
    }
```
9. 修改 AdminUsersController 的 create 和 update function
```
if(trim($request->password) == ''){

    $input = $request->except('password');

} else {

    $input = $request->all();

    $input['password'] = bcrypt($request->password);

}
```
10. Mutator
```
public function setPasswordAttribute($password){

    if(!empty($password)){

        $this->attributes['password'] = bcrypt($password);

    }

}
```
#### Middleware
1. 新增一個 middleware `php artisan make:middleware Admin`
2. 在 app\kernel.php 註冊 middleware (routemiddleware)
`'admin' => \App\Http\Middleware\Admin::class,`
3. 新增 404 頁面 resources\views\errors\404.blade.php
4. 在 User model 新增一個 function
```
public function isAdmin(){

    if($this->role->name == "administrator"){

        return true;

    }

    return false;

}
```
5. 修改 Admin middleware
```
public function handle($request, Closure $next)
{

    if(Auth::check()){

        if(Auth::user()->isAdmin()){

            return $next($request);

        }

    }

    return redirect('/');
}
```
#### Delete User
1. 新增 form 到 Users/edit view
```
{!! Form::open(['method'=>'DELETE', 'action'=>['AdminUsersController@destroy', $user->id]]) !!}

    <div class="form-group">
        {!! Form::submit('Delete User', ['class'=>'btn btn-danger']) !!}
    </div>

{!! Form::close() !!}
```
2. 在 AdminUsersController 新增 destroy function
```
public function destroy($id)
{
    User::findOrfail($id)->delete();

    Session::flash('deleted_user', "The user has been deleted");

    return redirect('/admin/users');
}
```
3. 將讀取到的 session 顯示在 Users/index view
```
@if(Session::has('deleted_user'))

    <p class="bg-danger">{{session('deleted_user')}}</p>

@endif
```
#### 在目錄刪除圖片
1. 修改 destroy function
```
public function destroy($id)
{
    $user = User::findOrfail($id);

    unlink(public_path() . $user->photo->file);

    $user->delete();

    Session::flash('deleted_user', "The user has been deleted");

    return redirect('/admin/users');
}
```