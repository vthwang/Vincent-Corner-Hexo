---
title: Nodejs 快速學習自我挑戰 Day4
thumbnail:
  - /images/learning/nodejs/nodejsday4.jpg
date: 2017-06-13 20:46:04
categories: 學習歷程
tags: Nodejs
---
<img src="/images/learning/nodejs/nodejsday4.jpg">

***
### Weather App
#### 進階 Promise
1. 新增 asyncAdd function，用 new Promise 新增 promise，然後再用 .then 輸出結果，最後用 .catch 把錯誤一次輸出(避免第二次 errorMessage 跑的是 success function)
```
var asyncAdd = (a, b) => {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (typeof a === 'number' && typeof b === 'number') {
                resolve(a + b);
            } else {
                reject('Arguments must be numbers');
            }
        }, 1500);
    });
};

asyncAdd(5, '7').then((res) => {
    console.log('Results: ', res);
    return asyncAdd(res, 33);
}).then((res) => {
    console.log('Should be 45', res);
}).catch((errorMessage) => {
    console.log(errorMessage);
});
```
2. 使用 Promise 取代 callback 整合 geocode
```
const request = require('request');

var geocodeAddress = (address) => {
    return new Promise((resolve, reject) => {
        var encodedAddress = encodeURIComponent(address);

        request ({
            url: `https://maps.googleapis.com/maps/api/geocode/json?address=${encodedAddress}`,
            json: true
        }, (error, response, body) => {
            if (error) {
                reject('Unable to connect to Google servers');
            } else if (body.status === 'ZERO_RESULTS') {
                reject('Unable to find that address');
            } else if (body.status === 'OK') {
                resolve({
                    address: body.results[0].formatted_address,
                    latitude: body.results[0].geometry.location.lat,
                    longitude: body.results[0].geometry.location.lng,
                });
            }
        });
    });
};

geocodeAddress('19146').then((location) => {
    console.log(JSON.stringify(location, undefined, 2));
}, (errorMessage) => {
    console.log(errorMessage);
});
```
#### 讓 Weather App 使用 Promise
1. [axios 套件](https://www.npmjs.com/package/axios)
2. 安裝 axios `npm install axios@0.13.1 --save`
3. 使用 axios，先使用 .then 取得地址，然後再用一次 .then 取得溫度，最後用 .catch 處理錯誤的出現
```
var encodedAddress = encodeURIComponent(argv.address);
var geocodeUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodedAddress}`;

axios.get(geocodeUrl).then((response) => {
    if (response.data.status === 'ZERO_RESULTS') {
        throw new Error('Unable to find that address.');
    }
    var lat = response.data.results[0].geometry.location.lat;
    var lng = response.data.results[0].geometry.location.lng;
    var weatherUrl = `https://api.darksky.net/forecast/key/${lat}, ${lng}`;
    console.log(response.data.results[0].formatted_address);
    return axios.get(weatherUrl);
}).then((response) => {
    var temperature = response.data.currently.temperature;
    var apparentTemperature = response.data.currently.apparentTemperature;
    console.log(`It's currently ${temperature}, It feels like ${apparentTemperature}.`);
}).catch((e) => {
    if (e.code === 'ENOTFOUND') {
        console.log('Unable to connect to API servers.');
    } else {
        console.log(e.message);
    }
});
```
#### Weather App 額外的功能 (思路)
1. 除了 Current Temperature 之外，可以從 Weather API 讀取更多資訊
2. 如果讀不到位置，可以使用預設的地點
3. 搜尋完的結果用 filesystem 寫入檔案
### 網頁伺服器及應用程式部署
#### Hello Express
1. [Express 官方網站](http://expressjs.com/)
2. 安裝 express `npm install express@4.14.0 --save`
3. 在根目錄新增 server.js
```
const express = require('express');

var app = express();

app.get('/', (req, res) => {
    // res.send('<h1>Hello Express!</h1>');
    res.send({
        name: 'Andrew',
        likes: [
            'Biking',
            'Cities'
        ]
    });
});

app.get('/about', (req, res) => {
    res.send('About Page');
});

// /bad - send back json with errorMessage
app.get('/bad', (req, res) => {
    res.send({
        errorMessage: 'Unable to handle request'
    });
});

app.listen(3000);
```
#### 創建網頁伺服器
1. 新增 public/help.html
```
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Help Page</title>
</head>
<body>
    <h1>Help Page</h1>
    <p>Some text here</p>
</body>
</html>
```
2. 使用 app.use 指定 public 目錄
`app.use(express.static(__dirname + '/public'));`
3. 當伺服器啟動，傳送訊息
```
app.listen(3000, () => {
    console.log('Server is up on port 3000');
});
```
#### 呈現 template 和 data
1. [handlebars.js](http://handlebarsjs.com/)
2. 安裝 handlebars.js `npm install hbs@4.0.0 --save`
3. 設定 view engine `app.set('view engine', 'hbs');`
4. 新增 views/about.hbs
```
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Help Page</title>
</head>
<body>
    <h1>About Page</h1>
    <p>Some text here</p>

    <footer>
        <p>Copyright 2017</p>
    </footer>
</body>
</html>
```
5. 使用 render 取得頁面
```
app.get('/about', (req, res) => {
    res.render('about.hbs');
});
```
6. 動態存取資料，傳送值到 view
```
app.get('/about', (req, res) => {
    res.render('about.hbs', {
        pageTitle: 'About Page',
        currentYear: new Date().getFullYear()
    });
});
```
7. 在 view 取得值
```
<h1>{{pageTitle}}</h1>
<p>Some text here</p>

<footer>
    <p>Copyright {{currentYear}}</p>
</footer>
```