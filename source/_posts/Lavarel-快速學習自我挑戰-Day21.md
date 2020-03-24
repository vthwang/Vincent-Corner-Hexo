---
title: Lavarel 快速學習自我挑戰 Day21
thumbnail:
  - /images/learning/laravel/laravelday21.png
date: 2017-05-31 16:58:07
categories: Study Note
tags: Laravel
---
<img src="/images/learning/laravel/laravelday21.png">

***
### 升級到 Laravel 5.3 Part II
#### 升級 users
1. 把 AdminUsersController 的 `lists` 全部改為 `pluck`
#### 升級 posts
1. 新增到 routes/web.php
`Route::get('/post/{id}', ['as'=>'home.post', 'uses'=>'AdminPostsController@post']);`
2. 新增 comment routes
`'show'=>'admin.comments.show'`
3. 把 AdminPostsController 的 `lists` 全部改為 `pluck`
4. 在 composer.json 升級套件 `"laravelcollective/html": "5.3.*",`，並使用 `composer update`
#### 升級 middleware
1. 修改 kernel.php 的 $routeMiddleware
`'can' => \Illuminate\Auth\Middleware\Authorize::class,`
2. 新增 kernel.php 的 $middlewareGroups
`\Illuminate\Routing\Middleware\SubstituteBindings::class,`
3. 新增 kernel.php 的 $routeMiddleware
`'bindings' => \Illuminate\Routing\Middleware\SubstituteBindings::class,`
4. 新增 kernel.php 的 api
`'bindings',`
### WYSIWYG and file installing editor
#### 下載套件 & 安裝編輯器
1. [TinyMCE 官方網站](https://www.tinymce.com/)
2. 新增 includes/tinyeditor.blade.php view
```
<script src="https://cloud.tinymce.com/stable/tinymce.min.js"></script>
<script>tinymce.init({ selector:'textarea' });</script>
```
3. 在 admin/posts/create view 新增 `@include('includes.tinyeditor')`
4. [FileManager Github](https://github.com/UniSharp/laravel-filemanager)
5. 安裝套件 ` composer require unisharp/laravel-filemanager`
6. [laravel intervention 官方網站](http://image.intervention.io/)
7. 安裝 intervention `composer require intervention/image`
8. 將 class 加到 config/app.php provider
`Unisharp\Laravelfilemanager\LaravelFilemanagerServiceProvider::class,`
`Intervention\Image\ImageServiceProvider::class,`
9. 將 class 加到 config/app.php alias
`'Image' => Intervention\Image\Facades\Image::class,`
10. Publish the package’s config and assets
`php artisan vendor:publish --tag=lfm_config`
`php artisan vendor:publish --tag=lfm_public`
#### 創建資料夾和上傳檔案
1. 修改 includes/tinyeditor.blade.php view
```
<script src="https://cloud.tinymce.com/stable/tinymce.min.js"></script>
<script>
    var editor_config = {
        path_absolute : "/",
        selector: "textarea.my-editor",
        plugins: [
            "advlist autolink lists link image charmap print preview hr anchor pagebreak",
            "searchreplace wordcount visualblocks visualchars code fullscreen",
            "insertdatetime media nonbreaking save table contextmenu directionality",
            "emoticons template paste textcolor colorpicker textpattern"
        ],
        toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image media",
        relative_urls: false,
        file_browser_callback : function(field_name, url, type, win) {
            var x = window.innerWidth || document.documentElement.clientWidth || document.getElementsByTagName('body')[0].clientWidth;
            var y = window.innerHeight|| document.documentElement.clientHeight|| document.getElementsByTagName('body')[0].clientHeight;

            var cmsURL = editor_config.path_absolute + 'laravel-filemanager?field_name=' + field_name;
            if (type == 'image') {
                cmsURL = cmsURL + "&type=Images";
            } else {
                cmsURL = cmsURL + "&type=Files";
            }

            tinyMCE.activeEditor.windowManager.open({
                file : cmsURL,
                title : 'Filemanager',
                width : x * 0.8,
                height : y * 0.8,
                resizable : "yes",
                close_previous : "no"
            });
        }
    };

    tinymce.init(editor_config);
</script>
```
2. 在 admin/posts/create view 的 textarea 加上 `my-editor` 的 class
3. 修改 post view，強制顯示圖片
`<p>{!! $post->body !!}</p>`
4. 將編輯器也引入 admin/posts/edit view
`@include('includes.tinyeditor')`
### Disqus system
1. 進入[網站首頁](https://disqus.com/)，選擇安裝程式碼到我的網站上面。
2. 新增新的網站，按照步驟做即可。
### 大量刪除媒體
1. 新增 form 到 admin/media/index view
```
<form action="/delete/media/" method="get" class="form-inline">
    {{csrf_field()}}        
    {{method_field('delete')}}
    <div class="form-group">
        <select name="checkBoxArray" id="" class="form-control">
            <option value="delete">Delete</option>
        </select>
    </div>
    <div class="form-group">
        <input type="submit" class="btn-primary">
    </div>
        /*table code*/
</form>
```
2. 新增 routes
`Route::get('/delete/media', 'AdminMediasController@deleteMedia');`
3. 將 Delete button 的 form 修改為
```
<input type="hidden" name="photo" value="{{$photo->id}}">

<div class="form-group">
    <input type="submit" name="delete_single" value="Delete" class="btn btn-danger">
</div>
```
4. 在 AdminMediasController 新增 deleteMedia function
```
public function deleteMedia(Request $request){

    if(isset($request->delete_single)){

        $this->destroy($request->photo);

        return redirect()->back();

    }

    if(isset($request->delete_all) && !empty($request->checkBoxArray)){

        $photos = Photo::findOrFail($request->checkBoxArray);

        foreach ($photos as $photo) {

            $photo->delete();

        }

        return redirect()->back();

    } else {

        return redirect()->back();

    }

}
```
5. 新增 script section 到 media/index view，讓全選功能完成。
```
@section('scripts')

    <script>

        $(document).ready(function(){

            $('#options').click(function(){

                if(this.checked){

                    $('.checkBoxes').each(function(){

                       this.checked = true;

                    });

                } else {

                    $('.checkBoxes').each(function(){

                        this.checked = false;

                    });

                }
                
            })

        });

    </script>

@stop
```