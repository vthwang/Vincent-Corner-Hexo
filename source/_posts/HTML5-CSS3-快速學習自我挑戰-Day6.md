---
title: HTML5+CSS3 快速學習自我挑戰 Day6
thumbnail:
  - /images/learning/htmlcss/HtmlCssDay6.png
date: 2017-12-20 19:53:29
categories: Study Note
tags: 
    - HTML
    - CSS
    - UX
---
<img src="/images/learning/htmlcss/HtmlCssDay6.png">

***
### BONUS
#### 使用 PHP 完成表單
1. 新增 index.php，把原本的 index.html 複製過去，新增 id，在 form 的地方加入 action，並新增 mail 完成傳送的訊息
```
<div class="form-box" id="form">
    <div class="row">
        <h2>We're happy to hear from you</h2>
    </div>
    <div class="row">
        <form method="post" action="mailer.php" class="contact-form">
            <div class="row">
                <?php
                    if($_GET['success'] == 1) {
                        echo "<div class=\"form-messages success\">Thank you! Your message has been sent.</div>";
                    }

                if($_GET['success'] == -1) {
                    echo "<div class=\"form-messages error\">Oops! Something went wrong. Please try again!</div>";
                }
                ?>
            </div>
```
2. 在 resource/css/style.css 新增表單樣式
```
.form-messages {
    width: 70%;
    padding: 10px;
    border-radius: 3px;
    margin: 0 auto 30px;
    color: #333;
}

.success { background-color: rgba(38, 191, 68, 0.8); }

.error { background-color: rgba(209, 46, 46, 0.8); }
```
3. 在 resource/css/style.css 將高度調整為 630px
```
.map-box {
    height: 630px;
}

.map {
    height: 630px;
}

.form-box {
    height: 630px;
}
```
4. 在根目錄新增 mailer.php
```
<?php
    // Get the form fields, removes html tags and whitespace.
    $name = strip_tags(trim($_POST["name"]));
    $name = str_replace(array("\r","\n"), array(" ", " "), $name);
    $email = filter_var(trim($_POST["email"]), FILTER_SANITIZE_EMAIL);
    $message = trim($_POST["message"]);

    //Check the data
    if (empty($name) OR empty($message) OR !filter_var($email, FILTER_SANITIZE_EMAIL)) {
        header("Location: https://omnifood.fishboneapps.com/index.php?success=-1#form");
        exit;
    }

    // Set the recipient email address. Update this to YOUR desired email address.
    $recipient = "dtvgood202@gmail.com";

    // Set the email subject.
    $subject = "New contact from $name";

    // Build the email content
    $email_content = "Name: $name\n";
    $email_content .= "Email: $email\n\n";
    $email_content .= "Message:\n$message\n";

    // Build the email headers.
    $email_headers = "From: $name <$email>";

    // Send the email.
    mail($recipient, $subject, $email_content, $email_headers);

    // Redirect to the index.html page with success code
    header("Location: https://omnifood.fishboneapps.com/index.php?success=1#form");
?>
```
#### 別停止學習
1. 建議學習 JavaScript
    - JavaScript 讓網站更生動
    - JavaScript 也可以在後端使用
    - JavaScript 很快可以開始
    - JavaScript 被高度需求且薪資高
    - JavaScript 是網路的未來
### 完成課程