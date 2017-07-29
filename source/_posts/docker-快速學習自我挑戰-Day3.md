---
title: docker 快速學習自我挑戰 Day3
thumbnail:
  - /blogs/images/learning/docker/dockerday3.png
date: 2017-07-26 21:34:35
categories: 學習歷程
tags: Docker
---
<img src="/blogs/images/learning/docker/dockerday3.png">

***
### 如何找到且使用 container images
#### 什麼是 image (什麼不是)？
##### 章節簡介
1. 關於 images，container 的基礎要件
2. 什麼是 image (什麼不是)
3. 使用 Docker Hub 註冊
4. 管理本地 image cache
5. 建立自己的 image
##### 什麼是 image (什麼不是)
1. App binaries and dependencies
2. image data 的元數據和如何使用 image
3. 官方定義：「image 是根目錄系統變化的有序集合，而且對 container runtime 的使用有相應的執行參數」
4. 不是完整的操作系統，沒有核心、核心模組(例如：drivers)
5. 小的跟一個檔案(app binary)一樣，就像 Go 語言的 static binary
6. 大的跟帶有 apt、Apache、PHP和更多被安裝軟體的 Ubuntu 一樣
#### 強大的 hub：使用 Docker Hub Registry images
1. [Docker Hub](https://hub.docker.com) 的基礎
2. 找到官方和其它很棒的公開 image
3. 下載 images 和 image tags 的基礎
4. Docker Hub：container 版的 apt 套件系統
5. 官方 image 和如何使用它
6. 如何辨別好的公開 image
7. 使用不同 base 的 image，像是 Debian 或 Alpine
#### Images 和他們的 Layers：找出 Image Cache
1. Image layers
2. Union file system：顯示出一系列 file system 的改變，跟實際的系統一樣
3. `history` 和 `inspect`：了解 image 如何構成
4. copy on write：container 如何在 image 上執行
5. Image 是由 file system changes 和 metadata 組成的
6. 每一層都被獨一無二的被辨識而且只存在 host 一次
7. 這樣的模式可以省下 host 的空間和 push/pull 的傳送時間
8. Container 只是在 image 上層的一個單一 read/write 層
9. `docker image history` 和 `inspect` 可以幫助我們了解這些資訊
#### Image Tagging 和推送到 Docker Hub
1. 學習前必須要會的：
    - 了解 container 和 image
    - 了解 image layer 的基礎
    - 了解 Docker Hub 的基礎
2. 這個章節要學的
    - 都在講 image tags
    - 如何上傳到 Docker Hub
    - Image ID vs. Tag
3. `cat .docker/config.json` 確認已認證登入
4. `docker image tag nginx tingsyuanwang/nginx` 給 image tag 到 Docker Hub 的帳戶
5. `docker image push tingsyuanwang/nginx` 推送到自己的 Docker Hub
6. `docker image tag tingsyuanwang/nginx tingsyuanwang/nginx:testing` 給定名為 testing 的 tag
7. `docker image push tingsyuanwang/nginx:testing` 上傳 image，實際上不會全部上傳，只上傳 tag
8. 回顧
    - 適時的 tagging images
    - 給 image tag 是為了要上傳到 Docker Hub
    - Tagging 是如何和 image ID 做關聯的
    - Latest Tag 只是預設標籤，並不代表最新
    - 從 Docker cli 登入 Docker Hub
    - 如何創建私有的 Docker Hub images
#### 建立 images：Dockerfile 的基礎
1. `docker build -f some-dockerfile` 創建 Dockerfile
2. `ENV NGINX_VERSION 1.13.1-1~stretch` 這邊的 ENV 是用來設定環境變數，這是對建立或運行 container 去設定 key 和 value 的主要方法
3. `&&` 是為了確保這些指令可以符合進一個單一 layer
4. `RUN ln -sf /dev/stdout /var/log/nginx/access.log \` 這行是關於 log 記錄檔，container 只要確保所有我們想要抓的資訊都有在 stdout 的 log 記錄檔案裡面，docker engine 本身就有 logging drivers 可以去控制 host 上所有 containers 的 logs
5. `EXPOSE 80 443` 預設來說，container 裡面沒有 TCP 或 UDP port 是開啟的，除非在這邊定義，`EXPOSE` 指令並不會讓 host 上的 port 開啟，要在執行 `docker run -p` 的時候設定 host 的 port
6. `CMD ["nginx", "-g", "daemon off;"]` `CMD`是必填參數，這是最後的指令，且在每次開啟、重啟或暫停新的 container 都會執行的命令
#### 建立 images：運行 Docker Builds
1. 新增一個 [Dockerfile](https://raw.githubusercontent.com/BretFisher/udemy-docker-mastery/master/dockerfile-sample-1/Dockerfile) 到根目錄
2. `docker image build -t customnginx .` 用 dockerfile 新建一個 image
#### 建立 images：擴展官方 image
1. `WORKDIR /usr/share/nginx/html` 這個就是在跑 `cd` 的語法
2. `COPY index.html index.html` 複製本地檔案到 docker container 裡面
3. `docker image build -t nginx-with-html .` 執行檔案
4. `docker container run -p 80:80 --rm nginx-with-html` 用剛剛建立出來的 image 來執行
#### 作業：建立自己的 Dockerfile 且使用它運行 container
1. Dockerfiles 是 process workflow 和藝術組合而成的
2. 使用已存在的 Node.js app 並把它 docker 化
3. 製作 Dockerfile，建立它，測試它，上傳它，(刪除它)，並運行它
4. 預期這樣的過程是反覆的，很少能夠一次就完成它的
5. 細節都在 `dockerfile-assignment-1/Dockerfile`
6. 使用官方 **node** 6.x image 的 alpine 版本
7. 預期結果會呈現在 `http://localhost` 的網頁
8. 標籤並推送到自己的 Docker Hub
9. 從本機的 cache 移除 image，並從 Hub 重新運行一次
#### 解答：建立自己的 Dockerfile 且使用它運行 container
1. Dockerfile
```
# Instructions from the app developer
# - you should use the 'node' official image, with the alpine 6.x branch
FROM node:6-alpine
# - this app listens on port 3000, but the container should launch on port 80
#  so it will respond to http://localhost:80 on your computer
EXPOSE 3000
# - then it should use alpine package manager to install tini: 'apk add --update tini'
RUN apk add --update tini
# - then it should create directory /usr/src/app for app files with 'mkdir -p /usr/src/app'
RUN mkdir -p /usr/src/app
# - Node uses a "package manager", so it needs to copy in package.json file
COPY package.json package.json
# - then it needs to run 'npm install' to install dependencies from that file
RUN npm install && npm cache clean
# - to keep it clean and small, run 'npm cache clean --force' after above
# - then it needs to copy in all files from current director
COPY . .
# - then it needs to start container with command 'tini -- node ./bin/www'
CMD [ "tini", "--", "node", "./bin/www"]
# - in the end you should be using FROM, RUN, WORKDIR, COPY, EXPOSE, and CMD commands
```
2. `docker build -t testnode .` 使用 Dockerfile 建立 image
3. `docker container run --rm -p 80:3000 testnode` 使用 image 建立 container
4. `docker tag testnode tingsyuanwang/testing-node` 修改 tag
5. `docker push tingsyuanwang/testing-node` 將檔案推送到 Docker Hub
6. `docker image rm tingsyuanwang/testing-node` 將本地端的 node image 移除
7. `docker container run --rm -p 80:3000 tingsyuanwang/testing-node` 運行 container 讓 docker 自動從遠端抓回來