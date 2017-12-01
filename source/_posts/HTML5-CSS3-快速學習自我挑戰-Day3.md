---
title: HTML5+CSS3 快速學習自我挑戰 Day3
thumbnail:
  - /images/learning/htmlcss/HtmlCssDay3.png
date: 2017-11-30 16:55:34
categories: 學習歷程
tags: 
    - HTML
    - CSS
    - UX
---
<img src="/images/learning/htmlcss/HtmlCssDay3.png">

***
### 殺手級的網站
#### 製作 Features Section
1. [下載 icons](http://ionicons.com/)，然後將 css 複製到 vendors/css、fonts 複製到 vendors/fonts
2. 在 index.html 引入 ionicons
`<link rel="stylesheet" type="text/css" href="vendors/css/ionicons.min.css">`
3. 在 header 下方加入 Feature Section
```
<section class="section-features">
    <div class="row">
        <h2>Get food fast &mdash; not fast food.</h2>
        <p class="long-copy">
            Hello, we're Omnifood, your new premium food delivery service. We know you're always busy. No time for cooking. So let us take care of that, we're really good at it, we promise!
        </p>
    </div>

    <div class="row">
        <div class="col span-1-of-4">
            <i class="ion-ios-infinite-outline"></i>
            <h3>Up to 365 days/year</h3>
            <p>
                Never cook again! We really mean that. Our subscription plans include up to 365 days/year coverage. You can also choose to order more flexibly if that's your style.
            </p>
        </div>
        <div class="col span-1-of-4">
            <i class="ion-ios-stopwatch-outline"></i>
            <h3>Ready in 20 minutes</h3>
            <p>
                You're only twenty minutes away from your delicious and super healthy meals delivered right to your home. We work with the best chefs in each town to ensure that you're 100% happy.
            </p>
        </div>
        <div class="col span-1-of-4">
            <i class="ion-ios-nutrition-outline"></i>
            <h3>100% organic</h3>
            <p>
                All our vegetables are fresh, organic and local. Animals are raised without added hormones or antibiotics. Good for your health, the environment, and it also tastes better!
            </p>
        </div>
        <div class="col span-1-of-4">
            <i class="ion-ios-cart-outline"></i>
            <h3>Order anything</h3>
            <p>
                We don't limit your creativity, which means you can order whatever you feel like. You can also choose from our menu containing over 100 delicious meals. It's up to you!
            </p>
        </div>
    </div>
</section>
```
4. 在 index.html 的 col 部份新增 box 和 icon 部分新增 icon-big 的 class
```
<div class="col span-1-of-4 box">
  <i class="ion-ios-infinite-outline icon-big"></i>
</div>
```
5. 在 style.css 的 REUSABLE COMPONENT 新增 section 和 box
```
section {
    padding: 80px 0;
}

.box {
    padding: 1%;
}
```
6. 在 style.css 的 HEADINGS 將共同的 css 取出來，並新增 h1 h2 h3
```
h1, h2, h3 {
    font-weight: 300;
    text-transform: uppercase;
}

h1 {
    margin-top: 0;
    margin-bottom: 20px;
    color: #fff;
    font-size: 240%;
    word-spacing: 4px;
    letter-spacing: 1px;
}

h2 {
    font-size: 180%;
    word-spacing: 2px;
    text-align: center;
    margin-bottom: 30px;
    letter-spacing: 1px;
}

h3 {
    font-size: 110%;
    margin-bottom: 15px;
}

h2:after {
    display: block;
    height: 2px;
    background-color: #e67e22;
    content: " ";
    width: 100px;
    margin: 30px auto 0;
}
```
7. 在 style.css 的 PARAGRAPHS 將共同的 css 取出來
```
.long-copy {
    line-height: 145%;
    width: 70%;
    margin-left: 15%;
}

.box p {
    font-size: 90%;
    line-height: 145%;
}
```
8. 在 style.css 的 ICONS 新增 icon-big
```
/* -------- ICONS -------- */
.icon-big {
    font-size: 350%;
    display: block;
    color: #e67e22;
    margin-bottom: 10px;
}
```
#### 建立 Favorite Meals Section
1. 在 index.html 新增一個 Favorite Meals Section
```
<section class="section-meals">
    <ul class="meals-showcase">
        <li>
            <figure class="meal-photo">
                <img src="resources/img/1.jpg" alt="Korean bibimbap with egg and vegetables">
            </figure>
        </li>
        <li>
            <figure class="meal-photo">
                <img src="resources/img/2.jpg" alt="Simple italian pizza with cherry tomatoes">
            </figure>
        </li>
        <li>
            <figure class="meal-photo">
                <img src="resources/img/3.jpg" alt="Chicken breast steak with vegetables">
            </figure>
        </li>
        <li>
            <figure class="meal-photo">
                <img src="resources/img/4.jpg" alt="Autumn pumpkin soup">
            </figure>
        </li>
    </ul>
    <ul class="meals-showcase">
        <li>
            <figure class="meal-photo">
                <img src="resources/img/5.jpg" alt="Paleo beef steak with vegetables">
            </figure>
        </li>
        <li>
            <figure class="meal-photo">
                <img src="resources/img/6.jpg" alt="Healthy baguette with egg and vegetables">
            </figure>
        </li>
        <li>
            <figure class="meal-photo">
                <img src="resources/img/7.jpg" alt="Burger with cheddar and bacon">
            </figure>
        </li>
        <li>
            <figure class="meal-photo">
                <img src="resources/img/8.jpg" alt="Granola with cherries and strawberries">
            </figure>
        </li>
    </ul>
</section>
```
2. 在 style.css 的 MEALS 新增樣式
```
.section-meals {
    padding: 0;
}

.meals-showcase {
    list-style: none;
    width: 100%;
}

.meals-showcase li {
    display: block;
    float: left;
    width: 25%;
}

.meal-photo {
    width: 100%;
    margin: 0;
    overflow: hidden;
    background-color: #000;
}

.meal-photo img {
    opacity: 0.7;
    width: 100%;
    height: auto;
    transform: scale(1.15);
    transition: transform 0.5s, opacity 0.5s;
}

.meal-photo img:hover {
    opacity: 1;
    transform: scale(1.03);
}
```
3. 在 style.css 的 MEALS 讓中間文字說明和下方段落有間距
```
.section-features .long-copy {
    margin-bottom: 40px;
}
```
#### 建立 How-it-works Section
1. 在 index.html 新增 How-it-works Section
```
<section class="section-steps">
    <div class="row">
        <h2>How it works - Simple as 1, 2, 3</h2>
    </div>
    <div class="row">
        <div class="col span-1-of-2 steps-box">
            <img src="resources/img/app-iPhone.png" alt="Omnifood app on iPhone" class="app-screen">
        </div>
        <div class="col span-1-of-2 steps-box">
            <div class="works-step">
                <div>1</div>
                <p>Choose the subscription plan that best fits your needs and sign up today.</p>
            </div>
            <div class="works-step">
                <div>2</div>
                <p>Order your delicious meal using our mobile app or website. Or you can even call us!</p>
            </div>
            <div class="works-step">
                <div>3</div>
                <p>Enjoy your meal after less than 20 minutes. See you the next time!</p>
            </div>

            <a href="#" class="btn-app"><img src="resources/img/download-app.svg" alt="App Store Button"></a>
            <a href="#" class="btn-app"><img src="resources/img/google-play-badge.svg" alt="Play Store Button"></a>
        </div>
    </div>
</section>
```
2. 在 style.css 的 HOW IT WORKS 新增樣式
```
.section-steps {
    background-color: #f4f4f4;
}

.steps-box:first-child {
    text-align: right;
    padding-right: 3%;
    margin-top: 30px;
}

.steps-box:last-child {
    padding-left: 3%;
    margin-top: 70px;
}

.app-screen {
    width: 40%;
}

.works-step {
    margin-bottom: 50px;
}

.works-step:last-of-type {
    margin-bottom: 80px;
}

.works-step div {
    color: #e67e22;
    border: 2px solid #e67e22;
    display: inline-block;
    border-radius: 50%;
    height: 50px;
    width: 50px;
    text-align: center;
    padding: 5px;
    float: left;
    font-size: 150%;
    margin-right: 25px;
}

.btn-app img {
    height: 50px;
    width: auto;
    margin-right: 10px;
}
```
3. 在 style.css 的 BASIC SETUP 新增 clearfix
```
.clearfix {zoom: 1;}
.clearfix:after {
    content: '.';
    clear: both;
    display: block;
    height: 0;
    visibility: hidden;
}
```
4. 在 index.html 的 meals-showcase 後面加上 clearfix `meals-showcase clearfix`
#### 建立 Cities Section
1. 在 index.html 新增 Cities Section
```
<section class="section-cities">
    <div class="row">
        <h2>We're currently in these cities</h2>
    </div>
    <div class="row">
        <div class="col span-1-of-4 box">
            <img src="resources/img/lisbon-3.jpg" alt="lisbon">
            <h3>Lisbon</h3>
            <div class="city-feature">
                <i class="ion-ios-person icon-small"></i>
                1600+ happy eaters
            </div>
            <div class="city-feature">
                <i class="ion-ios-star icon-small"></i>
                60+ top chefs
            </div>
            <div class="city-feature">
                <i class="ion-social-twitter icon-small"></i>
                <a href="#">@omnifood_lx</a>
            </div>
        </div>
        <div class="col span-1-of-4 box">
            <img src="resources/img/san-francisco.jpg" alt="lisbon">
            <h3>San Francisco</h3>
            <div class="city-feature">
                <i class="ion-ios-person icon-small"></i>
                3700+ happy eaters
            </div>
            <div class="city-feature">
                <i class="ion-ios-star icon-small"></i>
                160+ top chefs
            </div>
            <div class="city-feature">
                <i class="ion-social-twitter icon-small"></i>
                <a href="#">@omnifood_sf</a>
            </div>
        </div>
        <div class="col span-1-of-4 box">
            <img src="resources/img/berlin.jpg" alt="lisbon">
            <h3>Berlin</h3>
            <div class="city-feature">
                <i class="ion-ios-person icon-small"></i>
                2300+ happy eaters
            </div>
            <div class="city-feature">
                <i class="ion-ios-star icon-small"></i>
                110+ top chefs
            </div>
            <div class="city-feature">
                <i class="ion-social-twitter icon-small"></i>
                <a href="#">@omnifood_berlin</a>
            </div>
        </div>
        <div class="col span-1-of-4 box">
            <img src="resources/img/london.jpg" alt="lisbon">
            <h3>London</h3>
            <div class="city-feature">
                <i class="ion-ios-person icon-small"></i>
                1200+ happy eaters
            </div>
            <div class="city-feature">
                <i class="ion-ios-star icon-small"></i>
                50+ top chefs
            </div>
            <div class="city-feature">
                <i class="ion-social-twitter icon-small"></i>
                <a href="#">@omnifood_london</a>
            </div>
        </div>
    </div>
</section>
```
2. 在 style.css 的 CITIES 新增樣式
```
.box img {
    width: 100%;
    height: auto;
    margin-bottom: 15px;
}

.city-feature {
    margin-bottom: 5px;
}
```
3. 在 style.css 的 ICONS 新增樣式
```
.icon-small {
    display: inline-block;
    width: 30px;
    text-align: center;
    color: #e67e22;
    font-size: 120%;
    margin-right: 10px;

    /*secrets to align text and icons*/
    line-height: 120%;
    vertical-align: middle;
    margin-top: -5px;
}
```
4. 在 style.css 的 LINKS 新增樣式
```
a:link,
a:visited {
    color: #e67e22;
    text-decoration: none;
    padding-bottom: 1px;
    border-bottom: 1px solid #e67e22;
    transition: border-bottom 0.2s, color 0.2s
}

a:hover,
a:active {
    color: #555;
    border-bottom: 1px solid transparent;
}
```
5. 在 style.css 的 HOW IT WORKS 把 LINKS 底線移除
```
.btn-app:link,
.btn-app:visited {
    border: 0;
}
```
#### 建立 Customer Testimonials Section
1. 把 resources/img/back-customers.jpg 放到 resources/css/img/back-customers.jpg
2. 在 index.html 新增 Customer Testimonials Section
```
<section class="section-testimonials">
    <div class="row">
        <h2>Our customers can't live without us</h2>
    </div>
    <div class="row">
        <div class="col span-1-of-3">
            <blockquote>
                Omnifood is just awesome! I just launched a startup which leaves me with no time for cooking, so Omnifood is a life-saver. Now that I got used to it, I couldn't live without my daily meals!
                <cite><img src="resources/img/customer-1.jpg" alt="">Alberto Duncan</cite>
            </blockquote>
        </div>
        <div class="col span-1-of-3">
            <blockquote>
                Inexpensive, healthy and great-tasting meals, delivered right to my home. We have lots of food delivery here in Lisbon, but no one comes even close to Omifood. Me and my family are so in love!
                <cite><img src="resources/img/customer-2.jpg" alt="">Joana Silva</cite>
            </blockquote>
        </div>
        <div class="col span-1-of-3">
            <blockquote>
                I was looking for a quick and easy food delivery service in San Franciso. I tried a lot of them and ended up with Omnifood. Best food delivery service in the Bay Area. Keep up the great work!
                <cite><img src="resources/img/customer-3.jpg" alt="">Milton Chapman</cite>
            </blockquote>
        </div>
    </div>
</section>
```
3. 在 style.css 的 TESTIMONIALS 新增樣式
```
.section-testimonials {
    background-image: linear-gradient(rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0.8)), url('img/back-customers.jpg');
    background-size: cover;
    color: #fff;
    background-attachment: fixed;
}

blockquote {
    padding: 2%;
    font-style: italic;
    line-height: 145%;
    position: relative;
    margin-top: 40px;
}

blockquote:before {
    content: "\201C";
    font-size: 500%;
    display: block;
    position: absolute;
    top: -5px;
    left: -3px;
}

cite {
    font-size: 90%;
    margin-top: 25px;
    display: block;
}

cite img {
    height: 50px;
    border-radius: 50%;
    margin-right: 10px;
    vertical-align: middle;
}
```
4. 在 style.css 的 `header` 新增 `background-attachment: fixed;`，讓圖片在背景部分靜止不動，做成視差捲軸