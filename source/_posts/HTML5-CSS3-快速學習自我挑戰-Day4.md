---
title: HTML5+CSS3 快速學習自我挑戰 Day4
thumbnail:
  - /images/learning/htmlcss/HtmlCssDay4.jpg
date: 2017-12-01 18:13:49
categories: Study Note
tags: 
    - HTML
    - CSS
toc: true
    - UX
---
<img src="/images/learning/htmlcss/HtmlCssDay4.jpg">

***
### 殺手級的網站
#### 建立 Sign-up Section
1. 在 index.html 新增 Sign-up Section
```
<section class="section-plans">
    <div class="row">
        <h2>Start eating healthy today</h2>
    </div>
    <div class="row">
        <div class="col span-1-of-3">
            <div class="plan-box">
                <div>
                    <h3>Premium</h3>
                    <p class="plan-price">$399 <span>/ month</span></p>
                    <p class="plan-price-meal">That's only 13.30$ per meal</p>
                </div>
                <div>
                    <ul>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>1 meal every day</li>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>Order 24/7</li>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>Access to newest creations</li>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>Free delivery</li>
                    </ul>
                </div>
                <div>
                    <a href="#" class="btn btn-full">Sign up now</a>
                </div>
            </div>
        </div>
        <div class="col span-1-of-3">
            <div class="plan-box">
                <div>
                    <h3>Pro</h3>
                    <p class="plan-price">$149 <span>/ month</span></p>
                    <p class="plan-price-meal">That's only 14.90$ per meal</p>
                </div>
                <div>
                    <ul>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>1 meal 10 days/month</li>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>Order 24/7</li>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>Access to newest creations</li>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>Free delivery</li>
                    </ul>
                </div>
                <div>
                    <a href="#" class="btn btn-ghost">Sign up now</a>
                </div>
            </div>
        </div>
        <div class="col span-1-of-3">
            <div class="plan-box">
                <div>
                    <h3>Starter</h3>
                    <p class="plan-price">$19 <span>/ meal</span></p>
                    <p class="plan-price-meal">&nbsp;</p>
                </div>
                <div>
                    <ul>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>1 meal</li>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>Order from 8 am to 12 pm</li>
                        <li><i class="ion-ios-close-empty icon-small"></i></li>
                        <li><i class="ion-ios-checkmark-empty icon-small"></i>Free delivery</li>
                    </ul>
                </div>
                <div>
                    <a href="#" class="btn btn-ghost">Sign up now</a>
                </div>
            </div>
        </div>
    </div>
</section>
```
2. 在 style.css 的 SIGN UP 新增樣式
```
.section-plans {
    background-color: #f4f4f4;
}

.plan-box {
    background-color: #fff;
    border-radius: 5px;
    width: 90%;
    margin-left: 5%;
    box-shadow: 0 2px 2px #efefef;
}

.plan-box div {
    padding: 15px;
    border-bottom: 1px solid #e8e8e8;
}

.plan-box div:first-child {
    background-color: #fcfcfc;
    border-top-left-radius: 5px;
    border-top-right-radius: 5px;
}

.plan-box div:last-child {
    text-align: center;
}

.plan-price {
    font-size: 300%;
    margin-bottom: 10px;
    font-weight: 100;
    color: #e67e22;
}

.plan-price span {
    font-size: 30%;
}

.plan-price-meal {
    font-size: 80%;
}

.plan-box ul {
    list-style: none;
}

.plan-box ul li {
    padding: 5px 0;
}
```
#### 建立 Contact Form
1. 在 index.html 新增 Contact Form
```
<section class="section-form">
    <div class="row">
        <h2>We're happy to hear from you</h2>
    </div>
    <div class="row">
        <form method="post" action="#" class="contact-form">
            <div class="row">
                <div class="col span-1-of-3">
                    <label for="name">Name</label>
                </div>
                <div class="col span-2-of-3">
                    <input type="text" name="name" id="name" placeholder="Your name" required>
                </div>
            </div>
            <div class="row">
                <div class="col span-1-of-3">
                    <label for="email">Email</label>
                </div>
                <div class="col span-2-of-3">
                    <input type="email" name="email" id="email" placeholder="Your email" required>
                </div>
            </div>
            <div class="row">
                <div class="col span-1-of-3">
                    <label for="find-us">How did you find us?</label>
                </div>
                <div class="col span-2-of-3">
                    <select name="find-us" id="find-us">
                        <option value="friends">Friends</option>
                        <option value="search">Search Engine</option>
                        <option value="ad">Advertisement</option>
                        <option value="other">Other</option>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col span-1-of-3">
                    <label for="news">Newsletter</label>
                </div>
                <div class="col span-2-of-3">
                    <input type="checkbox" name="news" id="news" checked> Yes, Please
                </div>
            </div>
            <div class="row">
                <div class="col span-1-of-3">
                    <label for="">Drop us a line</label>
                </div>
                <div class="col span-2-of-3">
                    <textarea name="message" placeholder="Your message"></textarea>
                </div>
            </div>
            <div class="row">
                <div class="col span-1-of-3">
                    <label>&nbsp;</label>
                </div>
                <div class="col span-2-of-3">
                    <input type="submit" value="Send it!">
                </div>
            </div>
        </form>
    </div>
</section>
```
2. 在 style.css 的 FORM 新增樣式
```
.contact-form {
    width: 60%;
    margin: 0 auto;
}

input[type=text],
input[type=email],
select,
textarea {
    width: 100%;
    padding: 7px;
    border-radius: 3px;
    border: 1px solid #ccc;
}

textarea {
    height: 100px;
}

input[type=checkbox] {
    margin: 10px 5px 10px 0;
}

*:focus {
    outline:none;
}
```
3. 在 style.css 的 button 加上 input 的 submit botton
```
.btn:link,
.btn:visited,
input[type=submit]

.btn-full:link,
.btn-full:visited,
input[type=submit]

.btn:hover,
.btn:active,
input[type=submit]:hover,
input[type=submit]:active
```
#### 建立 Footer
1. 在 index.html 新增 Footer
```
<footer>
    <div class="row">
        <div class="col span-1-of-2">
            <ul class="footer-nav">
                <li><a href="#">About us</a></li>
                <li><a href="#">Blog</a></li>
                <li><a href="#">Press</a></li>
                <li><a href="#">iOS App</a></li>
                <li><a href="#">Android App</a></li>
            </ul>
        </div>
        <div class="col span-1-of-2">
            <ul class="social-links">
                <li><a href="#"><i class="ion-social-facebook"></i></a></li>
                <li><a href="#"><i class="ion-social-twitter"></i></a></li>
                <li><a href="#"><i class="ion-social-googleplus"></i></a></li>
                <li><a href="#"><i class="ion-social-instagram"></i></a></li>
            </ul>
        </div>
    </div>
    <div class="row">
        <p>
            Copyright &copy; 2015 by Omnifood. All rights reserved.
        </p>
    </div>
</footer>
```
2. 在 style.css 的 FOOTER 新增樣式
```
footer {
    background-color: #333;
    padding: 60px;
    font-size: 80;
}

.footer-nav {
    list-style: none;
    float: left;
}

.social-links {
    list-style: none;
    float: right;
}

.footer-nav li,
.social-links li {
    display: inline-block;
    margin-right: 40px;
}

.footer-nav li:last-child,
.social-links li:last-child {
    margin-right: 0;
}

.footer-nav li a:link,
.footer-nav li a:visited,
.social-links li a:link,
.social-links li a:visited {
    text-decoration: none;
    border: 0;
    color: #888;
}

.footer-nav li a:hover,
.footer-nav li a:active {
    color: #ddd;
}

.social-links li a:link,
.social-links li a:visited {
    font-size: 160%;
}

.ion-social-facebook,
.ion-social-twitter,
.ion-social-googleplus,
.ion-social-instagram {
    transition: color 0.2s;
}

.ion-social-facebook:hover {
    color: #3b5998;
}

.ion-social-twitter:hover {
    color: #00aced;
}

.ion-social-googleplus:hover {
    color: #dd4b39;
}

.ion-social-instagram:hover {
    color: #517fa4;
}

footer p {
    color: #888;
    text-align: center;
    font-size: 90%;
    margin-top: 20px;
}
```
### 使用 Media Queries 來做響應式設計
#### 讓網頁變成響應式
1. 新增 resources/css/queries.css
2. 在 index.html 引入新增的 queries.css
`<link rel="stylesheet" type="text/css" href="resources/css/queries.css">`
3. 在 index.html 引入 meta 讓 html 變成響應式
`<meta name="viewpoint" content="width=device-width, initial-scale=1.0">`
4. 在 resources/css/queries.css 新增 media query 讓網頁變成響應式
```
/*Big tablets to 1200px (widths smaller than 1140px row)*/
@media only screen and (max-width: 1200px) {
    .hero-text-box {
        width: 100%;
        padding: 0 2%;
    }

    .row { padding: 0 2%; }
}

/*Small tablets to big tablet: from 768px to 1023px*/
@media only screen and (max-width: 1023px) {
    body { font-size: 18px; }
    section { padding: 60px 0;}
    .long-copy {
        width: 80%;
        margin-left: 10%;
    }

    .steps-box { margin-top: 10px; }
    .steps-box:last-child { margin-top: 10px; }
    .works-step { margin-bottom: 40px; }
    .works-step:last-of-type { margin-bottom: 60px; }

    .app-screen { width: 50%; }

    .icon-small {
        width: 20px;
        margin-right: 5px;
    }
    .city-feature { font-size: 90%; }

    .plan-box {
        width: 100%;
        margin-left: 0;
    }
    .plan-price { font-size: 250%; }

    .contact-form { width: 80%; }

}

/*Small phones to small tablets: from 481px to 767px*/
@media only screen and (max-width: 767px) {
    body { font-size: 16px; }
    section { padding: 30px 0; }

    .row,
    .hero-text-box { padding: 0 4%; }
    .col {
        width: 100%;
        margin: 0 0 4% 0;
    }
    .main-nav { display: none; }

    h1 { font-size: 180%; }
    h2 { font-size: 150%; }

    .long-copy {
        width: 100%;
        margin-left: 0;
    }

    .steps-box:first-child {
        text-align: center;
    }

    .works-step div {
        height: 40px;
        width: 40px;
        margin-right: 15px;
        padding: 4px;
        font-size: 120%;
    }

    .works-step { margin-bottom: 20px; }
    .works-step:last-of-type { margin-bottom: 20px; }
}

/*Small phones: from 0 to 480px*/
@media only screen and (max-width: 480px) {
    section { padding: 25px 0; }
    .contact-form { width: 100%; }
}
```
5. 在 style.css 新增 overflow-x: hidden
```
html,
body {
    ...
    overflow-x: hidden;
}
```
#### 關於瀏覽器的筆記
1. CSS Browser prefixes
```
Android: -webkit-
Chrome: -webkit-
Firefox: -moz-
Internet Explorer: -ms-
ios: -webkit-
Opera: -o-
Safari: -webkit-
```
2. [CDN 網站](https://www.jsdelivr.com/)
3. 找到以下套件並放在網 index.html 的最下方
```
<script src="https://cdn.jsdelivr.net/npm/respond.js@1.4.2/dest/respond.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/selectivizr@1.0.3/selectivizr.min.js"></script>
```
4. [CSS 語法瀏覽器支援度查詢](https://caniuse.com/)