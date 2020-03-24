---
title: Laravel Line Bot 製作教程
thumbnail:
  - /images/technique/LaravelLineBot.jpg
date: 2018-06-20 19:49:17
categories: Skill Share
tags: 
    - Laravel
    - Linebot
---
<img src="/images/technique/LaravelLineBot.jpg">

***
### 環境部署
1. 開啟新專案 `laravel new '專案名稱'`
2. 將檔案上傳到 github
`git add .`
`git commit -m 'Blank Project'`
`git remote add origin '專案網址'`
`git push -u origin master`
3. 在 Heroku 開啟 PHP 專案，並連結 github
4. 在 Heroku 的 Setting 頁面加上 .env 的變數
```
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:DQZriLhKBTD+imG+n9UUPWqKG3kn7ZlNIKtDDmQcEFI=
APP_DEBUG=true
APP_URL=http://localhost
```
5. 在 Heroku 的 Deploy 滑到最下面點選 Deploy Branch
6. 安裝 line-bot-sdk
`composer require linecorp/line-bot-sdk`
7. 在根目錄新增 Procfile，沒有副檔名，完成之後直接上傳，網頁就可以開啟了
`web: vendor/bin/heroku-php-apache2 public/`
### 推送訊息功能
1. [推送訊息文件](https://developers.line.me/en/docs/messaging-api/reference/#send-push-message)
    - 可以在任何時間推送訊息給使用者、群組
2. HTTP request
    - `POST https://api.line.me/v2/bot/message/push`
3. Request headers

| Request header | Description |
|---|---|
| Content-Type | application/json |
| Authorization | Bearer `{channel access token}` |

4. Request body

| Property | Type | Required |
| --- | --- | --- |
| to | String | Required |
| messages | Array of message objects | Required |

5. 進去 Line Devloper 選擇你的應用，然後將以下參數貼到 Heroku 的 Setting 裡面
```
LINEBOT_TOKEN=<Channel access token>
LINEBOT_SECRET=<Channel secret>
LINE_USER_ID=<Your user ID>
```
6. 修改 app/Providers/AppServiceProvider.php
```
public function register()
{
    $this->lineBotRegister();
    $this->lineBotServiceRegister();
}

private function lineBotRegister()
{
    $this->app->singleton(LINEBot::class, function () {
        $httpClient = new CurlHTTPClient(env('LINEBOT_TOKEN'));
        return new LINEBot($httpClient, ['channelSecret' => env('LINEBOT_SECRET')]);
    });
}

private function lineBotServiceRegister()
{
    $this->app->singleton(LineBotService::class, function () {
        return new LineBotService(env('LINE_USER_ID'));
    });
}
```
### 正式推送訊息
1. 進入 Line 的設定介面，將 Auto-reply messages 關閉
2. 推送測試訊息 
`php vendor/bin/phpunit tests/Feature/Services/LineBotServiceTest.php`
3. [模板訊息傳送之 API](https://developers.line.me/en/docs/messaging-api/reference/#template-messages)，總共有四種模版
    - Buttons
    - Confirm
    - Carousel
    - Image Carousel
4. 









