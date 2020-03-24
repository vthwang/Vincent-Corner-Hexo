---
title: Lavarel 快速學習自我挑戰 Day12
thumbnail:
  - /images/learning/laravel/laravelday12.png
date: 2017-05-03 05:44:13
categories: Study Note
tags: Laravel
---
<img src="/images/learning/laravel/laravelday12.png">

***
### Sessions - [Sessions 設定官方文件](https://laravel.com/docs/5.2/session)
#### Setting and Reading Sessions
1. 加到 HomeController
```
$request->session()->put(['edwin'=>'master instructor']);
//        session(['peter'=>'student']);  //最常用

        $request->session()->get('edwin');
```
#### Global Session Function Deleting
1. 新增 session
```
    session(['edwin2'=>'your teacher']);

    return session('edwin2');
```
2. 刪除 session：`$request->session()->forget('edwin2');`
3. 刪除所有 session：`$request->session()->flush();`
4. 顯示 session 狀態：`return $request->session()->all();`
#### Flashing Data
1. 建立 flash data (只顯示一次的資料)
```
    $request->session()->flash('message', 'Post has been created');

    return $request->session()->get('message');
```
2. data 保存久一點 
```
    $request->session()->reflash();
        
    $request->session()->keep('message');
```
### Sending Email / API - [Mail 設定官方文件](https://laravel.com/docs/5.2/mail)
#### mailgun
[Mailgun 官方網站](https://www.mailgun.com/)
#### mailgun 設定
1. 設定 config/mail.php 的寄件人名稱與 mail
`'from' => ['address' => 'admin@pcelab.info', 'name' => 'Vincent Adler'],`
2. 設定 .env
```
MAIL_DRIVER=mailgun
MAILGUN_DOMAIN=XXXXX
MAILGUN_SECRET=XXXXX
```
3. 新增 mail 的 view (resources/views/mails/test.blade.php)
4. 新增 routes
```
Route::get('/', function () {

    $data = [

        'title'=> 'Hi student I hope you like the course',
        'content'=> 'This laravel course was created with a lot of love and dedication for you'

    ];

    Mail::send('emails.test', $data, function($message){

        $message->to('dtvgood202@gmail.com', 'Vincent')->subject('Hello student how are you');

    });

});
```
5. 新增套件：`composer require guzzlehttp/guzzle`
6. SSL certification error - 修改 vendor/guzzlehttp/guzzle/src/Client.php：configureDefaults function 的 verify 改為 `false`
### Git and Github (Version Control)
1. 新增 branch 分支 `git checkout -b newBranch`
2. 合併到主分支 `git merge newBranch`
3. 刪除已合併到 master 的分支 `git branch -d newBranch`