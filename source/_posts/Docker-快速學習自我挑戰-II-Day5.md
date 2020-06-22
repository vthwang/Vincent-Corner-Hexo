---
title: Docker 快速學習自我挑戰 II Day5
thumbnail:
  - /images/learning/docker-2/DockerDay05.png
date: 2020-03-01 16:06:04
categories: Study Note
tags: Docker
toc: true
---
<img src="/images/learning/docker-2/DockerDay05.png">

***
### Docker 的數據持久化和數據共享
1. Container 是在 Image 之上去創建的，Container 可以讀寫數據，而 Image 只能夠讀取，但是 Container 裡面所寫入的數據，只會存在 Container 裡面，如果刪除 Container，寫入的數據會全部消失。但是有一種需求，資料庫的 Container 會有數據的讀寫，在這種情況下，Docker 就需要數據持久化。

<img src="/images/learning/docker-2/DockerDay05-Image01.png">

2. Container 裡面會有一個 Program，把檔案寫入 File System，這些檔案會存在 Container 的 Layer 中，我們把數據的部分，額外 Mount 一個 Volume，這樣一來，數據就會被永久保存。

<img src="/images/learning/docker-2/DockerDay05-Image02.png">

3. Docker 持久化數據的方案
    - <span style="color:red">**基於本地文件系統的 Volume**</span>。可以在執行 docker create 或是 docker run 的時，通過 -v 參數將主機目錄作為 Container 的 Volume，這部分功能便是基於本地系統的 Volume 管理。
    - <span style="color:red">**基於外掛的 Volume**</span>。支持第三方的儲存方案，例如：AWS。
4. Volume 類型
    - 受管理的 Data Volume，由 Docker 後台自動創建。
    - 綁定掛載的 Volume，具體掛載位置可由用戶指定。
### 安裝 Vagrant Plugin
1. 列出所有外掛
`vagrant plugin list`
2. 安裝 vagrant scp
`vagrant plugin install vagrant-scp`
3. 把本地資料複製到虛擬機裡面
`vagrant scp labs/ docker_node1:/home/vagrant/labs/`
### 數據持久化 Data Volume
1. [MySQL Docker file](https://github.com/docker-library/mysql/blob/c4d585301408223c27b024ce442b9bcebf0b1855/8.0/Dockerfile) 裡面有一行，`VOLUME /var/lib/mysql` 就是將數據存到虛擬主機的目錄，實現數據持久化，讓數據不會因為 Container 消失而消失
2. 創建一個 MySQL 的 Container，並使用沒有密碼的環境變數
`docker run -d --name mysql1 -e MYSQL_ALLOW_EMPTY_PASSWORD mysql`
3. 這時候用 `docker ps` 查看 Container 會發現 mysql1 沒有啟動成功，使用 `docker logs mysql1` 查看，就會顯示要指定 MYSQL_ROOT_PASSWORD
```
2020-03-01 02:36:05+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.19-1debian9 started.
2020-03-01 02:36:05+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
2020-03-01 02:36:05+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.19-1debian9 started.
2020-03-01 02:36:06+00:00 [ERROR] [Entrypoint]: Database is uninitialized and password option is not specified
	You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD
```
4. 在創建 MySQL container 的同時，也會新增一個 Volume，要將該 Volume 移除
`docker rm mysql1`
`docker volume ls`
`docker volume rm [Volume id]`
5. 再次創建一個 MySQL 的 Container
`docker run -d --name mysql1 -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql`
6. 這時候我們可以去查看新增的 Volume 的細節，裡面就會看到這個 Volume 連結到本地的 /var/lib/docker/volumes/[Volume id]/_data 這個位置
`docker volume ls`
`docker volume inspect [Volume id]`
7. 我們在創建第二個 MySQL 的 Container
`docker run -d --name mysql2 -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql`
8. 這時候再 `docker volume ls`，就會發現新增了一個新增的 Volume
9. 把 Container 停止並刪除，再查看 Container 狀態就會發現沒有任何退出或在執行的 Container 了
`docker stop mysql1 mysql2`
`docker rm mysql1 mysql2`
`docker ps -a`
10. 使用 `docker volume ls` 查看 Volume，之前新增的都還在，但是會發現命名太複雜，我們可以自定義 Volume 名稱，先把所有的 volume 移除 `docker volume rm [volume1 id] [volume2 id] `
11. 創建一個 MySQL 的 Container 並指定 Volume 名稱為 mysql，路徑為 /var/lib/mysql
`docker run -d -v mysql:/var/lib/mysql --name mysql1 -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql`
12. 使用 `docker volume ls` 查看 Volume，就會看到新增的 mysql Volume
13. 為了驗證 MySQL 的數據持久，我們進去 mysql1 的 Container 新增一個新的 database
```
docker exec -it mysql1 /bin/bash
mysql -u root
show databases;
create database docker;
exit;
exit
```
14. 停止並刪除 Container 
`docker rm -f mysql1`
15. 創建一個新的 MySQL 的 Container，並連結到之前的 Volume
`docker run -d -v mysql:/var/lib/mysql --name mysql2 -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql`
16. 進去 mysql2 的 Container 查看 databases，會發現之前新增的 Database 還存在
```
docker exec -it mysql2 /bin/bash
mysql -u root
show databases;
```
### 數據持久化 Bind Mounting
1. Bind Mounting 就是做映射 `docker run -v /home/aaa:/root/aaa` ，可以將本地目錄和 Container 目錄做映射，如果本地目錄修改， Container 的數據內容也會修改，反之亦然
2. 新增一個 Dockerfile
```
# this same shows how we can extend/change an existing official image from Docker Hub

FROM nginx:latest
# highly recommend you always pin versions for anything beyond dev/learn

WORKDIR /usr/share/nginx/html
# change working directory to root of nginx webhost
# using WORKDIR is prefered to using 'RUN cd /some/path'

COPY index.html index.html

# I don't have to specify EXPOSE or CMD because they're in my FROM
```
3. 在同一個目錄新增 index.html
```
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">

  <title>hello</title>

</head>

<body>
  <h1>Hello Docker! </h1>
</body>
</html>
```
4. 將 Dockerfile 封裝成 Image
`docker build -t fishboneapps/nginx-volume-test .`
5. 創建一個新的 Container
`docker run -d -p 80:80 --name web fishboneapps/nginx-volume-test`
6. 這時候執行 curl 指令，就會得到 nginx 服務器回傳的 index.html
`curl 127.0.0.1` 
7. 這時候移除 web Container
`docker rm -f web`
8. 再新增一個 Container 將虛擬機目錄映射到 nginx 的默認目錄
`docker run -d -p 80:80 -v $(pwd):/usr/share/nginx/html --name web fishboneapps/nginx-volume-test`
9. 進入 web Container 就會發現虛擬機目錄裡面的 Dockerfile 出現在裡面，再新增一個 test.txt
```
docker exec -it web /bin/bash
ls
touch test.txt
exit
```
10. 在虛擬機的目錄 `ls` 就會發現剛剛在 container 裡面新增的 test.txt 存在該目錄，也就是說這兩個目錄是同步的
11. 在本地機器的 Vagrant 目錄也會出現 test.txt，因為 Vagrant 目錄與虛擬機目錄也用同樣的方式進行同步
### 開發者利器 Docker + Bind Mounting
1. 開啟一個 flask 服務的 Container
`docker run -d -p 80:5000 -v $(pwd):/skeleton --name flask fishboneapps/flask-skeleton`
2. 這時候透過本地的瀏覽器就可以讀取頁面(看 Vagrantfile 設置的 ip)，我使用的是 192.168.205.12
http://192.168.205.12/
3. 隨便打開檔案進行修改，就會發現網站會跟著變動
### 根據前面所學部署一個 WordPress
1. 新增一個 MySQL 的 Container
`docker run -d --name mysql -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=wordpress mysql:5.7`
2. 新增一個 WordPress 的 Container
`docker run -d -e WORDPRESS_DB_HOST=mysql:3306 --link mysql -p 8080:80 wordpress`
3. 透過本地的瀏覽器就可以讀取頁面，就會看到 WordPress 的網站了
4. 但是透過這種方式來建立 docker 的服務，會很繁瑣，而且管理也較為複雜，我們想把這些整合成一個 group，Docker Compose 就是為了解決這個問題而誕生了
### Docker Compose 是什麼
1. 多 Container 的 App 太麻煩
    - 要 docker build image 或是從 Docker Hub pull Image
    - 要創建多個 container
    - 要管理這些 container (啟動和刪除)
2. Docker Compose 是什麼
    - Docker Compose 是一個工具(基於 Docker 的命令列工具)
    - 這個工具可以透過 YAML 定義多 Container 的 Docker 應用
    - 通過一條命令就可以根據 YAML 文件的定義去創建或管理多個 Container
3. 默認文件：docker-compose.yml，三大概念：Services, Networks, Volumes
4. Services
    - 一個 Service 代表一個 Container，這個 Container 可以從 Docker Hub Image 來創建，或是從本地的 Dockerfile build 出來的 Image 來創建
    - Services 的啟動類似 docker run，我們可以給其指定 Network 和 Volume。
    - 以下用 docker-compose 的 service 和 docker run 產生同樣的容器
```
# Docker Compose
services:
  db:
    image: postgres:9.4
    volumes:
      - "db-data:/var/lib/postgresql/data"
    networks:
      - back-tier
# docker run
> docker run -d --network back-tier -v db-data:/var/lib/postgresql/data postgres:9.4
```
5. Volumes 和 Networks
    - 在跟 services 一樣的級別底下會有 volumes 和 networks
```
# Docker Compose
volumes:
  db-data

networks:
  front-tier:
    driver: bridge
  back-tier:
    driver: bridge

# docker volume 和 docker network
> docker volume create db-data
> docker network create -d bridge back-tier
```
6. 新增一個 WordPress 的 docker-compose.yml
```
# docker-compose 版本
version: '3'

services:

  wordpress:
    image: wordpress
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_PASSWORD: root
    networks:
      - my-bridge

  mysql:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: wordpress
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - my-bridge

volumes:
  mysql-data:

networks:
  my-bridge:
    driver: bridge
```
### 使用 docker-compose.yml
1. 在虛擬機上安裝 docker-compose，按照[官方文件](https://docs.docker.com/compose/install/)進行安裝
```
# 下載 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# 給予權限
sudo chmod +x /usr/local/bin/docker-compose
```
2. 在剛剛建立 wordpress.yml 的資料夾啟動 Container，這邊的 -f 預設就是 docker-compose.yml，可以不填
`docker-compose -f docker-compose.yml up`
3. 如果執行 `docker-compose up` 之後再使用 Command + C 退出會直接停止服務，所以可以讓指令在後台執行 `docker-compose up -d`，如果想要 debug 看 log，才會使用 `docker-compose up`
4. docker-composer 相關指令
    - `docker-compose stop` 會停止服務
    - `docker-compose down` 會刪除所有服務(包含 Cotainers, Images, Volumes 和 Networks)
    - `docker-compose start` 可以啟動服務
    - `docker-compose ps` 查看服務狀態
    - `docker-compose images` 查看所有 Images
    - `docker-compose exec` 對 Container 執行指令
5. docker-compose exec 和 docker exec 基本上是一樣的，執行以下指令可以直接進去 Container 裡
`docker-compose exec mysql bash`
`docker-compose exec wordpress bash`
6. 將 wordpress 服務停止並刪除
`docker-compose down`
7. 新增 docker-compose.yml
```
version: "3"

services:

  redis:
    image: redis

  web:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - 8080:5000
    environment:
      REDIS_HOST: redis
```
8. 新增 Dockerfile
```
FROM python:2.7
LABEL maintaner="vincent@fishboneapps.com"
COPY . /app
WORKDIR /app
RUN pip install flask redis
EXPOSE 5000
CMD [ "python", "app.py" ]
```
9. 新增 app.py
```
from flask import Flask
from redis import Redis
import os
import socket

app = Flask(__name__)
redis = Redis(host=os.environ.get('REDIS_HOST', '127.0.0.1'), port=6379)


@app.route('/')
def hello():
    redis.incr('hits')
    return 'Hello Container World! I have been seen %s times and my hostname is %s.\n' % (redis.get('hits'),socket.gethostname())


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
```
10. 使用 `docker-compose up` 就可以啟動服務了，這時候打開本地的瀏覽器就可以看到 flask 的頁面了
### 水平擴展和附載均衡
1. 用 docker-compose 的 --scale 啟動三個 web，但是會出現錯誤，會顯示 8080 已被佔用
`docker-compose up --scale= web=3 -d`
2. 修改 docker-compose.yml 把 port 刪除
```
version: "3"

services:

  redis:
    image: redis

  web:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      REDIS_HOST: redis
```
3. 這時候在分別執行以下命令，Container 就會被啟動
`docker-compose up -d`
`docker-compose up --scale web=3 -d`
4. 關閉所有的 Contaienr `docker-compose down`
5. 修改 docker-compose.yml，加上 loadbalancer
```
version: "3"

services:

  redis:
    image: redis

  web:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      REDIS_HOST: redis

  lb:
    image: dockercloud/haproxy
    links:
      - web
    ports:
      - 8080:80
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock 
```
6. 啟動 docker-compose
`docker-compose up -d`
7. 把網頁內容讀取出來 `curl 127.0.0.1:8080` 會返回 Container 的 id
`Hello Container World! I have been seen 1 times and my hostname is 5620b14f864a.`
8. 然後把 web 服務擴展成 3 個
`docker-compose up --scale web=3 -d`
9. 再把網頁內容讀出來，會發現有 3 個 Container id 會輪流出現
```
Hello Container World! I have been seen 2 times and my hostname is 5620b14f864a.
Hello Container World! I have been seen 3 times and my hostname is 923de444e90d.
Hello Container World! I have been seen 4 times and my hostname is 1fde842de3f1.
Hello Container World! I have been seen 5 times and my hostname is 5620b14f864a.
Hello Container World! I have been seen 6 times and my hostname is 923de444e90d.
Hello Container World! I have been seen 7 times and my hostname is 1fde842de3f1.
Hello Container World! I have been seen 8 times and my hostname is 5620b14f864a.
Hello Container World! I have been seen 9 times and my hostname is 923de444e90d.
```
10. 我們也可以把服務擴展成 5 台
`docker-compose up --scale web=5 -d`
11. 這時候直接 curl 10 次 ``for i in `seq 10`; do curl 127.0.0.1:8080; done``
```
Hello Container World! I have been seen 10 times and my hostname is 5620b14f864a.
Hello Container World! I have been seen 11 times and my hostname is 923de444e90d.
Hello Container World! I have been seen 12 times and my hostname is 1fde842de3f1.
Hello Container World! I have been seen 13 times and my hostname is 37c3b132c4bd.
Hello Container World! I have been seen 14 times and my hostname is c2e3df63ddec.
Hello Container World! I have been seen 15 times and my hostname is 5620b14f864a.
Hello Container World! I have been seen 16 times and my hostname is 923de444e90d.
Hello Container World! I have been seen 17 times and my hostname is 1fde842de3f1.
Hello Container World! I have been seen 18 times and my hostname is 37c3b132c4bd.
Hello Container World! I have been seen 19 times and my hostname is c2e3df63ddec.
```
12. 同樣地，也可以減少擴展
`docker-compose up --scale web=3 -d`
13. Docker Compose 是用於本地開發的一個工具，並不適合用於 Production，它就是為了方便在本地看部署的結果