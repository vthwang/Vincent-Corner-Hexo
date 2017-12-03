---
title: HTML5+CSS3 快速學習自我挑戰 Day5
thumbnail:
  - /images/learning/htmlcss/HtmlCssDay5.jpg
date: 2017-12-03 15:11:22
categories: 學習歷程
tags: 
    - HTML
    - CSS
    - UX
---
<img src="/images/learning/htmlcss/HtmlCssDay5.jpg">

***
### 增加一些特效吧！
#### jQuery 簡介
1. jQuery 是世界上最熱門的 JavaScript 函式庫
2. 完全免費
3. jQuery 很容易
    - 選擇和控制 HTML 元素
    - 創建動畫
    - 開發 Ajax 應用
4. [Magnific Popup：響應式 lightbox](http://dimsemenov.com/plugins/magnific-popup/)
5. [TooltipSter：建立 ToolTip](http://iamceege.github.io/tooltipster/)
6. [Mapplace.js：在網站內插入 google map](http://maplacejs.com/)
7. [Typer.js：顯示打字特效](https://steven.codes/typerjs/)
8. [One Page Scroll：滑動特效，一次只顯示一個區塊](http://www.thepetedesign.com/demos/onepage_scroll_demo.html)
9. [jQuery 函式庫 cdn](https://developers.google.com/speed/libraries)
10. 在 index.html 引入 jQuery 函式庫
`<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>`
11. 新增 resources/js/script.js
```
$(document).ready(function() {
    $('h1').click(function() {
        $(this).css('background-color', '#ff0000')
    });
});
```
12. 在 index.html 把 script.js 引入
`<script src="resources/js/script.js"></script>`
#### 建立 sticky navigation
1. 在 index.html 的 nav 新增 .sticky class `<nav class="sticky">`，並在本來的 logo 下面放入黑色的 logo
`<img src="resources/img/logo.png" alt="Omnifood logo" class="logo-black">`
2. 在 style.css 新增 logo-black 和 sticky header 的 CSS
```
.logo-black {
    display: none;
    height: 50px;
    width: auto;
    float: left;
    margin: 5px 0;
}

/* sticky navi*/
.sticky {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    background: rgba(255, 255, 255, 0.98);
    box-shadow: 0 2px 2px #efefef;
}

.sticky .main-nav { margin-top: 18px; }

.sticky .main-nav li a:link,
.sticky .main-nav li a:visited {
    padding: 16px 0;
    color: #555;
}

.sticky .logo { display: none; }
.sticky .logo-black { display: block; }
```
3. 下載 [webpoints](http://imakewebthings.com/waypoints/)，用來幫助滾動到 html element 的 function
4. 將下載好的檔案，儲存到 vendors/js/jquery.waypoints.min.js 並在 index.html 引入
`<script src="vendors/js/jquery.waypoints.min.js"></script>`
5. 在 script.js 控制如果超過 hero box 就顯示 sticky navigation
```
$(document).ready(function() {

    $('.js--section-features').waypoint(function(direction) {
        if (direction === "down") {
            $('nav').addClass('sticky');
        } else {
            $('nav').removeClass('sticky');
        }
    }, {
        offset: '60px;'
    });

});
```
#### 滾動到元素
1. [Smooth Scrolling](https://css-tricks.com/snippets/jquery/smooth-scrolling/)
2. 在 index.html 的主頁的兩個 buttons 新增兩個 class `js--scroll-to-plans` `js--scroll-to-start`
```
<a class="btn btn-full js--scroll-to-plans" href="#">I'm hungry</a>
<a class="btn btn-ghost js--scroll-to-start" href="#">Show me more</a>
```
3. 在 index.html 的個別區塊新增專屬 js 的 class 和 id
```
<section class="section-features js--section-features" id="features">
<section class="section-meals" id="works">
<section class="section-cities" id="cities">
<section class="section-plans js--section-plans" id="plans">
```
4. 在選單新增 id 的連結
```
<li><a href="#features">Food delivery</a></li>
<li><a href="#works">How it works</a></li>
<li><a href="#cities">Our cities</a></li>
<li><a href="#plans">Sign up</a></li>
```
5. 在 index.html 新增事件當點擊按鈕時，移動到某個位置
```
$('.js--scroll-to-plans').click(function() {
    $('html, body').animate({scrollTop: $('.js--section-plans').offset().top}, 1000);
});
$('.js--scroll-to-start').click(function() {
    $('html, body').animate({scrollTop: $('.js--section-features').offset().top}, 1000);
});
```
6. 從 Smooth Scrolling 的網站複製 js 到 script.js
```
// Select all links with hashes
$('a[href*="#"]')
// Remove links that don't actually link to anything
    .not('[href="#"]')
    .not('[href="#0"]')
    .click(function(event) {
        // On-page links
        if (
            location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '')
            &&
            location.hostname == this.hostname
        ) {
            // Figure out element to scroll to
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            // Does a scroll target exist?
            if (target.length) {
                // Only prevent default if animation is actually gonna happen
                event.preventDefault();
                $('html, body').animate({
                    scrollTop: target.offset().top
                }, 1000, function() {
                    // Callback after animation
                    // Must change focus!
                    var $target = $(target);
                    $target.focus();
                    if ($target.is(":focus")) { // Checking if the target was focused
                        return false;
                    } else {
                        $target.attr('tabindex','-1'); // Adding tabindex for elements not focusable
                        $target.focus(); // Set focus again
                    };
                });
            }
        }
    });
```
#### 在滾動的過程中增加動畫
1. [Animate.css](https://daneden.github.io/animate.css/)，將檔案下載放置到 vendors/css/animate.css
2. 在 index.html 引入 Animate.css
`<link rel="stylesheet" type="text/css" href="vendors/css/animate.css">`
3. 在 index.html 要放置動畫區塊，新增 class
```
// features 區塊
<div class="row js--wp-1">
<img src="resources/img/app-iPhone.png" alt="Omnifood app on iPhone" class="app-screen js--wp-2">
// cities 區塊
<div class="row js--wp-3">
<div class="plan-box js--wp-4">
```
4. 在 style.css 的 ANIMATION 新增
```
.js--wp-1,
.js--wp-2,
.js--wp-3 {
    opacity: 0;
    -webkit-animation-duration: 1s;
            animation-duration: 1s;
}

.js--wp-4 {
    -webkit-animation-duration: 1s;
            animation-duration: 1s;
}

.js--wp-1.animated,
.js--wp-2.animated,
.js--wp-3.animated {
    opacity: 1;
}
```
5. 在 script.js 新增動畫
```
$('.js--wp-1').waypoint(function(direction) {
    $('.js--wp-1').addClass('animated fadeIn');
}, {
    offset: '50%'
});

$('.js--wp-2').waypoint(function(direction) {
    $('.js--wp-2').addClass('animated fadeInUp');
}, {
    offset: '50%'
});

$('.js--wp-3').waypoint(function(direction) {
    $('.js--wp-3').addClass('animated fadeInUp');
}, {
    offset: '50%'
});
$('.js--wp-4').waypoint(function(direction) {
    $('.js--wp-4').addClass('animated pulse');
}, {
    offset: '50%'
});
```
#### 讓 navigation 變成響應式
1. 在 index.html 新增專屬 js 的 class
```
<ul class="main-nav js--main-nav">
// 新增手機版 hamburger bar
<a class="mobile-nav-icon js--nav-icon"><i class="ion-navicon-round"></i></a>
```
2. 在 style.css 新增手機版按鈕樣式
```
.mobile-nav-icon {
    float: right;
    margin-top: 30px;
    cursor: pointer;
    display: none;
}

.mobile-nav-icon i {
    font-size: 200%;
    color: #fff;
}
```
3. 在 queries.css 新增選單響應式樣式
```
.mobile-nav-icon { display: inline-block; }

.main-nav {
    float: left;
    margin-top: 35px;
    margin-left: 25px;
}

.main-nav li {
    display: block;
}

.main-nav li a:link,
.main-nav li a:visited {
    display: block;
    border: 0;
    padding: 10px 0;
    font-size: 100%;
}

.sticky .main-nav { margin-top: 10px; }

.sticky .main-nav li a:link,
.sticky .main-nav li a:visited { padding: 10px 0; }
.sticky .mobile-nav-icon { margin-top: 10px; }
.sticky .mobile-nav-icon i { color: #555; }
```
4. 在 script.js 新增選單打開關閉效果
```
$('.js--nav-icon').click(function() {
    var nav = $('.js--main-nav');
    var icon = $('.js--nav-icon i');

    nav.slideToggle(200);
    if (icon.hasClass('ion-navicon-round')) {
        icon.addClass('ion-close-round');
        icon.removeClass('ion-navicon-round');
    } else {
        icon.addClass('ion-navicon-round');
        icon.removeClass('ion-close-round');
    }
});
```
### 優化和發佈網站
#### 最後的調整：建立 favicon
1. [favicon 產生器](https://realfavicongenerator.net/)
2. 用產生器產生之後，將檔案放在 resources/favicons，然後在 index.html 引入
```
<link rel="apple-touch-icon" sizes="180x180" href="resources/favicons/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="resources/favicons/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="resources/favicons/favicon-16x16.png">
<link rel="manifest" href="resources/favicons/manifest.json">
<link rel="mask-icon" href="resources/favicons/safari-pinned-tab.svg" color="#5bbad5">
<link rel="shortcut icon" href="resources/favicons/favicon.ico">
<meta name="msapplication-config" content="resources/favicons/browserconfig.xml">
<meta name="theme-color" content="#ffffff">
```
#### 效能優化：網站速度
1. 優化容量很大圖片
2. 壓縮 CSS 和 jQuery code
3. [optimizilla：壓縮圖片工具](http://optimizilla.com/)
4. 壓縮完之後，在 style.css 更改圖片路徑
```
header {
    background: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, 0.7)), to(rgba(0, 0, 0, 0.7))), url(img/hero-min.jpg) center;
    background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url(img/hero-min.jpg) center;
    background-size: cover;
    height: 100vh;
    background-attachment: fixed;
}

.section-testimonials {
    background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(0, 0, 0, 0.8)), to(rgba(0, 0, 0, 0.8))), url('img/back-customers-min.jpg');
    background-image: linear-gradient(rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0.8)), url('img/back-customers-min.jpg');
    background-size: cover;
    color: #fff;
    background-attachment: fixed;
}
```
5. [CSS 壓縮工具](https://cssminifier.com/)
#### 基礎 Search Engine Optimization (SEO)
1. Search Engine Optimization (SEO)：改善且提升網站訪問量的技術，讓網頁可以被搜尋引擎搜尋到
2. META DESCRIPTION TAG：在 index.html 新增 Description meta
`<meta name="description" content="Omnifood is a premium food delivery service with the mission to bring affordable and healthy meals to as many people as possible">`
3. [HTML VALIDATION](http://validator.w3.org/)
4. CONTENT IS KING：網頁內容很重要，即使網站在搜尋的最上面，內容不好，你的使用者就會不想讀，另外，保持更新網站內容，如此一來，你的使用者就會更常回來觀看你的網站。
5. KEYWORDS：不要過度使用關鍵字，搜尋引擎會認為是垃圾網站且封鎖你的網站
6. BACKLINKS：讓其它網站引用你的網站，搜尋引擎會把這個項目列入計分項目
#### 發佈我們的網站
1. 















