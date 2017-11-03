---
title: Nodejs 快速學習自我挑戰 Day11
thumbnail:
  - /images/learning/nodejs/nodejsday11.jpeg
date: 2017-10-10 07:12:56
categories: 學習歷程
tags: Nodejs
---
<img src="/images/learning/nodejs/nodejsday11.jpeg">

***
### 使用 Socket.io 的即時 Web Apps
#### Broadcasting Events
1. 刪除 server/server.js 和 public/js/index.js 的 socket.emit
2. 在 server/server.js 新增 io.emit
```
socket.on('createMessage', (message) => {
    console.log('createMessage', message);
    io.emit('newMessage', {
        from: message.from,
        text: message.text,
        CreatedAt: new Date().getTime()
    });
});
```
3. `git push heroku master`
4. 在 server/server.js 新增兩種 emit，如果 connect 就傳送歡迎，如果有新用戶進來，就 broadcast 新用戶加入
```
socket.emit('newMessage', {
    from: 'Admin',
    text: 'Welcome to the chat app'
});

socket.broadcast.emit('newMessage', {
    from: 'Admin',
    text: 'New user joined',
    createdAt: new Date().getTime()
});
```
#### 訊息產生器和測試
1. 新增 server/utils/message.js
```
var generateMessage = (from, text) => {
    return {
        from,
        text,
        createdAt: new Date().getTime()
    };
};

module.exports = {generateMessage};
```
2. `npm install expect mocha --save-dev`
3. 修改 package.json
```
"test": "mocha server/**/*.test.js",
"test-watch": "nodemon --exec 'npm test'"
```
4. 新增 server/utils/message.test.js
5. `npm test`
6. 修改 server/utils/message.test.js
```
var expect = require('expect');

var {generateMessage} = require('./message');

describe('generateMessage', () => {
    it('should generate correct message object', () => {
        var from = 'Jen';
        var text = 'Some message';
        var message = generateMessage(from, text);

        expect(typeof message.createdAt).toBe('number');
        expect(message).toMatchObject({from, text});
    });
});
```
7. 在 server/server.js 引入 `const {generateMessage} = require('./utils/message');`
8. 將 server/server.js 的 object 換成 function
```
socket.emit('newMessage', generateMessage('Admin', 'Welcome to the chat app'));

socket.broadcast.emit('newMessage', generateMessage('Admin', 'New user joined'));

io.emit('newMessage', generateMessage(message.from, message.text));
```
#### Event Acknowledgements
1. 在 public/js/index.js 新增 emit
```
socket.emit('createMessage', {
    from: 'Frank',
    test: 'Hi'
}, function (data) {
    console.log('Got it', data);
});
```
2. 在 server/server.js 新增 callback function
```
socket.on('createMessage', (message, callback) => {
    console.log('createMessage', message);
    io.emit('newMessage', generateMessage(message.from, message.text));
    callback('This is from the server');
});
```
#### 訊息表單和 jQuery
1. [下載最新版的 jQuery](http://jquery.com/download/)
2. 放到 public/js/libs/jquery.js
3. 在 public/index.html 引入 `<script src="/js/libs/jquery-3.2.1.min.js"></script>`
4. 在 public/index.html 新增 form
```
<form id="message-form">
    <input name="message" type="text" placeholder="Message" />
    <button>Send</button>
</form>
```
5. 在 public/js/index.js 新增 jQuery 來取得 form 傳出來的訊息
```
jQuery('#message-form').on('submit', function (e) {
    e.preventDefault();

    socket.emit('createMessage', {
        from: 'User',
        text: jQuery('[name=message]').val()
    }, function () {

    });
});
```
6. 在 public/index.html 新增 `<ol id="messages"></ol>` 讓傳出得的訊息 console 在頁面上
7. 在 public/js/index.js 將取得的文字用 jQuery 創建元素並顯示在前端
```
socket.on('newMessage', function (message) {
    console.log('newMessage', message);
    var li = jQuery('<li></li>');
    li.text(`${message.from}: ${message.text}`);

    jQuery('#messages').append(li);
});
```
8. `git push heroku master`
#### Geolocation
1. [Geolocation 官方文件](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation)
2. 在 public/index.html 新增 button
`<button id="send-location">Send Location</button>`
3. 在 public/js/index.js 新增 click 事件，當點擊時傳送出 location 的資訊
```
var locationButton = jQuery('#send-location');
locationButton.on('click', function () {
    if (!navigator.geolocation) {
        return alert('Geolocation not supported by your browser');
    }

    navigator.geolocation.getCurrentPosition(function (position) {
        socket.emit('createLocationMessage', {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
        });
    }, function () {
        alert('Unable to fetch location');
    });
});
```
4. 在 server/server.js 新增 newMessage 把訊息傳到前端頁面
```
socket.on('createLocationMessage', (coords) => {
    io.emit('newMessage', generateMessage('Admin', `${coords.latitude}, ${coords.longitude}`));
});
```
5. 在 server/server.js 新增新的 message，讓 locaiton 可以超連結
```
socket.on('createLocationMessage', (coords) => {
    io.emit('newLocationMessage', generateLocationMessage('Admin', coords.latitude, coords.longitude));
});
```
6. 在 server/utils/message.js 新增 generateLocationMessage 並 export
```
var generateLocationMessage = (from, latitude, longitude) => {
    return {
        from,
        url: `https://www.google.com/maps?q=${latitude},${longitude}`,
        createdAt: new Date().getTime()
    };
};

module.exports = {generateMessage, generateLocationMessage};
```
7. 在 public/js/index.js 將取得的 location 傳送到前端頁面
```
socket.on('newLocationMessage', function (message) {
    var li = jQuery('<li></li>');
    var a = jQuery('<a target="_blank">My current location</a>');

    li.text(`${message.from}: `);
    a.attr('href', message.url);
    li.append(a);
    jQuery('#messages').append(li);
});
```
8. 在 server/utils/message.test.js 測試 generateLocationMessage 可以運作
```
describe('generateLocationMessage', () => {
    it('should generate correct location object', () => {
        var from = 'Deb';
        var latitude = 15;
        var longitude = 19;
        var url = 'https://www.google.com/maps?q=15,19';
        var message = generateLocationMessage(from, latitude, longitude);

        expect(typeof message.createdAt).toBe('number');
        expect(message).toMatchObject({from, url});
    });
});
```
9. `git push heroku master`
#### 裝飾聊天頁面
1. [樣式](https://gist.github.com/andrewjmead/4783dec59ba2d1e5bcf3e1c301c5858d)
2. 新增 public/css/styles.css
```
button,button:hover{border:none;color:#fff;padding:10px}.chat__messages,.chat__sidebar ul{list-style-type:none}*{box-sizing:border-box;margin:0;padding:0;font-family:HelveticaNeue-Light,"Helvetica Neue Light","Helvetica Neue",Helvetica,Arial,"Lucida Grande",sans-serif;font-weight:300;font-size:.95rem}li,ul{list-style-position:inside}h3{font-weight:600;text-align:center;font-size:1.5rem}button{background:#265f82;cursor:pointer;transition:background .3s ease}button:hover{background:#1F4C69}button:disabled{cursor:default;background:#698ea5}.centered-form{display:flex;align-items:center;height:100vh;width:100vw;justify-content:center;background:-moz-linear-gradient(125deg,rgba(39,107,130,1) 0,rgba(49,84,129,1) 100%);background:-webkit-gradient(linear,left top,right bottom,color-stop(0,rgba(49,84,129,1)),color-stop(100%,rgba(39,107,130,1)));background:-webkit-linear-gradient(125deg,rgba(39,107,130,1) 0,rgba(49,84,129,1) 100%);background:-o-linear-gradient(125deg,rgba(39,107,130,1) 0,rgba(49,84,129,1) 100%);background:-ms-linear-gradient(125deg,rgba(39,107,130,1) 0,rgba(49,84,129,1) 100%);background:linear-gradient(325deg,rgba(39,107,130,1) 0,rgba(49,84,129,1) 100%)}.centered-form__form{background:rgba(250,250,250,.9);border:1px solid #e1e1e1;border-radius:5px;padding:0 20px;margin:20px;width:230px}.form-field{margin:20px 0}.form-field>*{width:100%}.form-field label{display:block;margin-bottom:7px}.form-field input,.form-field select{border:1px solid #e1e1e1;padding:10px}.chat{display:flex}.chat__sidebar{overflow-y:scroll;width:260px;height:100vh;background:-moz-linear-gradient(125deg,rgba(39,107,130,1) 0,rgba(49,84,129,1) 100%);background:-webkit-gradient(linear,left top,right bottom,color-stop(0,rgba(49,84,129,1)),color-stop(100%,rgba(39,107,130,1)));background:-webkit-linear-gradient(125deg,rgba(39,107,130,1) 0,rgba(49,84,129,1) 100%);background:-o-linear-gradient(125deg,rgba(39,107,130,1) 0,rgba(49,84,129,1) 100%);background:-ms-linear-gradient(125deg,rgba(39,107,130,1) 0,rgba(49,84,129,1) 100%);background:linear-gradient(325deg,rgba(39,107,130,1) 0,rgba(49,84,129,1) 100%)}.chat__footer,.chat__sidebar li{background:#e6eaee;padding:10px}.chat__sidebar h3{color:#e6eaee;margin:10px 20px;text-align:left}.chat__sidebar li{border:1px solid #e1e1e1;border-radius:5px;margin:10px}.chat__main{display:flex;flex-direction:column;height:100vh;width:100%}.chat__messages{flex-grow:1;overflow-y:scroll;-webkit-overflow-scrolling:touch;padding:10px}.chat__footer{display:flex;flex-shrink:0}.chat__footer form{flex-grow:1;display:flex}.chat__footer form *{margin-right:10px}.chat__footer input{border:none;padding:10px;flex-grow:1}.message{padding:10px}.message__title{display:flex;margin-bottom:5px}.message__title h4{font-weight:600;margin-right:10px}.message__title span{color:#999}@media (max-width:600px){*{font-size:1rem}.chat__sidebar{display:none}.chat__footer{flex-direction:column}.chat__footer form{margin-bottom:10px}.chat__footer button{margin-right:0}}
```
2. 在 public/index.html 引入 `<link rel="stylesheet" href="/css/styles.css">`
3. 在 public/index.html 加入樣式
```
<body class="body">

    <div class="chat__sidebar">
        <h3>People</h3>
        <div id="users"></div>
    </div>

    <div class="chat__main">
        <ol id="messages" class="chat__messages"></ol>

        <div class="chat__footer">
            <form id="message-form">
                <input name="message" type="text" placeholder="Message" autofocus autocomplete="off" />
                <button>Send</button>
            </form>
            <button id="send-location">Send Location</button>
        </div>
    </div>

    <script src="/socket.io/socket.io.js"></script>
    <script src="/js/libs/jquery-3.2.1.min.js"></script>
    <script src="/js/index.js"></script>
</body>
```
4. 在 server/server.js 把 callback 改為空值
```
socket.on('createMessage', (message, callback) => {
    console.log('createMessage', message);
    io.emit('newMessage', generateMessage(message.from, message.text));
    callback('');
});
```
5. 修改 public/js/index.js 用 jQuery 取得值，然後送到 server
```
jQuery('#message-form').on('submit', function (e) {
    e.preventDefault();

    var messageTextbox = jQuery('[name=message]');

    socket.emit('createMessage', {
        from: 'User',
        text: messageTextbox.val()
    }, function () {
        messageTextbox.val('')
    });
});
```
6. 修改 public/js/index.js 當送出的時候把按鈕變成無法點擊，完成之後就移除無法點擊的效果
```
locationButton.on('click', function () {
    if (!navigator.geolocation) {
        return alert('Geolocation not supported by your browser');
    }

    locationButton.attr('disabled', 'disabled').text('Sending location...');

    navigator.geolocation.getCurrentPosition(function (position) {
        locationButton.removeAttr('disabled').text('Send location');
        socket.emit('createLocationMessage', {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
        });
    }, function () {
        locationButton.removeAttr('disabled').text('Send location');
        alert('Unable to fetch location');
    });
});
```
#### Timestamps 和使用 Moment 格式化
1. `npm i moment --save`
2. [Momentjs 官方網站](http://momentjs.com/)
3. 新增 playground/time.js 測試 moment.js
```
var moment = require('moment');

var date = moment();
date.add(1, 'years').subtract(9, 'months');
console.log(date.format('MMM Do, YYYY'));
console.log(date.format('h:mm a'));
```
#### Printing Message Timestamps
1. 修改 server/utils/message.js，引入 moment，然後將 createdAt 改為 moment().valueOf();
```
var moment = require('moment');

createdAt: moment().valueOf()
```
2. `npm test`，確定測試可以通過
3. 從 node_modules/moment/moment.js 複製檔案到 public/js/libs/moment.js
4. 在 public/index.html 引入 `<script src="/js/libs/moment.js"></script>`
5. 讓訊息送出時，同時顯示時間
```
var formattedTime = moment(message.createdAt).format('h:mm a');

li.text(`${message.from} ${formattedTime}: ${message.text}`);
```