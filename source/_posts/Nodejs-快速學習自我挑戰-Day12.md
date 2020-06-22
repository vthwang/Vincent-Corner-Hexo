---
title: Nodejs 快速學習自我挑戰 Day12
thumbnail:
  - /images/learning/nodejs/nodejsday12.jpg
date: 2017-10-14 08:51:23
categories: Study Note
tags: Nodejs
toc: true
---
<img src="/images/learning/nodejs/nodejsday12.jpg">

***
### 使用 Socket.io 的即時 Web Apps
#### Mustache.js
1. [下載 Mustache 最新版](https://github.com/janl/mustache.js/)，儲存到 public/js/libs/mustache.js
2. 在 public/index.html 引入 `<script src="js/libs/mustache.js"></script>`
3. 在 public/index.html 加入 template
```
<script id="message-template" type="text/template">
    <li class="message">
        <div class="message__title">
            <h4>{{from}}</h4>
            <span>{{createdAt}}</span>
        </div>
        <div class="message__body">
            <p>{{text}}</p>
        </div>
    </li>
</script>

<script id="location-message-template" type="text/template">
    <li class="message">
        <div class="message__title">
            <h4>{{from}}</h4>
            <span>{{createdAt}}</span>
        </div>
        <div class="message__body">
            <p>
                <a href="{{url}}" target="_blank">My current location</a>
            </p>
        </div>
    </li>
</script>
```
4. 在 public/js/index.js 使用 Mustache 來顯示 template
```
socket.on('newMessage', function (message) {
    var formattedTime = moment(message.createdAt).format('h:mm a');
    var template = jQuery('#message-template').html();
    var html = Mustache.render(template, {
        text: message.text,
        from: message.from,
        createdAt: formattedTime
    });

    jQuery('#messages').append(html);
});

socket.on('newLocationMessage', function (message) {
    var formattedTime = moment(message.createdAt).format('h:mm a');
    var template = jQuery('#location-message-template').html();
    var html = Mustache.render(template, {
        from: message.from,
        url: message.url,
        createdAt: formattedTime
    });

    jQuery('#messages').append(html);
});
```
5. `git push heroku master`
#### Autoscrolling
1. 在 public/js/index.js 新增 scrollToBottom function
```
function scrollToBottom () {
    // Selectors
    var messages = jQuery('#messages');
    var newMessage = messages.children('li:last-child');
    // Height
    var clientHeight = messages.prop('clientHeight');
    var scrollTop = messages.prop('scrollTop');
    var scrollHeight = messages.prop('scrollHeight');
    var newMessageHeight = newMessage.innerHeight();
    var lastMessageHeight = newMessage.prev().innerHeight();

    if (clientHeight + scrollTop + newMessageHeight + lastMessageHeight >= scrollHeight) {
        messages.scrollTop(scrollHeight);
    }
}
```
2. 在 public/js/index.js 的 newMessage 和 newLocationMessage 新增 scrollToBottom
`scrollToBottom();`
#### 新增一個 join page
1. 將本來的 index.html 和 index.js 改為 chat.html 和 chat.js
2. 新增 public/index.html
```
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scale=1, user-scalable=no">
    <title>Join | ChatApp</title>
    <link rel="stylesheet" href="css/styles.css">
</head>

<body class="centered-form">
    <div class="centered-form__form">
        <form action="chat.html">
            <div class="form-field">
                <h3>Join a Chat</h3>
            </div>
            <div class="form-field">
                <label>Display name</label>
                <input type="text" name="name" autofocus />
            </div>
            <div class="form-field">
                <label>Room name</label>
                <input type="text" name="room" />
            </div>
            <div class="form-field">
                <button>Join</button>
            </div>
        </form>
    </div>

</body>
</html>
```
#### 傳送 Room 資訊
1. [deparam function](https://gist.github.com/andrewjmead/b71e03d8df237983285892f9a265d401)
2. 把檔案下載到 public/js/libs/deparam.js
3. 在 public/chat.html 引入 `<script src="js/libs/deparam.js"></script>`
4. 在 public/js/chat.js 新增 emit
```
socket.on('connect', function () {
    var params = jQuery.deparam(window.location.search);

    socket.emit('join', params, function (err) {
        if (err) {
            alert(err);
            window.location.href = '/';
        } else {
            console.log('No error');
        }
    });
});
```
5. 新增 server/utils/validation.js
```
var isRealString = (str) => {
    return typeof str === 'string' && str.trim().length > 0;
};

module.exports = {isRealString};
```
6. 在 server/server.js 引入 `const {isRealString} = require('./utils/validation');`
7. 在 server/server.js 新增 socket.on 取得資訊，並做驗證
```
socket.on('join', (params, callback) => {
    if (!isRealString(params.name) || !isRealString(params.room)) {
        callback('Name and room name are required.');
    }

    callback();
});
```
8. 新增 server/utils/validation.test.js
    - 引入 isRealString
    - 測試一：拒絕不是 string 的值
    - 測試二：拒絕只有空白的 string
    - 測試三：接受沒有空格的 string
9. 新增 server/utils/validation.test.js
```
const expect = require('expect');

const {isRealString} = require('./validation');

describe('isRealString', () => {
    it('should reject non-string values', () => {
        var res = isRealString(98);
        expect(res).toBe(false);
    });

    it('should reject string with only spaces', () => {
        var res = isRealString('    ');
        expect(res).toBe(false);
    });

    it('should allow string with non-space characters', () => {
        var res = isRealString('  Andrew  ');
        expect(res).toBe(true);
    });
});
```
#### Socket.io Rooms
1. 在 server/server.js 新增 socket.join，然後把上面的 newMessage 放到下面，動態產生使用者加入的訊息
```
socket.on('join', (params, callback) => {
    if (!isRealString(params.name) || !isRealString(params.room)) {
        callback('Name and room name are required.');
    }

    socket.join(params.room);

    socket.emit('newMessage', generateMessage('Admin', 'Welcome to the chat app'));
    socket.broadcast.to(params.room).emit('newMessage', generateMessage('Admin', `${params.name} has joined`));
    callback();
});
```
#### 使用 ES6 classes 來儲存用戶
1. 新增 server/utils/users.js
```
class Person {
    constructor (name, age) {
        console.log(name, age);
    }
}

var me = new Person('Andrew', 25);
```
2. `node server/utils/users.js` 就會出現 Andrew 25
3. 在 class 新增 getUserDescription 
```
getUserDescription () {
    return `${this.name} is ${this.age} year(s) old.`;
}
```
4. 新增變數，然後讀出變數
```
var description = me.getUserDescription();
console.log(description);
```
5. `console.log(description);` 就會顯示出 Andrew is 25 year(s) old.
6. 在 server/utils/users.js 新增 Users class
```
class Users {
    constructor () {
        this.users = [];
    }
    addUser (id, name, room) {
        var user = {id, name, room};
        this.users.push(user);
        return user;
    }
}

module.exports = {Users};
```
7. 新增 server/utils/users.test.js
```
const expect = require('expect');

const {Users} = require('./users');

describe('Users', () => {
    it('should add new user', () => {
        var users = new Users();
        var user = {
            id: '123',
            name: 'Andrew',
            room: 'The Office Fans'
        };
        var resUser = users.addUser(user.id, user.name, user.room);

        expect(users.users).toEqual([user]);
    });
});
```
8. `npm test`
9. 在 server/utils/users.test.js 丟 data 進去
```
var users;

beforeEach(() => {
    users = new Users();
    users.users = [{
        id: '1',
        name: 'Mike',
        room: 'Node Course'
    },{
        id: '2',
        name: 'Jen',
        room: 'React Course'
    },{
        id: '3',
        name: 'Julie',
        room: 'Node Course'
    }];
});
```
10. `npm run test-watch`
11. 在 server/utils/user.js 新增 getUserList
```
getUserList (room) {
    var users = this.users.filter((user) => user.room === room);
    var namesArray = users.map((user) => user.name);

    return namesArray;
}
```
12. 在 server/utils/user.test.js 新增 getUserList 測試
```
it('should return names for node course', () => {
    var userList = users.getUserList('Node Course');

    expect(userList).toEqual(['Mike', 'Julie']);
});

it('should return names for react course', () => {
    var userList = users.getUserList('React Course');

    expect(userList).toEqual(['Jen']);
});
```
13. 在 server/utils/user.js 新增 getUser
```
getUser (id) {
    return this.users.filter((user) => user.id === id)[0];
}
```
14. 在 server/utils/user.test.js 新增 getUser 測試
```
it('should find user', () => {
    var userId = '2';
    var user = users.getUser(userId);

    expect(user.id).toBe(userId);
});

it('should not find user', () => {
    var userId = '99';
    var user = users.getUser(userId);

    expect(user).toBeUndefined();
});
```
15. 在 server/utils/user.js 新增 removeUser
```
removeUser (id) {
    var user = this.getUser(id);

    if (user) {
        this.users = this.users.filter((user) => user.id !== id);
    }

    return user;
}
```
16. 在 server/utils/user.test.js 新增 removeUser 測試
```
it('should remove a user', () => {
    var userId = '1';
    var user = users.removeUser(userId);

    expect(user.id).toBe(userId);
    expect(users.users.length).toBe(2);
});

it('should not remove user', () => {
    var userId = '99';
    var user = users.removeUser(userId);

    expect(user).toBeUndefined();
    expect(users.users.length).toBe(3);
});
```
#### Wiring up User List
1. 在 public/js/chat.js 新增 updateUserList
```
socket.on('updateUserList', function (users) {
    console.log('Users list', users);
});
```
2. 在 server/server.js 引入 `const {Users} = require('./utils/users');`
3. 在 server/server.js 新增 users `var users = new Users();`
4. 在 server/server.js 的 connect 部分，當連線時，先 removeUser，然後再重新 addUser，最後將 userList 傳送到前端頁面
```
users.removeUser(socket.id);
users.addUser(socket.id, params.name, params.room);

io.to(params.room).emit('updateUserList', users.getUserList(params.room));
```
5. 在 server/server.js 的 disconnect 部分，踢除 user，如果 user 存在，就更新 UserList，然後在前端頁面顯示 user 離開的訊息
```
socket.on('disconnect', () => {
    var user = users.removeUser(socket.id);

    if (user) {
        io.to(user.room).emit('updateUserList', users.getUserList(user.room));
        io.to(user.room).emit('newMessage', generateMessage('Admin', `${user.name} has left.`));
    }
});
```
6. 修改 public/js/chat.js 的 updateUserList，把 user 顯示在前端
```
socket.on('updateUserList', function (users) {
    var ol = jQuery('<ol></ol>');

    users.forEach(function (user) {
        ol.append(jQuery('<li></li>').text(user));
    });

    jQuery('#users').html(ol);
});
```
#### 只傳送訊息到同一個 Room
1. 在 public/js/chat.js 的 submit 刪掉 `from: 'User',`
2. 在 server/server.js 修改 createMessage 讓 message 只在指定的 room 發佈訊息
```
socket.on('createMessage', (message, callback) => {
    var user = users.getUser(socket.id);

    if (user && isRealString(message.text)) {
        io.to(user.room).emit('newMessage', generateMessage(user.name, message.text));
    }

    callback('');
});
```
3. 在 server/server.js 修改 createLocationMessage 如上
```
socket.on('createLocationMessage', (coords) => {
    var user = users.getUser(socket.id);

    if (user) {
        io.to(user.room).emit('newLocationMessage', generateLocationMessage(user.name, coords.latitude, coords.longitude));
    }

});
```
#### 新功能開發
1. 不管字母大小寫，都是同一個房間
2. 拒絕同樣名稱的用戶
3. 在進去聊天室的時候，列出正在聊天的聊天室名稱 (dropdown)