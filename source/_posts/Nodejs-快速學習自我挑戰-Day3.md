---
title: Nodejs 快速學習自我挑戰 Day3
thumbnail:
  - /images/learning/nodejs/nodejsday3.jpg
date: 2017-06-12 05:25:35
categories: Study Note
tags: Nodejs
toc: true
---
<img src="/images/learning/nodejs/nodejsday3.jpg">

***
### Weather App
#### 美化 Printing Objects
1. 將 Printing Object 用 stringify 處理
`console.log(JSON.stringify(body, undefined, 2));`
#### Http Request
1. 觀看 response 資訊，成功的話 Http status 會是 200
`console.log(JSON.stringify(response, undefined, 2));`
2. 觀看是否有錯誤
`console.log(JSON.stringify(error, undefined, 2));`
#### User Input 編碼
1. 安裝 Yargs `npm install yargs@4.8.1 --save`
2. 使用 yargs 新增 command 以及其他設定
```
const argv = yargs
    .options({
        a: {
            demand: true,
            alias: 'address',
            describe: 'Address to fetch weather for',
            string: true
        }
    })
    .help()
    .alias('help', 'h')
    .argv;
```
3. 將輸入編碼
`var encodedAddress = encodeURIComponent(argv.address);`
4. 將編碼好的地址傳進 request
```
url: `https://maps.googleapis.com/maps/api/geocode/json?address=${encodedAddress}`
```
#### Callback Errors 處理
1. 處理錯誤
```
request ({
    url: `https://maps.googleapis.com/maps/api/geocode/json?address=${encodedAddress}`,
    json: true
}, (error, response, body) => {
    if (error) {
        console.log('Unable to connect to Google servers');
    } else if (body.status === 'ZERO_RESULTS') {
        console.log('Unable to find that address');
    } else if (body.status === 'OK') {
        console.log(`Address: ${body.results[0].formatted_address}`);
        console.log(`Latitude: ${body.results[0].geometry.location.lat}`);
        console.log(`Longitude: ${body.results[0].geometry.location.lng}`);
    }
});
```
#### 將 Callback 放到其他地方
1. 新增 geocode/geocode.js
```
const request = require('request');

var geocodeAddress = (address) => {
    var encodedAddress = encodeURIComponent(address);

    request ({
        url: `https://maps.googleapis.com/maps/api/geocode/json?address=${encodedAddress}`,
        json: true
    }, (error, response, body) => {
        if (error) {
            console.log('Unable to connect to Google servers');
        } else if (body.status === 'ZERO_RESULTS') {
            console.log('Unable to find that address');
        } else if (body.status === 'OK') {
            console.log(`Address: ${body.results[0].formatted_address}`);
            console.log(`Latitude: ${body.results[0].geometry.location.lat}`);
            console.log(`Longitude: ${body.results[0].geometry.location.lng}`);
        }
    });
};

module.exports.geocodeAddress = geocodeAddress;
```
2. 在 app.js 引入 geocode
`const geocode = require('./geocode/geocode');`
3. 在 app.js 使用 geocode
`geocode.geocodeAddress(argv.address);`
4. 使用 callback 來得到結果
```
geocode.geocodeAddress(argv.address, (errorMessage, results) => {
    if (errorMessage) {
        console.log(errorMessage);
    } else {
        console.log(JSON.stringify(results, undefined, 2))
    }
});
```
5. 在 geocode 使用 callback
```
var geocodeAddress = (address, callback) => {
    var encodedAddress = encodeURIComponent(address);

    request ({
        url: `https://maps.googleapis.com/maps/api/geocode/json?address=${encodedAddress}`,
        json: true
    }, (error, response, body) => {
        if (error) {
            callback('Unable to connect to Google servers');
        } else if (body.status === 'ZERO_RESULTS') {
            callback('Unable to find that address');
        } else if (body.status === 'OK') {
            callback(undefined, {
                address: body.results[0].formatted_address,
                Latitude: body.results[0].geometry.location.lat,
                Longitude: body.results[0].geometry.location.lng,
            });
        }
    });
};
```
#### 跟天氣搜索的 API 串接
1. [forecast.io 開發者區](https://darksky.net/dev/)
2. Forecast Request api 格式
`https://api.darksky.net/forecast/[key]/[latitude],[longitude]`
3. request weather API
```
const request = require('request');

request({
    url: 'https://api.darksky.net/forecast/[key]/[latitude],[longitude]',
    json: true
}, (error, response, body) => {
    if (!error) {
        console.log(body.currently.temperature);
    } else {
        console.log('Unable to fetch weather.');
    }
});
```
#### 把 callback 串連在一起
1. 新增 weather/weather.js
```
const request = require('request');

var getWeather = (lat, lng, callback) => {
    request({
        url: `https://api.darksky.net/forecast/5c410165ac4d6fd40bb36232d16d7c8e/${lat}, ${lng}`,
        json: true
    }, (error, response, body) => {
        if (!error) {
            callback(undefined, {
                temperature: body.currently.temperature,
                apparentTemperature: body.currently.apparentTemperature
            });
        } else {
            callback('Unable to fetch weather.');
        }
    });
};

module.exports.getWeather = getWeather;
```
2. 將兩個 function 合在一起
```
geocode.geocodeAddress(argv.address, (errorMessage, results) => {
    if (errorMessage) {
        console.log(errorMessage);
    } else {
        console.log(results.address);
        weather.getWeather(results.latitude, results.longitude, (errorMessage, weatherResults) => {
            if (errorMessage) {
                console.log(errorMessage);
            } else {
                console.log(`It's currently ${weatherResults.temperature}. it feels like ${weatherResults.apparentTemperature}.`);
            }
        });
    }
});
```
#### ES6 Promises
1. Promise 提供兩種 function 可以使用：resolve 和 reject
```
var somePromise = new Promise((resolve, reject) => {
    resolve('Hey. It worked!');
});
```
2. .then 對 成功或錯誤的 cases 提供 callback function
```
somePromise.then((message) => {
    console.log('Success: ', message);
}, (errorMessage) => {
    console.log('Error: ', errorMessage);
});
```
3. 在 Promise 的處理，不可以同時出現 reject 和 resolve，若兩項同時出現，會執行第一項
`reject('Unable to fulfill promise');`