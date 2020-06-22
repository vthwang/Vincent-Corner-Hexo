---
title: docker 快速學習自我挑戰 Day5
thumbnail:
  - /images/learning/docker/dockerday5.jpg
date: 2017-07-29 12:37:49
categories: Study Note
tags: Docker
toc: true
---
<img src="/images/learning/docker/dockerday5.jpg">

***
### 讓 Docker Compose 更簡單：Multi-Container 工具
#### Docker Compose 和 The docker-compose.yml
##### Docker Compose
1. 為什麼：搞清楚 container 之間的關係
2. 為什麼：將 Docker container 的運行設定存成易讀取的檔案
3. 為什麼：一線開發者環境啟動
4. 可以分成兩個相關的事情
    - YAML 格式描述我們的解決方案選項：containers、networks、volumes
    - CLI 工具 **docker-compose** 被用在開發/測試自動化且使用 YAML 檔案
##### docker-compose.yml
1. Compose YAML 格式有自己的版本：1、2、2.1、3、3.1
2. YAML 檔案可以被用於本地 docker 自動化或...的 **docker-compose** 命令
3. **docker** 已經直接被產品化，叫做 Swarm (從 v.1.13 開始)
4. `docker-compose --help`
5. **docker-compose.yml** 是預設名稱，但是`docker-compose -f`可以任何使用喜歡的名稱
#### 測試基本 Compose 命令
1. Docker 的 CLI 工具有 Windows/Mac 版本，但是 Linux 需要分開下載
2. 不是一個產品化等級的工具，但是對在本地端開發和測試是理想的
3. 最常使用的兩個命令是
    - `docker-compose up` # 設定 volumes/networks 和開啟所有的 containers
    - `docker-compose down` # 停止所有的 containers 和移除 cont/vol/net
4. 如果你的所有專案都有 **Dockerfile** 和 **docker-compose.yml**，那「新的開發者」應該要
    - `git clone github.com/some/software`
    - `docker-compose up`
5. 進入超級管理員模式 `sudo -i`
6. 安裝 docker-compose [最新版本](https://github.com/docker/compose/releases) ``curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose``
#### 作業：為 Multi-Container 服務建立一個 Compose File
1. 建立一個基本的 compose file 用於 Drupal CMS 網站，Docker Hub 是你的好朋友
2. 使用 **Drupal** image 並與 **postgres** imgae 一起使用
3. 使用 **ports** 使 Drupal 運行在 8080，如此一來可以透過 localhost:8080 來存取網頁
4. 確定有設定 postgres 的 **POSTGRES_PASSWORD**
5. 用瀏覽器來設定 Drupal
6. 秘訣：Drupal 假定 DB 是 localhost，但是資料庫在另外一個 container，要在 Drupal 設定讓它跟 Docker network 溝通
7. 額外加分：使用 volumes 來儲存 Drupal 的 unique data
#### 答案：為 Multi-Container 服務建立一個 Compose File
1. 建立一個 docker-compose.yml
```
version: '2'

services:
  drupal:
    image: drupal
    ports:
      - "8080:80"
    volumes:
      - drupal-modules:/var/www/html/modules \
      - drupal-profiles:/var/www/html/profiles \
      - drupal-sites:/var/www/html/sites \
      - drupal-themes:/var/www/html/themes
  postgres:
    image: postgres
    environment:
      - POSTGRES_PASSWORD=mypassword
```
2. `docker-compose up` 啟動專案
3. `docker-compose down -v` 刪除專案
#### 新增 Image Building 到 Compose Files
##### 使用 Compose 來 Build
1. Compose 也可以建立你自己的客製化 images
2. 如果在 cache 沒有找到，會在 `docker-compose up` 的時候建立起來
3. 也可以透過 `docker-compose build` 或 `docker-compose up --build` 重建 
4. 對複雜的 builds 非常好，因為它會有很多 vars 或 build args
##### 實作
1. 建立一個 docker-compose.yml，如果找不到 nginx-custom 的 image，則會執行 build 裡的 Dockerfile
```
version: '2'

# based off compose-sample-2, only we build nginx.conf into image
# uses sample site from https://startbootstrap.com/template-overviews/agency/

services:
  proxy:
    build:
      context: .
      dockerfile: nginx.Dockerfile
    image: nginx-custom
    ports:
      - '80:80'
  web:
    image: httpd
    volumes:
      - ./html:/usr/local/apache2/htdocs/
```
2. `docker-compose up`
3. `docker-compose down`
4. `docker-compose down --rmi local` 在關閉的時候同時刪除 image
#### 作業：Run-Time Image Building 和 Multi-Container 開發的 Compose
1. 為本地端測試建立一個客製化的 **drupal** image
2. Compose 並不是只有給開發者使用，測試 apps 是很簡單/有趣的
3. 或許你在學習成為 Drupal 的管理者，或者是軟體測試者
4. 從上一次的作業開始 Compose file
5. 在目錄 **compose-assignment-2** 建立你自己的 **Dockerfile** 和 **docker-compose.yml**
6. 使用 **drupal** image 並與 **postgres** image 一起使用，就像之前一樣
7. 使用目錄裡的 [**README.md**](https://github.com/BretFisher/udemy-docker-mastery/tree/master/compose-assignment-2) 取得更多細節
#### 答案：Run-Time Image Building 和 Multi-Container 開發的 Compose
1. 建立 Dockerfile
```
FROM drupal:8.2

RUN apt-get update && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/themes

RUN git clone --branch 8.x-3.x --single-branch --depth 1 https://git.drupal.org/project/bootstrap.git \
    && chown -R www-data:www-data bootstrap

WORKDIR /var/www/html
```
2. 建立 docker-compose.yml
```
version: '2'

services:
  drupal:
    image: custom-drupal
    build: .
    ports:
      - "8080:80"
    volumes:
      - drupal-modules:/var/www/html/modules \
      - drupal-profiles:/var/www/html/profiles \
      - drupal-sites:/var/www/html/sites \
      - drupal-themes:/var/www/html/themes
  postgres:
    image: postgres:9.6
    environment:
      - POSTGRES_PASSWORD=mypassword
    volumes:
      - drupal-data:/var/lib/postgresql/data

volumes:
  drupal-data:
  drupal-modules:
  drupal-profiles:
  drupal-sites:
  drupal-themes:
```



