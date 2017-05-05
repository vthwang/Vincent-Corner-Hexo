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
#### 